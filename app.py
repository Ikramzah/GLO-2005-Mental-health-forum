from flask import Flask, render_template, request, redirect, session, url_for
from werkzeug.security import generate_password_hash, check_password_hash
from Database_DB.db_config import get_connection
from datetime import datetime, timedelta
import smtplib
import random
from email.mime.text import MIMEText
import pymysql
import os
import threading
from werkzeug.utils import secure_filename
from dotenv import load_dotenv
load_dotenv(dotenv_path=".env")
UPLOAD_FOLDER = 'static/uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
from flask import jsonify


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def send_email_async(email, code):
    threading.Thread(target=send_reset_code, args=(email, code)).start()

app = Flask(__name__)
app.secret_key = 'secret123'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Configuration SMTP sécurisée via .env
app.config['MAIL_SERVER'] = os.getenv('MAIL_SERVER')
app.config['MAIL_PORT'] = int(os.getenv('MAIL_PORT'))
app.config['MAIL_USERNAME'] = os.getenv('MAIL_USERNAME')
app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD')
app.config['MAIL_USE_TLS'] = os.getenv('MAIL_USE_TLS') == 'True'
# Liste des pays
countries = [
    "-- Sélectionnez un pays --",
    "Afghanistan", "Afrique du Sud", "Albanie", "Algérie", "Allemagne", "Andorre", "Angola",
    "Arabie Saoudite", "Argentine", "Arménie", "Australie", "Autriche", "Azerbaïdjan", "Bahamas",
    "Bahreïn", "Bangladesh", "Barbade", "Belgique", "Belize", "Bénin", "Bhoutan", "Biélorussie",
    "Birmanie", "Bolivie", "Bosnie-Herzégovine", "Botswana", "Brésil", "Brunei", "Bulgarie",
    "Burkina Faso", "Burundi", "Cambodge", "Cameroun", "Canada", "Cap-Vert", "Chili", "Chine",
    "Chypre", "Colombie", "Comores", "Congo", "Corée du Nord", "Corée du Sud", "Costa Rica",
    "Côte d'Ivoire", "Croatie", "Cuba", "Danemark", "Djibouti", "Dominique", "Egypte", "El Salvador",
    "Emirats Arabes Unis", "Equateur", "Erythrée", "Espagne", "Estonie", "Etats-Unis", "Ethiopie",
    "Fidji", "Finlande", "France", "Gabon", "Gambie", "Géorgie", "Ghana", "Grèce", "Guatemala",
    "Guinée", "Guinée-Bissau", "Haïti", "Honduras", "Hongrie", "Inde", "Indonésie", "Irak",
    "Iran", "Irlande", "Islande", "Israël", "Italie", "Jamaïque", "Japon", "Jordanie", "Kazakhstan",
    "Kenya", "Koweït", "Laos", "Lettonie", "Liban", "Liberia", "Libye", "Lituanie", "Luxembourg",
    "Madagascar", "Malaisie", "Malawi", "Maldives", "Mali", "Malte", "Maroc", "Maurice",
    "Mauritanie", "Mexique", "Moldavie", "Monaco", "Mongolie", "Monténégro", "Mozambique",
    "Namibie", "Népal", "Nicaragua", "Niger", "Nigéria", "Norvège", "Nouvelle-Zélande", "Oman",
    "Ouganda", "Ouzbékistan", "Pakistan", "Panama", "Paraguay", "Pays-Bas", "Pérou", "Philippines",
    "Pologne", "Portugal", "Qatar", "République Centrafricaine", "République Dominicaine",
    "Roumanie", "Royaume-Uni", "Russie", "Rwanda", "São Tomé-et-Príncipe", "Sénégal",
    "Serbie", "Seychelles", "Sierra Leone", "Singapour", "Slovaquie", "Slovénie", "Somalie",
    "Soudan", "Sri Lanka", "Suède", "Suisse", "Suriname", "Syrie", "Tadjikistan", "Taïwan",
    "Tanzanie", "Tchad", "Thaïlande", "Timor oriental", "Togo", "Tunisie", "Turkménistan",
    "Turquie", "Ukraine", "Uruguay", "Vanuatu", "Vatican", "Venezuela", "Vietnam", "Yémen",
    "Zambie", "Zimbabwe"
]
@app.context_processor
def inject_user():
    if 'username' in session:
        conn = get_connection()
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM Utilisateurs WHERE username = %s", (session['username'],))
            user = cursor.fetchone()
        conn.close()
        return dict(user=user)
    return dict(user=None)

# Configuration de l'envoi d'email
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USERNAME'] = 'samahghost@gmail.com'  # 🔁 Remplace par ton email
app.config['MAIL_PASSWORD'] = 'ogizkvoawnzsmupz'   # 🔁 Mot de passe d'application Gmail
app.config['MAIL_USE_TLS'] = True

