-- =====================================================================
-- SQL Mastery Bootcamp - Uber Database Sample Data
-- PostgreSQL 15+
-- =====================================================================
-- Realistic sample data for practice queries
-- South African themed: cities, names, phone numbers
-- =====================================================================

-- =====================================================================
-- DRIVERS: 10 drivers across South African cities
-- =====================================================================

INSERT INTO drivers (name, email, phone, rating, city, vehicle_type, is_active, created_at) VALUES
('John Dlamini', 'john.dlamini@drivers.uber.co.za', '+27712345678', 4.85, 'Johannesburg', 'Toyota Corolla', true, '2024-01-05 08:30:00+02'),
('Thandi Mkhize', 'thandi.mkhize@drivers.uber.co.za', '+27823456789', 4.92, 'Cape Town', 'Hyundai i20', true, '2024-01-06 09:15:00+02'),
('Sipho Ndlela', 'sipho.ndlela@drivers.uber.co.za', '+27834567890', 4.65, 'Johannesburg', 'Ford Fiesta', true, '2024-01-07 10:00:00+02'),
('Naledi Khumalo', 'naledi.k@drivers.uber.co.za', '+27712345679', 4.78, 'Durban', 'Volkswagen Polo', true, '2024-01-08 11:30:00+02'),
('Bongani Mthembu', 'bongani.m@drivers.uber.co.za', '+27823456790', 3.95, 'Pretoria', 'Suzuki Swift', true, '2024-01-09 07:45:00+02'),
('Amelia Van Der Merwe', 'amelia.vdm@drivers.uber.co.za', '+27834567891', 4.88, 'Cape Town', 'BMW 1 Series', true, '2024-01-10 08:20:00+02'),
('Thabo Molefe', 'thabo.molefe@drivers.uber.co.za', '+27712345680', 4.71, 'Johannesburg', 'Mazda 2', true, '2024-01-11 09:00:00+02'),
('Lindiwe Nkosi', 'lindiwe.nkosi@drivers.uber.co.za', '+27823456791', 4.83, 'Durban', 'Toyota Yaris', true, '2024-01-12 10:30:00+02'),
('Kwanele Zuma', 'kwanele.zuma@drivers.uber.co.za', '+27834567892', 4.56, 'Pretoria', 'Datsun Go', false, '2024-01-13 11:15:00+02'),
('Nomsa Sithole', 'nomsa.sithole@drivers.uber.co.za', '+27712345681', 4.91, 'Cape Town', 'Toyota Avanza', true, '2024-01-14 08:45:00+02');

-- =====================================================================
-- RIDERS: 20 riders across major cities
-- =====================================================================

INSERT INTO riders (name, email, phone, city, is_active, created_at) VALUES
('Amara Khumalo', 'amara.k@email.co.za', '+27712111111', 'Johannesburg', true, '2024-01-01 12:00:00+02'),
('Lerato Mthembu', 'lerato.m@email.co.za', '+27823222222', 'Cape Town', true, '2024-01-01 13:30:00+02'),
('Mpume Sithole', 'mpume.s@email.co.za', '+27834333333', 'Durban', true, '2024-01-02 14:15:00+02'),
('Zanele Nkosi', 'zanele.n@email.co.za', '+27712444444', 'Johannesburg', true, '2024-01-02 15:45:00+02'),
('Trevor Williams', 'trevor.w@email.co.za', '+27823555555', 'Pretoria', true, '2024-01-03 08:00:00+02'),
('Busisiwe Dlamini', 'busisiwe.d@email.co.za', '+27834666666', 'Cape Town', true, '2024-01-03 09:30:00+02'),
('Kabelo Molefe', 'kabelo.m@email.co.za', '+27712777777', 'Johannesburg', true, '2024-01-04 10:15:00+02'),
('Mandisa Ndaba', 'mandisa.n@email.co.za', '+27823888888', 'Durban', false, '2024-01-04 11:45:00+02'),
('Sizwe Mthembu', 'sizwe.mthembu@email.co.za', '+27834999999', 'Johannesburg', true, '2024-01-05 12:30:00+02'),
('Nomvula Zwane', 'nomvula.z@email.co.za', '+27712000000', 'Cape Town', true, '2024-01-05 13:15:00+02'),
('Themba Dlamini', 'themba.d@email.co.za', '+27823111111', 'Pretoria', true, '2024-01-06 14:00:00+02'),
('Naledi Sekhukhune', 'naledi.s@email.co.za', '+27834222222', 'Johannesburg', true, '2024-01-06 15:30:00+02'),
('Gorata Molefe', 'gorata.m@email.co.za', '+27712333333', 'Durban', true, '2024-01-07 08:45:00+02'),
('Precious Khumalo', 'precious.k@email.co.za', '+27823444444', 'Cape Town', true, '2024-01-07 09:30:00+02'),
('Khaya Nkosi', 'khaya.n@email.co.za', '+27834555555', 'Johannesburg', true, '2024-01-08 10:15:00+02'),
('Nalini Patel', 'nalini.p@email.co.za', '+27712666666', 'Durban', true, '2024-01-08 11:00:00+02'),
('Jared Smith', 'jared.smith@email.co.za', '+27823777777', 'Johannesburg', true, '2024-01-09 12:30:00+02'),
('Zainab Hassan', 'zainab.h@email.co.za', '+27834888888', 'Cape Town', true, '2024-01-09 13:45:00+02'),
('Ravi Kumar', 'ravi.k@email.co.za', '+27712999999', 'Johannesburg', true, '2024-01-10 14:15:00+02'),
('Siyanda Ndaba', 'siyanda.n@email.co.za', '+27823000000', 'Pretoria', true, '2024-01-10 15:30:00+02');

