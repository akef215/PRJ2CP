from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db
from app.services.statistics_services import update_statistic 
from app.models.statistics import Statistic
from sqlalchemy.future import select
router = APIRouter()

@router.get("/test/{quiz_id}")
async def get_stat_by_quiz(quiz_id: int, db: AsyncSession = Depends(get_db)):
    return await update_statistic(quiz_id, db)




@router.get("/stats/{quiz_id}")
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