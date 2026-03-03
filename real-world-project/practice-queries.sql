-- =====================================================================
-- SQL Mastery Bootcamp - Practice Queries
-- Day-by-Day Examples and Exercises
-- PostgreSQL 15+
-- =====================================================================
-- Use these queries to practice alongside the bootcamp curriculum.
-- Run each query and study the results.
-- Try to write variations before looking at solutions.
-- =====================================================================

-- =====================================================================
-- DAY 1-2: FOUNDATIONS - Basic SELECT, WHERE, Filtering
-- =====================================================================

-- Query 1.1: Select all drivers
SELECT * FROM drivers LIMIT 10;

-- Query 1.2: Select only active drivers
SELECT id, name, email, city, rating FROM drivers WHERE is_active = true;

-- Query 1.3: Select drivers in Johannesburg
SELECT id, name, vehicle_type, rating FROM drivers WHERE city = 'Johannesburg' ORDER BY rating DESC;

-- Query 1.4: Select completed trips
SELECT id, driver_id, rider_id, fare, distance_km, status FROM trips WHERE status = 'completed' LIMIT 5;

-- Query 1.5: Select high-value trips (> 50 ZAR)
SELECT id, driver_id, rider_id, fare, distance_km FROM trips WHERE fare > 50.00 ORDER BY fare DESC;

-- Query 1.6: Select cancelled trips
SELECT id, requested_at, status FROM trips WHERE status = 'cancelled';

-- Query 1.7: Select trips with specific rider
SELECT id, driver_id, fare, status FROM trips WHERE rider_id = 1;

-- Query 1.8: Filter trips by date range
SELECT id, requested_at, status FROM trips WHERE requested_at >= '2024-01-17' AND requested_at < '2024-01-18';

-- Query 1.9: Use LIKE for city search
SELECT id, name, email, city FROM drivers WHERE city LIKE '%burg%' OR city LIKE '%Cape%';

-- Query 1.10: NULL handling - find trips not yet started
SELECT id, rider_id, status, requested_at, started_at FROM trips WHERE started_at IS NULL;

-- =====================================================================
-- DAY 3: JOINs - Combine Multiple Tables
-- =====================================================================

-- Query 3.1: INNER JOIN - Trips with driver names
SELECT 
  t.id,
  d.name AS driver_name,
  t.pickup_location,
  t.dropoff_location,
  t.fare
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
LIMIT 10;

-- Query 3.2: JOIN - Trips with driver and rider names
SELECT 
  t.id,
  d.name AS driver_name,
  r.name AS rider_name,
  t.fare,
  t.distance_km,
  t.status
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
INNER JOIN riders r ON t.rider_id = r.id
LIMIT 10;

-- Query 3.3: LEFT JOIN - All drivers and their trips (if any)
SELECT 
  d.id,
  d.name,
  COUNT(t.id) AS trip_count
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id, d.name
ORDER BY trip_count DESC;

-- Query 3.4: JOIN with payments
SELECT 
  t.id,
  d.name,
  t.fare,
  p.amount,
  p.method,
  p.status
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
LEFT JOIN payments p ON t.id = p.trip_id
WHERE t.status = 'completed'
LIMIT 10;

-- Query 3.5: Multiple JOINs - Comprehensive trip info
SELECT 
  t.id,
  d.name AS driver_name,
  r.name AS rider_name,
  t.fare,
  p.amount,
  p.method,
  COUNT(rev.id) AS review_count
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
INNER JOIN riders r ON t.rider_id = r.id
LEFT JOIN payments p ON t.id = p.trip_id
LEFT JOIN reviews rev ON t.id = rev.trip_id
WHERE t.status = 'completed'
GROUP BY t.id, d.name, r.name, t.fare, p.amount, p.method
LIMIT 10;

-- =====================================================================
-- DAY 4: FUNCTIONS & NULL HANDLING
-- =====================================================================