-- =====================================================================
-- TRIPS: 50 trips with mixed statuses
-- =====================================================================

INSERT INTO trips (driver_id, rider_id, pickup_location, dropoff_location, pickup_lat, pickup_lng, dropoff_lat, dropoff_lng, fare, distance_km, duration_minutes, status, requested_at, started_at, completed_at) VALUES
-- Completed trips (35 trips)
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

-- Cancelled trips (8 trips)
(3, 16, 'Berea, JNB', 'Auckland Park, JNB', -26.1923, 28.0156, -26.1823, 28.0234, 0.00, 0.0, 0, 'cancelled', '2024-01-19 15:45:00+02', NULL, NULL),
(5, 17, 'Claremont, CPT', 'Wynberg, CPT', -33.9724, 18.4701, -33.9934, 18.4956, 0.00, 0.0, 0, 'cancelled', '2024-01-19 16:00:00+02', NULL, NULL),
(2, 18, 'Westville, DBN', 'Cowies Hill, DBN', -29.8512, 30.8934, -29.8723, 30.8867, 0.00, 0.0, 0, 'cancelled', '2024-01-19 16:30:00+02', NULL, NULL),
(7, 19, 'Kempton Park, JNB', 'Boksburg, JNB', -26.0756, 28.1667, -26.1923, 28.3045, 0.00, 0.0, 0, 'cancelled', '2024-01-19 17:00:00+02', NULL, NULL),
(4, 20, 'Pretoria West, PTA', 'Danville, PTA', -25.7234, 28.1856, -25.7156, 28.2567, 0.00, 0.0, 0, 'cancelled', '2024-01-19 17:30:00+02', NULL, NULL),
(6, 1, 'Maitland, CPT', 'Bellville, CPT', -33.8934, 18.6201, -33.8764, 18.6056, 0.00, 0.0, 0, 'cancelled', '2024-01-20 08:00:00+02', NULL, NULL),
(1, 2, 'Alexandra, JNB', 'Wynberg, JNB', -26.0934, 28.0567, -26.2234, 28.1567, 0.00, 0.0, 0, 'cancelled', '2024-01-20 08:30:00+02', NULL, NULL),
(8, 3, 'Umbilo, DBN', 'Isipingo, DBN', -29.9234, 31.0156, -30.0345, 31.0234, 0.00, 0.0, 0, 'cancelled', '2024-01-20 09:00:00+02', NULL, NULL),

