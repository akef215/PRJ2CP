from fastapi import Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from sqlalchemy.future import select
from sqlalchemy import func
from app.models.student import Student
from app.models.module import Module
from app.models.feedback import Feedback
from app.models.statistics import Statistic
from app.models.results import Result
from app.models.choice import Choice
from app.models.question import Question
from app.schemas.student import StudentCreate

from database import get_db
from collections import defaultdict
from datetime import datetime
from typing import List, Literal
from app.models.quiz import Quiz

from collections import defaultdict
from datetime import datetime

async def update_statistic(quizz_id: int, db: AsyncSession):
    # Récupérer tous les choix de réponses du quiz
    query = select(Choice).where(Choice.quiz_id == quizz_id)
    result = await db.execute(query)
    choix = result.scalars().all()

    # Calcul du score total possible
    total = sum(choice.score for choice in choix if choice.score > 0)

    if total == 0:  # Éviter une division par zéro
        raise HTTPException(status_code=400, detail="Invalid quiz, total score is zero")

    # Récupérer toutes les réponses pour le quiz
    query = select(Result).where(Result.quizz_id == quizz_id).order_by(Result.student_id)
    result = await db.execute(query)
    resultats = result.scalars().all()

    if not resultats:
        raise HTTPException(status_code=404, detail="No submission yet")
    
    # Dictionnaire pour stocker les scores des étudiants
    statistiques = {}

    # Transformer la liste des choix en dictionnaire pour un accès rapide
    choix_dict = {choice.id: choice.score for choice in choix}

    # Calcul des scores des étudiants
    for answer in resultats:
        student_id = answer.student_id

        if student_id not in statistiques:
            statistiques[student_id] = 0  

        # Ajouter le score du choix de l'étudiant s'il existe
        if answer.choice_id in choix_dict:
            statistiques[student_id] += choix_dict[answer.choice_id]

    # Mettre à jour ou insérer les scores dans la table `statistiques`
    for student_id, score in statistiques.items():
        pourcentage = (score / total) * 100

        # Vérifier si une entrée existe déjà pour cet étudiant et ce quiz
        query = select(Statistic).where(
            Statistic.id_student == student_id, 
            Statistic.id_quiz == quizz_id
        )
        result = await db.execute(query)
        existing_stat = result.scalars().first()

        if existing_stat:
            # Mise à jour du pourcentage
            existing_stat.pourcentage = pourcentage
        else:
            # Insérer une nouvelle entrée
            new_stat = Statistic(id_student=student_id, id_quiz=quizz_id, pourcentage=pourcentage)
            db.add(new_stat)

    try:
        await db.commit()
    except IntegrityError:
        await db.rollback()
        raise HTTPException(status_code=500, detail="Database error while updating statistics")

    return {"message": "Statistics updated successfully"}



def generate_chart_data(stats, group_by="month"):
    data = defaultdict(list)

    for stat in stats:
        date = stat.quiz.date if stat.quiz and stat.quiz.date else None
        if not date:
            continue

        if group_by == "month":
            # Crée une clé comme "2025-03-S1", "2025-03-S2", ...
            week_number = (date.day - 1) // 7 + 1  # 1ère semaine = jours 1-7, etc.
            key = f"{date.year}-{date.month:02d}-S{week_number}"
        elif group_by == "year":
            # Clé comme "2025-03"
            key = f"{date.year}-{date.month:02d}"
        else:
            continue

        data[key].append(stat.pourcentage)

    # Tri des clés pour garder l’ordre chronologique
    sorted_keys = sorted(data.keys())
    x = sorted_keys
    y = [sum(data[k]) / len(data[k]) for k in sorted_keys]  # Moyenne des pourcentages

    return x, y

async def survey_statistics(survey_id: int, db: AsyncSession):
    # Sélectionner toutes les questions pour un quiz spécifique (survey_id)
    query = select(Question).where(Question.quiz_id == survey_id)
    result = await db.execute(query)
    questions = result.scalars().all()

    if not questions:
        raise HTTPException(status_code=404, detail="Empty Survey")

    statQ = []  # Pour stocker les statistiques des questions

    for question in questions:
        # Sélectionner toutes les réponses (choices) pour la question spécifique
        query = select(Choice).where(Choice.question_id == question.id)
        result = await db.execute(query)
        answers = result.scalars().all()

        # Si aucune réponse n'est trouvée pour la question, on passe à la suivante
        if not answers:
            continue

        statC = []  # Pour stocker les statistiques des choix pour une question
        for answer in answers:
            # Compter le nombre de fois que chaque choix a été sélectionné
            count_query = select(func.count()).where(Result.choice_id == answer.id)
            count_result = await db.execute(count_query)
            count = count_result.scalar()

            # Ajouter la statistique du choix
            statC.append({ "choice": answer.answer, "count": count })

        # Ajouter les statistiques de la question à la liste des statistiques
        statQ.append({"question": question.statement, "choices": statC})

    return statQ