# Dictionnaire temporaire pour stocker les codes
reset_codes = {}  # Code temporaire stocké en mémoire (ou utilise ta base SQL)

def send_reset_code(email, code):
    sender = app.config['MAIL_USERNAME']
    password = app.config['MAIL_PASSWORD']
    msg = MIMEText(f"Voici votre code de réinitialisation : {code}")
    msg['Subject'] = 'Réinitialisation de mot de passe'
    msg['From'] = sender
    msg['To'] = email

    with smtplib.SMTP(app.config['MAIL_SERVER'], app.config['MAIL_PORT']) as server:
        server.starttls()
        server.login(sender, password)
        server.send_message(msg)

@app.route('/demander_code_reset', methods=['GET', 'POST'])
def demander_code_reset():
    msg = ''
    if request.method == 'POST':
        email = request.form['email']
        conn = get_connection()
        with conn.cursor() as cursor:
            cursor.execute("SELECT username FROM Utilisateurs WHERE email = %s", (email,))
            user = cursor.fetchone()
        conn.close()
        if user:
            code = str(random.randint(100000, 999999))
            reset_codes[email] = code
            send_email_async(email, code)
            session['reset_email'] = email
            msg = "Code envoyé à votre adresse courriel."
            return redirect(url_for('verifier_code'))
        else:
            msg = "Adresse courriel inconnue."
    return render_template('reset_password_request.html', msg=msg)
@app.route('/delete_account')
def delete_account():
    if 'username' in session:
        conn = get_connection()
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM Utilisateurs WHERE username = %s", (session['username'],))
            conn.commit()
        conn.close()
        session.clear()
        return redirect(url_for('login'))
    return redirect(url_for('login'))
