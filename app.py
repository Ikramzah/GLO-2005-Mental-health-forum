from flask import Flask, render_template, request, redirect, session, url_for
from werkzeug.security import generate_password_hash, check_password_hash
from Database_DB.db_config import get_connection
from datetime import datetime, timedelta
import pymysql

app = Flask(__name__)
app.secret_key = 'secret123'

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
        lieu_de_residence = request.form['lieu_de_residence']
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
        cursor.execute("""
            SELECT P.*, U.username, U.photo_de_profil
            FROM Publications P
            JOIN Utilisateurs U ON P.username = U.username
            ORDER BY P.date DESC
        """)
        publications = cursor.fetchall()
    conn.close()
    return render_template('publications.html', publications=publications)

@app.route('/chercher_utilisateurs', methods=['GET'])
def chercher_utilisateurs():
    query = request.args.get('q', '')
    users = []
    if query:
        conn = get_connection()
        with conn.cursor() as cursor:
            sql = """
                SELECT U.username, U.nom, U.prenom, E.niveau_anonymat, U.email, U.photo_de_profil
                FROM Utilisateurs U
                INNER JOIN Etudiants E ON U.username = E.username
                WHERE U.username LIKE %s OR U.nom LIKE %s OR U.prenom OR U.email LIKE %s
            """
            wildcard = '%' + query + '%'
            cursor.execute(sql, (wildcard, wildcard, wildcard))
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



@app.route('/rendez_vous/<username>', methods=['GET', 'POST'])
def rendez_vous(username):
    # Connexion à la base de données
    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            # Récupérer les données du conseiller
            cursor.execute('SELECT prenom, nom, username FROM Utilisateurs WHERE username = %s', (username,))
            conseiller = cursor.fetchone()

            # Vérifier si le conseiller existe
            if not conseiller:
                return "Conseiller non trouvé", 404

            # Obtenir la date actuelle
            current_date = datetime.now().date()

            # Calculer les 15 jours à venir
            days = []
            for i in range(15):
                day = current_date + timedelta(days=i)
                days.append(day)

            # Durée par défaut (60 minutes)
            duree_rdv = int(request.form.get('duree_rdv', 60))  # Défaut à 60 minutes

            # Préparer un dictionnaire pour les créneaux horaires
            horaires_disponibles = {}

            # Remplir le dictionnaire avec les créneaux horaires
            for day in days:
                # Ne pas afficher de créneaux le week-end
                if day.weekday() in [5, 6]:  # 5 = samedi, 6 = dimanche
                    horaires_disponibles[day] = []
                else:
                    horaires_disponibles[day] = []
                    start_time = datetime.combine(day, datetime.min.time())
                    for hour in range(9, 18):  # De 9h00 à 17h00
                        start_time_str = (start_time + timedelta(hours=hour)).strftime('%H:%M')
                        end_time_str = (start_time + timedelta(hours=hour, minutes=duree_rdv)).strftime('%H:%M')

                        # Vérifier si le créneau est déjà réservé
                        cursor.execute("""
                            SELECT 1 FROM Reserver
                            WHERE (username_conseiller = %s OR username_etudiant = %s)
                            AND date = %s
                            AND (
                                (heure_debut < %s AND heure_fin > %s) OR
                                (heure_debut >= %s AND heure_debut < %s) OR
                                (heure_fin > %s AND heure_fin <= %s)
                            )
                        """, (username, session['username'], day, end_time_str, start_time_str, start_time_str, end_time_str, start_time_str, end_time_str))

                        reserved = cursor.fetchone()

                        if not reserved:
                            horaires_disponibles[day].append((start_time_str, end_time_str))

            # Si le formulaire est soumis (pour choisir la durée du rendez-vous)
            if request.method == 'POST':
                return render_template('rendez_vous.html', horaires_disponibles=horaires_disponibles, conseiller=conseiller, duree_rdv=duree_rdv)

            return render_template('rendez_vous.html', horaires_disponibles=horaires_disponibles, conseiller=conseiller, duree_rdv=duree_rdv)

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

if __name__ == '__main__':
    app.run(debug=True)
