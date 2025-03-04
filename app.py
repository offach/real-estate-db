from flask import Flask, render_template, request
import psycopg2

app = Flask(__name__)

# Конфигурация базы данных
DATABASE_URL = 'postgresql://postgres:1234@localhost/real_estate_agency'

# Функция для подключения к базе данных
def get_db_connection():
    conn = psycopg2.connect(DATABASE_URL)
    return conn

@app.route('/')
def index():
    search = request.args.get('search', '')
    type = request.args.get('type', '')

    conn = get_db_connection()
    cur = conn.cursor()

    query = "SELECT property_id, type, address, price, bedrooms, latitude, longitude FROM property WHERE 1=1"
    if search:
        query += f" AND address LIKE '%{search}%'"
    if type:
        query += f" AND type = '{type}'"

    cur.execute(query)
    properties = cur.fetchall()
    cur.close()
    conn.close()

    return render_template('index.html', properties=properties, search=search, type=type)

if __name__ == '__main__':
    app.run(debug=True)