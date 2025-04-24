from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import String, Integer, ForeignKey, DateTime, Text
from datetime import datetime
from app.models import Base

class Feedback(Base):
    __tablename__ = "feedbacks"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, nullable=False)
    groupe: Mapped[str] = mapped_column(ForeignKey("groupes.id", ondelete="CASCADE"), nullable=False)
    module: Mapped[str] = mapped_column(ForeignKey("modules.code", ondelete="CASCADE"), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    date: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

