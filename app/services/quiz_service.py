from fastapi import Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import distinct
from sqlalchemy.orm import selectinload
from datetime import date
from typing import List
from app.models.groupe import Groupe
from app.models.module import Module
from app.models.quiz import Quiz
from app.models.student import Student
from app.models.choice import Choice
from app.models.question import Question
from app.models.results import Result
from app.models.choice import Choice  # Import the Answer model
from app.schemas.quiz import QuizCreate, AnswerSubmission
from app.schemas.question import QuestionModel
from app.schemas.choice import ChoiceModel
from app.schemas.quiz import QuizOut
from app.schemas.quiz import QuizChange
from app.schemas.notif import NotificationCreate  # Import NotificationCreate
from app.models.notifs import Notif  # Import Notification model

async def get_available_quizzes_service(db: AsyncSession) -> List[Quiz]:
    """Fetch quizzes that are available (i.e., their date is today or in the future)."""
    today = date.today()
    stmt = select(Quiz).where(Quiz.date >= today, Quiz.type_quizz != 'S', Quiz.launch == True)
    result = await db.execute(stmt)
    return result.scalars().all()

async def get_day_quizzes_service(date: date, db: AsyncSession) -> List[Quiz]:
    stmt = select(Quiz).where(Quiz.date == date, Quiz.launch == True)
    result = await db.execute(stmt)
    return result.scalars().all()

async def get_quizzes_service(db: AsyncSession) -> List[Quiz]:
    """Fetch quizzes"""
    stmt = select(Quiz).where(Quiz.type_quizz != 'S')
    result = await db.execute(stmt)
    return result.scalars().all()

async def get_surveys_service(db: AsyncSession) -> List[Quiz]:
    """Fetch surveys"""
    stmt = select(Quiz).where(Quiz.type_quizz == 'S')
    result = await db.execute(stmt)
    return result.scalars().all()


async def get_quiz(quiz_id: int, db: AsyncSession):
    stmt = select(Quiz).where(Quiz.id == quiz_id)
    result = await db.execute(stmt)
    return result.scalars().first()

async def get_surveys(db: AsyncSession) -> List[Quiz]:
    """Fetch Surveys that are available (i.e., their date is today or in the future)."""
    today = date.today()
    stmt = select(Quiz).where(Quiz.date >= today, Quiz.type_quizz == 'S', Quiz.launch == True)
    result = await db.execute(stmt)
    return result.scalars().all()

async def add_quiz(quizz: QuizCreate, db: AsyncSession):
    # Instanciation d'un quiz
    quiz = Quiz(title=quizz.title, date=quizz.date, description=quizz.description, module_code=quizz.module, duree=quizz.duree, type_quizz=quizz.type, groupe_id=quizz.groupe)

    # La recherche du module
    result = await db.execute(select(Module).where(Module.code == quizz.module))
    code = result.scalars().first()

    if not code:
        raise HTTPException(status_code=404, detail="Le module n'existe pas")

    # La recherche des groupes
    result = await db.execute(select(Groupe).where(Groupe.id == quizz.groupe))
    groups = result.scalars().first()

    if not groups:
        raise HTTPException(status_code=404, detail="No group found")

    # L'ajout du quiz dans la base de donnée
    db.add(quiz)
    await db.commit()
    return quiz

async def add_question(quiz_id: int, question: QuestionModel, db: AsyncSession):
    # Instanciation de la question
    qstn = Question(quiz_id=quiz_id, statement=question.statement, duree=question.duree)

    # Verifier que le quiz existe deja
    results = await db.execute(select(Quiz).where(Quiz.id == quiz_id))
    quiz = results.scalars().first()
    if not quiz:
        raise HTTPException(status_code=404, detail="No quiz found")
    
    db.add(qstn)
    await db.commit()

    return qstn

async def add_choice(quiz_id: int, question_id: int, choix: ChoiceModel, db: AsyncSession):
    # Instanciation de la question
    choice = Choice(quiz_id=quiz_id, question_id = question_id, score=choix.score, answer=choix.answer)

    # Verifier que le quiz existe deja
    results = await db.execute(select(Quiz).where(Quiz.id == quiz_id))
    quiz = results.scalars().first()
    if not quiz:
        raise HTTPException(status_code=404, detail="No quiz found")
    
    # Verifier que la question existe deja
    results = await db.execute(select(Question).where(Question.quiz_id == quiz_id, Question.id == question_id))
    qstn = results.scalars().first()
    if not qstn:
        raise HTTPException(status_code=404, detail="No question found")
    
    db.add(choice)
    await db.commit()
    return choice

async def delete_quiz_service(quiz_id: int, db: AsyncSession):
    result = await db.execute(select(Quiz).filter(Quiz.id == quiz_id))
    quiz = result.scalars().first()

    if not quiz:
        raise HTTPException(status_code=404, detail=f"Quiz with ID {quiz_id} not found")

    await db.delete(quiz)
    await db.commit()

    return {"message": f"Quiz with ID {quiz_id} deleted successfully"}

