# schemas/notification.py
from pydantic import BaseModel

class NotificationCreate(BaseModel):
    content: str
    recipient_id: int
