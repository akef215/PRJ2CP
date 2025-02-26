from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import Text, Integer, ForeignKey, DateTime, Boolean
from datetime import datetime
from app.models import Base

class Reclamation(Base):
    __tablename__ = "reclamations"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, nullable=False)
    student_id: Mapped[int] = mapped_column(Integer, ForeignKey("students.id"), nullable=False)
    quiz_id: Mapped[int] = mapped_column(Integer, ForeignKey("quizzes.id"), nullable=True)  # Can be related to a quiz
    subject: Mapped[str] = mapped_column(Text, nullable=False)  # Topic of the complaint
    message: Mapped[str] = mapped_column(Text, nullable=False)  # Detailed complaint
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)  # Timestamp
    resolved: Mapped[bool] = mapped_column(Boolean, default=False)  # Whether it has been resolved or not

    # Relationships
    student = relationship("Student", back_populates="reclamations")
    quiz = relationship("Quiz", back_populates="reclamations")

