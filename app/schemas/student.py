from pydantic import BaseModel, EmailStr

class StudentBase(BaseModel):
    fname: str
    lname: str
    level:str
    groupe_id:str
    id: str
    email: EmailStr

class StudentCreate(StudentBase):
    password: str

    class Config:
        from_attributes = True 