-- =====================================================================
-- SQL Mastery Bootcamp - Uber Ride-Sharing Database Schema
-- PostgreSQL 15+
-- =====================================================================
-- This schema models a real-world ride-sharing platform with drivers,
-- riders, trips, payments, reviews, and earnings tracking.
-- 
-- Use this file to create the complete database structure.
-- Drop tables in reverse order to respect foreign key constraints.
-- =====================================================================

-- Drop existing tables (if any) in correct order
DROP TABLE IF EXISTS driver_earnings CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS trips CASCADE;
DROP TABLE IF EXISTS riders CASCADE;
DROP TABLE IF EXISTS drivers CASCADE;

-- =====================================================================
-- DRIVERS TABLE
-- =====================================================================
-- Core driver information: profile, rating, availability, location
-- Primary entity: identified uniquely by id
-- Rating: decimal(3,2) allows values like 4.85 (avg of 1-5 stars)

CREATE TABLE drivers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  rating DECIMAL(3,2) DEFAULT 5.00,
  city VARCHAR(50) NOT NULL,
  vehicle_type VARCHAR(50),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE drivers IS 'Drivers who provide rides. Rating is average of 1-5 star reviews.';
COMMENT ON COLUMN drivers.rating IS 'Average rating from riders (1.00 to 5.00)';
COMMENT ON COLUMN drivers.city IS 'Operating city (Johannesburg, Cape Town, Durban, Pretoria, etc.)';

-- =====================================================================
-- RIDERS TABLE
-- =====================================================================
-- Customer information: who books the rides
-- Similar structure to drivers but without rating/vehicle info