@app.route('/ajouter_livre', methods=['POST'])
def ajouter_livre():
    if 'username' not in session or session['role'] != 'conseiller':
        return redirect(url_for('login'))

    titre = request.form['titre']
    auteur = request.form['auteur']
    date = request.form['date_publication']
    description = request.form['description']
    conseiller = request.form['nom_conseiller']
    photo = request.files['photo_livre']

    if photo and allowed_file(photo.filename):
        filename = secure_filename(photo.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        photo.save(filepath)
        chemin_image = f"uploads/{filename}"

        conn = get_connection()
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Livre (nom_livre, auteur, date_publication, description, photo_livre)
                VALUES (%s, %s, %s, %s, %s)
            """, (titre, auteur, date, description, chemin_image))
            conn.commit()

            cursor.execute("SELECT LAST_INSERT_ID() AS id")
            livre_id = cursor.fetchone()['id']

            cursor.execute("""
                INSERT INTO Recommander (id_livre, username_conseiller)
                VALUES (%s, %s)
            """, (livre_id, session['username']))
            conn.commit()
        conn.close()

    return redirect(url_for('livres'))
@app.route('/supprimer_livre/<int:id_livre>', methods=['POST'])
def supprimer_livre(id_livre):
    if 'username' not in session or session.get('role') != 'conseiller':
        return redirect(url_for('login'))

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            # Supprimer d'abord la recommandation (si existe)
            cursor.execute("DELETE FROM Recommander WHERE id_livre = %s", (id_livre,))
            # Ensuite, supprimer le livre lui-même
            cursor.execute("DELETE FROM Livre WHERE id_livre = %s", (id_livre,))
            conn.commit()
    finally:
        conn.close()

    return redirect(url_for('livres'))


@app.route('/verifier_code', methods=['GET', 'POST'])
def verifier_code():
    msg = ''
    if request.method == 'POST':
        email = session.get('reset_email')
        input_code = request.form['code']
        if reset_codes.get(email) == input_code:
            return redirect(url_for('set_new_password'))
        else:
            msg = "Code incorrect."
    return render_template('verify_code.html', msg=msg)

@app.route('/set_new_password', methods=['GET', 'POST'])
def set_new_password():
    msg = ''
    if request.method == 'POST':
        email = session.get('reset_email')
        password = request.form['password']
        confirm = request.form['confirm']
        if password != confirm:
            msg = "Les mots de passe ne correspondent pas."
        else:
            hashed = generate_password_hash(password)
            conn = get_connection()
            with conn.cursor() as cursor:
                cursor.execute("UPDATE Utilisateurs SET mot_de_passe = %s WHERE email = %s", (hashed, email))
                conn.commit()
            conn.close()
            msg = "Mot de passe modifié avec succès !"
            return redirect(url_for('login'))
    return render_template('set_new_password.html', msg=msg)

@app.route('/')
def accueil():
    return render_template('home.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    msg = ''
    msg_type = ''
    if request.method == 'POST':
        prenom = request.form['prenom']
        nom = request.form['nom']
        email = request.form['email']
        mot_de_passe = request.form['mot_de_passe']
        confirmer = request.form['confirmer_mot_de_passe']
        date_de_naissance = request.form['date_de_naissance']
        lieu_de_residence = request.form.get('pays')
        statut = request.form['statut']
        username = request.form['username']

        if mot_de_passe != confirmer:
            msg = 'Les mots de passe ne correspondent pas.'
            msg_type = 'error'
            return render_template('signup.html', msg=msg, msg_type=msg_type, countries=countries)

        mot_de_passe_hash = generate_password_hash(mot_de_passe)

        conn = get_connection()
        with conn.cursor() as cursor:
            cursor.execute('SELECT * FROM Utilisateurs WHERE email = %s', (email,))
            compte = cursor.fetchone()

            if compte:
                msg = 'Ce courriel est déjà utilisé.'
                msg_type = 'error'
            else:
                cursor.execute('''
                INSERT INTO Utilisateurs (username, nom, prenom, email, mot_de_passe, date_inscription, date_de_naissance, lieu_de_residence)
                VALUES (%s, %s, %s, %s, %s, CURDATE(), %s, %s)
                ''', (username, nom, prenom, email, mot_de_passe_hash, date_de_naissance, lieu_de_residence))

                if statut == 'etudiant':
                    cursor.execute("INSERT INTO Etudiants (username, statut_etudiant) VALUES (%s, %s)", (username, 'citoyen'))
                elif statut == 'conseiller':
                    cursor.execute("INSERT INTO Conseillers (username) VALUES (%s)", (username,))
                elif statut == 'etudiant-conseiller':
                    cursor.execute("INSERT INTO Etudiants (username, statut_etudiant) VALUES (%s, %s)", (username, 'citoyen'))
                    cursor.execute("INSERT INTO Conseillers (username) VALUES (%s)", (username,))

                conn.commit()
                msg = 'Inscription réussie ! Vous pouvez vous connecter.'
                msg_type = 'success'
                return redirect('/login')
        conn.close()

    return render_template('signup.html', msg=msg, msg_type=msg_type, countries=countries)

@app.route('/login', methods=['GET', 'POST'])
def login():
    msg = ''
    msg_type = ''
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        conn = get_connection()
        with conn.cursor() as cursor:
            cursor.execute('SELECT * FROM Utilisateurs WHERE email = %s', (email,))
            user = cursor.fetchone()
        conn.close()

        if user and check_password_hash(user['mot_de_passe'], password):
            session['loggedin'] = True
            session['username'] = user['username']
            session['email'] = user['email']
            session['nom'] = user['nom']
            session['prenom'] = user['prenom']
            # Détection du rôle
            conn = get_connection()
            with conn.cursor() as cursor:
                cursor.execute("SELECT * FROM Conseillers WHERE username = %s", (user['username'],))
                if cursor.fetchone():
                    session['role'] = 'conseiller'
                else:
                    cursor.execute("SELECT * FROM Moderateur WHERE username = %s", (user['username'],))
                    if cursor.fetchone():
                        session['role'] = 'moderateur'
                    else:
                        session['role'] = 'etudiant'
            conn.close()
            return redirect('/dashboard')

        else:
            msg = 'Identifiants incorrects.'
            msg_type = 'error'

    return render_template('login.html', msg=msg, msg_type=msg_type)

@app.route('/dashboard')
def dashboard():
    if 'loggedin' in session:
        return render_template('dashboard.html')
    return redirect('/login')

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/login')

@app.route('/publications')
def publications():
    conn = get_connection()
    with conn.cursor() as cursor:
        #  Récupère les publications non supprimées
        cursor.execute("""
            SELECT 
                P.*, 
                U.photo_de_profil,
                COUNT(C.id_commentaire) AS nb_reponses
            FROM Publications P
            JOIN Utilisateurs U ON P.username = U.username
            LEFT JOIN Commentaires C 
                ON P.id_publication = C.id_publication 
                AND C.status_suppression = FALSE
            LEFT JOIN Effacer E 
                ON E.id_commentaire = C.id_commentaire
            WHERE E.id_publication IS NULL
            GROUP BY P.id_publication
            ORDER BY P.date DESC
        """)
        publications = cursor.fetchall()

        #  Réactions par type pour chaque publication
        cursor.execute("""
            SELECT id_publication, type_reaction, COUNT(*) AS nb
            FROM Reagir_publication
            GROUP BY id_publication, type_reaction
        """)
        reactions_data = cursor.fetchall()

    conn.close()

    #  Structuration des réactions
    reactions = {}
    for r in reactions_data:
        pub_id = r['id_publication']
        if pub_id not in reactions:
            reactions[pub_id] = {}
        reactions[pub_id][r['type_reaction']] = r['nb']

    return render_template('publications.html', publications=publications, reactions=reactions)

@app.route('/ajouter_indisponibilite', methods=['GET', 'POST'])
def ajouter_indisponibilite():
    if 'username' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        username = session['username']
        date = request.form['date']
        heure_debut = request.form['heure_debut']
        heure_fin = request.form['heure_fin']
        raison = request.form.get('raison', '')

        conn = get_connection()
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Indisponibilites (username_conseiller, date, heure_debut, heure_fin, raison)
                VALUES (%s, %s, %s, %s, %s)
            """, (username, date, heure_debut, heure_fin, raison))
            conn.commit()
        conn.close()
        return redirect(url_for('dashboard'))  # ou une page de confirmation

    return render_template('ajouter_indisponibilite.html')

