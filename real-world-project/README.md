# Uber Ride-Sharing Database - SQL Practice Environment

A realistic PostgreSQL database schema modeling an Uber-style ride-sharing platform. Use this for hands-on SQL practice aligned with the 10-day bootcamp.

---

## What Is This Database?

A production-like ride-sharing system capturing:
- **Drivers:** who drives, where, vehicle type, ratings
- **Riders:** who books rides, contact info
- **Trips:** the core event; every ride from pickup to completion
- **Payments:** how each trip was paid
- **Reviews:** quality ratings for drivers and riders
- **Driver Earnings:** revenue tracking per driver

**Data Scale (Practice Version):**
- 10 drivers across South African cities
- 20 riders
- 50 trips (completed, cancelled, in-progress)
- 40 payments
- 60 reviews
- 40 earnings records

**Real-World Scale (Reference):**
- Production databases have millions of drivers, trips, and transactions
- Used for training on partitioning, indexing, and analytics

---

## Database Schema Overview

### Core Tables

#### `drivers`
Who provides the rides; tracks active status, ratings, location.
```
Columns: id, name, email, phone, rating, city, vehicle_type, is_active, created_at
Primary Key: id
Relationships: Referenced by trips (driver_id), reviews (reviewee_id), driver_earnings (driver_id)
```

#### `riders`
Who books the rides; basic profile info.
```
Columns: id, name, email, phone, city, is_active, created_at
Primary Key: id
Relationships: Referenced by trips (rider_id), reviews (reviewer_id)
```

#### `trips` (Core Fact Table)
Every ride: from request to completion. The most queried table.
```
Columns: id, driver_id FK, rider_id FK, pickup_location, dropoff_location, pickup_lat/lng, dropoff_lat/lng, 
          fare, distance_km, duration_minutes, status, requested_at, started_at, completed_at
Primary Key: id
Foreign Keys: driver_id → drivers.id, rider_id → riders.id
Indexes: driver_id, rider_id, status, created_at (for analytics)
```

#### `payments`
How each trip was paid; tracks payment status and method.
```
Columns: id, trip_id FK UNIQUE, amount, method (card/cash/wallet), status (pending/completed/failed/refunded), paid_at
Primary Key: id
Foreign Key: trip_id → trips.id (one payment per trip)
```

#### `reviews`
Quality ratings; both drivers review riders and vice versa.
```
Columns: id, trip_id FK, reviewer_id, reviewee_id, reviewer_type (rider/driver), rating (1-5), comment, created_at
Primary Key: id
Foreign Key: trip_id → trips.id
```

#### `driver_earnings`
Revenue tracking per driver per trip; gross minus platform fees.
```
Columns: id, driver_id FK, trip_id FK, gross_amount, platform_fee, net_amount, earned_at
Primary Keys: driver_id + trip_id (one record per driver earning)
Foreign Keys: driver_id → drivers.id, trip_id → trips.id
```

---

## Entity Relationship Diagram

```
drivers ──────┬──→ trips (driver_id)
              ├──→ reviews (reviewee_id)
              └──→ driver_earnings (driver_id)

riders ───────┬──→ trips (rider_id)
              └──→ reviews (reviewer_id)

trips ────────┬──→ payments (trip_id)
              ├──→ reviews (trip_id)
              └──→ driver_earnings (trip_id)
```

**Relationships:**
- **1:Many:** One driver → many trips
- **1:Many:** One rider → many trips
- **1:1:** One trip → one payment
- **1:Many:** One trip → many reviews
- **1:Many:** One driver → many earnings records

---

## How to Use With DB Fiddle

1. Go to **db-fiddle.com**
2. Select **PostgreSQL 15** from the left panel
3. Paste the entire contents of `db-fiddle-setup.sql` into the **LEFT panel** (SQL Schema)
4. Click **"Run"**
5. Use the **RIGHT panel** to write and test queries

The database is now ready for practice queries.

---

## Day-by-Day Query Map

