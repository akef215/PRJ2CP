from fastapi import Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from sqlalchemy.future import select
from app.models.student import Student
from app.models.module import Module
from app.models.feedback import Feedback
from app.models.statistics import Statistic
from app.models.results import Result
from app.models.choice import Choice
from app.schemas.student import StudentCreate
from database import get_db


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