import csv
import argparse
import requests

# Configuration de l'URL de l'API
API_URL = "http://127.0.0.1:8000/teachers/Modules"

def upload_modules_from_csv(file_path):
    with open(file_path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)

        required_columns = {"Code", "Titre", "Coef", "Level"}
        if not required_columns.issubset(reader.fieldnames):
            print("Erreur : Le fichier CSV doit contenir les colonnes 'code', 'titre', 'coef' et 'level'")
            return
        
        for row in reader:
            response = requests.post(API_URL, params={
                "code": row["Code"],
                "titre": row["Titre"],
                "coef": int(row["Coef"]),
                "level": row["Level"],
            })

            if response.status_code == 200:
                print(f"✅ Module {row['Code']} ajouté avec succès.")
            else:
                print(f"⚠️ Erreur pour {row['Code']}: {response.json()}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Importer des modules depuis un fichier CSV vers l'API")
    parser.add_argument("file", type=str, help="Chemin du fichier CSV contenant les modules")
    
    args = parser.parse_args()
    upload_modules_from_csv(args.file)
