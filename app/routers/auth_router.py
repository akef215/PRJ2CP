from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db
from app.schemas.auth import AuthRequest, AuthResponse
from app.services.auth_service import authenticate_teacher, authenticate_student

router = APIRouter()

@router.post("/teachers/login", response_model=AuthResponse)
async def login(auth_data: AuthRequest):
    return await authenticate_teacher(auth_data.email, auth_data.password)

@router.post("/students/login", response_model=AuthResponse)
async def login(auth_data: AuthRequest, db: AsyncSession = Depends(get_db)):
    return await authenticate_student(auth_data.email, auth_data.password, db)
