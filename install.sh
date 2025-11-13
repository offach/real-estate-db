#!/bin/bash

# Alternative installation script for Python 3.13 compatibility

echo "🔧 Installing dependencies (Python 3.13 compatible)..."

# Activate venv if it exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Upgrade pip and build tools
pip install --upgrade pip setuptools wheel

# For Python 3.13, try installing from pre-built wheels or use alternative
echo "📦 Installing psycopg2-binary..."
python3 --version

# Try different installation methods
if pip install --only-binary :all: psycopg2-binary 2>/dev/null; then
    echo "✅ psycopg2-binary installed successfully"
elif pip install psycopg2-binary --prefer-binary 2>/dev/null; then
    echo "✅ psycopg2-binary installed successfully"
else
    echo "⚠️  Standard installation failed, trying with build isolation disabled..."
    pip install --no-build-isolation psycopg2-binary || {
        echo "❌ psycopg2-binary installation failed"
        echo ""
        echo "💡 Solutions:"
        echo "1. Install PostgreSQL development headers:"
        echo "   macOS: brew install postgresql"
        echo "   Ubuntu/Debian: sudo apt-get install libpq-dev python3-dev"
        echo ""
        echo "2. Or use psycopg (newer alternative):"
        echo "   pip install psycopg[binary]"
        echo "   (Then update app.py to use 'import psycopg' instead)"
        exit 1
    }
fi

# Install other dependencies
echo "📦 Installing Flask and python-dotenv..."
pip install Flask python-dotenv

echo "✅ Installation complete!"

