import os
from dotenv import load_dotenv
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

from sqlalchemy import text
from typing import List

# Charger les variables d'environnement depuis .env
load_dotenv()

# Récupérer les valeurs depuis .env
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")

# Construire l'URL de la base de données
DATABASE_URL = f"mysql+aiomysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# Créer le moteur de base de données
engine = create_async_engine(DATABASE_URL, echo=True)

# Créer une session de base de données
SessionLocal = sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)

# Dépendance pour obtenir la session de base de données
async def get_db():
    async with SessionLocal() as session:
        yield session
