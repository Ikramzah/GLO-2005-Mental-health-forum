import pymysql

def get_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='XXXXXX',
        database='MENTALHEALTH_DB',
        cursorclass=pymysql.cursors.DictCursor
    )