| Day | Topic | Tables to Use | Example Queries |
|-----|-------|---------------|-----------------| 
| 1-2 | Basic SELECTs, Filtering | `trips`, `drivers`, `riders` | Find all completed trips, list active drivers |
| 3 | JOINs | `trips` + `drivers`, `riders` | Show each trip with driver and rider names |
| 4 | Functions, CASE | `trips`, `driver_earnings` | Classify trip distances; format dates |
| 5 | Aggregates, Window Functions | `trips`, `driver_earnings` | Total revenue per driver; trip rankings |
| 6 | CTEs, Subqueries | `trips`, `drivers` | Top 5 drivers by trip count using CTE |
| 7 | Views, CREATE/ALTER | `trips`, `drivers` | Create view of high-rated drivers |
| 8 | EXPLAIN ANALYZE | Any table | Profile query performance; identify slow queries |
| 9 | Performance Tuning | `trips` (large table) | Test index usage; optimize joins |
| 10 | Analytics, Aggregation | All tables | Daily revenue by city; driver performance metrics |

---

## Sample Starter Queries

### 1. Find All Completed Trips
```sql
SELECT id, driver_id, rider_id, fare, distance_km, duration_minutes
FROM trips
WHERE status = 'completed'
LIMIT 10;
```

### 2. Show Top-Rated Drivers
```sql
SELECT id, name, city, rating, is_active
FROM drivers
WHERE rating >= 4.5 AND is_active = true
ORDER BY rating DESC;
```

### 3. Join: Trips with Driver Names
```sql
SELECT 
  t.id as trip_id,
  d.name as driver_name,
  t.pickup_location,
  t.dropoff_location,
  t.fare
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
LIMIT 10;
```

### 4. Aggregate: Revenue Per Driver
```sql
SELECT 
  driver_id,
  COUNT(*) as trip_count,
  ROUND(AVG(fare), 2) as avg_fare,
  ROUND(SUM(fare), 2) as total_revenue
FROM trips
WHERE status = 'completed'
GROUP BY driver_id
ORDER BY total_revenue DESC;
```

### 5. Window Function: Trip Rank per Driver
```sql
SELECT 
  driver_id,
  id as trip_id,
  fare,
  ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY fare DESC) as rank_in_driver
FROM trips
WHERE status = 'completed'
LIMIT 20;
```

### 6. CTE: High-Value Trips
```sql
WITH high_value AS (
  SELECT id, driver_id, rider_id, fare
  FROM trips
  WHERE fare > 100 AND status = 'completed'
)
SELECT 
  hv.id,
  d.name as driver_name,
  r.name as rider_name,
  hv.fare
FROM high_value hv
JOIN drivers d ON hv.driver_id = d.id
JOIN riders r ON hv.rider_id = r.id;
```

---

## Data Dictionary

### drivers
| Column | Type | Description | Example |
|--------|------|-------------|---------|
| id | SERIAL | Unique driver identifier | 1 |
| name | VARCHAR(100) | Driver full name | John Dlamini |
| email | VARCHAR(100) UNIQUE | Contact email | john@uber.co.za |
| phone | VARCHAR(20) | Phone number | +27712345678 |
| rating | DECIMAL(3,2) | Average passenger rating | 4.85 |
| city | VARCHAR(50) | Operating city | Johannesburg |
| vehicle_type | VARCHAR(50) | Car model/type | Toyota Corolla |
| is_active | BOOLEAN | Can currently accept rides | true |
| created_at | TIMESTAMPTZ | Registration timestamp | 2024-01-15 10:30:00+02 |

### riders
| Column | Type | Description | Example |
|--------|------|-------------|---------|
| id | SERIAL | Unique rider identifier | 1 |
| name | VARCHAR(100) | Rider full name | Amara Khumalo |
| email | VARCHAR(100) UNIQUE | Contact email | amara@email.co.za |
| phone | VARCHAR(20) | Phone number | +27821234567 |
| city | VARCHAR(50) | Home city | Cape Town |
| is_active | BOOLEAN | Account status | true |
| created_at | TIMESTAMPTZ | Signup timestamp | 2024-01-10 14:20:00+02 |

