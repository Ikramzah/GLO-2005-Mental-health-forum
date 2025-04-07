from flask import Flask, render_template, request, redirect, session
from werkzeug.security import generate_password_hash, check_password_hash
from Database_DB.db_config import get_connection

app = Flask(__name__)
app.secret_key = 'secret123'

# Liste des pays
countries = [ "-- Sélectionnez un pays --", "Afghanistan", "Algérie", "France", "Canada", "Maroc", "Tunisie", "Sénégal", "Côte d'Ivoire", "Autres..." ]  # 🔄 raccourcie pour la clarté

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
            return redirect('/dashboard')  # ✅ redirection vers le bon dashboard
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
        cursor.execute("SELECT * FROM Publications ORDER BY date DESC")
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
                SELECT U.username, U.nom, U.prenom, E.niveau_anonymat, U.email
                FROM Utilisateurs U
                INNER JOIN Etudiants E ON U.username = E.username
                WHERE U.username LIKE %s OR U.nom LIKE %s OR U.prenom LIKE %s OR U.email LIKE %s
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




if __name__ == '__main__':
    app.run(debug=True)
