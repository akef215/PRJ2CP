from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import student_router, teacher_router, auth_router, quiz_router, statistics_router, feedback_router

app = FastAPI()

# CORS : Autoriser toutes les origines temporairement (pour les tests)
app.add_middleware(
    CORSMiddleware,
    #allow_origins=["*"],  # Pour le développement, remplace par ton domaine final en production
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Ajout des routeurs
app.include_router(statistics_router.router, prefix="/statistics", tags=["Statistics"])
app.include_router(quiz_router.router, prefix="/quizzes", tags=["Quizzes"])
app.include_router(teacher_router.router, prefix="/teachers", tags=["Teachers"])
app.include_router(student_router.router, prefix="/students", tags=["Students"])
app.include_router(auth_router.router, prefix="/auth", tags=["Auth"])
app.include_router(feedback_router.router, prefix="/feedback", tags=["Feedback"])