@app.route('/ajouter_indisponibilite', methods=['GET', 'POST'])
def ajouter_indisponibilite():
    if 'username' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        username = session['username']
        date = request.form['date']
        heure_debut = request.form['heure_debut']
        heure_fin = request.form['heure_fin']
        raison = request.form.get('raison', '')

        conn = get_connection()
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Indisponibilites (username_conseiller, date, heure_debut, heure_fin, raison)
                VALUES (%s, %s, %s, %s, %s)
            """, (username, date, heure_debut, heure_fin, raison))
            conn.commit()
        conn.close()
        return redirect(url_for('dashboard'))  # ou une page de confirmation

    return render_template('ajouter_indisponibilite.html')

@app.route('/chercher_utilisateurs', methods=['GET'])
def chercher_utilisateurs():
    query = request.args.get('q', '')
    users = []
    if query:
        conn = get_connection()
        with conn.cursor() as cursor:
            sql = """
                SELECT 
                    U.username, 
                    U.nom, 
                    U.prenom, 
                    COALESCE(E.niveau_anonymat, 'public') AS niveau_anonymat,
                    U.email, 
                    U.photo_de_profil
                FROM Utilisateurs U
                LEFT JOIN Etudiants E ON U.username = E.username
                LEFT JOIN Conseillers C ON U.username = C.username
                WHERE 
                    U.username LIKE %s OR 
                    U.nom LIKE %s OR 
                    U.prenom LIKE %s OR 
                    U.email LIKE %s
            """
            wildcard = f"%{query}%"
            cursor.execute(sql, (wildcard, wildcard, wildcard, wildcard))
            users = cursor.fetchall()
        conn.close()
    return render_template('chercher_utilisateurs.html', users=users, query=query)

@app.route('/livres')
def livres():
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
             SELECT L.*, C.username AS Conseiller
             FROM Livre L
             JOIN Recommander R ON L.id_livre = R.id_livre
             JOIN Conseillers C ON R.username_conseiller = C.username
         """)
        livres = cursor.fetchall()
    conn.close()
    return render_template('livres.html', livres=livres)

@app.route('/conseillers')
def conseillers():
    conn = get_connection()  # ta fonction DB dans db_config.py
    with conn.cursor() as cursor:
        cursor.execute("SELECT nom, prenom, photo_de_profil, username FROM Utilisateurs WHERE username IN (SELECT username FROM Conseillers);")
        conseillers_list = cursor.fetchall()
    conn.close()
    return render_template('conseillers.html', conseillers=conseillers_list)

@app.route('/publications_utilisateur')
def publications_utilisateur():
    if 'username' not in session:
        return redirect(url_for('login'))

    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT P.*, U.photo_de_profil,
            (
                SELECT COUNT(*) FROM Commentaires C
                WHERE C.id_publication = P.id_publication
                  AND C.id_commentaire NOT IN (
                      SELECT E.id_commentaire FROM Effacer E WHERE E.id_commentaire IS NOT NULL
                  )
            ) AS nb_reponses
            FROM Publications P
            JOIN Utilisateurs U ON P.username = U.username
            WHERE P.username = %s
              AND P.id_publication NOT IN (
                  SELECT id_publication FROM Effacer WHERE id_publication IS NOT NULL
              )
            ORDER BY P.date DESC
        """, (session['username'],))
        publications = cursor.fetchall()

        # Requêtes pour les réactions comme avant
        cursor.execute("""
            SELECT id_publication, type_reaction, COUNT(*) AS nb
            FROM Reagir_publication
            GROUP BY id_publication, type_reaction
        """)
        reactions_data = cursor.fetchall()

    conn.close()

    reactions = {}
    for r in reactions_data:
        pub_id = r['id_publication']
        if pub_id not in reactions:
            reactions[pub_id] = {}
        reactions[pub_id][r['type_reaction']] = r['nb']

    return render_template('publications_utilisateur.html', publications=publications, reactions=reactions)


@app.route('/mes_rendez_vous')
def mes_rendez_vous():
    if 'username' not in session or session.get('role') != 'conseiller':
        return redirect(url_for('login'))

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT R.date, R.heure_debut, R.heure_fin, R.raison, U.nom, U.prenom
                FROM Reserver R
                JOIN Utilisateurs U ON R.username_etudiant = U.username
                WHERE R.username_conseiller = %s AND R.date >= CURDATE()
                ORDER BY R.date, R.heure_debut
            """, (session['username'],))
            rendez_vous = cursor.fetchall()
    finally:
        conn.close()

    return render_template('mes_rendez_vous.html', rendez_vous=rendez_vous)


