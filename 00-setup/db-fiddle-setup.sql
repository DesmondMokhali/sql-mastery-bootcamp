-- =====================================================================
-- DB FIDDLE SETUP - SQL Mastery Bootcamp
-- PostgreSQL 15+
-- =====================================================================
-- INSTRUCTIONS:
-- 1. Go to db-fiddle.com
-- 2. Select PostgreSQL 15 from dropdown (top left)
-- 3. Paste THIS ENTIRE FILE into the LEFT panel (SQL Schema)
-- 4. Click "Run"
-- 5. Use the RIGHT panel to write and test your queries
--
-- This file sets up a complete Uber ride-sharing database
-- with sample data ready for practice.
-- =====================================================================

-- Drop existing tables in correct order
DROP TABLE IF EXISTS driver_earnings CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS trips CASCADE;
DROP TABLE IF EXISTS riders CASCADE;
DROP TABLE IF EXISTS drivers CASCADE;

-- =====================================================================
-- DRIVERS TABLE
-- =====================================================================

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

-- =====================================================================
-- RIDERS TABLE
-- =====================================================================

CREATE TABLE riders (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  city VARCHAR(50) NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================================
-- TRIPS TABLE
-- =====================================================================

CREATE TABLE trips (
  id SERIAL PRIMARY KEY,
  driver_id INT NOT NULL REFERENCES drivers(id),
  rider_id INT NOT NULL REFERENCES riders(id),
  pickup_location VARCHAR(255) NOT NULL,
  dropoff_location VARCHAR(255) NOT NULL,
  pickup_lat DECIMAL(10,8),
  pickup_lng DECIMAL(10,8),
  dropoff_lat DECIMAL(10,8),
  dropoff_lng DECIMAL(10,8),
  fare DECIMAL(10,2) NOT NULL,
  distance_km DECIMAL(6,2),
  duration_minutes INT,
  status VARCHAR(20) NOT NULL CHECK (status IN ('requested', 'accepted', 'in_progress', 'completed', 'cancelled')),
  requested_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ
);

CREATE INDEX idx_trips_driver_id ON trips(driver_id);
CREATE INDEX idx_trips_rider_id ON trips(rider_id);
CREATE INDEX idx_trips_status ON trips(status);
CREATE INDEX idx_trips_requested_at ON trips(requested_at);

-- =====================================================================
-- PAYMENTS TABLE
-- =====================================================================

CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  trip_id INT NOT NULL UNIQUE REFERENCES trips(id),
  amount DECIMAL(10,2) NOT NULL,
  method VARCHAR(20) NOT NULL CHECK (method IN ('card', 'cash', 'wallet')),
  status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
  paid_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payments_status ON payments(status);

-- =====================================================================
-- REVIEWS TABLE
-- =====================================================================

CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  trip_id INT NOT NULL REFERENCES trips(id),
  reviewer_id INT NOT NULL,
  reviewee_id INT NOT NULL,
  reviewer_type VARCHAR(20) NOT NULL CHECK (reviewer_type IN ('rider', 'driver')),
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reviews_reviewee_id ON reviews(reviewee_id);
CREATE INDEX idx_reviews_trip_id ON reviews(trip_id);

-- =====================================================================
-- DRIVER_EARNINGS TABLE
-- =====================================================================

CREATE TABLE driver_earnings (
  id SERIAL PRIMARY KEY,
  driver_id INT NOT NULL REFERENCES drivers(id),
  trip_id INT NOT NULL REFERENCES trips(id),
  gross_amount DECIMAL(10,2) NOT NULL,
  platform_fee DECIMAL(10,2) NOT NULL,
  net_amount DECIMAL(10,2) NOT NULL,
  earned_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_driver_earnings_driver_id ON driver_earnings(driver_id);
CREATE INDEX idx_driver_earnings_earned_at ON driver_earnings(earned_at);

-- =====================================================================
-- INSERT SAMPLE DATA - DRIVERS
-- =====================================================================

INSERT INTO drivers (name, email, phone, rating, city, vehicle_type, is_active) VALUES
('John Dlamini', 'john.dlamini@drivers.uber.co.za', '+27712345678', 4.85, 'Johannesburg', 'Toyota Corolla', true),
('Thandi Mkhize', 'thandi.mkhize@drivers.uber.co.za', '+27823456789', 4.92, 'Cape Town', 'Hyundai i20', true),
('Sipho Ndlela', 'sipho.ndlela@drivers.uber.co.za', '+27834567890', 4.65, 'Johannesburg', 'Ford Fiesta', true),
('Naledi Khumalo', 'naledi.k@drivers.uber.co.za', '+27712345679', 4.78, 'Durban', 'Volkswagen Polo', true),
('Bongani Mthembu', 'bongani.m@drivers.uber.co.za', '+27823456790', 3.95, 'Pretoria', 'Suzuki Swift', true),
('Amelia Van Der Merwe', 'amelia.vdm@drivers.uber.co.za', '+27834567891', 4.88, 'Cape Town', 'BMW 1 Series', true),
('Thabo Molefe', 'thabo.molefe@drivers.uber.co.za', '+27712345680', 4.71, 'Johannesburg', 'Mazda 2', true),
('Lindiwe Nkosi', 'lindiwe.nkosi@drivers.uber.co.za', '+27823456791', 4.83, 'Durban', 'Toyota Yaris', true),
('Kwanele Zuma', 'kwanele.zuma@drivers.uber.co.za', '+27834567892', 4.56, 'Pretoria', 'Datsun Go', false),
('Nomsa Sithole', 'nomsa.sithole@drivers.uber.co.za', '+27712345681', 4.91, 'Cape Town', 'Toyota Avanza', true);

-- =====================================================================
-- INSERT SAMPLE DATA - RIDERS
-- =====================================================================

INSERT INTO riders (name, email, phone, city, is_active) VALUES
('Amara Khumalo', 'amara.k@email.co.za', '+27712111111', 'Johannesburg', true),
('Lerato Mthembu', 'lerato.m@email.co.za', '+27823222222', 'Cape Town', true),
('Mpume Sithole', 'mpume.s@email.co.za', '+27834333333', 'Durban', true),
('Zanele Nkosi', 'zanele.n@email.co.za', '+27712444444', 'Johannesburg', true),
('Trevor Williams', 'trevor.w@email.co.za', '+27823555555', 'Pretoria', true),
('Busisiwe Dlamini', 'busisiwe.d@email.co.za', '+27834666666', 'Cape Town', true),
('Kabelo Molefe', 'kabelo.m@email.co.za', '+27712777777', 'Johannesburg', true),
('Mandisa Ndaba', 'mandisa.n@email.co.za', '+27823888888', 'Durban', false),
('Sizwe Mthembu', 'sizwe.mthembu@email.co.za', '+27834999999', 'Johannesburg', true),
('Nomvula Zwane', 'nomvula.z@email.co.za', '+27712000000', 'Cape Town', true),
('Themba Dlamini', 'themba.d@email.co.za', '+27823111111', 'Pretoria', true),
('Naledi Sekhukhune', 'naledi.s@email.co.za', '+27834222222', 'Johannesburg', true),
('Gorata Molefe', 'gorata.m@email.co.za', '+27712333333', 'Durban', true),
('Precious Khumalo', 'precious.k@email.co.za', '+27823444444', 'Cape Town', true),
('Khaya Nkosi', 'khaya.n@email.co.za', '+27834555555', 'Johannesburg', true),
('Nalini Patel', 'nalini.p@email.co.za', '+27712666666', 'Durban', true),
('Jared Smith', 'jared.smith@email.co.za', '+27823777777', 'Johannesburg', true),
('Zainab Hassan', 'zainab.h@email.co.za', '+27834888888', 'Cape Town', true),
('Ravi Kumar', 'ravi.k@email.co.za', '+27712999999', 'Johannesburg', true),
('Siyanda Ndaba', 'siyanda.n@email.co.za', '+27823000000', 'Pretoria', true);

-- =====================================================================
-- INSERT SAMPLE DATA - TRIPS (50 trips)
-- =====================================================================

INSERT INTO trips (driver_id, rider_id, pickup_location, dropoff_location, pickup_lat, pickup_lng, dropoff_lat, dropoff_lng, fare, distance_km, duration_minutes, status, requested_at, started_at, completed_at) VALUES
(1, 1, 'Sandton City, JNB', 'OR Tambo Airport', -26.1344, 28.0472, -26.1369, 28.2428, 85.50, 32.4, 28, 'completed', '2024-01-15 09:15:00+02', '2024-01-15 09:18:00+02', '2024-01-15 09:46:00+02'),
(2, 2, 'V&A Waterfront, CPT', 'Camps Bay Beach', -33.8622, 18.4241, -33.9424, 18.3616, 45.20, 8.5, 12, 'completed', '2024-01-15 10:30:00+02', '2024-01-15 10:32:00+02', '2024-01-15 10:44:00+02'),
(3, 3, 'Durban Beach Front', 'Umhlanga Rocks', -29.8587, 31.0277, -29.7261, 31.1269, 52.80, 15.2, 18, 'completed', '2024-01-15 11:00:00+02', '2024-01-15 11:03:00+02', '2024-01-15 11:21:00+02'),
(1, 4, 'Johannesburg Hospital', 'Bryanston', -26.1689, 27.9991, -26.0831, 28.0398, 38.90, 12.1, 15, 'completed', '2024-01-15 14:15:00+02', '2024-01-15 14:18:00+02', '2024-01-15 14:33:00+02'),
(4, 5, 'Pretoria Central', 'Hatfield', -25.7461, 28.2293, -25.7599, 28.2337, 32.40, 9.8, 11, 'completed', '2024-01-15 15:45:00+02', '2024-01-15 15:47:00+02', '2024-01-15 15:58:00+02'),
(2, 6, 'Bellville, CPT', 'Tygervalley Centre', -33.8764, 18.6056, -33.8689, 18.5889, 28.50, 2.8, 8, 'completed', '2024-01-16 08:30:00+02', '2024-01-16 08:32:00+02', '2024-01-16 08:40:00+02'),
(7, 7, 'Midrand, JNB', 'Menlyn Shopping Centre', -25.9875, 28.0847, -25.7693, 28.3158, 65.30, 24.5, 22, 'completed', '2024-01-16 09:00:00+02', '2024-01-16 09:03:00+02', '2024-01-16 09:25:00+02'),
(8, 8, 'Pinetown, DBN', 'Westville Shopping', -29.8234, 30.9089, -29.8512, 30.8934, 38.70, 10.2, 13, 'completed', '2024-01-16 10:15:00+02', '2024-01-16 10:18:00+02', '2024-01-16 10:31:00+02'),
(6, 9, 'Constantia Nek, CPT', 'Hout Bay Harbour', -34.0402, 18.3597, -34.0535, 18.3556, 52.10, 6.7, 10, 'completed', '2024-01-16 11:30:00+02', '2024-01-16 11:32:00+02', '2024-01-16 11:42:00+02'),
(3, 10, 'Southdale, JNB', 'Eastgate Shopping', -26.1987, 28.1045, -26.1934, 28.0914, 35.80, 5.4, 9, 'completed', '2024-01-16 12:45:00+02', '2024-01-16 12:47:00+02', '2024-01-16 12:56:00+02'),
(1, 11, 'Pretoria Train Station', 'Union Buildings', -25.7461, 28.2293, -25.7406, 28.2283, 28.30, 0.8, 3, 'completed', '2024-01-16 13:30:00+02', '2024-01-16 13:31:00+02', '2024-01-16 13:34:00+02'),
(5, 12, 'Rosebank, JNB', 'Wanderers Cricket', -26.1145, 28.0452, -26.1701, 28.0381, 42.50, 8.2, 11, 'completed', '2024-01-16 14:00:00+02', '2024-01-16 14:02:00+02', '2024-01-16 14:13:00+02'),
(2, 13, 'Green Point, CPT', 'Table Mountain Aerial Cableway', -33.9346, 18.3931, -33.9628, 18.3835, 38.90, 5.2, 8, 'completed', '2024-01-17 08:00:00+02', '2024-01-17 08:02:00+02', '2024-01-17 08:10:00+02'),
(7, 14, 'Edenvale, JNB', 'Kyalami Racing Circuit', -26.1487, 28.0719, -25.9889, 28.0889, 78.40, 25.3, 26, 'completed', '2024-01-17 09:15:00+02', '2024-01-17 09:18:00+02', '2024-01-17 09:44:00+02'),
(4, 15, 'Menlyn, PTA', 'Pretoria Zoo', -25.7693, 28.3158, -25.8187, 28.2913, 45.60, 13.4, 16, 'completed', '2024-01-17 10:30:00+02', '2024-01-17 10:32:00+02', '2024-01-17 10:48:00+02'),
(6, 16, 'Strand, CPT', 'Gordon''s Bay', -34.3404, 18.8621, -34.2789, 18.9084, 48.70, 12.1, 14, 'completed', '2024-01-17 11:00:00+02', '2024-01-17 11:03:00+02', '2024-01-17 11:17:00+02'),
(8, 17, 'Umkomaas, DBN', 'Shelly Beach', -30.2134, 30.7956, -30.2345, 30.8456, 35.20, 8.3, 10, 'completed', '2024-01-17 12:15:00+02', '2024-01-17 12:17:00+02', '2024-01-17 12:27:00+02'),
(1, 18, 'Soweto, JNB', 'Apartheid Museum', -26.2486, 27.8658, -26.2534, 27.8743, 45.30, 12.7, 16, 'completed', '2024-01-17 13:30:00+02', '2024-01-17 13:33:00+02', '2024-01-17 13:49:00+02'),
(3, 19, 'Killarney, JNB', 'Kyalami Grand Prix Circuit', -26.0918, 28.1089, -25.9889, 28.0889, 68.50, 21.3, 20, 'completed', '2024-01-17 14:45:00+02', '2024-01-17 14:48:00+02', '2024-01-17 15:08:00+02'),
(10, 20, 'Fish Hoek, CPT', 'Kalk Bay', -34.1659, 18.4565, -34.1808, 18.4425, 22.10, 4.1, 6, 'completed', '2024-01-17 15:00:00+02', '2024-01-17 15:02:00+02', '2024-01-17 15:08:00+02'),
(2, 1, 'Newlands, CPT', 'Kirstenbosch Botanical Gardens', -33.9855, 18.4314, -33.9882, 18.4298, 32.50, 3.2, 7, 'completed', '2024-01-18 08:30:00+02', '2024-01-18 08:32:00+02', '2024-01-18 08:39:00+02'),
(7, 2, 'Alberton, JNB', 'Palmridge Shopping Centre', -26.2534, 28.0743, -26.2789, 28.1034, 38.60, 9.8, 13, 'completed', '2024-01-18 09:45:00+02', '2024-01-18 09:47:00+02', '2024-01-18 10:00:00+02'),
(4, 3, 'Centurion, PTA', 'The Menlyn Shopping Centre', -25.8934, 28.3456, -25.7693, 28.3158, 52.80, 15.4, 18, 'completed', '2024-01-18 10:30:00+02', '2024-01-18 10:33:00+02', '2024-01-18 10:51:00+02'),
(6, 4, 'Bloubergstrand, CPT', 'Table Mountain Viewpoint', -33.8694, 18.3903, -33.8628, 18.3835, 18.90, 1.8, 5, 'completed', '2024-01-18 11:00:00+02', '2024-01-18 11:02:00+02', '2024-01-18 11:07:00+02'),
(8, 5, 'Pinetown, DBN', 'Kloof, DBN', -29.8234, 30.9089, -29.7891, 30.8945, 28.40, 7.2, 9, 'completed', '2024-01-18 12:30:00+02', '2024-01-18 12:32:00+02', '2024-01-18 12:41:00+02'),
(1, 6, 'Benoni, JNB', 'Springs, JNB', -26.2345, 28.2156, -26.2089, 28.3634, 55.30, 16.8, 19, 'completed', '2024-01-18 13:45:00+02', '2024-01-18 13:48:00+02', '2024-01-18 14:07:00+02'),
(3, 7, 'Observatory, CPT', 'Pinelands Shopping Centre', -33.9299, 18.4718, -33.9034, 18.4789, 35.60, 5.8, 10, 'completed', '2024-01-18 14:30:00+02', '2024-01-18 14:32:00+02', '2024-01-18 14:42:00+02'),
(5, 8, 'Waterfall Estate, PTA', 'Woodhill Estate, PTA', -25.7234, 28.3567, -25.7856, 28.3234, 42.10, 12.3, 14, 'completed', '2024-01-18 15:15:00+02', '2024-01-18 15:18:00+02', '2024-01-18 15:32:00+02'),
(10, 9, 'Strand Beach, CPT', 'Voelklip Beach, CPT', -34.3404, 18.8621, -34.3234, 18.9145, 25.80, 6.7, 9, 'completed', '2024-01-19 08:00:00+02', '2024-01-19 08:02:00+02', '2024-01-19 08:11:00+02'),
(2, 10, 'Morningside, DBN', 'Amanzimtoti Beach, DBN', -29.8234, 31.0089, -30.0234, 30.8234, 62.40, 18.9, 22, 'completed', '2024-01-19 09:30:00+02', '2024-01-19 09:33:00+02', '2024-01-19 09:55:00+02'),
(7, 11, 'Dainfern, JNB', 'Sunninghill, JNB', -25.9756, 28.0234, -25.7893, 28.0567, 48.50, 14.5, 17, 'completed', '2024-01-19 10:45:00+02', '2024-01-19 10:48:00+02', '2024-01-19 11:05:00+02'),
(4, 12, 'Pretoria East, PTA', 'Arcadia, PTA', -25.7461, 28.2293, -25.7534, 28.2234, 18.30, 1.2, 3, 'completed', '2024-01-19 11:30:00+02', '2024-01-19 11:32:00+02', '2024-01-19 11:35:00+02'),
(6, 13, 'Strand, CPT', 'Hermanus, CPT', -34.3404, 18.8621, -34.4234, 19.2156, 125.60, 41.2, 48, 'completed', '2024-01-19 12:00:00+02', '2024-01-19 12:05:00+02', '2024-01-19 12:53:00+02'),
(1, 14, 'Fourways, JNB', 'Bedfordview, JNB', -25.9934, 28.0156, -26.1445, 28.0823, 68.90, 21.3, 23, 'completed', '2024-01-19 13:15:00+02', '2024-01-19 13:18:00+02', '2024-01-19 13:41:00+02'),
(8, 15, 'Durban CBD, DBN', 'Glenwood, DBN', -29.8587, 31.0277, -29.8456, 31.0156, 24.50, 3.4, 6, 'completed', '2024-01-19 14:30:00+02', '2024-01-19 14:32:00+02', '2024-01-19 14:38:00+02'),
(3, 16, 'Berea, JNB', 'Auckland Park, JNB', -26.1923, 28.0156, -26.1823, 28.0234, 0.00, 0.0, 0, 'cancelled', '2024-01-19 15:45:00+02', NULL, NULL),
(5, 17, 'Claremont, CPT', 'Wynberg, CPT', -33.9724, 18.4701, -33.9934, 18.4956, 0.00, 0.0, 0, 'cancelled', '2024-01-19 16:00:00+02', NULL, NULL),
(2, 18, 'Westville, DBN', 'Cowies Hill, DBN', -29.8512, 30.8934, -29.8723, 30.8867, 0.00, 0.0, 0, 'cancelled', '2024-01-19 16:30:00+02', NULL, NULL),
(7, 19, 'Kempton Park, JNB', 'Boksburg, JNB', -26.0756, 28.1667, -26.1923, 28.3045, 0.00, 0.0, 0, 'cancelled', '2024-01-19 17:00:00+02', NULL, NULL),
(4, 20, 'Pretoria West, PTA', 'Danville, PTA', -25.7234, 28.1856, -25.7156, 28.2567, 0.00, 0.0, 0, 'cancelled', '2024-01-19 17:30:00+02', NULL, NULL),
(6, 1, 'Maitland, CPT', 'Bellville, CPT', -33.8934, 18.6201, -33.8764, 18.6056, 0.00, 0.0, 0, 'cancelled', '2024-01-20 08:00:00+02', NULL, NULL),
(1, 2, 'Alexandra, JNB', 'Wynberg, JNB', -26.0934, 28.0567, -26.2234, 28.1567, 0.00, 0.0, 0, 'cancelled', '2024-01-20 08:30:00+02', NULL, NULL),
(8, 3, 'Umbilo, DBN', 'Isipingo, DBN', -29.9234, 31.0156, -30.0345, 31.0234, 0.00, 0.0, 0, 'cancelled', '2024-01-20 09:00:00+02', NULL, NULL),
(3, 4, 'Rosebank, JNB', 'Sandton Convention Centre', -26.1145, 28.0452, -26.1234, 28.0567, 0.00, 0.0, 0, 'in_progress', '2024-01-20 10:00:00+02', '2024-01-20 10:02:00+02', NULL),
(10, 5, 'Camps Bay, CPT', 'Clifton Beach', -33.9424, 18.3616, -33.9856, 18.3589, 0.00, 0.0, 0, 'in_progress', '2024-01-20 10:30:00+02', '2024-01-20 10:32:00+02', NULL),
(1, 6, 'Westville, DBN', 'Umhlanga Ridge, DBN', -29.8512, 30.8934, -29.7234, 31.0567, 0.00, 0.0, 0, 'in_progress', '2024-01-20 11:00:00+02', '2024-01-20 11:03:00+02', NULL),
(7, 7, 'Pretoria Central, PTA', 'Menlyn, PTA', -25.7461, 28.2293, -25.7693, 28.3158, 0.00, 0.0, 0, 'in_progress', '2024-01-20 11:45:00+02', '2024-01-20 11:48:00+02', NULL),
(4, 8, 'Jordanhill, JNB', 'Illovo, JNB', -26.1156, 28.0234, -26.1445, 28.0823, 0.00, 0.0, 0, 'in_progress', '2024-01-20 12:15:00+02', '2024-01-20 12:18:00+02', NULL),
(6, 9, 'Milnerton, CPT', 'Paarden Eiland, CPT', -33.8904, 18.4501, -33.9034, 18.4845, 0.00, 0.0, 0, 'in_progress', '2024-01-20 13:00:00+02', '2024-01-20 13:02:00+02', NULL),
(2, 10, 'Durban Beachfront, DBN', 'Point Waterfront, DBN', -29.8587, 31.0277, -29.8601, 31.0189, 0.00, 0.0, 0, 'in_progress', '2024-01-20 14:00:00+02', '2024-01-20 14:02:00+02', NULL);

-- =====================================================================
-- STARTER QUERIES - Uncomment and run these to test your setup
-- =====================================================================

-- Check if data loaded successfully:
-- SELECT COUNT(*) AS driver_count FROM drivers;
-- SELECT COUNT(*) AS rider_count FROM riders;
-- SELECT COUNT(*) AS trip_count FROM trips;

-- Try a simple query:
-- SELECT id, name, rating, city FROM drivers WHERE is_active = true ORDER BY rating DESC;

-- Try a JOIN:
-- SELECT t.id, d.name, r.name, t.fare FROM trips t
-- JOIN drivers d ON t.driver_id = d.id
-- JOIN riders r ON t.rider_id = r.id
-- LIMIT 10;

-- Try an aggregate:
-- SELECT driver_id, COUNT(*) as trip_count, ROUND(AVG(fare), 2) as avg_fare
-- FROM trips WHERE status = 'completed' GROUP BY driver_id ORDER BY trip_count DESC;

-- Database is ready! Start with Day 1 queries from the bootcamp.
