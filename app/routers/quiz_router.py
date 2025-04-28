from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from database import get_db
from app.services.quiz_service import (
    get_available_quizzes_service, add_quiz, add_question, add_choice,
    delete_quiz_service, delete_question_service, delete_choice_service,
    update_quiz, update_question, update_choice, get_students_within_score_range,
    get_students_who_did_quiz, answer_quiz, get_quiz_details_service, get_quiz_with_question_id,
    get_all_quizzes_service, get_available_quizzes_today,get_available_surveys_today
)
from app.schemas.quiz import QuizOut, QuizCreate, AnswerSubmission

from app.services.quiz_service import get_available_quizzes_service
from app.services.quiz_service import add_quiz, add_question, add_choice, delete_quiz_service, delete_question_service, delete_choice_service, update_quiz, update_question, update_choice, get_students_within_score_range, get_students_who_did_quiz, get_available_questions_service, get_available_choices_service, get_surveys, get_quiz
from app.schemas.quiz import QuizOut
from app.schemas.quiz import QuizChange
from app.schemas.quiz import QuizCreate

from app.schemas.question import QuestionModel
from app.schemas.choice import ChoiceModel
from typing import List
from pydantic import BaseModel

router = APIRouter()


# Récupérer les quiz disponibles
@router.get("/available", response_model=List[QuizOut])
async def get_available_quizzes(db: AsyncSession = Depends(get_db)):
    return await get_available_quizzes_service(db)

# Ajouter un quiz

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



# Ajouter une question à un quiz
@router.post("/{quiz_id}/add_questions")
async def add_questions(quiz_id: int, question: QuestionModel, db: AsyncSession = Depends(get_db)):
    return await add_question(quiz_id, question, db)



# Ajouter un choix à une question
@router.post("/{quiz_id}/add_questions/{question_id}/add_choices")



@router.post("/{quiz_id}/{question_id}/add_choices")
async def add_choices(quiz_id: int, question_id: int, choix: ChoiceModel, db: AsyncSession = Depends(get_db)):
    return await add_choice(quiz_id, question_id, choix, db)



# Supprimer un quiz
@router.delete("/delete/{quiz_id}")
async def delete_quiz(quiz_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_quiz_service(quiz_id, db)




# Supprimer une question d’un quiz
@router.delete("/{quiz_id}/delete_questions/{question_id}")
async def delete_question(quiz_id: int, question_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_question_service(quiz_id, question_id, db)



# Supprimer un choix d’une question
@router.delete("/{quiz_id}/delete_questions/{question_id}/delete_choices/{choice_id}")
async def delete_choice(choice_id: int, quiz_id: int, question_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_choice_service(choice_id, quiz_id, question_id, db)

@router.delete("/delete_questions/{question_id}")
async def delete_question(question_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_question_service(question_id, db)



@router.delete("/delete_choices/{choice_id}")
async def delete_choice(choice_id: int, db: AsyncSession = Depends(get_db)):
    return await delete_choice_service(choice_id, db)



# Modifier un quiz
@router.put("/modify/{quiz_id}")
async def update_quizzes(quiz_id: int, quiz_data: QuizChange, db: AsyncSession = Depends(get_db)):
    return await update_quiz(quiz_id, quiz_data, db)




# Modifier une question
@router.put("/{quiz_id}/modify_questions/{question_id}")
async def update_question_route(quiz_id: int, question_id: int, question_data: QuestionModel, db: AsyncSession = Depends(get_db)):
    return await update_question(quiz_id, question_id, question_data, db)




# Modifier un choix d’une question
@router.put("/{quiz_id}/modify_questions/{question_id}/modify_choices/{choice_id}")
async def update_choice_route(quiz_id: int, question_id: int, choice_id: int, choice_data: ChoiceModel, db: AsyncSession = Depends(get_db)):
    return await update_choice(quiz_id, question_id, choice_id, choice_data, db)



# Répondre à un quiz
@router.put("/modify_questions/{question_id}")
async def update_questions(question_id: int, question_data: QuestionModel, db: AsyncSession = Depends(get_db)):
    return await update_question(question_id ,question_data, db)



@router.put("/modify_choices/{choice_id}")
async def update_choices(choice_id: int, choice_data: ChoiceModel, db: AsyncSession = Depends(get_db)):
    return await update_choice(choice_id, choice_data, db)


# Answer a quiz
@router.post("/quizzes/{quiz_id}/answer")
async def answer_quiz_route(quiz_id: int, submission: AnswerSubmission, db: AsyncSession = Depends(get_db)):
    return await answer_quiz(quiz_id, submission.answers, db)





# Obtenir la liste des étudiants ayant participé à un quiz
@router.get("/quizzes/{quiz_id}/students", response_model=List[str])
async def get_students_who_did_quiz_route(quiz_id: int, db: AsyncSession = Depends(get_db)):
    result = await get_students_who_did_quiz(quiz_id, db)
    if not result or "students_who_did_quiz" not in result:
        raise HTTPException(status_code=404, detail="No students have participated in this quiz.")
    return result["students_who_did_quiz"]





# Obtenir la liste des étudiants ayant un score dans une certaine plage
@router.get("/quizzes/{quiz_id}/students/score_range", response_model=dict)
async def get_students_within_score_range_route(
    quiz_id: int, min_score: int, max_score: int, db: AsyncSession = Depends(get_db)
):
    return await get_students_within_score_range(quiz_id, min_score, max_score, db)






@router.get("/quizzes/{quiz_id}/details")
async def get_quiz_details(quiz_id: int, db: AsyncSession = Depends(get_db)):
    return await get_quiz_details_service(quiz_id, db)







@router.get("/quizzes/{quiz_id}/details_more")
async def get_quiz_details_with_question(quiz_id: int, db: AsyncSession = Depends(get_db)):
    return await get_quiz_with_question_id(quiz_id, db)



@router.get("/quizzes/all", response_model=List[QuizOut])
async def get_all_quizzes(db: AsyncSession = Depends(get_db)):
    quizzes = await get_all_quizzes_service(db)
    return quizzes


# Modèle de réponse structuré avec un 'id' explicite
class QuizIDResponse(BaseModel):
    id: int



@router.get("/available_quizzes_today", response_model=List[QuizIDResponse])
async def available_quizzes(db: AsyncSession = Depends(get_db)) -> List[QuizIDResponse]:
    """
    Endpoint to fetch the IDs of quizzes available today or in the future.
    """
    quiz_ids = await get_available_quizzes_today(db)
    return [QuizIDResponse(id=quiz_id) for quiz_id in quiz_ids]



 
@router.get("/available_surveys_today", response_model=List[QuizIDResponse])
async def available_surveys(db: AsyncSession = Depends(get_db)) -> List[QuizIDResponse]:
    """
    Endpoint to fetch the IDs of surveys available today or in the future.
    """
    quiz_ids = await get_available_surveys_today(db)
    return [QuizIDResponse(id=quiz_id) for quiz_id in quiz_ids]   