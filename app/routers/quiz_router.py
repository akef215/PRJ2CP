from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from sqlalchemy.ext.asyncio import AsyncSession
from app.services.quiz_service import get_available_quizzes_service
from app.schemas.quiz import QuizOut
from typing import List

router = APIRouter()
@router.get("/available", response_model=List[QuizOut])
async def get_available_quizzes(db: AsyncSession = Depends(get_db)):
    return await get_available_quizzes_service(db)
