from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, Integer, ForeignKey
from app.models import Base

class Statistic(Base):
    __tablename__ = "statistiques"  # Correction du nom de la table

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    id_student: Mapped[str] = mapped_column(String(7), ForeignKey("students.id"), nullable=False)
    id_quiz: Mapped[int] = mapped_column(Integer, ForeignKey("quizzes.id"), nullable=False)
    score: Mapped[int] = mapped_column(Integer, nullable=False)