async def delete_question_service(question_id: int, db: AsyncSession):
    result = await db.execute(select(Question).filter(Question.id == question_id))
    question = result.scalars().first()

    if not question:
        raise HTTPException(status_code=404, detail=f"Question not found")

    await db.delete(question)
    await db.commit()

    return {"message": f"Question deleted successfully"}

async def delete_choice_service(choice_id: int, db: AsyncSession):
    result = await db.execute(select(Choice).where(Choice.id == choice_id))
    choice = result.scalars().first()
    await db.delete(choice)
    await db.commit()

    return {"message": f"Choice deleted successfully"}

async def update_quiz(quiz_id: int, quiz_data: QuizChange, db: AsyncSession):
    # Vérifier si le quiz existe
    result = await db.execute(select(Quiz).where(Quiz.id == quiz_id))
    quiz = result.scalars().first()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz non trouvé")

    # Mise à jour des champs fournis
    quiz.title = quiz_data.title if quiz_data.title else quiz.title
    quiz.duree = quiz_data.duree if quiz_data.duree else quiz.duree
    quiz.module_code = quiz_data.module_code if quiz_data.module_code else quiz.module_code
    quiz.date = quiz_data.date if quiz_data.date else quiz.date


    await db.commit()
    await db.refresh(quiz)

    return quiz

async def update_question(question_id: int, question_data: QuestionModel, db: AsyncSession):

    # Vérifier si la question existe
    result = await db.execute(select(Question).where(Question.id == question_id))
    question = result.scalars().first()

    if not question:
        raise HTTPException(status_code=404, detail="Question non trouvée")

    # Mise à jour des champs fournis
    question.statement = question_data.statement if question_data.statement else question.statement
    question.duree = question_data.duree if question_data.duree else question.duree

    await db.commit()
    await db.refresh(question)

    return question

async def update_choice(choice_id: int, choice_data: ChoiceModel, db: AsyncSession):

    # Vérifier si le choix existe
    result = await db.execute(select(Choice).where(Choice.id == choice_id))
    choice = result.scalars().first()

    if not choice:
        raise HTTPException(status_code=404, detail="Choice not found")

    # Mise à jour des champs fournis
    choice.answer = choice_data.answer if choice_data.answer else choice.answer
    choice.score = choice_data.score if choice_data.score else choice.score

    await db.commit()
    await db.refresh(choice)

    return choice

async def answer_quiz(quiz_id: int, answers: dict[int, int], db: AsyncSession):
    total_score = 0
    for question_id, choice_id in answers.items():
        question_result = await db.execute(
            select(Question).where(Question.id == question_id, Question.quiz_id == quiz_id)
        )
        question = question_result.scalars().first()
        if not question:
            raise HTTPException(status_code=404, detail=f"Question {question_id} not found in quiz {quiz_id}")

        choice_result = await db.execute(
            select(Choice).where(Choice.id == choice_id, Choice.question_id == question.id)
        )
        choice = choice_result.scalars().first()
        if not choice:
            raise HTTPException(status_code=404, detail=f"Choice {choice_id} not found for question {question_id}")

        total_score += choice.score

    return {"message": "Quiz answered successfully", "total_score": total_score}


# Function to get students who did the quiz
async def get_students_who_did_quiz(quiz_id: int, db: AsyncSession):
    # Execute the query to get the quiz results for the given quiz_id
    results = await db.execute(select(Result).where(Result.quizz_id == quiz_id))
    quiz_results = results.scalars().all()

    if not quiz_results:
        return {"students_who_did_quiz": []}  # Return an empty list if no students participated

    # Extract student_ids from the results
    student_ids = [result.student_id for result in quiz_results]

    return {"students_who_did_quiz": student_ids}

# Function to get students who passed the quiz (score > 10)
async def get_students_within_score_range(
    quiz_id: int, min_score: int, max_score: int, db: AsyncSession
):
    # Récupérer tous les résultats des étudiants pour ce quiz avec les scores
    stmt = (
        select(Result.student_id, Choice.score)
        .join(Choice, Choice.id == Result.choice_id)
        .where(Result.quizz_id== quiz_id)
    )
    
    results = await db.execute(stmt)
    results = results.fetchall()

    # Calculer les scores totaux des étudiants
    student_scores = {}
    for student_id, score in results:
        student_scores[student_id] = student_scores.get(student_id, 0) + score

    # Filtrer les étudiants dont le score est dans la plage donnée
    passed_students = [
        student_id for student_id, total_score in student_scores.items()
        if min_score <= total_score <= max_score
    ]

    # Si aucun étudiant ne correspond, renvoyer une erreur 404
    if not passed_students:
        raise HTTPException(status_code=404, detail="No students found within the score range.")

    return {"students_in_score_range": passed_students}


