from sqlalchemy import Column, String, Integer, ForeignKey, Table
from app.models import Base

quiz_groupe = Table(
    "quiz_groupe",
    Base.metadata,
    Column("quiz_id", Integer, ForeignKey("quizzes.id", ondelete="CASCADE"), primary_key=True),
    Column("group_id", String(8), ForeignKey("groupes.id", ondelete="CASCADE"), primary_key=True)
)
