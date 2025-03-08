from pydantic import BaseModel, EmailStr
from typing import Optional

# Base model for student
class StudentBase(BaseModel):
    name: str
    level: str
    groupe_id: str
    id: str
    email: EmailStr

# Model for creating a student
class StudentCreate(StudentBase):
    password: str

    class Config:
        from_attributes = True

# Model for updating student info
class StudentUpdate(BaseModel):
    name: Optional[str] = None
    level: Optional[str] = None
    groupe: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None

    class Config:
        from_attributes = True

# Define the response model for when sending student data back
class StudentResponse(BaseModel):
    id: int  # This can stay as int if 'id' is an integer
    code: str  # Change to 'str' to handle values like '23/0276'
    name: str

    class Config:
        from_attributes = True