async def get_quiz_details_service(quiz_id: int, db: AsyncSession):
    # Vérifier que le quiz existe
    result = await db.execute(
        select(Quiz)
        .where(Quiz.id == quiz_id)
        .options(selectinload(Quiz.questions).selectinload(Question.choices))
    )
    quiz = result.scalars().first()

    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz non trouvé")

    # Formater la réponse avec les données du quiz
    quiz_data = {
        "quiz_id": quiz.id,
        "time_limit": quiz.duree,
        "total_questions": len(quiz.questions),
        "questions": []
    }

    # Parcourir toutes les questions du quiz
    for question in quiz.questions:
        # Collecter toutes les réponses possibles pour chaque question
        choices = [{"choiceId": choice.id, "answer": choice.answer, "points": choice.score} for choice in question.choices]

        # Ajouter les détails de chaque question avec toutes les réponses possibles
        quiz_data["questions"].append({
            "statement": question.statement,
            "choices": choices,  # Liste de toutes les réponses possibles
        })

    return quiz_data

async def get_available_questions_service(quiz_id: int, db: AsyncSession) -> List[Question]:
    result = await db.execute(select(Question).where(Question.quiz_id == quiz_id))
    quiz_questions = result.scalars().all()
    
    return quiz_questions or []

async def get_available_choices_service(quiz_id: int, qstn_id: int, db: AsyncSession) -> List[Choice]:
    # Vérifie que la question existe bien
    qstn_result = await db.execute(
        select(Question).where(
            Question.quiz_id == quiz_id,
            Question.id == qstn_id
        )
    )
    question = qstn_result.scalars().first()

    if not question:
        return []

    # Récupère les choix associés à la question
    result = await db.execute(
        select(Choice).where(
            Choice.quiz_id == quiz_id,
            Choice.question_id == question.id  # on utilise qstn_id directement
        )
    )
    choices = result.scalars().all()

    return choices or []
async def get_quiz_with_question_id(quiz_id: int, db: AsyncSession):
    # Vérifier que le quiz existe
    result = await db.execute(
        select(Quiz)
        .where(Quiz.id == quiz_id)
        .options(selectinload(Quiz.questions).selectinload(Question.choices))
    )
    quiz = result.scalars().first()

    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz non trouvé")

    quiz_data = {
        "quiz_id": quiz.id,
        "quiz_title": quiz.title,
        "time_limit_minutes": quiz.duree,
        "total_questions": len(quiz.questions),
        "questions": []
    }

    for question in quiz.questions:
        choices = [
            {
                "choice_id": choice.id,
                "answer": choice.answer,
                "points": choice.score
            } 
            for choice in question.choices
        ]

        quiz_data["questions"].append({
            "question_id": question.id,
            "statement": question.statement,
            "time_limit_seconds": question.duree,   # <-- temps spécifique pour cette question
            "choices": choices,
        })

    return quiz_data



async def get_all_quizzes_service(db: AsyncSession) -> List[Quiz]:
    """Fetch all quizzes, without any date or type filter."""
    stmt = select(Quiz)
    result = await db.execute(stmt)
    return result.scalars().all()



async def get_available_quizzes_today(db: AsyncSession) -> List[int]:
    """Fetch IDs of quizzes that are available """
    today = date.today()
    stmt = select(Quiz.id).where(Quiz.date >= today, Quiz.type_quizz != 'S')
    result = await db.execute(stmt)
    return result.scalars().all()


async def get_available_surveys_today(db: AsyncSession) -> List[int]:
    """Fetch IDs of surveys that are available """
    today = date.today()
    stmt = select(Quiz.id).where(Quiz.date >= today, Quiz.type_quizz == 'S')
    result = await db.execute(stmt)
    return result.scalars().all()

async def launch_quiz_service(quiz_id: int, db: AsyncSession):
    # Récupérer le quiz
    result = await db.execute(select(Quiz).where(Quiz.id == quiz_id))
    quiz = result.scalar_one_or_none()

    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    if quiz.launch:
        raise HTTPException(status_code=400, detail="Quiz already launched")

    # Lancer le quiz
    quiz.launch = True
    await db.commit()
    today = date.today()
    # Récupérer les étudiants du groupe lié
    if not quiz.groupe_id:
        return {"message": "Quiz launched but no group assigned"}

    notif = Notif(description = f"The quiz '{quiz.title}' has been launched!", date = today, quizz_id=quiz.id, groupe_id=quiz.groupe_id)
    db.add(notif)
    await db.commit()

    return {
        "message": "Quiz launched successfully",
        "group_id": quiz.groupe_id
    }

async def get_submitted_quizzes(student_id: str, db: AsyncSession) -> List[Quiz]:
    stmt = (
        select(Quiz)
        .join(Result, Result.quizz_id == Quiz.id)
        .where(Result.student_id == student_id)
        .where(Quiz.type_quizz != "S")
        .distinct()
    )
    result = await db.execute(stmt)
    quizzes = result.scalars().all()
    return quizzes

async def get_submitted_surveys(student_id: str, db: AsyncSession) -> List[Quiz]:
    stmt = (
        select(Quiz)
        .join(Result, Result.quizz_id == Quiz.id)
        .where(Result.student_id == student_id)
        .where(Quiz.type_quizz == "S")
        .distinct()
    )
    result = await db.execute(stmt)
    quizzes = result.scalars().all()
    return quizzes

async def get_correct_answers(quiz_id: int, db: AsyncSession):
    stmt = select(Choice).where(Choice.score > 0, Choice.quiz_id == quiz_id)
    result = await db.execute(stmt)
    correction = result.scalars().all()
    return correction
