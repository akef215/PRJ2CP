from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel
from database import get_db

from app.services.feedback_service import create_feedback, get_feedbacks_by_group,  get_all_feedbacks


from app.models.feedback import Feedback
from app.services.feedback_service import (
    create_feedback, get_all_feedbacks, get_feedbacks_by_group, get_feedbacks_by_id, delete_feedback
)

router = APIRouter(tags=["Feedback"])


router = APIRouter(tags=["Feedback"])

class FeedbackRequest(BaseModel):
    description: str
    groupe: str
    

@router.post("/")
async def submit_feedback(
    feedback: FeedbackRequest, 
    db: AsyncSession = Depends(get_db)
):
    print(f"✅ Reçu : {feedback.model_dump()}")

    if not feedback.description.strip():
        raise HTTPException(status_code=400, detail="Description cannot be empty")

    feedback_entry = await create_feedback(
        description=feedback.description,
        groupe=feedback.groupe,
        
        db=db
    )

    return {"message": "Feedback submitted successfully", "feedback": feedback_entry}

# Get all feedbacks
@router.get("/")
async def fetch_all_feedbacks(db: AsyncSession = Depends(get_db)):
    feedbacks = await get_all_feedbacks(db)
    return feedbacks

# Get feedbacks by group
@router.get("/group/{groupe}")
async def fetch_feedbacks_by_group(groupe: str, db: AsyncSession = Depends(get_db)):
    feedbacks = await get_feedbacks_by_group(groupe, db)
    if not feedbacks:
        raise HTTPException(status_code=404, detail="No feedback found for this group")
    return feedbacks

# Get feedbacks by Id
@router.get("/{id}")
async def fetch_feedbacks_by_id(id: int, db: AsyncSession = Depends(get_db)):
    feedbacks = await get_feedbacks_by_id(id, db)
    if not feedbacks:
        raise HTTPException(status_code=404, detail="No feedback found for this id")
    return feedbacks

@router.delete("/{id}")
async def delete_feedback_by_id(id: int, db: AsyncSession = Depends(get_db)):
    return await delete_feedback(id, db)

