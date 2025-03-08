from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.feedback import Feedback

# Function to create anonymous feedback
async def create_feedback(description: str, groupe: str, module: str, db: AsyncSession):
    feedback = Feedback(
        description=description,
        groupe=groupe,
        module=module
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

# Function to get feedback by module
async def get_feedbacks_by_module(module: str, db: AsyncSession):
    result = await db.execute(
        select(Feedback).filter(Feedback.module == module)
    )
    feedbacks = result.scalars().all()
    return feedbacks
