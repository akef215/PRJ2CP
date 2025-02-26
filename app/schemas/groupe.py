from pydantic import BaseModel, EmailStr

class GroupeBase(BaseModel):
    level: str
    numero: int
    id: str