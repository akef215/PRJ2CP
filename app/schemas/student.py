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

    model_config = {"from_attributes": True}

# Model for updating student info
class StudentUpdate(BaseModel):
    name: Optional[str] = None
    level: Optional[str] = None
    groupe_id: Optional[str] = None  # Correction ici
    email: Optional[EmailStr] = None
    password: Optional[str] = None

    model_config = {"from_attributes": True}

# Define the response model for when sending student data back
class StudentResponse(BaseModel):
    id: str  
    code: str  
    name: str
    groupe_id: str  # Ajout de groupe_id

    model_config = {"from_attributes": True}
