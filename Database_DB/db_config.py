from flask_mysqldb import MySQL

mysql = MySQL()

def init_app(app):
    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'root'
    app.config['MYSQL_PASSWORD'] = 'ton_mot_de_passe_mysql'
    app.config['MYSQL_DB'] = 'MENTALHEALTH_DB'
    mysql.init_app(app)
