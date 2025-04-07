import pymysql

def get_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='Kimo.2004',
        database='MENTALHEALTH_DB',
        cursorclass=pymysql.cursors.DictCursor
    )
