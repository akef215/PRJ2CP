from fastapi import Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
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
    query = select(Choice).where(Choice.quiz_id == quizz_id)
    result = await db.execute(query)
    choix = result.scalars().all()

    # Calcul du score total possible
    total = sum(choice.score for choice in choix if choice.score > 0)
    print(total)

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

    for answer in resultats:
        student_id = answer.student_id

        if student_id not in statistiques:
            statistiques[student_id] = 0  

        # Ajouter le score du choix de l'étudiant s'il existe
        if answer.choice_id in choix_dict:
            statistiques[student_id] += choix_dict[answer.choice_id]

    # Calculer le pourcentage pour chaque étudiant
    for student_id in statistiques:
        statistiques[student_id] = (statistiques[student_id] / total) * 100

    return statistiques