@app.route('/rendez_vous/<username>', methods=['GET', 'POST'])
def rendez_vous(username):
    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute('SELECT prenom, nom, username FROM Utilisateurs WHERE username = %s', (username,))
            conseiller = cursor.fetchone()

            if not conseiller:
                return "Conseiller non trouvé", 404

            current_date = datetime.now().date()
            duree_rdv = int(request.form.get('duree_rdv', 60)) if request.method == 'POST' else 60

            days = [current_date + timedelta(days=i) for i in range(15)]
            horaires_disponibles = {}

            for day in days:
                if day.weekday() in [5, 6]:  # Week-end
                    horaires_disponibles[day] = []
                    continue

                horaires_disponibles[day] = []
                start_time = datetime.combine(day, datetime.min.time())

                for hour in range(9, 17):  # 9h à 16h pour un créneau de 1h max
                    start_time_str = (start_time + timedelta(hours=hour)).strftime('%H:%M')
                    end_time_str = (start_time + timedelta(hours=hour, minutes=duree_rdv)).strftime('%H:%M')

                    # Vérifie indisponibilités
                    cursor.execute("""
                        SELECT 1 FROM Indisponibilites
                        WHERE username_conseiller = %s AND date = %s
                        AND (
                            (heure_debut < %s AND heure_fin > %s) OR
                            (heure_debut >= %s AND heure_debut < %s) OR
                            (heure_fin > %s AND heure_fin <= %s)
                        )
                    """, (username, day, end_time_str, start_time_str,
                          start_time_str, end_time_str,
                          start_time_str, end_time_str))
                    indispo = cursor.fetchone()
                    if indispo:
                        continue

                    # Vérifie si déjà réservé
                    cursor.execute("""
                        SELECT 1 FROM Reserver
                        WHERE (username_conseiller = %s OR username_etudiant = %s)
                        AND date = %s
                        AND (
                            (heure_debut < %s AND heure_fin > %s) OR
                            (heure_debut >= %s AND heure_debut < %s) OR
                            (heure_fin > %s AND heure_fin <= %s)
                        )
                    """, (username, session['username'], day,
                          end_time_str, start_time_str,
                          start_time_str, end_time_str,
                          start_time_str, end_time_str))
                    reserved = cursor.fetchone()
                    if not reserved:
                        horaires_disponibles[day].append((start_time_str, end_time_str))

            return render_template('rendez_vous.html',
                                   horaires_disponibles=horaires_disponibles,
                                   conseiller=conseiller,
                                   duree_rdv=duree_rdv)
    finally:
        connection.close()


