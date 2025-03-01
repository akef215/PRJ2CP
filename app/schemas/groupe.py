from pydantic import BaseModel
from typing import List

class GroupeBase(BaseModel):
    level: str
    numero: int
    id: str

class GroupAssignment(BaseModel):
    group_ids: List[str] 