import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Application configuration"""
    DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:1234@localhost/real_estate_agency')
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    FLASK_ENV = os.getenv('FLASK_ENV', 'development')
    FLASK_DEBUG = os.getenv('FLASK_DEBUG', 'True').lower() == 'true'

