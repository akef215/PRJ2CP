from fastapi import Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.student import Student
from app.models.module import Module
from app.models.quiz import Quiz
from app.models.question import Question
from app.models.choice import Choice
from app.models.results import Result
from app.models.groupe import Groupe
from app.schemas.student import StudentCreate, StudentUpdate
from database import get_db
from app.utils.hash import hash_password
from app.dependencies.auth import get_current_student

async def create_student_service(student: StudentCreate, db: AsyncSession = Depends(get_db)):
    # Vérifier si l'email est déjà utilisé
    stmt = select(Student).where(Student.email == student.email)
    result = await db.execute(stmt)  
    existing_student = result.scalars().first()  # Correction du nom de variable

    if existing_student:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Hasher le mot de passe
    hashed_password = hash_password(student.password)

    # Créer l’objet Student
    db_student = Student(
        id=student.id,
        name=student.name,
        email=student.email,
        password=hashed_password,
        level=student.level,
        groupe=student.groupe_id
    )
    db.add(db_student)
    await db.commit()  
    await db.refresh(db_student)  

    return db_student

async def delete_student_service(student_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Student).filter(Student.id == student_id))
    student = result.scalars().first()

    if not student:
        raise HTTPException(status_code=404, detail=f"Student with ID {student_id} not found")

    await db.delete(student)
    await db.commit()

    return {"message": f"Student with ID {student_id} deleted successfully"}

async def delete_current_student(current_student: dict = Depends(get_current_student), db: AsyncSession = Depends(get_db)):
    student_id = current_student["sub"]
    result = await db.execute(select(Student).filter(Student.id == student_id))
    student = result.scalars().first()

    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    await db.delete(student)
    await db.commit()

    return {"message": "Student deleted successfully"}
async def get_student_modules(current_student: dict = Depends(get_current_student), db: AsyncSession = Depends(get_db)):
    student_id = current_student["sub"]
    print(f"Student ID from token: {student_id}")  # Debugging

    result = await db.execute(select(Student).filter(Student.id == student_id))
    student = result.scalars().first()
    
    if not student:
        print(f"Student with ID {student_id} not found in DB")
        raise HTTPException(status_code=404, detail="Student not found")

    print(f"Student found: {student.id}, Level: {student.level}")

    level = student.level
    stmt = select(Module).where(Module.level == level)
    result = await db.execute(stmt)
    modules = result.scalars().all()

    print(f"Modules found: {modules}")  # Voir si des modules sont trouvés

    return modules


async def get_student_group(current_student: dict = Depends(get_current_student), db: AsyncSession = Depends(get_db)):
    student_id = current_student["sub"]

    result = await db.execute(select(Student).filter(Student.id == student_id))
    student = result.scalars().first()

    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    result = await db.execute(select(Groupe).filter(Groupe.id == student.groupe))
    groupe = result.scalars().first()

    if not groupe:
        raise HTTPException(status_code=404, detail="Student has no assigned group")

    return groupe

async def update_student_profile(
    updated_data: StudentUpdate,
    db: AsyncSession = Depends(get_db),
    current_student: dict = Depends(get_current_student)
):
    student_id = current_student["sub"]
    result = await db.execute(select(Student).where(Student.id == student_id))
    student = result.scalars().first()

    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    # Vérifier si l'email est déjà utilisé par un autre étudiant
    if updated_data.email and updated_data.email != student.email:
        result = await db.execute(select(Student).where(Student.email == updated_data.email))
        existing_student = result.scalars().first()
        if existing_student:
            raise HTTPException(status_code=400, detail="Email already registered")

    # Mise à jour des champs
    if updated_data.name:
        student.name = updated_data.name
    if updated_data.email:
        student.email = updated_data.email
    if updated_data.level:
        student.level = updated_data.level
    if updated_data.groupe_id:
        student.groupe = updated_data.groupe_id
    if updated_data.password:
        student.password = hash_password(updated_data.password)

    await db.commit()
    await db.refresh(student)

    return {"message": "Profile updated successfully", "student": student}

async def add_result(
    question_id: int,
    quizz_id: int,
    choice_id: int,
    db: AsyncSession = Depends(get_db),
    current_student: dict = Depends(get_current_student)
):
    student_id = current_student["sub"]
    
    # Vérification de l'existence de l'étudiant
    result = await db.execute(select(Student).where(Student.id == student_id))
    student = result.scalars().first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    # Vérification de l'existence du quiz
    result = await db.execute(select(Quiz).where(Quiz.id == quizz_id))
    quiz = result.scalars().first()
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")

    # Vérification de l'existence de la question
    result = await db.execute(select(Question).where(Question.quiz_id == quizz_id, Question.id == question_id))
    question = result.scalars().first()
    if not question:
        raise HTTPException(status_code=404, detail="Question not found")

    # Vérification de l'existence du choix
    result = await db.execute(select(Choice).where(Choice.quiz_id == quizz_id, Choice.question_id == question.id, Choice.id == choice_id))
    choice = result.scalars().first()
    if not choice:
        raise HTTPException(status_code=404, detail="Choice not found")

    # Enregistrement du résultat
    new_result = Result(
        student_id=student.id,
        question_id=question_id,
        quizz_id=quizz_id,
        choice_id=choice.choice_id
    )

    db.add(new_result)
    await db.commit()
    await db.refresh(new_result)
    return new_result
