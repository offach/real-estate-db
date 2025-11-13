-- Initialize database schema for Real Estate Agency
-- This is a fallback if the custom format SQL dump cannot be restored

CREATE TABLE IF NOT EXISTS property (
    property_id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    bedrooms INTEGER,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8)
);

-- Insert sample data
INSERT INTO property (type, address, price, bedrooms, latitude, longitude) VALUES
('Apartment', '123 Main Street, New York, NY 10001', 250000, 2, 40.7128, -74.0060),
('House', '456 Oak Avenue, Los Angeles, CA 90001', 500000, 3, 34.0522, -118.2437),
('Land', '789 Pine Road, Chicago, IL 60601', 100000, NULL, 41.8781, -87.6298),
('Apartment', '321 Elm Street, Miami, FL 33101', 180000, 1, 25.7617, -80.1918),
('House', '654 Maple Drive, Seattle, WA 98101', 650000, 4, 47.6062, -122.3321),
('Apartment', '987 Cedar Lane, Boston, MA 02101', 320000, 2, 42.3601, -71.0589),
('House', '147 Birch Court, Denver, CO 80201', 420000, 3, 39.7392, -104.9903),
('Land', '258 Spruce Way, Austin, TX 78701', 150000, NULL, 30.2672, -97.7431)
ON CONFLICT DO NOTHING;

-- Create index for faster searches
CREATE INDEX IF NOT EXISTS idx_property_type ON property(type);
CREATE INDEX IF NOT EXISTS idx_property_address ON property USING gin(to_tsvector('english', address));