@app.route('/reserver/<username>/<date>/<start_time>', methods=['POST'])
def reserver(username, date, start_time):
    raison = request.form.get('raison', '')
    print(f"Réservation reçue: {username}, {date}, {start_time}, Raison: {raison}")
    # Calculer l'heure de fin
    duree_rdv = request.form.get('duree_rdv', 60, type=int)
    end_time = (datetime.strptime(start_time, '%H:%M') + timedelta(minutes=duree_rdv)).strftime('%H:%M')
    print(f"End Time Calculé: {end_time}")

    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT 1 FROM Reserver
                WHERE (username_conseiller = %s OR username_etudiant = %s)
                AND date = %s
                AND (
                    (heure_debut < %s AND heure_fin > %s) OR
                    (heure_debut >= %s AND heure_debut < %s) OR
                    (heure_fin > %s AND heure_fin <= %s)
                )
            """, (username, session['username'], date, end_time, start_time, start_time, end_time, start_time, end_time))

            reserved = cursor.fetchone()

            if reserved:
                return "Ce créneau est déjà réservé par vous ou un autre utilisateur. Veuillez choisir un autre créneau.", 400

            cursor.execute("""
                INSERT INTO Reserver (username_etudiant, username_conseiller, date, heure_debut, heure_fin, raison, statut)
                VALUES (%s, %s, %s, %s, %s, %s, 'En attente')
            """, (session['username'], username, date, start_time, end_time, raison))

            connection.commit()
    finally:
        connection.close()

    return redirect(url_for('rendez_vous', username=username, date=date, start_time=start_time))

@app.route('/user_profile')
def profile():
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("SELECT nom, prenom, photo_de_profil, username, lieu_de_residence,email FROM Utilisateurs WHERE username = %s;", (session['username'],))
        current_user = cursor.fetchone()
        cursor.execute("SELECT statut_etudiant FROM Etudiants WHERE username = %s;", (session['username'],))
        statut = cursor.fetchone()
    conn.close()
    return render_template('user_profile.html', user=current_user, statut=statut)

@app.route('/profil/<username>')
def profil_utilisateur(username):
    conn = get_connection()
    utilisateur = None
    publications = []
    est_conseiller = False
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT U.username, U.nom, U.prenom, U.email, U.photo_de_profil,
                       COALESCE(E.niveau_anonymat, 'public') AS niveau_anonymat
                FROM Utilisateurs U
                LEFT JOIN Etudiants E ON U.username = E.username
                WHERE U.username = %s
            """, (username,))
            utilisateur = cursor.fetchone()

            if utilisateur:
                cursor.execute("SELECT 1 FROM Conseillers WHERE username = %s", (username,))
                est_conseiller = cursor.fetchone() is not None

                if utilisateur['niveau_anonymat'] != 'anonyme':
                    cursor.execute("""
                        SELECT * FROM Publications
                        WHERE username = %s
                        ORDER BY date DESC
                    """, (username,))
                    publications = cursor.fetchall()
    finally:
        conn.close()

    return render_template(
        'profil_utilisateur.html',
        utilisateur=utilisateur,
        publications=publications,
        est_conseiller=est_conseiller
    )

@app.route('/modifier_photo', methods=['GET', 'POST'])
def modifier_photo():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    msg = ''
    if request.method == 'POST':
        if 'photo' not in request.files:
            msg = "Aucun fichier envoyé."
        file = request.files['photo']
        if file.filename == '':
            msg = "Nom de fichier vide."
        elif file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)
            photo_path = f"uploads/{filename}"
            print(filename)
            print(filepath)
            # Mise à jour en BD
            conn = get_connection()
            with conn.cursor() as cursor:
                cursor.execute("""
                    UPDATE Utilisateurs SET photo_de_profil = %s WHERE username = %s
                """, (photo_path, session['username']))
                conn.commit()
            conn.close()

            session['photo_de_profil'] = filename  # Mémoriser en session
            msg = "Photo mise à jour avec succès !"
            return redirect('/user_profile')
        else:
            msg = "Format non supporté."

    return render_template('modifier_photo.html', msg=msg)

@app.route('/apropos')
def apropos():
    return render_template('apropos.html')

@app.route('/publication/<int:id>')
def afficher_une_publication(id):
    conn = get_connection()
    publication = None
    commentaires = []
    reactions = {}
    commentaire_reactions = {}

    try:
        with conn.cursor() as cursor:
            #  Publication
            cursor.execute("""
                SELECT P.*, U.nom, U.prenom, U.photo_de_profil
                FROM Publications P
                JOIN Utilisateurs U ON P.username = U.username
                WHERE P.id_publication = %s
            """, (id,))
            publication = cursor.fetchone()

            if not publication:
                return "Publication introuvable", 404

            publication["photo_profil_path"] = publication["photo_de_profil"]

            #  Commentaires visibles (non effacés)
            cursor.execute("""
                SELECT C.id_commentaire, C.contenu AS texte, C.date_creation AS date_et_heure,
                       U.nom, U.prenom, E.niveau_anonymat
                FROM Commentaires C
                JOIN Utilisateurs U ON C.username = U.username
                JOIN Etudiants E ON U.username = E.username
                WHERE C.id_publication = %s
                  AND NOT EXISTS (
                    SELECT 1 FROM Effacer EFF WHERE EFF.id_commentaire = C.id_commentaire
                  )
                ORDER BY C.date_creation ASC
            """, (id,))
            commentaires = cursor.fetchall()

            #  Réactions sur la publication
            cursor.execute("""
                SELECT id_publication, type_reaction, COUNT(*) AS nb
                FROM Reagir_publication
                WHERE id_publication = %s
                GROUP BY id_publication, type_reaction
            """, (id,))
            for r in cursor.fetchall():
                reactions.setdefault(r['id_publication'], {})[r['type_reaction']] = r['nb']

            #  Réactions sur commentaires
            cursor.execute("""
                SELECT C.id_commentaire, RC.type_reaction, COUNT(*) AS nb
                FROM Commentaires C
                JOIN Reagir_commentaire RC ON C.id_commentaire = RC.id_commentaire
                WHERE C.id_publication = %s
                GROUP BY C.id_commentaire, RC.type_reaction
            """, (id,))
            for r in cursor.fetchall():
                cid = r['id_commentaire']
                commentaire_reactions.setdefault(cid, {})[r['type_reaction']] = r['nb']

    finally:
        conn.close()

    return render_template(
        'publication_affichage.html',
        publication=publication,
        commentaires=commentaires,
        reactions=reactions,
        commentaire_reactions=commentaire_reactions
    )

 
