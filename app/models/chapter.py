from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import String, Integer, ForeignKey
from app.models import Base

class Chapter(Base):
    __tablename__ = "chapters"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True, nullable=False)
    module: Mapped[str] = mapped_column(ForeignKey("modules.code", ondelete="CASCADE"), nullable=False)
    titre: Mapped[str] = mapped_column(String(50), nullable=False)