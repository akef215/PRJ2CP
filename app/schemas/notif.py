# schemas/notification.py
from pydantic import BaseModel

class NotificationCreate(BaseModel):
    description: str
    recipient_id: str
