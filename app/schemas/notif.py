# schemas/notification.py
from pydantic import BaseModel

class NotificationCreate(BaseModel):
    description: str
    groupe_id: str