-- Query 4.1: Text functions - driver names uppercase
SELECT 
  id,
  UPPER(name) AS name_upper,
  LOWER(email) AS email_lower,
  LENGTH(name) AS name_length
FROM drivers
LIMIT 5;

-- Query 4.2: Substring function
SELECT 
  id,
  name,
  SUBSTRING(phone, 1, 3) AS phone_prefix
FROM drivers
LIMIT 5;

-- Query 4.3: CASE statement - classify trip distance
SELECT 
  id,
  distance_km,
  CASE 
    WHEN distance_km < 5 THEN 'short'
    WHEN distance_km BETWEEN 5 AND 15 THEN 'medium'
    WHEN distance_km > 15 THEN 'long'
    ELSE 'unknown'
  END AS distance_category
FROM trips
WHERE status = 'completed'
LIMIT 10;

-- Query 4.4: CASE statement - classify fare
SELECT 
  id,
  fare,
  CASE 
    WHEN fare < 30 THEN 'budget'
    WHEN fare BETWEEN 30 AND 75 THEN 'standard'
    WHEN fare > 75 THEN 'premium'
  END AS fare_category
FROM trips
WHERE status = 'completed'
ORDER BY fare DESC;

-- Query 4.5: COALESCE - handle NULL values
SELECT 
  t.id,
  d.name,
  COALESCE(t.completed_at, 'Not completed') AS completion_status
FROM trips t
LEFT JOIN drivers d ON t.driver_id = d.id
LIMIT 10;

-- Query 4.6: Date functions
SELECT 
  id,
  requested_at,
  DATE(requested_at) AS request_date,
  EXTRACT(HOUR FROM requested_at) AS request_hour,
  EXTRACT(DAY FROM requested_at) AS request_day
FROM trips
LIMIT 10;

-- Query 4.7: ROUND and CAST functions
SELECT 
  id,
  fare,
  ROUND(fare, 1) AS fare_rounded,
  ROUND(fare::NUMERIC / distance_km, 2) AS fare_per_km
FROM trips
WHERE distance_km > 0
LIMIT 10;

-- =====================================================================
-- DAY 5: AGGREGATES & WINDOW FUNCTIONS
-- =====================================================================

-- Query 5.1: Basic aggregates - revenue summary
SELECT 
  COUNT(*) AS total_trips,
  ROUND(AVG(fare), 2) AS avg_fare,
  ROUND(SUM(fare), 2) AS total_revenue,
  MAX(fare) AS highest_fare,
  MIN(fare) AS lowest_fare
FROM trips
WHERE status = 'completed';

-- Query 5.2: GROUP BY - trips per driver
SELECT 
  driver_id,
  COUNT(*) AS trip_count,
  ROUND(AVG(fare), 2) AS avg_fare,
  ROUND(SUM(fare), 2) AS total_revenue
FROM trips
WHERE status = 'completed'
GROUP BY driver_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 5.3: GROUP BY with JOIN - driver performance
SELECT 
  d.id,
  d.name,
  COUNT(t.id) AS completed_trips,
  ROUND(AVG(d.rating), 2) AS avg_rating,
  ROUND(SUM(de.net_amount), 2) AS total_earnings
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id AND t.status = 'completed'
LEFT JOIN driver_earnings de ON t.id = de.trip_id
GROUP BY d.id, d.name
ORDER BY total_earnings DESC;

-- Query 5.4: HAVING - drivers with high trip volumes
SELECT 
  driver_id,
  COUNT(*) AS trip_count,
  ROUND(AVG(fare), 2) AS avg_fare
FROM trips
WHERE status = 'completed'
GROUP BY driver_id
HAVING COUNT(*) >= 3
ORDER BY trip_count DESC;

-- Query 5.5: Window function - ROW_NUMBER for ranking
SELECT 
  id,
  driver_id,
  fare,
  ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY fare DESC) AS rank_in_driver,
  ROW_NUMBER() OVER (ORDER BY fare DESC) AS rank_overall
