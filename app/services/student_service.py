from fastapi import Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.student import Student
from app.models.module import Module
from app.models.quiz import Quiz
from app.models.question import Question
from app.models.choice import Choice
from app.schemas.student import StudentCreate
from app.models import Result
from database import get_db
from app.utils.hash import hash_password
from app.dependencies.auth import get_current_student
from app.schemas.student import StudentUpdate

async def create_student_service(student: StudentCreate, db: AsyncSession = Depends(get_db)):
    # Vérifier si l'email est déjà utilisé
    stmt = select(Student).where(Student.email == student.email)
    result = await db.execute(stmt)  
    existing_teacher = result.scalars().first()
    if existing_teacher:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Hasher le mot de passe
    hashed_password = hash_password(student.password)

    # Créer l’objet Student
    db_student = Student(id=student.id,  name=student.name, email=student.email, password=hashed_password, level=student.level, groupe=student.groupe_id)
    db.add(db_student)
    await db.commit()  
    await db.refresh(db_student)  

    return student

async def delete_student_service(student_id: str, db: AsyncSession = Depends(get_db)):

    # Exécuter la requête avec select() pour AsyncSession
    result = await db.execute(select(Student).filter(Student.id == student_id))
    student = result.scalars().first()

    if not student:
        raise HTTPException(status_code=404, detail=f"Teacher with ID {student_id} not found")

    await db.delete(student)
    await db.commit()

    return {"message": f"Student with ID {student_id} deleted successfully"}

async def delete_current_student(current_student: dict = Depends(get_current_student), db:AsyncSession = Depends(get_db)):
    id = current_student["sub"]
    result = await db.execute(select(Student).filter(Student.id == id))
    student = result.scalars().first()
    
    await db.delete(student)
    await db.commit()

    return {"message": "Student deleted successfully"}


async def get_student_modules(current_student:dict = Depends(get_current_student),db:AsyncSession = Depends(get_db)):
    student_id = current_student["sub"]
    result = await db.execute(select(Student).filter(Student.id == student_id))
    student = result.scalars().first()
    
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

   # Assuming there is a relationship between student and module
    level = student.level
    stmt = select(Module).where(Module.level == level)
    result = await db.execute(stmt)
    modules = result.scalars().all()
    return modules


async def get_student_group(current_student: dict = Depends(get_current_student), db: AsyncSession = Depends(get_db)):
    student_id = current_student["sub"]

    # Recherche de l'étudiant
    result = await db.execute(select(Student).filter(Student.id == student_id))
    student = result.scalars().first()

    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    # Récupération du groupe de l'étudiant
    result = await db.execute(select(groupe).filter(groupe.id == student.groupe))
    groupe = result.scalars().first()

    if not groupe:
        raise HTTPException(status_code=404, detail="Student has no assigned group")

    return groupe


async def update_student_profile(updated_data: StudentUpdate, db: AsyncSession = Depends(get_db), current_student: dict = Depends(get_current_student)):
    student_id = current_student["sub"]

    # Fetch the student record
    result = await db.execute(select(Student).where(Student.id == student_id))
    student = result.scalars().first()

    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    # Check if email is already taken by another student
    if updated_data.email and updated_data.email != student.email:
        result = await db.execute(select(Student).where(Student.email == updated_data.email))
        existing_student = result.scalars().first()
        if existing_student:
            raise HTTPException(status_code=400, detail="Email already registered")

    # Update fields
    if updated_data.name:
        student.name = updated_data.name

    if updated_data.email:
        student.email = updated_data.email
    if updated_data.level:
        student.level = updated_data.level
    if updated_data.groupe:
        student.groupe = updated_data.groupe
    if updated_data.password:
        student.password = hash_password(updated_data.password)

    await db.commit()
    await db.refresh(student)

    return {"message": "Profile updated successfully", "student": student}

async def add_result(question_id: int, quizz_id: int, choice_id: int, db: AsyncSession, current_student: dict = Depends(get_current_student)):
    student_id = current_student["sub"]
    result = await db.execute(select(Student).where(Student.id == student_id))
    student = result.scalars().first()
    
    result = await db.execute(select(Quiz).where(Quiz.id == quizz_id))
    quiz = result.scalars().first()

    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")
    
    result = await db.execute(select(Question).where(Question.quiz_id == quizz_id, Question.question_id == question_id))
    question = result.scalars().first()

    if not question:
        raise HTTPException(status_code=404, detail="Question not found")
    
    result = await db.execute(select(Choice).where(Choice.quiz_id == quizz_id, Choice.question_id == question.id, Choice.choice_id == choice_id))
    choice = result.scalars().first()

    if not choice:
        raise HTTPException(status_code=404, detail="Choice not found")
    
    new_result = Result(
        student_id=student.id,
        question_id=question_id,
        quizz_id=quizz_id,
        choice_id=choice.id
    )

    db.add(new_result)
    await db.commit()
    await db.refresh(new_result)
    return new_result