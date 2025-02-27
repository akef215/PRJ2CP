from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from datetime import date
from typing import List
from app.models.quiz import Quiz

async def get_available_quizzes_service(db: AsyncSession) -> List[Quiz]:
    """Fetch quizzes that are available (i.e., their date is today or in the future)."""
    today = date.today()
    stmt = select(Quiz).where(Quiz.date >= today)
    result = await db.execute(stmt)
    return result.scalars().all()