FROM trips
WHERE status = 'completed'
LIMIT 15;

-- Query 5.6: Window function - running total
SELECT 
  driver_id,
  earned_at,
  net_amount,
  SUM(net_amount) OVER (
    PARTITION BY driver_id 
    ORDER BY earned_at
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total
FROM driver_earnings
ORDER BY driver_id, earned_at
LIMIT 20;

-- Query 5.7: Aggregate with city
SELECT 
  d.city,
  COUNT(DISTINCT d.id) AS driver_count,
  COUNT(t.id) AS trip_count,
  ROUND(AVG(t.fare), 2) AS avg_fare
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id AND t.status = 'completed'
GROUP BY d.city
ORDER BY trip_count DESC;

-- =====================================================================
-- DAY 6: CTEs & SUBQUERIES
-- =====================================================================

-- Query 6.1: CTE - high-earning drivers
WITH driver_stats AS (
  SELECT 
    driver_id,
    COUNT(*) AS trip_count,
    ROUND(SUM(net_amount), 2) AS total_earnings
  FROM driver_earnings
  GROUP BY driver_id
)
SELECT 
  d.id,
  d.name,
  ds.trip_count,
  ds.total_earnings
FROM drivers d
JOIN driver_stats ds ON d.id = ds.driver_id
WHERE ds.total_earnings > 500
ORDER BY ds.total_earnings DESC;

-- Query 6.2: Subquery - rides by top drivers
SELECT 
  d.id,
  d.name,
  (SELECT COUNT(*) FROM trips WHERE driver_id = d.id AND status = 'completed') AS completed_trips
FROM drivers d
WHERE d.is_active = true
ORDER BY completed_trips DESC;

-- Query 6.3: CTE with multiple references
WITH trip_stats AS (
  SELECT 
    driver_id,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_trips,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_trips
  FROM trips
  GROUP BY driver_id
)
SELECT 
  d.id,
  d.name,
  ts.total_trips,
  ts.completed_trips,
  ts.cancelled_trips,
  ROUND(100.0 * ts.completed_trips / ts.total_trips, 1) AS completion_rate_pct
FROM drivers d
JOIN trip_stats ts ON d.id = ts.driver_id
ORDER BY completion_rate_pct DESC;

-- Query 6.4: Subquery in FROM - derived table
SELECT 
  city,
  avg_rating,
  trip_count
FROM (
  SELECT 
    d.city,
    ROUND(AVG(d.rating), 2) AS avg_rating,
    COUNT(t.id) AS trip_count
  FROM drivers d
  LEFT JOIN trips t ON d.id = t.driver_id AND t.status = 'completed'
  GROUP BY d.city
) city_stats
WHERE trip_count > 5
ORDER BY trip_count DESC;

-- Query 6.5: EXISTS - riders with trips
SELECT 
  r.id,
  r.name,
  r.city
FROM riders r
WHERE EXISTS (
  SELECT 1 FROM trips t WHERE t.rider_id = r.id AND t.status = 'completed'
)
LIMIT 10;

-- =====================================================================
-- DAY 7: VIEWS & CREATE STATEMENTS
-- =====================================================================

-- Query 7.1: Create a view of high-rated drivers
CREATE OR REPLACE VIEW high_rated_drivers AS
SELECT 
  id,
  name,
  email,
  city,
  rating,
  is_active
FROM drivers
WHERE rating >= 4.5 AND is_active = true;

-- Query to test the view:
SELECT * FROM high_rated_drivers ORDER BY rating DESC;

-- Query 7.2: Create a view for driver daily metrics
CREATE OR REPLACE VIEW driver_daily_metrics AS
SELECT 
  DATE(t.requested_at) AS trip_date,
  t.driver_id,
  d.name,
  d.city,
  COUNT(*) AS trip_count,
  ROUND(AVG(t.fare), 2) AS avg_fare,
  ROUND(SUM(t.fare), 2) AS daily_revenue
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
GROUP BY DATE(t.requested_at), t.driver_id, d.name, d.city;

-- Query to test:
SELECT * FROM driver_daily_metrics WHERE trip_date = '2024-01-17' ORDER BY daily_revenue DESC;

-- Query 7.3: Insert new driver
INSERT INTO drivers (name, email, phone, rating, city, vehicle_type, is_active, created_at)
VALUES ('Test Driver', 'test.driver@drivers.uber.co.za', '+27700000000', 5.00, 'Johannesburg', 'Toyota Corolla', true, CURRENT_TIMESTAMP);

-- Query 7.4: Update driver rating
UPDATE drivers SET rating = 4.95 WHERE id = 1;

-- Query 7.5: Delete cancelled trip (careful!)
-- DELETE FROM trips WHERE status = 'cancelled' AND id = 43;

-- =====================================================================
-- DAY 8: EXPLAIN ANALYZE & Query Performance
-- =====================================================================

-- Query 8.1: EXPLAIN simple query
EXPLAIN ANALYZE
SELECT * FROM drivers WHERE city = 'Johannesburg';

-- Query 8.2: EXPLAIN JOIN query
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
  t.id,
  d.name,
  r.name,
  t.fare
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
INNER JOIN riders r ON t.rider_id = r.id
WHERE t.status = 'completed'
LIMIT 100;

-- Query 8.3: EXPLAIN aggregate query
EXPLAIN ANALYZE
SELECT 
  driver_id,
  COUNT(*) AS trip_count,
  ROUND(AVG(fare), 2) AS avg_fare
FROM trips
WHERE status = 'completed'
GROUP BY driver_id;

-- Query 8.4: Check index usage
SELECT indexname, idx_scan FROM pg_stat_user_indexes WHERE tablename = 'trips';

-- Query 8.5: View table statistics
SELECT 
  tablename,
  n_live_tup AS live_rows,
  n_dead_tup AS dead_rows,
  last_vacuum,
  last_autovacuum,
  last_analyze
FROM pg_stat_user_tables
WHERE tablename IN ('trips', 'drivers', 'riders');

-- =====================================================================
-- DAY 9: PERFORMANCE OPTIMIZATION & Advanced Queries
-- =====================================================================

-- Query 9.1: Find slow queries (sequential scan on large table)
EXPLAIN ANALYZE
SELECT COUNT(*) FROM trips WHERE distance_km > 10;

-- Query 9.2: Query with subquery vs JOIN
-- Less efficient (subquery):
SELECT * FROM trips WHERE driver_id IN (
  SELECT driver_id FROM driver_earnings WHERE net_amount > 50
);

-- More efficient (JOIN):
SELECT DISTINCT t.* FROM trips t
INNER JOIN driver_earnings de ON t.id = de.trip_id
WHERE de.net_amount > 50;

-- Query 9.3: Denormalization example - add driver name to trips for faster reads
-- SELECT t.id, t.driver_id, d.name FROM trips t JOIN drivers d ON t.driver_id = d.id;

-- Query 9.4: Check for missing indexes
SELECT 
  schemaname,
  tablename,
  indexname,
  idx_scan AS index_scans,
  idx_tup_read AS tuples_read,
  idx_tup_fetch AS tuples_fetched
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

-- =====================================================================
-- DAY 10: ANALYTICS & Data Warehouse Queries
-- =====================================================================

-- Query 10.1: Daily revenue dashboard
SELECT 
  DATE(t.requested_at) AS trip_date,
  COUNT(*) AS trip_count,
  ROUND(AVG(t.fare), 2) AS avg_fare,
  ROUND(SUM(t.fare), 2) AS daily_revenue,
  ROUND(AVG(d.rating), 2) AS avg_driver_rating
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
GROUP BY DATE(t.requested_at)
ORDER BY trip_date DESC;

-- Query 10.2: City performance analysis
SELECT 
  d.city,
  COUNT(DISTINCT d.id) AS active_drivers,
  COUNT(DISTINCT t.id) AS completed_trips,
  ROUND(AVG(t.fare), 2) AS avg_fare,
  ROUND(SUM(de.net_amount), 2) AS total_driver_earnings,
  ROUND(SUM(t.fare) - SUM(de.net_amount), 2) AS platform_revenue
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id AND t.status = 'completed'
LEFT JOIN driver_earnings de ON t.id = de.trip_id
GROUP BY d.city
ORDER BY total_driver_earnings DESC;

-- Query 10.3: Driver ranking with multiple metrics
WITH driver_metrics AS (
  SELECT 
    d.id,
    d.name,
    d.city,
    d.rating,
    COUNT(DISTINCT CASE WHEN t.status = 'completed' THEN t.id END) AS completed_trips,
    COUNT(DISTINCT CASE WHEN t.status = 'cancelled' THEN t.id END) AS cancelled_trips,
    ROUND(SUM(CASE WHEN t.status = 'completed' THEN de.net_amount ELSE 0 END), 2) AS total_earnings,
    ROUND(AVG(r.rating), 2) AS avg_review_rating
  FROM drivers d
  LEFT JOIN trips t ON d.id = t.driver_id
  LEFT JOIN driver_earnings de ON t.id = de.trip_id
  LEFT JOIN reviews r ON t.id = r.trip_id AND r.reviewer_type = 'rider'
  GROUP BY d.id, d.name, d.city, d.rating
)
SELECT 
  id,
  name,
  city,
  rating,
  completed_trips,
  cancelled_trips,
  ROUND(100.0 * completed_trips / (completed_trips + cancelled_trips), 1) AS completion_rate_pct,
  total_earnings,
  avg_review_rating,
  ROW_NUMBER() OVER (ORDER BY total_earnings DESC) AS earnings_rank
FROM driver_metrics
WHERE completed_trips > 0
ORDER BY earnings_rank;

-- Query 10.4: Payment method distribution
SELECT 
  p.method,
  COUNT(*) AS transaction_count,
  ROUND(AVG(p.amount), 2) AS avg_amount,
  ROUND(SUM(p.amount), 2) AS total_revenue,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM payments WHERE status = 'completed'), 1) AS pct_of_total
