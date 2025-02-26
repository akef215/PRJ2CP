from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, Integer, ForeignKey, DateTime, Boolean, Text
from datetime import datetime
from app.models import Base

class Complaint(Base):
    __tablename__ = "complaints"

    id_reclamation: Mapped[int] = mapped_column(Integer, primary_key=True, nullable=False)
    id_student: Mapped[str] = mapped_column(String(9), ForeignKey("students.id"), nullable=False)
    id_quiz: Mapped[int] = mapped_column(Integer, ForeignKey("quizzes.id"), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    statut: Mapped[bool] = mapped_column(Boolean, default=False)
    date_reclamation: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    # Relations
    student = relationship("Student", back_populates="complaints")
    quiz = relationship("Quiz", back_populates="complaints")
