from flask import Flask, render_template, request, redirect, session
from werkzeug.security import generate_password_hash, check_password_hash
import MySQLdb.cursors
from Database_DB.db_config import mysql, init_app

app = Flask(__name__)
app.secret_key = 'secret123'
init_app(app)

# 🔵 Page d'accueil (home.html)
@app.route('/')
def accueil():
    return render_template('home.html')

# 🔐 Connexion
@app.route('/login', methods=['GET', 'POST'])
def login():
    msg = ''
    msg_type = ''
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM Utilisateurs WHERE email = %s', (email,))
        user = cursor.fetchone()

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

# 📝 Inscription
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

        if mot_de_passe != confirmer:
            msg = 'Les mots de passe ne correspondent pas.'
            msg_type = 'error'
            return render_template('signup.html', msg=msg, msg_type=msg_type)

        mot_de_passe_hash = generate_password_hash(mot_de_passe)

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM Utilisateurs WHERE email = %s', (email,))
        compte = cursor.fetchone()

        if compte:
            msg = 'Ce courriel est déjà utilisé.'
            msg_type = 'error'
        else:
            username = (prenom[:3] + nom[:3] + email[:3]).lower()
            cursor.execute('''
            INSERT INTO Utilisateurs (username, nom, prenom, email, mot_de_passe, date_inscription)
            VALUES (%s, %s, %s, %s, %s, CURDATE())
            ''', (username, nom, prenom, email, mot_de_passe_hash))
            mysql.connection.commit()
            msg = 'Inscription réussie ! Vous pouvez vous connecter.'
            msg_type = 'success'
            return redirect('/login')

    return render_template('signup.html', msg=msg, msg_type=msg_type)

# 👤 Tableau de bord
@app.route('/dashboard')
def dashboard():
    if 'loggedin' in session:
        return render_template('dashboard.html')
    return redirect('/login')

# 🚪 Déconnexion
@app.route('/logout')
def logout():
    session.clear()
    return redirect('/login')


if __name__ == '__main__':
    app.run(debug=True)
