from fastapi import HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.student import Student
from app.models.module import Module
from app.schemas.student import StudentCreate
from app.utils.hash import hash_password
from app.schemas.student import StudentUpdate

async def create_student_service(student: StudentCreate, db: AsyncSession):
    # Vérifier si l'email est déjà utilisé
    stmt = select(Student).where(Student.email == student.email)
    result = await db.execute(stmt)  
    existing_teacher = result.scalars().first()
    if existing_teacher:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Hasher le mot de passe
    hashed_password = hash_password(student.password)

    # Créer l’objet Student
    db_student = Student(id=student.id,  name=student.name, level=student.level, groupe_id=student.groupe_id, email=student.email, password=hashed_password)
    db.add(db_student)
    await db.commit()  
    await db.refresh(db_student)  

    return db_student

async def delete_student_service(student_id: str, db: AsyncSession):

    # Exécuter la requête avec select() pour AsyncSession
    result = await db.execute(select(Student).filter(Student.id == student_id))
    student = result.scalars().first()

    if not student:
        raise HTTPException(status_code=404, detail=f"Teacher with ID {student_id} not found")

    await db.delete(student)
    await db.commit()

    return {"message": f"Student with ID {student_id} deleted successfully"}

async def delete_current_student(current_student: dict, db:AsyncSession):
    id = current_student["sub"]
    result = await db.execute(select(Student).filter(Student.id == id))
    student = result.scalars().first()
    
    await db.delete(student)
    await db.commit()

    return {"message": "Student deleted successfully"}


async def get_student_modules(current_student:dict, db:AsyncSession):
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


async def get_student_group(db: AsyncSession, current_student: dict):
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


async def update_student_profile(updated_data: StudentUpdate, db: AsyncSession, current_student: dict):
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