-- In-progress trips (7 trips)
(3, 4, 'Rosebank, JNB', 'Sandton Convention Centre', -26.1145, 28.0452, -26.1234, 28.0567, 0.00, 0.0, 0, 'in_progress', '2024-01-20 10:00:00+02', '2024-01-20 10:02:00+02', NULL),
(10, 5, 'Camps Bay, CPT', 'Clifton Beach', -33.9424, 18.3616, -33.9856, 18.3589, 0.00, 0.0, 0, 'in_progress', '2024-01-20 10:30:00+02', '2024-01-20 10:32:00+02', NULL),
(1, 6, 'Westville, DBN', 'Umhlanga Ridge, DBN', -29.8512, 30.8934, -29.7234, 31.0567, 0.00, 0.0, 0, 'in_progress', '2024-01-20 11:00:00+02', '2024-01-20 11:03:00+02', NULL),
(7, 7, 'Pretoria Central, PTA', 'Menlyn, PTA', -25.7461, 28.2293, -25.7693, 28.3158, 0.00, 0.0, 0, 'in_progress', '2024-01-20 11:45:00+02', '2024-01-20 11:48:00+02', NULL),
(4, 8, 'Jordanhill, JNB', 'Illovo, JNB', -26.1156, 28.0234, -26.1445, 28.0823, 0.00, 0.0, 0, 'in_progress', '2024-01-20 12:15:00+02', '2024-01-20 12:18:00+02', NULL),
(6, 9, 'Milnerton, CPT', 'Paarden Eiland, CPT', -33.8904, 18.4501, -33.9034, 18.4845, 0.00, 0.0, 0, 'in_progress', '2024-01-20 13:00:00+02', '2024-01-20 13:02:00+02', NULL),
(2, 10, 'Durban Beachfront, DBN', 'Point Waterfront, DBN', -29.8587, 31.0277, -29.8601, 31.0189, 0.00, 0.0, 0, 'in_progress', '2024-01-20 14:00:00+02', '2024-01-20 14:02:00+02', NULL);

-- =====================================================================
-- PAYMENTS: 40 payments (one per completed trip)
-- =====================================================================

INSERT INTO payments (trip_id, amount, method, status, paid_at) VALUES
(1, 85.50, 'card', 'completed', '2024-01-15 09:47:00+02'),
(2, 45.20, 'card', 'completed', '2024-01-15 10:45:00+02'),
(3, 52.80, 'cash', 'completed', '2024-01-15 11:22:00+02'),
(4, 38.90, 'wallet', 'completed', '2024-01-15 14:34:00+02'),
(5, 32.40, 'card', 'completed', '2024-01-15 15:59:00+02'),
(6, 28.50, 'card', 'completed', '2024-01-16 08:41:00+02'),
(7, 65.30, 'card', 'completed', '2024-01-16 09:26:00+02'),
(8, 38.70, 'cash', 'completed', '2024-01-16 10:32:00+02'),
(9, 52.10, 'wallet', 'completed', '2024-01-16 11:43:00+02'),
(10, 35.80, 'card', 'completed', '2024-01-16 12:57:00+02'),
(11, 28.30, 'card', 'completed', '2024-01-16 13:35:00+02'),
(12, 42.50, 'wallet', 'completed', '2024-01-16 14:14:00+02'),
(13, 38.90, 'card', 'completed', '2024-01-17 08:11:00+02'),
(14, 78.40, 'card', 'completed', '2024-01-17 09:45:00+02'),
(15, 45.60, 'cash', 'completed', '2024-01-17 10:49:00+02'),
(16, 48.70, 'wallet', 'completed', '2024-01-17 11:18:00+02'),
(17, 35.20, 'card', 'completed', '2024-01-17 12:28:00+02'),
(18, 45.30, 'card', 'completed', '2024-01-17 13:50:00+02'),
(19, 68.50, 'cash', 'completed', '2024-01-17 15:09:00+02'),
(20, 22.10, 'card', 'completed', '2024-01-17 15:09:00+02'),
(21, 32.50, 'wallet', 'completed', '2024-01-18 08:40:00+02'),
(22, 38.60, 'card', 'completed', '2024-01-18 10:01:00+02'),
(23, 52.80, 'card', 'completed', '2024-01-18 10:52:00+02'),
(24, 18.90, 'wallet', 'completed', '2024-01-18 11:08:00+02'),
(25, 28.40, 'card', 'completed', '2024-01-18 12:42:00+02'),
(26, 55.30, 'cash', 'completed', '2024-01-18 14:08:00+02'),
(27, 35.60, 'card', 'completed', '2024-01-18 14:43:00+02'),
(28, 42.10, 'wallet', 'completed', '2024-01-18 15:33:00+02'),
(29, 25.80, 'card', 'completed', '2024-01-19 08:12:00+02'),
(30, 62.40, 'card', 'completed', '2024-01-19 09:56:00+02'),
(31, 48.50, 'cash', 'completed', '2024-01-19 11:06:00+02'),
(32, 18.30, 'wallet', 'completed', '2024-01-19 11:36:00+02'),
(33, 125.60, 'card', 'completed', '2024-01-19 12:54:00+02'),
(34, 68.90, 'card', 'completed', '2024-01-19 13:42:00+02'),
(35, 24.50, 'wallet', 'completed', '2024-01-19 14:39:00+02');

