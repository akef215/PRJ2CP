from pydantic import BaseModel
from datetime import date
from .groupe import GroupAssignment
from typing import Optional, List

class QuizOut(BaseModel):
    id: int
    title: str
    date: date
    description: str
    module_code: str
    type_quizz: str
    duree: int

    class Config:
        from_attributes = True 

class QuizCreate(BaseModel):
    title: str
    date: date
    module: str  # Ensure this field matches the database schema
    duree: int
    description: Optional[str] = None
    groupes: List[GroupAssignment]  # Make it a list of groups

class Answer(BaseModel):
    question_id: int
    choice_id: int

class AnswerSubmission(BaseModel):
    question_id: int
    choice_id: int

class QuizSubmission(BaseModel):
    answers: List[AnswerSubmission]