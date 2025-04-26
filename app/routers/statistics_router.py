from typing import Literal
from collections import defaultdict
from sqlalchemy.orm import selectinload
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from database import get_db

from app.services.statistics_services import update_statistic,generate_chart_data,survey_statistics,get_chapter_statistics_by_student,get_chapter_statistics
from app.models.statistics import Statistic
from app.models.quiz import Quiz
from app.models.chapter import Chapter





router = APIRouter()

@router.get("/quiz/{quiz_id}")
async def get_stat_by_quiz(quiz_id: int, db: AsyncSession = Depends(get_db)):
    return await update_statistic(quiz_id, db)


@router.get("/stats/basic/{quiz_id}")
async def get_statistics(quiz_id: int, db: AsyncSession = Depends(get_db)):
    query = select(Statistic).where(Statistic.id_quiz == quiz_id)
    result = await db.execute(query)
    stats = result.scalars().all()

    return [
        {
            "student_id": stat.id_student,
            "quiz_id": stat.id_quiz,
            "pourcentage": stat.pourcentage
        }
        for stat in stats
    ]

@router.get("/stats/with-date/{quiz_id}")
async def get_statistics_with_date(quiz_id: int, db: AsyncSession = Depends(get_db)):
    query = (
        select(Statistic)
        .options(selectinload(Statistic.quiz))  # Préchargement de la relation
        .where(Statistic.id_quiz == quiz_id)
    )
    result = await db.execute(query)
    stats = result.scalars().all()

    return [
        {
            "date": stat.quiz.date.isoformat() if stat.quiz and stat.quiz.date else None,
            "quizNumber": stat.id_quiz,
            "progress": stat.pourcentage / 100
        }
        for stat in stats
    ]







@router.get("/stats/chart/{quiz_id}")
async def get_chart_data(
    quiz_id: int,
    group_by: Literal["month", "year"] = Query("month"),
    db: AsyncSession = Depends(get_db)
):
    # On récupère les stats avec la relation au quiz pour accéder à la date
    query = select(Statistic).where(Statistic.id_quiz == quiz_id).options(
        selectinload(Statistic.quiz)  # très important pour éviter l’erreur de lazy loading
    )
    result = await db.execute(query)
    stats = result.scalars().all()

    x, y = generate_chart_data(stats, group_by=group_by)
    return {
        "x": x,  # les pourcentages (progress)
        "y": y   # les périodes (mois ou semaines)
    }

@router.get("/surveys/{survey_id}")
async def get_stat_survey(survey_id: int, db: AsyncSession = Depends(get_db)):
    return await survey_statistics(survey_id, db)



@router.get("/chapters/{student_id}")
async def chapter_stats( db: AsyncSession = Depends(get_db)):
    #return await get_chapter_statistics_by_student(student_id, db)
      return await get_chapter_statistics(db)



