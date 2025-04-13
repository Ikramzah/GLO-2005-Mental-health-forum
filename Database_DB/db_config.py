import pymysql

def get_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='Mamafirst1',
        database='MENTALHEALTH_DB',
        cursorclass=pymysql.cursors.DictCursor
    )