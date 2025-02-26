from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import Text, Integer, ForeignKey, UniqueConstraint
from app.models import Base

class Question(Base):
    __tablename__ = "questions"

    id : Mapped[int] = mapped_column(Integer, nullable=False, primary_key=True)
    quiz_id : Mapped[int] = mapped_column(Integer, ForeignKey("quizzes.id"))
    statement : Mapped[str] = mapped_column(Text, nullable=False)
    time : Mapped[int] = mapped_column(Integer, nullable=True)

    __table_args__ = (
        UniqueConstraint('id', 'quiz_id', name='uq_qstn_id_quizz'),
    )