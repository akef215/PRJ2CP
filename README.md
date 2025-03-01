# PRJ2CP
Projet 2CP : Projet6 (Systemes embarqués)

# Les technologies utilisées :
Le framework : FastAPI (Python)
L'outil alembic : pour l'immigration de la base de donnée
Le SGBD : MySQL

# L'environnement virtuel :
python -m venv .venv
.venv\Scripts\activate

# Le fichier .env :
Il contient les variables qui doivent rester cacher (La configuration de la base de donnée, le profile de l'enseignant en question ainsi que la configuration du token)

# Le fichier requirements.txt :
 Il contient les dependences utilisées dans le projet, on peut les installer direcetement avec la commande : pip install -r requirements.txt

# La configuration d'alembic  :
Il faut lancer la commande : alembic init .
puis aller se rendre au fichier alembic.ini, changer la ligne : sqlalchemy.url = mysql+pymysql://user:password@localhost:Port/DataBaseName

# Le lancement du serveur uvicorn :
dans un terminal cmd : uvicorn main:app --reload 

main c'est le nom du fichier principal et app c'est l'instance FastAPI, si vous utilisez d'autres noms veuillez changer la commande!
