from pydantic import BaseModel


class ModuleBase(BaseModel):
    code: str
    titre: str
    coef: int
    level:str