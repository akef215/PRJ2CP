from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas.student import StudentCreate, StudentBase
from database import get_db
from app.services.student_service import create_student_service, delete_student_service, delete_current_student, get_student_modules, get_student_group
from app.dependencies.auth import get_current_student

router = APIRouter()

@router.post("/SignUp", response_model=StudentBase)
async def create_student(student: StudentCreate, db: AsyncSession = Depends(get_db)):
    return await create_student_service(student, db)

@router.get("/me/Profile")
async def get_my_profile(current_student: dict = Depends(get_current_student)):
    return {"id": current_student["sub"],
            "exp": current_student["exp"]}

@router.delete("/me/Delete")
async def delete_teacher(current_student: dict = Depends(get_current_student), db: AsyncSession = Depends(get_db)):
    return await delete_current_student(current_student, db)

@router.get("/me/modules")
async def get_my_modules(current_student: dict = Depends(get_current_student), db: AsyncSession = Depends(get_db)):
    return await get_student_modules(current_student, db)


@router.get("/me/group")
async def get_my_group(current_student: dict = Depends(get_current_student), db: AsyncSession = Depends(get_db)):
    return await get_student_group(current_student, db)

