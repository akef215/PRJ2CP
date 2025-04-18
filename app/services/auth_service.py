from sqlalchemy.ext.asyncio import AsyncSession
from app.utils.hash import hash_password
from sqlalchemy.future import select
from fastapi import HTTPException, Depends
from app.models.student import Student
from app.utils.hash import verify_password, hash_password
from app.utils.jwt import create_access_token
from database import get_db  # Import get_db dependency
from app.models.password_reset import PasswordReset  # Import PasswordReset model
from dotenv import load_dotenv
import os
from datetime import datetime, timedelta
from app.utils.token import generate_verification_code
load_dotenv()

print("EMAIL:", os.getenv("TEACHER_EMAIL"))
print("PASSWORD:", os.getenv("TEACHER_PASSWORD"))


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

async def request_password_reset(email: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Student).where(Student.email == email))
    student = result.scalars().first()
    
    if not student or not email.endswith("@esi.dz"):
        raise HTTPException(status_code=404, detail="Email not found or invalid")

    def generate_verification_code():
        import random
        return str(random.randint(100000, 999999))
    
    code = generate_verification_code()
    
    reset = PasswordReset(
        email=email,
        code=code,
        expires_at=datetime.utcnow() + timedelta(minutes=10)
    )

    await db.merge(reset)
    await db.commit()

    # Ici tu dois envoyer le mail (ou simuler dans la console si test)
    print(f"Verification code for {email}: {code}")

    return {"message": "Verification code sent to your email"}


async def confirm_password_reset(email: str, code: str, new_password: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(PasswordReset).where(PasswordReset.email == email))
    record = result.scalars().first()

    if not record or record.code != code or record.expires_at < datetime.utcnow():
        raise HTTPException(status_code=400, detail="Invalid or expired code")

    result = await db.execute(select(Student).where(Student.email == email))
    student = result.scalars().first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    student.password = hash_password(new_password)
    await db.commit()

    return {"message": "Password updated successfully"}
