import pymysql

def get_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
<<<<<<< HEAD
        password='Kimo.2004',
=======
        password='Mamafirst1',
>>>>>>> 7f0c3b3 (authentification, modification de mot de pass, styling de modifier mot de pass, modifier photo et toucher un peu la page profil, Ajout d'un formulaire réservé au conseiller pour ajouter un livre)
        database='MENTALHEALTH_DB',
        cursorclass=pymysql.cursors.DictCursor
    )
