from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, Integer, ForeignKey, Float
from app.models import Base
from app.models.quiz import Quiz

class Statistic(Base):
    __tablename__ = "statistiques"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    id_student: Mapped[str] = mapped_column(String(7), ForeignKey("students.id"), nullable=False)
    id_quiz: Mapped[int] = mapped_column(Integer, ForeignKey("quizzes.id"), nullable=False)
    pourcentage: Mapped[int] = mapped_column(Float, nullable=False)

    quiz = relationship("Quiz", back_populates="statistics")
