from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db
from app.services.statistics_services import update_statistic, survey_statistics

router = APIRouter()

@router.get("/quiz/{quiz_id}")
async def get_stat_by_quiz(quiz_id: int, db: AsyncSession = Depends(get_db)):
    return await update_statistic(quiz_id, db)

@router.get("/surveys/{survey_id}")
async def get_stat_survey(survey_id: int, db: AsyncSession = Depends(get_db)):
    return await survey_statistics(survey_id, db)