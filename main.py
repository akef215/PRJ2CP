from fastapi import FastAPI
from app.routers import student_router, teacher_router, auth_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Autorise toutes les origines (à restreindre en prod)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(teacher_router.router, prefix="/teachers", tags=["Teachers"])
app.include_router(student_router.router, prefix="/students", tags=["Students"])
app.include_router(auth_router.router, prefix="/auth", tags=["Auth"])