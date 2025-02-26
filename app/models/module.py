from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import String, Integer
from app.models import Base

class Module(Base):
    __tablename__ = "modules"

    code : Mapped[str] = mapped_column(String(10), nullable=False, primary_key=True)
    titre : Mapped[str] = mapped_column(String(255), nullable=False) 
    coef : Mapped[int] = mapped_column(Integer, nullable=False)
    level : Mapped[str] = mapped_column(String(6), nullable=False)
