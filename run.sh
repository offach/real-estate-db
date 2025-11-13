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

# Upgrade pip first
echo "⬆️  Upgrading pip..."
pip install --upgrade pip setuptools wheel -q

# Install dependencies
echo "📥 Installing dependencies..."

# Check Python version
PYTHON_MAJOR=$(python3 -c "import sys; print(sys.version_info.major)")
PYTHON_MINOR=$(python3 -c "import sys; print(sys.version_info.minor)")
echo "🐍 Python version: $PYTHON_MAJOR.$PYTHON_MINOR"

# Install psycopg2-binary with different strategies for Python 3.13+
if [[ $PYTHON_MAJOR -gt 3 ]] || [[ $PYTHON_MAJOR -eq 3 && $PYTHON_MINOR -ge 13 ]]; then
    echo "⚠️  Python 3.13+ detected - using alternative installation method..."
    # Try with prefer-binary first
    pip install --prefer-binary psycopg2-binary || {
        echo "⚠️  Binary installation failed, trying with build isolation disabled..."
        pip install --no-build-isolation psycopg2-binary || {
            echo "❌ psycopg2-binary installation failed"
            echo ""
            echo "💡 Solutions for Python 3.13+:"
            echo "1. Install PostgreSQL development headers:"
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo "   brew install postgresql"
                echo "   Then run: ./run.sh again"
            else
                echo "   sudo apt-get install libpq-dev python3-dev  # Ubuntu/Debian"
            fi
            echo ""
            echo "2. Or run the alternative installer:"
            echo "   ./install.sh"
            echo ""
            echo "3. Or install manually:"
            echo "   pip install --upgrade pip setuptools wheel"
            echo "   pip install --no-build-isolation psycopg2-binary"
            exit 1
        }
    }
else
    # Standard installation for older Python versions
    pip install --no-cache-dir psycopg2-binary || {
        echo "⚠️  Installation failed, trying alternative method..."
        pip install --prefer-binary psycopg2-binary || {
            echo "❌ Failed to install psycopg2-binary"
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo "💡 On macOS, try: brew install postgresql"
            fi
            exit 1
        }
    }
fi

# Install remaining dependencies
echo "📦 Installing Flask and python-dotenv..."
pip install --no-cache-dir Flask python-dotenv -q

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚙️  Creating .env file from example..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your database credentials!"
fi

# Check database connection (optional)
echo "🔍 Checking database connection..."
python3 -c "
try:
    import psycopg2
    from config.config import Config
    try:
        conn = psycopg2.connect(Config.DATABASE_URL)
        print('✅ Database connection successful!')
        conn.close()
    except Exception as e:
        print(f'⚠️  Database connection failed: {e}')
        print('💡 Make sure PostgreSQL is running and DATABASE_URL is correct in .env')
except ImportError:
    print('⚠️  psycopg2 not installed, skipping database check')
" 2>/dev/null || echo "⚠️  Could not check database connection"

# Start the application
echo "🚀 Starting Flask application..."
echo "📍 Open http://localhost:5000 in your browser"
echo ""
python3 app.py

