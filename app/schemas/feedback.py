from pydantic import BaseModel
from datetime import datetime

# Schema for creating feedback
class FeedbackCreate(BaseModel):
    groupe: str
    
    description: str

    class Config:
        from_attributes = True  # Enables ORM compatibility

# Schema for returning feedback data
class FeedbackResponse(FeedbackCreate):
    id: int
    date: datetime

    class Config:
        from_attributes = True  # Enables ORM compatibility