@app.route('/modifier_publication/<int:id>', methods=['GET', 'POST'])
def modifier_publication(id):
    if 'username' not in session:
        return redirect(url_for('login'))
 
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            # Vérifier que la publication existe et appartient au user connecté
            cursor.execute("SELECT * FROM Publications WHERE id_publication = %s", (id,))
            publication = cursor.fetchone()
 
            if not publication:
                return "Publication introuvable", 404
 
            if publication['username'] != session['username']:
                return "Accès non autorisé", 403
 
            if request.method == 'POST':
                nouveau_titre = request.form['p_titre']
                nouveau_texte = request.form['texte']
                nouveau_statut = request.form['statut']
 
                cursor.execute("""
                    UPDATE Publications
                    SET p_titre = %s, texte = %s, statut = %s
                    WHERE id_publication = %s
                """, (nouveau_titre, nouveau_texte, nouveau_statut, id))
 
                conn.commit()
                return redirect(url_for('afficher_une_publication', id=id))
 
    finally:
        conn.close()
 
    return render_template('modifier_publication.html', publication=publication)
 
 
@app.route('/signaler_publication/<int:id>', methods=['GET', 'POST'])
def signaler_publication(id):
    if 'username' not in session:
        return redirect(url_for('login'))
 
    if request.method == 'POST':
        raison = request.form.get('raison', 'Raison non précisée')
        conn = get_connection()
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Effacer (id_publication, username, raison, type_effacement)
                VALUES (%s, %s, %s, 'utilisateur')
            """, (id, session['username'], raison))
            conn.commit()
        conn.close()
        return redirect(url_for('publications'))
 
    return render_template('signaler_publication.html', publication_id=id)
 
 
@app.route('/ajouter_commentaire/<int:id>', methods=['POST'])
def ajouter_commentaire(id):
    if 'username' not in session:
        return redirect(url_for('login'))
    texte = request.form['texte']
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            INSERT INTO Commentaires (username, id_publication, contenu)
            VALUES (%s, %s, %s)
        """, (session['username'], id, texte))
        conn.commit()
    conn.close()
    return redirect(url_for('afficher_une_publication', id=id))

@app.route('/modifier_lieu', methods=['GET', 'POST'])
def modifier_lieu():
    if 'username' not in session:
        return redirect(url_for('login'))

    msg = ''
    conn = get_connection()
    with conn.cursor() as cursor:
        if request.method == 'POST':
            nouveau_lieu = request.form['lieu_de_residence']

            cursor.execute("""
                UPDATE Utilisateurs SET lieu_de_residence = %s WHERE username = %s
            """, (nouveau_lieu, session['username']))
            conn.commit()
            session['lieu_de_residence'] = nouveau_lieu
            return redirect(url_for('profile'))

        cursor.execute("""
            SELECT lieu_de_residence FROM Utilisateurs WHERE username = %s
        """, (session['username'],))
        user = cursor.fetchone()
    conn.close()
    return render_template('modifier_lieu.html', lieu_actuel=user['lieu_de_residence'], countries=countries, msg=msg)

@app.route('/modifier_email', methods=['GET', 'POST'])
def modifier_email():
    if 'username' not in session:
        return redirect(url_for('login'))

    msg = ''
    conn = get_connection()
    with conn.cursor() as cursor:
        if request.method == 'POST':
            nouvel_email = request.form['email']

            # Vérifier que l’email n’est pas déjà pris
            cursor.execute("SELECT * FROM Utilisateurs WHERE email = %s AND username != %s", (nouvel_email, session['username']))
            email_existant = cursor.fetchone()
            if email_existant:
                msg = "Cet email est déjà utilisé par un autre utilisateur."
            else:
                cursor.execute("""
                    UPDATE Utilisateurs SET email = %s WHERE username = %s
                """, (nouvel_email, session['username']))
                conn.commit()
                session['email'] = nouvel_email
                return redirect(url_for('profile'))

        cursor.execute("""
            SELECT email FROM Utilisateurs WHERE username = %s
        """, (session['username'],))
        user = cursor.fetchone()
    conn.close()
    return render_template('modifier_email.html', email=user['email'], msg=msg)

