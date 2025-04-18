import socket
import subprocess

# Obtenir l'adresse IP locale (Wi-Fi)
ip = socket.gethostbyname(socket.gethostname())
print(f"🚀 Uvicorn sera accessible sur: http://{ip}:8000")

# Lancer uvicorn avec 0.0.0.0
subprocess.run(["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"])
