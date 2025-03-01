from pydantic import BaseModel
from datetime import date

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
