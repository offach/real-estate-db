#!/bin/bash

# Script to setup database (create and restore)

echo "🗄️  Setting up database..."

CURRENT_USER=$(whoami)

# Find psql
PSQL_CMD=""
if command -v psql &> /dev/null; then
    PSQL_CMD="psql"
elif [ -f "/opt/homebrew/opt/postgresql@14/bin/psql" ]; then
    PSQL_CMD="/opt/homebrew/opt/postgresql@14/bin/psql"
fi

if [ -z "$PSQL_CMD" ]; then
    echo "❌ psql not found"
    exit 1
fi

# Create database
echo "📦 Creating database..."
$PSQL_CMD -U "$CURRENT_USER" -d postgres -c "DROP DATABASE IF EXISTS real_estate_agency;" 2>/dev/null
$PSQL_CMD -U "$CURRENT_USER" -d postgres -c "CREATE DATABASE real_estate_agency;" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Database created!"
    
    # Try to restore
    if [ -f "real_estate_agency.sql" ]; then
        echo "📥 Restoring database..."
        if command -v pg_restore &> /dev/null; then
            # Try custom format first
            pg_restore -d real_estate_agency real_estate_agency.sql 2>/dev/null && echo "✅ Database restored from custom format!" || {
                echo "⚠️  Custom format restore failed, trying init-db.sql..."
                if [ -f "init-db.sql" ]; then
                    $PSQL_CMD -U "$CURRENT_USER" -d real_estate_agency -f init-db.sql 2>/dev/null && echo "✅ Database initialized from init-db.sql!" || echo "⚠️  init-db.sql also failed"
                else
                    echo "💡 Using fallback schema"
                fi
            }
        else
            echo "⚠️  pg_restore not found, using init-db.sql..."
            if [ -f "init-db.sql" ]; then
                $PSQL_CMD -U "$CURRENT_USER" -d real_estate_agency -f init-db.sql 2>/dev/null && echo "✅ Database initialized!" || echo "⚠️  Failed to initialize"
            fi
        fi
    elif [ -f "init-db.sql" ]; then
        echo "📥 Initializing database from init-db.sql..."
        $PSQL_CMD -U "$CURRENT_USER" -d real_estate_agency -f init-db.sql 2>/dev/null && echo "✅ Database initialized!" || echo "⚠️  Failed to initialize"
    fi
else
    echo "❌ Failed to create database"
    exit 1
fi

# Update .env
if [ -f ".env" ]; then
    sed -i.bak "s|postgresql://postgres:|postgresql://$CURRENT_USER:|g" .env 2>/dev/null
    echo "✅ .env file updated with correct username"
fi

echo "✅ Setup complete!"

