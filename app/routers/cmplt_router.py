from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.services.cmplt_services import create_complaint, get_all_complaints, get_complaints_by_student, get_complaints_by_quiz
from database import get_db  # Assuming get_db is your database dependency
from app.models import Complaint  # Import the Complaint model
from sqlalchemy.orm import Session

router = APIRouter()


# Route to submit a complaint
@router.post("/submit-complaint")
async def submit_complaint(description: str, id_quiz: int, id_student: str, db: AsyncSession = Depends(get_db)):
    complaint = await create_complaint(description, id_quiz, id_student, db)
    return {"message": "Complaint submitted successfully", "complaint_id": complaint.id_reclamation}


# Route to get all complaints
@router.get("/complaints")
async def get_complaints(db: AsyncSession = Depends(get_db)):
    complaints = await get_all_complaints(db)
    return complaints


# Route to get complaints by student ID
# Route to get complaints by student ID
@router.get("/complaints/student/{id_student}")
async def get_complaints_by_student(id_student: str, db: AsyncSession = Depends(get_db)):
    complaints = await get_complaints_by_student(id_student, db)
    if not complaints:
        raise HTTPException(status_code=404, detail="No complaints found for this student")
    return complaints

# Route to get complaints by quiz ID
@router.get("/complaints/quiz/{id_quiz}")
async def get_complaints_by_quiz(id_quiz: int, db: Session = Depends(get_db)):
    try:
        complaints = db.query(Complaint).filter(Complaint.id_quiz == id_quiz).all()
        return complaints
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")

