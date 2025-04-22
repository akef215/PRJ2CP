from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from sqlalchemy.ext.asyncio import AsyncSession
from app.services.quiz_service import get_available_quizzes_service
from app.services.quiz_service import add_quiz, add_question, add_choice, delete_quiz_service, delete_question_service, delete_choice_service, update_quiz, update_question, update_choice, get_students_within_score_range, get_students_who_did_quiz, get_available_questions_service, get_available_choices_service, get_surveys, get_quiz
from app.schemas.quiz import QuizOut
from app.schemas.quiz import QuizChange
from app.schemas.quiz import QuizCreate
from app.schemas.question import QuestionModel
from app.schemas.choice import ChoiceModel
from typing import List

from app.schemas.quiz import AnswerSubmission  # Adjust the import path as necessary

router = APIRouter()
@router.get("/quizzes", response_model=List[QuizOut])
async def get_available_quizzes(db: AsyncSession = Depends(get_db)):
    return await get_available_quizzes_service(db)

@router.get("/quiz/{quiz_id}", response_model=QuizOut)
async def get_quiz_byId(quiz_id : int, db: AsyncSession = Depends(get_db)):
    return await get_quiz(quiz_id, db)

@router.get("/surveys", response_model=List[QuizOut])
async def get_available_surveys(db: AsyncSession = Depends(get_db)):
    return await get_surveys(db)

@router.get("/{quiz_id}/questions")
async def get_available_quizzes(quiz_id: int, db: AsyncSession = Depends(get_db)):
    return await get_available_questions_service(quiz_id, db)

@router.get("/{quiz_id}/{qstn_id}/choices")
async def get_available_choices(quiz_id: int, qstn_id: int, db: AsyncSession = Depends(get_db)):
    return await get_available_choices_service(quiz_id, qstn_id, db)

@router.post("/add_quiz")
async def add_quizzes(quiz: QuizCreate, db: AsyncSession = Depends(get_db)):
    return await add_quiz(quiz, db)

@router.post("/{quiz_id}/add_questions")
async def add_questions(quiz_id: int, question: QuestionModel, db: AsyncSession = Depends(get_db)):
    return await add_question(quiz_id, question, db)

@router.post("/{quiz_id}/{question_id}/add_choices")
async def add_choices(quiz_id: int, question_id: int, choix: ChoiceModel, db: AsyncSession = Depends(get_db)):
    return await add_choice(quiz_id, question_id, choix, db)

@router.delete("/delete/{quiz_id}")
async def delete_quiz(quiz_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_quiz_service(quiz_id, db)

@router.delete("/delete_questions/{question_id}")
async def delete_question(question_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_question_service(question_id, db)

@router.delete("/delete_choices/{choice_id}")
async def delete_choice(choice_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_choice_service(choice_id, db)

@router.put("/modify/{quiz_id}")
async def update_quizzes(quiz_id: int, quiz_data: QuizChange, db: AsyncSession = Depends(get_db)):
    return await update_quiz(quiz_id, quiz_data, db)


@router.put("/modify_questions/{question_id}")
async def update_questions(question_id: int, question_data: QuestionModel, db: AsyncSession = Depends(get_db)):
    return await update_question(question_id ,question_data, db)

@router.put("/modify_choices/{choice_id}")
async def update_choices(choice_id: int, choice_data: ChoiceModel, db: AsyncSession = Depends(get_db)):
    return await update_choice(choice_id, choice_data, db)
# Answer a quiz
@router.post("/quizzes/{quiz_id}/answer")
async def answer_quiz(quiz_id: int, submission: AnswerSubmission, db: AsyncSession = Depends(get_db)):
    return await answer_quiz(quiz_id, submission.answers, db)

# Get the list of students who participated in the quiz

@router.get("/quizzes/{quiz_id}/students", response_model=List[str])
async def get_students_who_did_quiz_route(quiz_id: int, db: AsyncSession = Depends(get_db)):
    # Call the service function to get students who participated in the quiz
    result = await get_students_who_did_quiz(quiz_id, db)
    
    if not result or "students_who_did_quiz" not in result:
        raise HTTPException(status_code=404, detail="No students have participated in this quiz.")
    
    return result["students_who_did_quiz"]

# Get the list of students who passed the quiz (score > 10)

@router.get("/quizzes/{quiz_id}/students/score_range", response_model=dict)
async def get_students_within_score_range_route(
    quiz_id: int, min_score: int, max_score: int, db: AsyncSession = Depends(get_db)
):
    # Call the service function
    return await get_students_within_score_range(quiz_id, min_score, max_score, db)


@router.put("/{quiz_id}/modify_questions/{question_id}")
async def update_questions(quiz_id: int, question_id: int, question_data: QuestionModel, db: AsyncSession = Depends(get_db)):
    return await update_question(quiz_id, question_id ,question_data, db)

@router.put("/{quiz_id}/modify_questions/{question_id}/modify_choices/{choice_id}")
async def update_questions(quiz_id: int, question_id: int, choice_id: int, choice_data: ChoiceModel, db: AsyncSession = Depends(get_db)):
    return await update_question(quiz_id, question_id , choice_id, choice_data, db)

