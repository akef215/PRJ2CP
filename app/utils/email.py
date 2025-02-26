import smtplib
from email.mime.text import MIMEText
import time
from datetime import datetime, timedelta

# Adresse de l'expéditeur (remplace par la tienne)
sender_email = "nm_zenagui@esi.dz"
app_password = "motdepasse"  # Utilise un App Password

# Liste des étudiants (remplace par les vraies adresses email)
student_emails = [
    "nl_boudaoud@esi.dz"
]

# Fonction pour envoyer un email
def send_email(receiver_email):
    subject = "Recuperation du compte"
    code = 1234
    body = f"Bonjour, Le code de recuperation est {code}. Cordialement"

    msg = MIMEText(body)
    msg["From"] = sender_email
    msg["To"] = receiver_email
    msg["Subject"] = subject

    try:
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
            server.login(sender_email, app_password)
            server.sendmail(sender_email, receiver_email, msg.as_string())
        print(f"✅ Email envoyé à {receiver_email}")
    except Exception as e:
        print(f"❌ Erreur lors de l'envoi de l'email à {receiver_email} : {e}")

# Fonction pour envoyer des emails à tous les étudiants
def send_emails_to_students():
    for email in student_emails:
        send_email(email)

# Fonction pour vérifier si c'est le moment d'envoyer les emails
def check_and_send_emails(quiz_time):
    # Calculer l'heure d'envoi (10 minutes avant le quiz)
    send_time = quiz_time - timedelta(minutes=10)

    while True:
        now = datetime.now()
        if now >= send_time:
            print("⏰ Il est temps d'envoyer les emails !")
            send_emails_to_students()
            print("✅ Tous les emails ont été envoyés.")
            break  # Arrêter la boucle après l'envoi
        else:
            # Afficher le temps restant avant l'envoi
            time_remaining = send_time - now
            print(f"⏳ Temps restant avant l'envoi : {time_remaining}")
            time.sleep(60)  # Attendre 1 minute avant de vérifier à nouveau

# Fonction principale
def main():
    # Saisir manuellement la date et l'heure du quiz
    try:
        date_input = input("Entrez la date du quiz (AAAA-MM-JJ) : ")
        time_input = input("Entrez l'heure du quiz (HH:MM) : ")
        quiz_time = datetime.strptime(f"{date_input} {time_input}", "%Y-%m-%d %H:%M")
    except ValueError:
        print("⚠️ Format invalide. Utilisez le format AAAA-MM-JJ pour la date et HH:MM pour l'heure.")
        return

    print(f"📅 Quiz programmé pour le {quiz_time.strftime('%Y-%m-%d à %H:%M')}")

    # Démarrer la vérification et l'envoi des emails
    check_and_send_emails(quiz_time)

# Démarrer le script
if __name__ == "__main__":
    print("🚀 Démarrage du planificateur d'emails...")
    main()