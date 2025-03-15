from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.schemas.student import StudentCreate, StudentBase, StudentResponse, StudentUpdate  # Add StudentResponse and StudentUpdate here
from database import get_db
from app.services.student_service import (
    create_student_service,
    delete_student_service,
    delete_current_student,
    get_student_modules,
    get_student_group,
    update_student_profile,
    get_current_student  # Add get_current_student here
)
from app.services.student_service import create_student_service, add_result, delete_current_student, get_student_modules, get_student_group, update_student_profile

router = APIRouter()

# Route for creating a student
@router.post("/SignUp", response_model=StudentBase)
async def create_student(student: StudentCreate, db: AsyncSession = Depends(get_db)):
    return await create_student_service(student, db)

# Route to get the current student's profile@router.get("/me/Profile", response_model=StudentResponse)
async def get_my_profile(current_student: dict = Depends(get_current_student)):
    return StudentResponse(
        id=current_student["sub"], 
        code=current_student.get("code", ""), 
        name=current_student.get("name", "")
    )

# Route to delete the current student
@router.delete("/me/Delete")
async def delete_student(current_student: dict = Depends(get_current_student), db: AsyncSession = Depends(get_db)):
    return await delete_current_student(current_student, db)

# Route to get the current student's modules
@router.get("/me/modules")
async def get_my_modules(current_student: dict = Depends(get_current_student), db: AsyncSession = Depends(get_db)):
    return await get_student_modules(current_student, db)

# Route to get the current student's group
@router.get("/me/group")
async def get_my_group(current_student: dict = Depends(get_current_student), db: AsyncSession = Depends(get_db)):
    return await get_student_group(current_student, db)

# Route to update the current student's profile
@router.put("/students/me/profile", response_model=dict)
async def update_profile(updated_data: StudentUpdate, db: AsyncSession = Depends(get_db), current_student: dict = Depends(get_current_student)):
    return await update_student_profile(updated_data, db, current_student)

@router.post("/answer_quiz/{quiz_id}/question/{question_id}")
async def submit_result(question_id: int, quiz_id: int, choice_id: int, db: AsyncSession = Depends(get_db), current_student: dict = Depends(get_current_student)):
    return await add_result(question_id, quiz_id, choice_id, db, current_student)
