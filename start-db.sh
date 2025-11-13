#!/bin/bash

# Script to start PostgreSQL database and setup

echo "🗄️  Starting PostgreSQL database..."

# Get current username
CURRENT_USER=$(whoami)

# Check if PostgreSQL is installed via Homebrew
if command -v brew &> /dev/null; then
    # Try to find PostgreSQL service (could be postgresql, postgresql@14, etc.)
    PG_SERVICE=$(brew services list | grep -i postgresql | head -1 | awk '{print $1}')
    
    if [ -n "$PG_SERVICE" ]; then
        echo "📦 Starting PostgreSQL via Homebrew ($PG_SERVICE)..."
        brew services start "$PG_SERVICE" 2>/dev/null || brew services restart "$PG_SERVICE"
        sleep 3
        
        if brew services list | grep "$PG_SERVICE" | grep -q started; then
            echo "✅ PostgreSQL started successfully!"
        else
            echo "❌ Failed to start PostgreSQL"
            echo "💡 Try: brew services restart $PG_SERVICE"
            exit 1
        fi
    else
        echo "⚠️  PostgreSQL not found in Homebrew services"
        echo "💡 Install it with: brew install postgresql"
        echo "💡 Or use Docker: docker-compose up db"
        exit 1
    fi
else
    echo "⚠️  Homebrew not found"
    echo "💡 Please start PostgreSQL manually or use Docker:"
    echo "   docker-compose up db"
    exit 1
fi

# Find psql command
PSQL_CMD=""
if command -v psql &> /dev/null; then
    PSQL_CMD="psql"
elif [ -f "/opt/homebrew/opt/postgresql@14/bin/psql" ]; then
    PSQL_CMD="/opt/homebrew/opt/postgresql@14/bin/psql"
elif [ -f "/usr/local/opt/postgresql@14/bin/psql" ]; then
    PSQL_CMD="/usr/local/opt/postgresql@14/bin/psql"
fi

if [ -z "$PSQL_CMD" ]; then
    echo "⚠️  psql not found in PATH"
    echo "💡 Add PostgreSQL to PATH or use full path"
    exit 1
fi

# Check if database exists and create if needed
echo "🔍 Checking database..."
DB_EXISTS=$($PSQL_CMD -lqt -U "$CURRENT_USER" 2>/dev/null | cut -d \| -f 1 | grep -qw real_estate_agency && echo "yes" || echo "no")

if [ "$DB_EXISTS" = "yes" ]; then
    echo "✅ Database 'real_estate_agency' exists"
else
    echo "📦 Creating database 'real_estate_agency'..."
    if command -v createdb &> /dev/null; then
        createdb real_estate_agency 2>/dev/null || {
            echo "⚠️  Failed to create database with createdb, trying with psql..."
            $PSQL_CMD -U "$CURRENT_USER" -d postgres -c "CREATE DATABASE real_estate_agency;" 2>/dev/null
        }
    else
        $PSQL_CMD -U "$CURRENT_USER" -d postgres -c "CREATE DATABASE real_estate_agency;" 2>/dev/null
    fi
    
    if [ $? -eq 0 ]; then
        echo "✅ Database 'real_estate_agency' created successfully!"
        
        # Try to restore if SQL file exists
        if [ -f "real_estate_agency.sql" ]; then
            echo "📥 Attempting to restore database from SQL dump..."
            if command -v pg_restore &> /dev/null; then
                pg_restore -d real_estate_agency real_estate_agency.sql 2>/dev/null && echo "✅ Database restored!" || echo "⚠️  Could not restore (file might be in custom format, skipping)"
            else
                echo "⚠️  pg_restore not found, skipping restore"
            fi
        fi
    else
        echo "❌ Failed to create database"
        echo "💡 Try manually: createdb real_estate_agency"
    fi
fi

# Update .env file with correct username
if [ -f ".env" ]; then
    # Check if DATABASE_URL uses wrong username
    if grep -q "postgresql://postgres:" .env 2>/dev/null; then
        echo "🔧 Updating .env file with correct username ($CURRENT_USER)..."
        sed -i.bak "s|postgresql://postgres:|postgresql://$CURRENT_USER:|g" .env
        echo "✅ .env file updated!"
    fi
fi

echo ""
echo "✅ Database setup complete!"
echo "💡 Database URL: postgresql://$CURRENT_USER@localhost/real_estate_agency"

