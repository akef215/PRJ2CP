from sqlalchemy.orm import DeclarativeBase

# Définir une base commune pour tous les modèles
class Base(DeclarativeBase):
    pass

from .student import Student
from .groupe import Groupe
from .module import Module
from .quiz import Quiz
from .question import Question
from .choice import Choice
from .results import Result
from .feedback import Feedback
from .statistics import Statistic
from .notifs import Notif
from .password_reset import PasswordReset