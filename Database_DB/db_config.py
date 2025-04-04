import pymysql

def get_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='071120',
        database='MENTALHEALTH_DB',
        cursorclass=pymysql.cursors.DictCursor
    )
