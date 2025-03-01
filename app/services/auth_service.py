from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from fastapi import HTTPException
from app.models.student import Student
from app.utils.hash import verify_password
from app.utils.jwt import create_access_token
from dotenv import load_dotenv
import os

load_dotenv()

async def authenticate_teacher(email: str, password: str):
    if (email != os.getenv("TEACHER_EMAIL") or password != os.getenv("TEACHER_PASSWORD")):
        raise HTTPException(status_code=401, detail="Unauthorised operation")
    # Générer un token JWT
    token = create_access_token({"sub": os.getenv("TEACHER_EMAIL")})
    return {"access_token": token, "token_type": "bearer", "detail" : "Succes!"}

async def authenticate_student(email: str, password: str, db: AsyncSession):
    stmt = select(Student).where(Student.email == email)
    result = await db.execute(stmt)
    student = result.scalars().first()

    if not student or not verify_password(password, student.password):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_access_token({"sub": student.id})
    return {"access_token" : token, "token_type" : "bearer"}