import os
import asyncio
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
engine = create_async_engine(DATABASE_URL, echo=True, future=True)

# Créer une session de base de données
SessionLocal = sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)

# Dépendance pour obtenir la session de base de données
async def get_db():
    async with SessionLocal() as session:
        yield session

# Fonction pour tester la connexion à la base de données
async def test_db_connection():
    try:
        async with engine.connect() as conn:
            result = await conn.execute(text("SELECT 1"))
            print(f"✅ Connexion réussie ! Résultat : {result.scalar()}")
    except Exception as e:
        print(f"❌ Erreur de connexion : {e}")
    finally:
        await engine.dispose()  # ✅ Fermer proprement l'engine

# Exécuter le test de connexion
if __name__ == "__main__":
    asyncio.run(test_db_connection())