### trips
| Column | Type | Description | Example |
|--------|------|-------------|---------|
| id | SERIAL | Unique trip identifier | 1 |
| driver_id | INT FK | Driver for this trip | 1 |
| rider_id | INT FK | Rider requesting trip | 5 |
| pickup_location | VARCHAR(255) | Start address | Sandton City, JNB |
| dropoff_location | VARCHAR(255) | End address | OR Tambo Airport |
| pickup_lat | DECIMAL(10,8) | Pickup latitude | -26.1344 |
| pickup_lng | DECIMAL(10,8) | Pickup longitude | 28.0472 |
| dropoff_lat | DECIMAL(10,8) | Dropoff latitude | -26.1369 |
| dropoff_lng | DECIMAL(10,8) | Dropoff longitude | 28.2428 |
| fare | DECIMAL(10,2) | Trip cost in ZAR | 85.50 |
| distance_km | DECIMAL(6,2) | Distance traveled | 32.40 |
| duration_minutes | INT | Trip length in minutes | 28 |
| status | VARCHAR(20) | Trip state | completed |
| requested_at | TIMESTAMPTZ | When rider requested | 2024-01-20 09:15:00+02 |
| started_at | TIMESTAMPTZ | When driver accepted | 2024-01-20 09:18:00+02 |
| completed_at | TIMESTAMPTZ | When trip ended | 2024-01-20 09:46:00+02 |

### payments
| Column | Type | Description | Example |
|--------|------|-------------|---------|
| id | SERIAL | Unique payment identifier | 1 |
| trip_id | INT FK UNIQUE | Associated trip | 1 |
| amount | DECIMAL(10,2) | Payment amount in ZAR | 85.50 |
| method | VARCHAR(20) | Payment method | card |
| status | VARCHAR(20) | Payment result | completed |
| paid_at | TIMESTAMPTZ | Payment timestamp | 2024-01-20 09:47:00+02 |

### reviews
| Column | Type | Description | Example |
|--------|------|-------------|---------|
| id | SERIAL | Unique review identifier | 1 |
| trip_id | INT FK | Trip being reviewed | 1 |
| reviewer_id | INT | Who left the review | 5 |
| reviewee_id | INT | Who is being reviewed | 1 |
| reviewer_type | VARCHAR(20) | rider or driver | rider |
| rating | INT | 1-5 star rating | 5 |
| comment | TEXT | Optional feedback | Excellent driver, very safe |
| created_at | TIMESTAMPTZ | Review timestamp | 2024-01-20 10:00:00+02 |

### driver_earnings
| Column | Type | Description | Example |
|--------|------|-------------|---------|
| id | SERIAL | Unique record identifier | 1 |
| driver_id | INT FK | Driver who earned | 1 |
| trip_id | INT FK | Associated trip | 1 |
| gross_amount | DECIMAL(10,2) | Ride revenue in ZAR | 85.50 |
| platform_fee | DECIMAL(10,2) | Uber's commission | 17.10 |
| net_amount | DECIMAL(10,2) | Driver payout | 68.40 |
| earned_at | TIMESTAMPTZ | When earned | 2024-01-20 09:46:00+02 |

---

## Next Steps

1. **Setup:** Use `schema.sql` to create the database structure
2. **Seed Data:** Use `seed-data.sql` to populate with sample data
3. **Practice:** Use `practice-queries.sql` to follow along with bootcamp days
4. **Optimize:** Study execution plans with `EXPLAIN ANALYZE`

---

## Files in This Directory

- `schema.sql` - Complete database schema (CREATE TABLE statements)
- `seed-data.sql` - Sample realistic data for practice
- `practice-queries.sql` - Day-by-day query examples and exercises
- `README.md` - This file

---

## Tips for Success

✅ **Do:**
- Start with simple SELECT queries; build complexity gradually
- Use `LIMIT 10` when first testing queries (faster feedback)
- Run `EXPLAIN ANALYZE` on every query >100ms
- Write comments explaining your logic
- Test with real data volumes (not just tiny samples)

❌ **Don't:**
- Use `SELECT *` in production; specify columns
- Forget WHERE clauses in DELETE/UPDATE statements
- Assume indexes exist; verify with EXPLAIN
- Optimize without measuring first (EXPLAIN ANALYZE)
- Skip the error log; document and learn from mistakes

---

## Contact & Questions

This database is designed for the SQL Mastery Bootcamp. For questions, refer to the study kit materials or revisit the case studies for similar patterns.

**Good luck with your SQL journey!** 🚀