FROM payments p
WHERE p.status = 'completed'
GROUP BY p.method
ORDER BY total_revenue DESC;

-- Query 10.5: Review analysis
SELECT 
  CASE WHEN r.reviewer_type = 'rider' THEN 'Riders reviewing Drivers' ELSE 'Drivers reviewing Riders' END AS review_type,
  r.rating,
  COUNT(*) AS count,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM reviews), 1) AS pct_of_total
FROM reviews r
GROUP BY r.reviewer_type, r.rating
ORDER BY r.reviewer_type, r.rating DESC;

-- =====================================================================
-- PRACTICE EXERCISES - Try These Yourself!
-- =====================================================================

-- EXERCISE 1: Find all trips completed on 2024-01-17
-- (Answer: 9 trips completed that day)

-- EXERCISE 2: Which driver has earned the most money?
-- (Answer: Driver ID with highest SUM of net_amount in driver_earnings)

-- EXERCISE 3: Find riders who have taken 0 trips
-- (Answer: Use LEFT JOIN and IS NULL)

-- EXERCISE 4: Calculate the average time from request to completion
-- (Answer: Use EXTRACT(EPOCH ...) to get seconds, then convert to minutes)

-- EXERCISE 5: Find trips where the payment status is failed or refunded
-- (Answer: Use payments table with status IN clause)

-- =====================================================================
-- END OF PRACTICE QUERIES
-- =====================================================================