@app.route('/modifier_statut', methods=['GET', 'POST'])
def modifier_statut():
    if 'username' not in session:
        return redirect(url_for('login'))

    conn = get_connection()
    with conn.cursor() as cursor:
        if request.method == 'POST':
            nouveau_statut = request.form['statut_etudiant']
            cursor.execute("""
                UPDATE Etudiants SET statut_etudiant = %s WHERE username = %s
            """, (nouveau_statut, session['username']))
            conn.commit()
            conn.close()
            return redirect(url_for('profile'))

        cursor.execute("""
            SELECT statut_etudiant FROM Etudiants WHERE username = %s
        """, (session['username'],))
        statut = cursor.fetchone()
    conn.close()
    return render_template('modifier_statut.html', statut=statut)

from flask import jsonify, request

@app.route('/react_publication', methods=['POST'])
def react_publication():
    if 'username' not in session:
        return jsonify({'error': 'Unauthorized'}), 401

    data = request.get_json()
    pub_id = data.get('id_publication')
    reaction = data.get('type_reaction')
    username = session['username']

    conn = get_connection()
    with conn.cursor() as cursor:
        # Vérifie si une réaction existe déjà
        cursor.execute("""
            SELECT * FROM Reagir_publication
            WHERE id_publication = %s AND username = %s
        """, (pub_id, username))
        existing = cursor.fetchone()

        if existing:
            # Met à jour la réaction
            cursor.execute("""
                UPDATE Reagir_publication
                SET type_reaction = %s, timestamp = NOW()
                WHERE id_publication = %s AND username = %s
            """, (reaction, pub_id, username))
        else:
            # Insère une nouvelle réaction
            cursor.execute("""
                INSERT INTO Reagir_publication (id_publication, username, type_reaction)
                VALUES (%s, %s, %s)
            """, (pub_id, username, reaction))

        conn.commit()

        # Recalcule tous les types de réaction
        cursor.execute("""
            SELECT type_reaction, COUNT(*) as nb
            FROM Reagir_publication
            WHERE id_publication = %s
            GROUP BY type_reaction
        """, (pub_id,))
        stats = cursor.fetchall()
    conn.close()

    return jsonify({r['type_reaction']: r['nb'] for r in stats})

@app.route('/react_commentaire', methods=['POST'])
def react_commentaire():
    if 'username' not in session:
        return jsonify({'error': 'Unauthorized'}), 401

    data = request.get_json()
    com_id = data.get('id_commentaire')
    reaction = data.get('type_reaction')
    username = session['username']

    conn = get_connection()
    with conn.cursor() as cursor:
        # Vérifie si une réaction existe déjà
        cursor.execute("""
            SELECT * FROM Reagir_commentaire
            WHERE id_commentaire = %s AND username = %s
        """, (com_id, username))
        existing = cursor.fetchone()

        if existing:
            # Met à jour la réaction
            cursor.execute("""
                UPDATE Reagir_commentaire
                SET type_reaction = %s, date_reaction = NOW()
                WHERE id_commentaire = %s AND username = %s
            """, (reaction, com_id, username))
        else:
            # Insère une nouvelle réaction
            cursor.execute("""
                INSERT INTO Reagir_commentaire (id_commentaire, username, type_reaction)
                VALUES (%s, %s, %s)
            """, (com_id, username, reaction))

        conn.commit()

        # Recalcule tous les types de réaction
        cursor.execute("""
            SELECT type_reaction, COUNT(*) as nb
            FROM Reagir_commentaire
            WHERE id_commentaire = %s
            GROUP BY type_reaction
        """, (com_id,))
        stats = cursor.fetchall()
    conn.close()

    return jsonify({r['type_reaction']: r['nb'] for r in stats})

@app.route('/creer_publication', methods=['GET', 'POST'])
def creer_publication():
    if 'username' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        titre = request.form['p_titre']
        texte = request.form['texte']
        statut = request.form['statut']
        image = request.files.get('image')
        chemin_image = None

        if image and image.filename != '':
            filename = secure_filename(image.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            image.save(filepath)
            chemin_image = f"uploads/{filename}"

        conn = get_connection()
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Publications (username, p_titre, texte, statut, images)
                VALUES (%s, %s, %s, %s, %s)
            """, (session['username'], titre, texte, statut, chemin_image))
            conn.commit()
        conn.close()

        return redirect(url_for('publications'))

    return render_template('creer_publication.html')
 

if __name__ == '__main__':
    app.run(debug=True)
