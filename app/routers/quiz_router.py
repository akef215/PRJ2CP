from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from sqlalchemy.ext.asyncio import AsyncSession
from app.services.quiz_service import get_available_quizzes_service, answer_quiz
from app.services.quiz_service import add_quiz, add_question, add_choice, delete_quiz_service, delete_question_service, delete_choice_service
from app.schemas.quiz import QuizOut, QuizSubmission
from app.schemas.quiz import QuizCreate
from app.schemas.question import QuestionModel
from app.schemas.choice import ChoiceModel
from app.models import Choice, Question
from typing import List
from sqlalchemy.future import select
from app.schemas.quiz import AnswerSubmission


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

@router.post("/quizzes/{quiz_id}/answer")
async def answer_quiz(quiz_id: int, submission: QuizSubmission, db: AsyncSession = Depends(get_db)):
    answers = submission.answers  # Récupérer la liste des réponses
    total_score = 0

    for answer in answers:
        # Vérifier si la question appartient bien au quiz
        question_result = await db.execute(select(Question).where(
            Question.id == answer.question_id, Question.quiz_id == quiz_id
        ))
        question = question_result.scalars().first()
        if not question:
            raise HTTPException(status_code=404, detail=f"Question {answer.question_id} not found in quiz {quiz_id}")

        # Vérifier si le choix est valide
        choice_result = await db.execute(select(Choice).where(
            Choice.id == answer.choice_id, Choice.question_id == question.id
        ))
        choice = choice_result.scalars().first()
        if not choice:
            raise HTTPException(status_code=404, detail=f"Choice {answer.choice_id} not found for question {answer.question_id}")

        # Ajouter le score
        total_score += choice.score

    return {"message": "Quiz answered successfully", "total_score": total_score}