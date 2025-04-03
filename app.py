from flask import Flask, render_template, request, redirect, session
from werkzeug.security import generate_password_hash, check_password_hash
from Database_DB.db_config import get_connection

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
        # Récupérer toutes les publications par ordre décroissant de date
        cursor.execute("SELECT * FROM Publications ORDER BY date DESC")
        publications = cursor.fetchall()
    conn.close()
    return render_template('publications.html', publications=publications)

@app.route('/publication/<int:id>')
def detail_publication(id):
    conn = get_connection()
    with conn.cursor() as cursor:
        # Récupérer la publication sélectionnée par son id
        cursor.execute("SELECT * FROM Publications WHERE id_publication = %s", (id,))
        publication = cursor.fetchone()
        # Si tu disposes d'une table pour les commentaires, tu pourrais la récupérer ici, par exemple :
        # cursor.execute("SELECT * FROM Comments WHERE id_publication = %s ORDER BY DateCommentaire ASC", (id,))
        # commentaires = cursor.fetchall()
    conn.close()

    if publication:
        # Passe éventuellement aussi les commentaires au template
        return render_template('publication_detail.html', publication=publication)  # , commentaires=commentaires
    else:
        return redirect('/publications')


if __name__ == '__main__':
    app.run(debug=True)
