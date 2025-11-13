from flask import Flask, render_template, request, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor
from config.config import Config
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
app.config.from_object(Config)

def get_db_connection():
    """Create and return database connection with error handling"""
    try:
        conn = psycopg2.connect(app.config['DATABASE_URL'])
        return conn
    except psycopg2.Error as e:
        logger.error(f"Database connection error: {e}")
        raise

@app.route('/')
def index():
    """Main page with property listings"""
    try:
        search = request.args.get('search', '').strip()
        property_type = request.args.get('type', '').strip()

        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)

        # Use parameterized queries to prevent SQL injection
        query = """
            SELECT property_id, type, address, price, bedrooms, latitude, longitude 
            FROM property 
            WHERE 1=1
        """
        params = []
        
        if search:
            query += " AND address ILIKE %s"
            params.append(f'%{search}%')
        
        if property_type:
            query += " AND type = %s"
            params.append(property_type)

        query += " ORDER BY price ASC"

        cur.execute(query, params)
        properties = cur.fetchall()
        cur.close()
        conn.close()

        # Convert to list of dicts for easier template handling
        properties_list = [dict(prop) for prop in properties]

        return render_template('index.html', 
                             properties=properties_list, 
                             search=search, 
                             type=property_type)
    except psycopg2.Error as e:
        logger.error(f"Database query error: {e}")
        return render_template('error.html', error="Database error occurred"), 500
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return render_template('error.html', error="An unexpected error occurred"), 500

@app.route('/api/properties')
def api_properties():
    """API endpoint for property data (JSON)"""
    try:
        search = request.args.get('search', '').strip()
        property_type = request.args.get('type', '').strip()

        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)

        query = """
            SELECT property_id, type, address, price, bedrooms, latitude, longitude 
            FROM property 
            WHERE 1=1
        """
        params = []
        
        if search:
            query += " AND address ILIKE %s"
            params.append(f'%{search}%')
        
        if property_type:
            query += " AND type = %s"
            params.append(property_type)

        query += " ORDER BY price ASC"

        cur.execute(query, params)
        properties = cur.fetchall()
        cur.close()
        conn.close()

        return jsonify([dict(prop) for prop in properties])
    except Exception as e:
        logger.error(f"API error: {e}")
        return jsonify({'error': str(e)}), 500

@app.errorhandler(404)
def not_found(error):
    return render_template('error.html', error="Page not found"), 404

@app.errorhandler(500)
def internal_error(error):
    return render_template('error.html', error="Internal server error"), 500

if __name__ == '__main__':
    app.run(
        host='0.0.0.0',
        port=5000,
        debug=app.config['FLASK_DEBUG']
    )
