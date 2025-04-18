from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db
from app.schemas.auth import AuthRequest, AuthResponse
from app.services.auth_service import authenticate_teacher, authenticate_student, request_password_reset, confirm_password_reset

router = APIRouter()

@router.post("/teachers/login", response_model=AuthResponse)
async def login(auth_data: AuthRequest):
    return await authenticate_teacher(auth_data.email, auth_data.password)

@router.post("/students/login", response_model=AuthResponse)
async def login(auth_data: AuthRequest, db: AsyncSession = Depends(get_db)):
    return await authenticate_student(auth_data.email, auth_data.password, db)


@router.post("/forgot-password")
async def forgot_password(email: str, db: AsyncSession = Depends(get_db)):
    return await request_password_reset(email, db)

@router.post("/reset-password")
async def reset_password(email: str, code: str, new_password: str, db: AsyncSession = Depends(get_db)):
    return await confirm_password_reset(email, code, new_password, db)