# app/models/password_reset.py
from sqlalchemy import Column, String, DateTime
from datetime import datetime, timedelta
from database import Base

class PasswordReset(Base):
    __tablename__ = "password_resets"

    email = Column(String, primary_key=True)
    code = Column(String, nullable=False)
    expires_at = Column(DateTime, default=lambda: datetime.utcnow() + timedelta(minutes=10))
