import requests

# Configuration de l'URL de l'API
API_URL = "http://127.0.0.1:8000/teachers/Groupes"

level = input("Veuillez entrer le niveau scolaire : ")
n = int(input("Veuillez entrer le nombre de groupes de ce niveau : "))
for i in range(n):
    id = level+str(i+1)
    response = requests.post(API_URL, params={
                "level" : level,
                "numero" : i+1
            })
    
    if response.status_code == 200:
        print(f"✅ Groupe {id} ajouté avec succès.")
    else:
        print(f"⚠️ Erreur pour {id}: {response.json()}")