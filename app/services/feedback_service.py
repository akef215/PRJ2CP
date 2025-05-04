from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.feedback import Feedback
from app.models.groupe import Groupe


# Function to create anonymous feedback
async def create_feedback(description: str, groupe: str, db: AsyncSession):
    # Récupère l'objet Groupe depuis la base
    result = await db.execute(select(Groupe).where(Groupe.id == groupe))
    groupe_obj = result.scalar_one_or_none()

    if not groupe_obj:
        raise ValueError("Groupe introuvable")

    # Crée le feedback avec l'objet, pas la string
    feedback = Feedback(
        description=description,
        groupe=groupe_obj,
    )
    db.add(feedback)
    await db.commit()
    await db.refresh(feedback)
    return feedback

# Function to get all feedbacks
async def get_all_feedbacks(db: AsyncSession):
    result = await db.execute(select(Feedback))
    feedbacks = result.scalars().all()
    return feedbacks

# Function to get feedback by group
async def get_feedbacks_by_group(groupe: str, db: AsyncSession):
    result = await db.execute(
        select(Feedback).filter(Feedback.groupe == groupe)
    )
    feedbacks = result.scalars().all()
    return feedbacks


async def get_feedbacks_by_id(id: int, db: AsyncSession):
    result = await db.execute(
        select(Feedback).filter(Feedback.id == id)
    )
    feedback = result.scalars().first()
    return feedback

async def delete_feedback(id: int, db: AsyncSession):
    result = await db.execute(
        select(Feedback).filter(Feedback.id == id)
    )
    feedback = result.scalars().first()
    if not feedback:
        return "erreur"
    
    await db.delete(feedback);
    await db.commit()
    return "success"