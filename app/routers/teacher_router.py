from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db
from app.schemas.module import ModuleBase
from app.services.teacher_service import get_groups, get_all_students, get_students_by_groupe, create_group, create_module, get_modules, supp_module

router = APIRouter()

@router.post("/add_groupe")
async def add_groupe(level : str, numero: int, db: AsyncSession = Depends(get_db)):
    return await create_group(db, level, numero)

@router.post("/add_module")
async def add_module(module: ModuleBase, db: AsyncSession = Depends(get_db)):
    return await create_module(db, module)

@router.delete("/delete_module")
async def delete_module(code: str, db: AsyncSession = Depends(get_db)):
    return await supp_module(db, code)

@router.get("/groupes")
async def show_groupes(db: AsyncSession = Depends(get_db)):
    return await get_groups(db)

@router.get("/students")
async def show_all_students(db : AsyncSession = Depends(get_db)):
    return await get_all_students(db)

@router.get("/{groupe}/students")
async def show_groupe_students(groupe: str, db : AsyncSession = Depends(get_db)):
    return await get_students_by_groupe(db, groupe)

@router.get("/modules")
async def show_groupes(db: AsyncSession = Depends(get_db)):
    return await get_modules(db)
