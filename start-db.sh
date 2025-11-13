#!/bin/bash

# Script to start PostgreSQL database

echo "🗄️  Starting PostgreSQL database..."

# Check if PostgreSQL is installed via Homebrew
if command -v brew &> /dev/null; then
    if brew services list | grep -q postgresql; then
        echo "📦 Starting PostgreSQL via Homebrew..."
        brew services start postgresql
        sleep 2
        if brew services list | grep postgresql | grep -q started; then
            echo "✅ PostgreSQL started successfully!"
        else
            echo "❌ Failed to start PostgreSQL"
            echo "💡 Try: brew services restart postgresql"
            exit 1
        fi
    else
        echo "⚠️  PostgreSQL not found in Homebrew services"
        echo "💡 Install it with: brew install postgresql"
        echo "💡 Or use Docker: docker-compose up db"
    fi
else
    echo "⚠️  Homebrew not found"
    echo "💡 Please start PostgreSQL manually or use Docker:"
    echo "   docker-compose up db"
fi

# Check if database exists
echo "🔍 Checking database..."
if command -v psql &> /dev/null; then
    if psql -lqt | cut -d \| -f 1 | grep -qw real_estate_agency; then
        echo "✅ Database 'real_estate_agency' exists"
    else
        echo "⚠️  Database 'real_estate_agency' not found"
        echo "💡 Create it with: createdb real_estate_agency"
        echo "💡 Then restore: pg_restore -d real_estate_agency real_estate_agency.sql"
    fi
else
    echo "⚠️  psql not found in PATH"
fi

