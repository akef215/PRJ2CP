from pydantic import BaseModel, EmailStr
from typing import Optional

class StudentBase(BaseModel):
    name: str
    level: str
    groupe_id: str
    id: str
    email: EmailStr

class StudentCreate(StudentBase):
    password: str

    class Config:
        from_attributes = True

class StudentUpdate(BaseModel):
    name: Optional[str] = None
    level: Optional[str] = None
    groupe: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None

    class Config:
        from_attributes = True