CREATE TABLE riders (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  city VARCHAR(50) NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE riders IS 'Riders who book trips. Customers of the platform.';

-- =====================================================================
-- TRIPS TABLE (CORE FACT TABLE)
-- =====================================================================
-- Every ride: from request to completion
-- Most frequently queried table in analytics
-- Status tracks progression: requested → accepted → in_progress → completed/cancelled

CREATE TABLE trips (
  id SERIAL PRIMARY KEY,
  driver_id INT NOT NULL REFERENCES drivers(id),
  rider_id INT NOT NULL REFERENCES riders(id),
  
  -- Location data
  pickup_location VARCHAR(255) NOT NULL,
  dropoff_location VARCHAR(255) NOT NULL,
  pickup_lat DECIMAL(10,8),
  pickup_lng DECIMAL(10,8),
  dropoff_lat DECIMAL(10,8),
  dropoff_lng DECIMAL(10,8),
  
  -- Trip metrics
  fare DECIMAL(10,2) NOT NULL,
  distance_km DECIMAL(6,2),
  duration_minutes INT,
  
  -- Status tracking
  status VARCHAR(20) NOT NULL CHECK (status IN ('requested', 'accepted', 'in_progress', 'completed', 'cancelled')),
  
  -- Timestamps: complete journey timeline
  requested_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ
);

COMMENT ON TABLE trips IS 'Core fact table: every ride from request to completion or cancellation.';
COMMENT ON COLUMN trips.status IS 'Trip state: requested, accepted, in_progress, completed, cancelled';
COMMENT ON COLUMN trips.fare IS 'Final fare charged to rider in ZAR';

-- Indexes for common query patterns
CREATE INDEX idx_trips_driver_id ON trips(driver_id);
CREATE INDEX idx_trips_rider_id ON trips(rider_id);
CREATE INDEX idx_trips_status ON trips(status);
CREATE INDEX idx_trips_requested_at ON trips(requested_at);
CREATE INDEX idx_trips_status_requested ON trips(status, requested_at); -- Covering index for "recent trips by status"

-- =====================================================================
-- PAYMENTS TABLE
-- =====================================================================
-- How each trip was paid; tracks payment status
-- One payment per trip (1:1 relationship via UNIQUE constraint)
-- Methods: card, cash, wallet (stored credits)

CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  trip_id INT NOT NULL UNIQUE REFERENCES trips(id),
  
  amount DECIMAL(10,2) NOT NULL,
  method VARCHAR(20) NOT NULL CHECK (method IN ('card', 'cash', 'wallet')),
  status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
  
  paid_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE payments IS 'Payment records: one per trip. Tracks method, status, and completion.';
COMMENT ON COLUMN payments.method IS 'card: credit/debit; cash: cash payment; wallet: account credits';
COMMENT ON COLUMN payments.status IS 'pending: awaiting; completed: paid; failed: declined; refunded: reversed';

-- Index for finding unpaid trips
CREATE INDEX idx_payments_status ON payments(status);

-- =====================================================================
-- REVIEWS TABLE
-- =====================================================================
-- Quality ratings: riders review drivers and drivers review riders
-- Many reviews per trip (1 rider review + optional driver review)
-- Rating: 1-5 stars; comment is optional feedback

CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  trip_id INT NOT NULL REFERENCES trips(id),
  
  reviewer_id INT NOT NULL,      -- ID of person leaving review (driver or rider)
  reviewee_id INT NOT NULL,      -- ID of person being reviewed (driver or rider)
  reviewer_type VARCHAR(20) NOT NULL CHECK (reviewer_type IN ('rider', 'driver')),
  
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE reviews IS 'Quality ratings for drivers and riders. 1-5 star scale.';
COMMENT ON COLUMN reviews.reviewer_type IS 'rider: rider reviewed driver; driver: driver reviewed rider';
COMMENT ON COLUMN reviews.rating IS '1 (poor) to 5 (excellent)';

-- Indexes for driver performance queries
CREATE INDEX idx_reviews_reviewee_id ON reviews(reviewee_id);
CREATE INDEX idx_reviews_trip_id ON reviews(trip_id);
CREATE INDEX idx_reviews_reviewer_type ON reviews(reviewer_type);

-- =====================================================================
-- DRIVER_EARNINGS TABLE
-- =====================================================================
-- Revenue tracking per driver per trip
-- Shows: gross revenue, platform commission, driver net payout
-- Primary key is (driver_id, trip_id) for one record per earning event

CREATE TABLE driver_earnings (
  id SERIAL PRIMARY KEY,
  driver_id INT NOT NULL REFERENCES drivers(id),
  trip_id INT NOT NULL REFERENCES trips(id),
  
  gross_amount DECIMAL(10,2) NOT NULL,    -- What rider paid
  platform_fee DECIMAL(10,2) NOT NULL,    -- Uber's commission (typically 20-30%)
  net_amount DECIMAL(10,2) NOT NULL,      -- Driver's payout
  
  earned_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE driver_earnings IS 'Driver revenue tracking: gross fare, platform fee deducted, net payout.';
COMMENT ON COLUMN driver_earnings.gross_amount IS 'Amount rider paid for trip';
COMMENT ON COLUMN driver_earnings.platform_fee IS 'Platform commission deducted from gross';
COMMENT ON COLUMN driver_earnings.net_amount IS 'What driver actually receives (gross - fee)';

-- Indexes for driver performance and analytics
CREATE INDEX idx_driver_earnings_driver_id ON driver_earnings(driver_id);
CREATE INDEX idx_driver_earnings_earned_at ON driver_earnings(earned_at);
CREATE INDEX idx_driver_earnings_driver_earned ON driver_earnings(driver_id, earned_at); -- For "earnings over time per driver"

-- =====================================================================
-- SAMPLE INDEXES FOR COMMON QUERIES
-- =====================================================================
-- These are examples; add more based on your specific queries

-- For finding active drivers in a city
CREATE INDEX idx_drivers_city_active ON drivers(city, is_active) WHERE is_active = true;

-- For finding trips by completion time (analytics)
CREATE INDEX idx_trips_completed_at ON trips(completed_at) WHERE status = 'completed';

-- For payment reconciliation
CREATE INDEX idx_payments_trip_id ON payments(trip_id);

-- =====================================================================
-- DATABASE INITIALIZATION NOTES
-- =====================================================================
-- 
-- 1. This schema follows best practices:
--    - All tables have surrogate INT PRIMARY KEYs (id)
--    - Foreign keys enforce referential integrity
--    - CHECK constraints validate status enums
--    - UNIQUE constraints prevent duplicates (e.g., one payment per trip)
--    - TIMESTAMPTZ stores timezone-aware timestamps
--
-- 2. Indexes:
--    - Every foreign key should have an index for JOIN performance
--    - Filtered indexes on status columns (frequent WHERE filters)
--    - Composite indexes for multi-column queries
--
-- 3. Enum Fields (stored as VARCHAR with CHECK):
--    - Chosen over separate dimension tables for simplicity in practice database
--    - Production might use native ENUM type for stricter validation
--
-- 4. Data Model Decisions:
--    - Denormalized location strings (pickup_location, dropoff_location)
--      instead of separate locations table for simplicity
--    - Geographic data stored as decimal lat/lng (not PostGIS geometry)
--      for learning; production would use PostGIS POINT type
--    - Driver/rider names stored (denormalization) instead of lookup
--      to avoid extra JOINs in practice queries
--
-- 5. Next Steps:
--    - Load sample data with seed-data.sql
--    - Run practice queries from practice-queries.sql
--    - Analyze execution plans with EXPLAIN ANALYZE
--
-- =====================================================================
