from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from sqlalchemy.ext.asyncio import AsyncSession
from app.services.quiz_service import get_available_quizzes_service
from app.services.quiz_service import add_quiz, add_question, add_choice, delete_quiz_service, delete_question_service, delete_choice_service
from app.schemas.quiz import QuizOut
from app.schemas.quiz import QuizCreate
from app.schemas.question import QuestionModel
from app.schemas.choice import ChoiceModel
from typing import List

router = APIRouter()
@router.get("/available", response_model=List[QuizOut])
async def get_available_quizzes(db: AsyncSession = Depends(get_db)):
    return await get_available_quizzes_service(db)

@router.post("/add_quiz")
async def add_quizzes(quiz: QuizCreate, db: AsyncSession = Depends(get_db)):
    return await add_quiz(quiz, db)

@router.post("/{quiz_id}/add_questions")
async def add_questions(quiz_id: int, question: QuestionModel, db: AsyncSession = Depends(get_db)):
    return await add_question(quiz_id, question, db)

@router.post("/{quiz_id}/add_questions/{question_id}/add_choices")
async def add_choices(quiz_id: int, question_id: int, choix: ChoiceModel, db: AsyncSession = Depends(get_db)):
    return await add_choice(quiz_id, question_id, choix, db)

@router.delete("/delete/{quiz_id}")
async def delete_quiz(quiz_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_quiz_service(quiz_id, db)

@router.delete("/{quiz_id}/delete_questions/{question_id}")
async def delete_question(quiz_id: int, question_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_question_service(quiz_id, question_id, db)

@router.delete("/{quiz_id}/delete_questions/{question_id}/delete_choices/{choice_id}")
async def delete_choice(choice_id: int, quiz_id: int, question_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_choice_service(choice_id, quiz_id, question_id, db)