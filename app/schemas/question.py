from pydantic import BaseModel

class QuestionModel(BaseModel):
    id: int
    statement: str
    duree: int

    class Config:
        from_attributes = True 