-- =====================================================================
-- REVIEWS: 60 reviews (mostly from completed trips)
-- =====================================================================

INSERT INTO reviews (trip_id, reviewer_id, reviewee_id, reviewer_type, rating, comment, created_at) VALUES
-- Trip 1 reviews
(1, 1, 1, 'rider', 5, 'Excellent driver, very safe and professional', '2024-01-15 09:50:00+02'),
(1, 1, 1, 'driver', 5, 'Great rider, easy trip', '2024-01-15 09:51:00+02'),
-- Trip 2 reviews
(2, 2, 2, 'rider', 5, 'Amazing experience, beautiful car', '2024-01-15 10:50:00+02'),
(2, 2, 2, 'driver', 4, 'Good rider, pleasant conversation', '2024-01-15 10:51:00+02'),
-- Trip 3 reviews
(3, 3, 3, 'rider', 4, 'Professional and courteous', '2024-01-15 11:30:00+02'),
(3, 3, 3, 'driver', 5, 'Rider was very kind', '2024-01-15 11:31:00+02'),
-- Trip 4 reviews
(4, 4, 1, 'rider', 5, 'Smooth ride, great service', '2024-01-15 14:40:00+02'),
(4, 4, 1, 'driver', 4, 'Good passenger', '2024-01-15 14:41:00+02'),
-- Trip 5 reviews
(5, 5, 4, 'rider', 5, 'Efficient and friendly', '2024-01-15 16:05:00+02'),
(5, 5, 4, 'driver', 5, 'Very polite rider', '2024-01-15 16:06:00+02'),
-- Trip 6 reviews
(6, 6, 2, 'rider', 4, 'Good driver, short trip', '2024-01-16 08:45:00+02'),
(6, 6, 2, 'driver', 4, 'Quick trip, professional', '2024-01-16 08:46:00+02'),
-- Trip 7 reviews
(7, 7, 7, 'rider', 5, 'Excellent ride, very comfortable', '2024-01-16 09:30:00+02'),
(7, 7, 7, 'driver', 5, 'Delightful passenger', '2024-01-16 09:31:00+02'),
-- Trip 8 reviews
(8, 8, 8, 'rider', 4, 'Good service, clean car', '2024-01-16 10:35:00+02'),
(8, 8, 8, 'driver', 3, 'Rider was somewhat quiet', '2024-01-16 10:36:00+02'),
-- Trip 9 reviews
(9, 9, 6, 'rider', 5, 'Outstanding driver, beautiful scenery stop', '2024-01-16 11:50:00+02'),
(9, 9, 6, 'driver', 5, 'Wonderful passenger, great chat', '2024-01-16 11:51:00+02'),
-- Trip 10 reviews
(10, 10, 3, 'rider', 4, 'Reliable and safe', '2024-01-16 13:00:00+02'),
(10, 10, 3, 'driver', 4, 'Good passenger', '2024-01-16 13:01:00+02'),
-- Trip 11 reviews
(11, 11, 1, 'rider', 5, 'Perfect short trip', '2024-01-16 13:40:00+02'),
(11, 11, 1, 'driver', 5, 'Pleasant passenger', '2024-01-16 13:41:00+02'),
-- Trip 12 reviews
(12, 12, 5, 'rider', 3, 'Okay, but took long route', '2024-01-16 14:20:00+02'),
(12, 12, 5, 'driver', 4, 'Rider was quiet', '2024-01-16 14:21:00+02'),
-- Trip 13 reviews
(13, 13, 2, 'rider', 5, 'Excellent driver, great music', '2024-01-17 08:15:00+02'),
(13, 13, 2, 'driver', 5, 'Wonderful rider', '2024-01-17 08:16:00+02'),
-- Trip 14 reviews
(14, 14, 7, 'rider', 5, 'Amazing long drive, very comfortable', '2024-01-17 09:50:00+02'),
(14, 14, 7, 'driver', 5, 'Great passenger', '2024-01-17 09:51:00+02'),
-- Trip 15 reviews
(15, 15, 4, 'rider', 4, 'Professional and punctual', '2024-01-17 10:55:00+02'),
(15, 15, 4, 'driver', 4, 'Good rider', '2024-01-17 10:56:00+02'),
-- Trip 16 reviews
(16, 16, 6, 'rider', 5, 'Beautiful drive along coast', '2024-01-17 11:20:00+02'),
(16, 16, 6, 'driver', 5, 'Lovely passenger', '2024-01-17 11:21:00+02'),
-- Trip 17 reviews
(17, 17, 8, 'rider', 4, 'Good driver, relaxing ride', '2024-01-17 12:30:00+02'),
(17, 17, 8, 'driver', 4, 'Pleasant passenger', '2024-01-17 12:31:00+02'),
-- Trip 18 reviews
(18, 18, 1, 'rider', 5, 'Great knowledge of city', '2024-01-17 13:55:00+02'),
(18, 18, 1, 'driver', 5, 'Interested passenger', '2024-01-17 13:56:00+02'),
-- Trip 19 reviews
(19, 19, 3, 'rider', 5, 'Smooth and quick', '2024-01-17 15:15:00+02'),
(19, 19, 3, 'driver', 5, 'Great passenger', '2024-01-17 15:16:00+02'),
-- Trip 20 reviews
(20, 20, 10, 'rider', 5, 'Perfect short trip', '2024-01-17 15:10:00+02'),
(20, 20, 10, 'driver', 5, 'Wonderful passenger', '2024-01-17 15:11:00+02'),
-- Trip 21 reviews
(21, 1, 2, 'rider', 4, 'Good driver', '2024-01-18 08:45:00+02'),
(21, 1, 2, 'driver', 4, 'Good passenger', '2024-01-18 08:46:00+02'),
-- Trip 22 reviews
(22, 2, 7, 'rider', 5, 'Excellent service', '2024-01-18 10:05:00+02'),
(22, 2, 7, 'driver', 5, 'Great rider', '2024-01-18 10:06:00+02'),
-- Trip 23 reviews
(23, 3, 4, 'rider', 4, 'Professional', '2024-01-18 10:55:00+02'),
(23, 3, 4, 'driver', 4, 'Good passenger', '2024-01-18 10:56:00+02'),
-- Trip 24 reviews
(24, 4, 6, 'rider', 5, 'Lovely short trip', '2024-01-18 11:10:00+02'),
(24, 4, 6, 'driver', 5, 'Great passenger', '2024-01-18 11:11:00+02'),
-- Trip 25 reviews
(25, 5, 8, 'rider', 4, 'Good driver', '2024-01-18 12:45:00+02'),
(25, 5, 8, 'driver', 4, 'Good passenger', '2024-01-18 12:46:00+02'),
-- Trip 26 reviews
(26, 6, 1, 'rider', 5, 'Excellent experience', '2024-01-18 14:15:00+02'),
(26, 6, 1, 'driver', 5, 'Great rider', '2024-01-18 14:16:00+02'),
-- Trip 27 reviews
(27, 7, 3, 'rider', 4, 'Good service', '2024-01-18 14:50:00+02'),
(27, 7, 3, 'driver', 4, 'Good passenger', '2024-01-18 14:51:00+02'),
-- Trip 28 reviews
(28, 8, 5, 'rider', 5, 'Excellent driver', '2024-01-18 15:40:00+02'),
(28, 8, 5, 'driver', 5, 'Wonderful passenger', '2024-01-18 15:41:00+02'),
-- Trip 29 reviews
(29, 9, 10, 'rider', 5, 'Perfect short trip', '2024-01-19 08:15:00+02'),
(29, 9, 10, 'driver', 5, 'Great passenger', '2024-01-19 08:16:00+02'),
-- Trip 30 reviews
(30, 10, 2, 'rider', 4, 'Good driver', '2024-01-19 10:00:00+02'),
(30, 10, 2, 'driver', 4, 'Good passenger', '2024-01-19 10:01:00+02'),
-- Trip 31 reviews
(31, 11, 7, 'rider', 5, 'Excellent service', '2024-01-19 11:10:00+02'),
(31, 11, 7, 'driver', 5, 'Great rider', '2024-01-19 11:11:00+02'),
-- Trip 32 reviews
(32, 12, 4, 'rider', 5, 'Perfect trip', '2024-01-19 11:40:00+02'),
(32, 12, 4, 'driver', 5, 'Wonderful passenger', '2024-01-19 11:41:00+02'),
-- Trip 33 reviews
(33, 13, 6, 'rider', 5, 'Amazing long drive', '2024-01-19 13:00:00+02'),
(33, 13, 6, 'driver', 5, 'Great passenger', '2024-01-19 13:01:00+02'),
-- Trip 34 reviews
(34, 14, 1, 'rider', 5, 'Excellent experience', '2024-01-19 13:50:00+02'),
(34, 14, 1, 'driver', 5, 'Great rider', '2024-01-19 13:51:00+02'),
-- Trip 35 reviews
(35, 15, 8, 'rider', 5, 'Perfect trip', '2024-01-19 14:45:00+02'),
(35, 15, 8, 'driver', 5, 'Great passenger', '2024-01-19 14:46:00+02');

