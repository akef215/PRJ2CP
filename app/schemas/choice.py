from pydantic import BaseModel

class ChoiceModel(BaseModel):
    id: int
    score: float
    answer: str