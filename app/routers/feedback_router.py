from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db
from app.models.feedback import Feedback
from app.services.feedback_service import (
    create_feedback, get_all_feedbacks, get_feedbacks_by_group, get_feedbacks_by_module, get_feedbacks_by_id, delete_feedback
)

router = APIRouter(tags=["Feedback"])

# Create a new anonymous feedback
@router.post("/")
async def submit_feedback(description: str, groupe: str, module: str, db: AsyncSession = Depends(get_db)):
    if not description.strip():
        raise HTTPException(status_code=400, detail="Description cannot be empty")
    
    feedback = await create_feedback(description=description, groupe=groupe, module=module, db=db)
    return {"message": "Feedback submitted successfully", "feedback": feedback}

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

# Get feedbacks by module
@router.get("/module/{module}")
async def fetch_feedbacks_by_module(module: str, db: AsyncSession = Depends(get_db)):
    feedbacks = await get_feedbacks_by_module(module, db)
    if not feedbacks:
        raise HTTPException(status_code=404, detail="No feedback found for this module")
    return feedbacks