-- =====================================================================
-- DRIVER_EARNINGS: 35 records (one per completed trip)
-- =====================================================================

INSERT INTO driver_earnings (driver_id, trip_id, gross_amount, platform_fee, net_amount, earned_at) VALUES
(1, 1, 85.50, 17.10, 68.40, '2024-01-15 09:46:00+02'),
(2, 2, 45.20, 9.04, 36.16, '2024-01-15 10:44:00+02'),
(3, 3, 52.80, 10.56, 42.24, '2024-01-15 11:21:00+02'),
(1, 4, 38.90, 7.78, 31.12, '2024-01-15 14:33:00+02'),
(4, 5, 32.40, 6.48, 25.92, '2024-01-15 15:58:00+02'),
(2, 6, 28.50, 5.70, 22.80, '2024-01-16 08:40:00+02'),
(7, 7, 65.30, 13.06, 52.24, '2024-01-16 09:25:00+02'),
(8, 8, 38.70, 7.74, 30.96, '2024-01-16 10:31:00+02'),
(6, 9, 52.10, 10.42, 41.68, '2024-01-16 11:42:00+02'),
(3, 10, 35.80, 7.16, 28.64, '2024-01-16 12:56:00+02'),
(1, 11, 28.30, 5.66, 22.64, '2024-01-16 13:34:00+02'),
(5, 12, 42.50, 8.50, 34.00, '2024-01-16 14:13:00+02'),
(2, 13, 38.90, 7.78, 31.12, '2024-01-17 08:10:00+02'),
(7, 14, 78.40, 15.68, 62.72, '2024-01-17 09:44:00+02'),
(4, 15, 45.60, 9.12, 36.48, '2024-01-17 10:48:00+02'),
(6, 16, 48.70, 9.74, 38.96, '2024-01-17 11:17:00+02'),
(8, 17, 35.20, 7.04, 28.16, '2024-01-17 12:27:00+02'),
(1, 18, 45.30, 9.06, 36.24, '2024-01-17 13:49:00+02'),
(3, 19, 68.50, 13.70, 54.80, '2024-01-17 15:08:00+02'),
(10, 20, 22.10, 4.42, 17.68, '2024-01-17 15:08:00+02'),
(2, 21, 32.50, 6.50, 26.00, '2024-01-18 08:39:00+02'),
(7, 22, 38.60, 7.72, 30.88, '2024-01-18 10:00:00+02'),
(4, 23, 52.80, 10.56, 42.24, '2024-01-18 10:51:00+02'),
(6, 24, 18.90, 3.78, 15.12, '2024-01-18 11:07:00+02'),
(8, 25, 28.40, 5.68, 22.72, '2024-01-18 12:41:00+02'),
(1, 26, 55.30, 11.06, 44.24, '2024-01-18 14:07:00+02'),
(3, 27, 35.60, 7.12, 28.48, '2024-01-18 14:42:00+02'),
(5, 28, 42.10, 8.42, 33.68, '2024-01-18 15:32:00+02'),
(10, 29, 25.80, 5.16, 20.64, '2024-01-19 08:11:00+02'),
(2, 30, 62.40, 12.48, 49.92, '2024-01-19 09:55:00+02'),
(7, 31, 48.50, 9.70, 38.80, '2024-01-19 11:05:00+02'),
(4, 32, 18.30, 3.66, 14.64, '2024-01-19 11:35:00+02'),
(6, 33, 125.60, 25.12, 100.48, '2024-01-19 12:53:00+02'),
(1, 34, 68.90, 13.78, 55.12, '2024-01-19 13:41:00+02'),
(8, 35, 24.50, 4.90, 19.60, '2024-01-19 14:38:00+02');

-- =====================================================================
-- Data Load Complete
-- =====================================================================
-- Summary: 10 drivers, 20 riders, 50 trips (35 completed, 8 cancelled, 7 in_progress)
-- 40 payments, 60 reviews, 35 earnings records
-- Ready for SQL practice queries!
-- =====================================================================

