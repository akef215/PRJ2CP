from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import Boolean, String, Integer, ForeignKey, Date, Text
from app.models import Base 
from app.models.quiz_groupe import quiz_groupe
import datetime

class Quiz(Base):
    __tablename__ = "quizzes" 

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True, index=True)
    title: Mapped[str] = mapped_column(String(50))
    date: Mapped[datetime.date] = mapped_column(Date, nullable=False)
    description: Mapped[str] = mapped_column(Text)
    module_code: Mapped[str] = mapped_column(String(10), ForeignKey("modules.code", ondelete="CASCADE"), nullable=False)
    type_quizz: Mapped[str] = mapped_column(String(1), default="1")
    duree: Mapped[int] = mapped_column(Integer, nullable=False)
    launch: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)

    groupes = relationship("Groupe", secondary=quiz_groupe, back_populates="quizzes")
    questions = relationship("Question", back_populates="quizzes", cascade="all, delete-orphan")
    statistics = relationship("Statistic", back_populates="quiz", cascade="all, delete-orphan")  # 👈 Ajoute ça

    def __repr__(self):
        return f"<Quiz id={self.id} title={self.title} date={self.date} type={self.type_quizz}>"
