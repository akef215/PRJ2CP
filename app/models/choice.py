from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import Text, Integer, ForeignKey, Float, UniqueConstraint
from app.models import Base

class Choice(Base):
    __tablename__ = "choices"

    id : Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True, nullable=False)
    quiz_id : Mapped[int] = mapped_column(ForeignKey("quizzes.id", ondelete="CASCADE"))
    question_id : Mapped[int] = mapped_column(ForeignKey("questions.id", ondelete="CASCADE"))
    score : Mapped[float] = mapped_column(Float)
    answer : Mapped[str] = mapped_column(Text, nullable=False)

    questions = relationship("Question", back_populates="choices")

    