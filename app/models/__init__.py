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
from .quiz_groupe import quiz_groupe
from .complaint import Complaint
from .statistics import Statistic
