from fastapi import HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from datetime import date
from typing import List
from app.models.groupe import Groupe
from app.models.module import Module
from app.models.quiz import Quiz
from app.models.choice import Choice
from app.models.question import Question
from app.models.quiz_groupe import quiz_groupe
from app.schemas.quiz import QuizCreate
from app.schemas.question import QuestionModel
from app.schemas.choice import ChoiceModel

async def get_available_quizzes_service(db: AsyncSession) -> List[Quiz]:
    """Fetch quizzes that are available (i.e., their date is today or in the future)."""
    today = date.today()
    stmt = select(Quiz).where(Quiz.date >= today)
    result = await db.execute(stmt)
    return result.scalars().all()

async def add_quiz_to_groups(db: AsyncSession, quiz_id: int, group_ids: list[str]):
    for group_id in group_ids:
        association = quiz_groupe(quiz_id=quiz_id, groupe_id=group_id)
        db.add(association)
    await db.commit()

async def add_quiz(quizz: QuizCreate, db: AsyncSession):
    
    # Instanciation d'un quiz
    quiz = Quiz(title = quizz.title, date = quizz.date, description = quizz.description, module_code = quizz.module, duree = quizz.duree)

    # La recherche du module
    result = await db.execute(select(Module).where(Module.code == quizz.module))
    code = result.scalars().first()

    if not code:
        raise HTTPException(status_code=404, detail="Le module n'existe pas")

    # La recherche des groupes
    result = await db.execute(select(Groupe).where(Groupe.id.in_(tuple(quizz.groupes.group_ids))))
    groups = result.scalars().all()

    if not groups:
        raise HTTPException(status_code=404, detail="No group found")

    # L'ajout du quiz dans la base de donnée
    db.add(quiz)
    await db.commit()

    # Associer les groupes au quiz
    await db.refresh(quiz)
    result = await db.execute(select(Quiz).where(Quiz.id == quiz.id).options(selectinload(Quiz.groupes)))
    quiz = result.scalars().first()
    quiz.groupes.extend(groups)
    await db.commit()
    await db.refresh(quiz, ["groupes"])
   
    return quiz

async def add_question(quiz_id: int, question: QuestionModel, db: AsyncSession):
    # Instanciation de la question
    qstn = Question(question_id = question.id, quiz_id = quiz_id, statement = question.statement, duree = question.duree)

    # Verifier que le quiz existe deja
    results = await db.execute(select(Quiz).where(Quiz.id == quiz_id))
    quiz = results.scalars().first();
    if not quiz:
        raise HTTPException(status_code=404, detail="No quiz found")
    
    db.add(qstn)
    await db.commit()

    return qstn

async def add_choice(quiz_id: int, question_id: int, choix: ChoiceModel, db: AsyncSession):
    # Instanciation de la question
    choice = Choice(choice_id = choix.id, quiz_id = quiz_id, score = choix.score, answer = choix.answer)

    # Verifier que le quiz existe deja
    results = await db.execute(select(Quiz).where(Quiz.id == quiz_id))
    quiz = results.scalars().first();
    if not quiz:
        raise HTTPException(status_code=404, detail="No quiz found")
    
    # Verifier que la question existe deja
    results = await db.execute(select(Question).where(Question.quiz_id == quiz_id, Question.question_id == question_id))
    qstn = results.scalars().first()
    if not qstn:
        raise HTTPException(status_code=404, detail="No question found")
    
    qid = qstn.id
    choice.question_id = qid
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

async def delete_question_service(quiz_id: int, question_id: int, db: AsyncSession):
    result = await db.execute(select(Question).filter(Question.question_id == question_id, Question.quiz_id == quiz_id))
    question = result.scalars().first()

    if not question:
        raise HTTPException(status_code=404, detail=f"Question not found")

    await db.delete(question)
    await db.commit()

    return {"message": f"Question deleted successfully"}

async def delete_choice_service(choice_id: int, quiz_id: int, question_id: int, db: AsyncSession):
    result = await db.execute(select(Question).filter(Question.question_id == question_id, Question.quiz_id == quiz_id))
    question = result.scalars().first()

    if not question:
        raise HTTPException(status_code=404, detail=f"Question not found")

    result = await db.execute(select(Choice).where(Choice.choice_id == choice_id, Choice.question_id == question_id, Choice.id == quiz_id))
    choice = result.scalars().first()
    await db.delete(choice)
    await db.commit()

    return {"message": f"Choice deleted successfully"}