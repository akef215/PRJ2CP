from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import Text, Integer, ForeignKey, UniqueConstraint
from app.models import Base

class Question(Base):
    __tablename__ = "questions"

    id : Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True, nullable=False)
    quiz_id : Mapped[int] = mapped_column(Integer, ForeignKey("quizzes.id", ondelete="CASCADE"))
    statement : Mapped[str] = mapped_column(Text, nullable=False)
    duree : Mapped[int] = mapped_column(Integer, nullable=True)

    choices = relationship("Choice", back_populates="questions", cascade="all, delete-orphan")
    quizzes = relationship("Quiz", back_populates="questions")
    quiz_id = mapped_column(Integer, ForeignKey("quizzes.id", ondelete="CASCADE"))