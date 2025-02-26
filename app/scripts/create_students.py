import csv
import argparse
import requests

# Configuration de l'URL de l'API
API_URL = "http://127.0.0.1:8000/students/SignUp"

def upload_students_from_csv(file_path):
    with open(file_path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)

        required_columns = {"id", "fname", "lname", "email", "level", "groupe", "password"}
        if not required_columns.issubset(reader.fieldnames):
            print("Erreur : Le fichier CSV doit contenir les colonnes 'id', 'fname', 'lname', 'email', 'level', 'groupe' et 'password'")
            return
        
        for row in reader:
            response = requests.post(API_URL, json={
                "fname": row["fname"],
                "lname": row["lname"],
                "level": row["level"],
                "groupe_id": row["level"]+row["groupe"],
                "id": row["id"],
                "email": row["email"],
                "password": row["password"]
            })

            if response.status_code == 200:
                print(f"✅ Etudiant {row['id']} ajouté avec succès.")
            else:
                print(f"⚠️ Erreur pour {row['id']}: {response.json()}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Importer des etudiants depuis un fichier CSV vers l'API")
    parser.add_argument("file", type=str, help="Chemin du fichier CSV contenant les etudiants")
    
    args = parser.parse_args()
    upload_students_from_csv(args.file)
