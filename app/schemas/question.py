from pydantic import BaseModel

class QuestionModel(BaseModel):
    statement: str
    duree: int
    
    class Config:
        from_attributes = True 