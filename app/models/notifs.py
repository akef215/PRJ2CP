from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import String, Integer, Date, Text, ForeignKey
from app.models import Base
import datetime

class Notif(Base):
    __tablename__ = "notifications"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, nullable=False, autoincrement=True)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    date: Mapped[datetime.date] = mapped_column(Date, nullable=False)
    quizz_id : Mapped[int] = mapped_column(Integer, ForeignKey("quizzes.id"), nullable=False)
    groupe_id: Mapped[str] = mapped_column(String(8), ForeignKey("groupes.id"), nullable=False)
    
