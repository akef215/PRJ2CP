from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import Session
from sqlalchemy.future import select
from app.models import Complaint
from datetime import datetime
from fastapi import HTTPException

# Function to create a complaint
async def create_complaint(description: str, id_quiz: int, id_student: str, db: AsyncSession):
    complaint = Complaint(
        description=description,
        id_quiz=id_quiz,
        id_student=id_student
    )
    db.add(complaint)
    await db.commit()  # Awaiting commit to save changes
    await db.refresh(complaint)  # Awaiting refresh to load updated data
    return complaint

# Function to get all complaints
async def get_all_complaints(db: AsyncSession):
    result = await db.execute(select(Complaint))
    complaints = result.scalars().all()
    return complaints

# Function to get complaints by student
# Function to get complaints by student ID
async def get_complaints_by_student(id_student: str, db: AsyncSession):
    result = await db.execute(
        select(Complaint).filter(Complaint.id_student == id_student)
    )
    complaints = result.scalars().all()
    return complaints

# Function to get complaints by quiz ID
async def get_complaints_by_quiz(id_quiz: int, db: AsyncSession):
    result = await db.execute(
        select(Complaint).filter(Complaint.id_quiz == id_quiz)
    )
    complaints = result.scalars().all()
    return complaints
# Function to delete a complaint
