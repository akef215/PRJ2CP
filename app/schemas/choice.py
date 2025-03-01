from pydantic import BaseModel
from typing import List

class ChoiceModel(BaseModel):
    id: int
    score: float
    answer: str