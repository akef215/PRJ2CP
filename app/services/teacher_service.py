from fastapi import Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import defer
from app.models.student import Student
from app.models.groupe import Groupe
from app.models.module import Module
from app.schemas.module import ModuleBase
from app.schemas.groupe import GroupeBase
from database import get_db
import os


from pathlib import Path

ENV_PATH = Path(__file__).resolve().parents[2] / ".env"


async def get_groupe_students(n_groupe : int, db : AsyncSession = Depends(get_db)):
    stmt = select(Student).where(Student.groupe == n_groupe)
    result = await db.execute(stmt)
    students = result.scalars().all()
    if not students:
        raise HTTPException(status_code=404, detail=f"Le groupe {n_groupe} est vide")
    return students

async def create_group(db: AsyncSession, level: str, numero: int) -> GroupeBase:
    stmt = select(Groupe).filter(Groupe.numero == numero, Groupe.level == level)
    result = await db.execute(stmt)
    db_groupe = result.scalar_one_or_none()

    if db_groupe:
        raise HTTPException(status_code=400, detail="Le groupe existe déjà")

    groupe = Groupe(level=level, numero=numero)
    db.add(groupe)
    await db.commit()
    await db.refresh(groupe)
    
    return groupe

async def create_module(db: AsyncSession, code: str, titre: str, level: str, coef : int) -> ModuleBase:
    stmt = select(Module).filter(Module.code == code)
    result = await db.execute(stmt)
    db_module = result.scalar_one_or_none()

    if db_module:
        raise HTTPException(status_code=400, detail="Le module existe déjà")

    module = Module(code=code, titre=titre, coef=coef, level=level)
    db.add(module)
    await db.commit()
    await db.refresh(module)
    
    return module

async def get_groups(db: AsyncSession):
    result = await db.execute(select(Groupe))
    group_ids = result.scalars().all()
    return group_ids

async def get_all_students(db : AsyncSession):
    result = await db.execute(select(Student))
    students = result.scalars().all()
    return students 

async def get_students_by_groupe(db : AsyncSession, group_id: str):
    result = await db.execute(select(Groupe).where(Groupe.id == group_id))
    groupe = result.scalars().first()
    if not groupe:
        raise HTTPException(status_code=404, detail=f"The teacher has not acces to the groupe {group_id}")
    
    result = await db.execute(select(Student).options(defer(Student.password)).where(Student.groupe == group_id))
    students = result.scalars().all()
    return students

async def get_modules(db: AsyncSession):
    result = await db.execute(select(Module))
    modules_codes = result.scalars().all()
    return modules_codes




def update_env_variable(file_path: str, key: str, new_value: str):
    lines = []
    with open(file_path, "r") as f:
        lines = f.readlines()

    key_found = False
    for i, line in enumerate(lines):
        if line.strip().startswith(f"{key}="):
            lines[i] = f"{key}={new_value}\n"
            key_found = True
            break

    if not key_found:
        lines.append(f"{key}={new_value}\n")

    with open(file_path, "w") as f:
        f.writelines(lines)

async def update_teacher_profile(email: str = None, password: str = None):
    if email:
        update_env_variable(ENV_PATH, "TEACHER_EMAIL", email)
    if password:
        update_env_variable(ENV_PATH, "TEACHER_PASSWORD", password)
    return {"message": "Teacher profile updated"}