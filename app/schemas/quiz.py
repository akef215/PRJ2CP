from pydantic import BaseModel
from datetime import date
from .groupe import GroupAssignment
from typing import Optional

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
    module: str
    duree: int
    description: Optional[str] = None
    groupes: GroupAssignment 
