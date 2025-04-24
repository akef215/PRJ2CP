from pydantic import BaseModel

class ChoiceModel(BaseModel):
    score: float
    answer: str