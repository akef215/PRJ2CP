from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, ForeignKey
from app.models import Base 

class Student(Base):
    __tablename__ = "students" 

    id: Mapped[str] = mapped_column(String(7), primary_key=True, unique=True, index=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    email: Mapped[str] = mapped_column(String(100), unique=True, nullable=False, index=True)
    password: Mapped[str] = mapped_column(String(255), nullable=False)
    level: Mapped[str] = mapped_column(String(6), nullable=False)

    groupe_id: Mapped[str] = mapped_column(
        String(8),
        ForeignKey("groupes.id", ondelete="CASCADE"),
        nullable=False
    )

    groupe_rel = relationship("Groupe", back_populates="etudiants")
