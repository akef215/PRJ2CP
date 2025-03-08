from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db
from app.services.statistics_services import update_statistic 

router = APIRouter()

@router.get("/test/{quiz_id}")
async def get_stat_by_quiz(quiz_id: int, db: AsyncSession = Depends(get_db)):
    return await update_statistic(quiz_id, db)