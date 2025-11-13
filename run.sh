#!/bin/bash

# Real Estate Agency - Startup Script
# This script helps you quickly start the application

echo "🏠 Real Estate Agency - Starting..."

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install -q -r requirements.txt

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚙️  Creating .env file from example..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your database credentials!"
fi

# Check database connection (optional)
echo "🔍 Checking database connection..."
python3 -c "
import psycopg2
from config.config import Config
try:
    conn = psycopg2.connect(Config.DATABASE_URL)
    print('✅ Database connection successful!')
    conn.close()
except Exception as e:
    print(f'❌ Database connection failed: {e}')
    print('⚠️  Please check your DATABASE_URL in .env file')
"

# Start the application
echo "🚀 Starting Flask application..."
echo "📍 Open http://localhost:5000 in your browser"
echo ""
python3 app.py

