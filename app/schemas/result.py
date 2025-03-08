from pydantic import BaseModel
from typing import List

# Define the response model
class ResultResponse(BaseModel):
    id: int
    student_id: int
    question_id: int
    quizz_id: int
    choice_id: str  # Treat choice_id as a string since it contains slashes

    class Config:
        orm_mode = True  # This is to allow the Pydantic model to work with SQLAlchemy models
