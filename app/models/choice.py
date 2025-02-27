from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import Text, Integer, ForeignKey, Float, UniqueConstraint
from app.models import Base

class Choice(Base):
    __tablename__ = "choices"

    id : Mapped[int] = mapped_column(Integer, primary_key=True, nullable=False)
    quiz_id : Mapped[int] = mapped_column(Integer, ForeignKey("quizzes.id"))
    question_id : Mapped[int] = mapped_column(Integer, ForeignKey("questions.id"))
    score : Mapped[float] = mapped_column(Float)
    answer : Mapped[str] = mapped_column(Text, nullable=False)

    __table_args__ = (
        UniqueConstraint('id', 'question_id', name='uq_answ_id_qstn'),
    )

    