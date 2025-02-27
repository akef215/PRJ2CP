from fastapi import FastAPI
from app.routers import student_router, teacher_router, auth_router,quiz_router

app = FastAPI()

app.include_router(teacher_router.router, prefix="/teachers", tags=["Teachers"])
app.include_router(student_router.router, prefix="/students", tags=["Students"])
app.include_router(auth_router.router, prefix="/auth", tags=["Auth"])
app.include_router(quiz_router.router, prefix="/quizzes", tags=["Quizzes"]) 