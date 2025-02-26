from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import Integer, ForeignKey, String
from app.models import Base

class Result(Base):
    __tablename__ = "results"

    id : Mapped[int] = mapped_column(Integer, unique=True, autoincrement=True, primary_key=True, nullable=False)
    student_id : Mapped[str] = mapped_column(String(7), ForeignKey("students.id"), nullable=False, index=True)
    question_id : Mapped[int] = mapped_column(Integer, ForeignKey("questions.id"), nullable=False)
    quizz_id : Mapped[int] = mapped_column(Integer, ForeignKey("quizzes.id"), nullable=False)
    choice_id : Mapped[int] = mapped_column(Integer, ForeignKey("choices.id"), nullable=False)
