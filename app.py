from flask import Flask, render_template, request, redirect, session, url_for
from werkzeug.security import generate_password_hash, check_password_hash
from Database_DB.db_config import get_connection
from datetime import datetime, timedelta
import pymysql
import os
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = 'static/uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}



def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


app = Flask(__name__)
app.secret_key = 'secret123'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

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
        # Récupérer publications non supprimées et compter uniquement les commentaires non supprimés
        cursor.execute("""
            SELECT P.*, U.photo_de_profil,
            (
                SELECT COUNT(*) 
                FROM Commentaires C
                WHERE C.id_publication = P.id_publication
                  AND NOT EXISTS (
                      SELECT 1 FROM Effacer E 
                      WHERE E.id_commentaire = C.id_commentaire
                  )
            ) AS nb_reponses
            FROM Publications P
            JOIN Utilisateurs U ON P.username = U.username
            WHERE NOT EXISTS (
                SELECT 1 FROM Effacer E 
                WHERE E.id_publication = P.id_publication
            )
            ORDER BY P.date DESC
        """)
        publications = cursor.fetchall()

        # Réactions
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
 
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT P.*, U.nom, U.prenom, U.photo_de_profil
                FROM Publications P
                JOIN Utilisateurs U ON P.username = U.username
                WHERE id_publication = %s
            """, (id,))
            publication = cursor.fetchone()
 
            if publication:
                # Image de profil
                publication["photo_profil_path"] = publication["photo_de_profil"]
 
            # Commentaires
            cursor.execute("""
                SELECT C.contenu AS texte , C.date_creation AS date_et_heure, U.nom, U.prenom, E.niveau_anonymat
                FROM Commentaires C
                JOIN Utilisateurs U ON C.username = U.username
                JOIN Etudiants E ON U.username = E.username
                WHERE C.id_publication = %s
                ORDER BY C.date_creation ASC
            """, (id,))
            commentaires = cursor.fetchall()
 
    finally:
        conn.close()
 
    if not publication:
        return "Publication introuvable", 404
     
    print("Publication =", publication)
    print("Commentaires =", commentaires)
 
 
    return render_template('publication_affichage.html', publication=publication, commentaires=commentaires)
 
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
 

if __name__ == '__main__':
    app.run(debug=True)