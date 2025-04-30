from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, Integer, UniqueConstraint
from app.models import Base

class Groupe(Base):
    __tablename__ = "groupes"

    id: Mapped[str] = mapped_column(String(8), nullable=False, primary_key=True)
    numero: Mapped[int] = mapped_column(Integer, nullable=False)
    level: Mapped[str] = mapped_column(String(6), nullable=False)

    __table_args__ = (
        UniqueConstraint('numero', 'level', name='uq_numero_level'),
    )

    quizzes = relationship("Quiz", back_populates="groupe", cascade="all, delete-orphan")

    # 🔽 Relation vers les étudiants
    etudiants = relationship(
        "Student", 
        back_populates="groupe_rel", 
        cascade="all, delete-orphan", 
        passive_deletes=True
    )

    feedbacks = relationship(
    "Feedback", 
    back_populates="groupe", 
    cascade="all, delete-orphan", 
    passive_deletes=True
    )

    def __init__(self, level: str, numero: int):
        self.numero = numero
        self.level = level
        self.id = f"{level}{numero}"
