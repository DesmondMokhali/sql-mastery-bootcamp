# 🏆 Day 10: Data Warehouse & Final Projects
**Friday, 13 March 2026 (Extension)**  
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) – From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** — Please like, subscribe and support the original creator!

---

## 📅 Today's Schedule

| Time | Activity | Duration | Focus |
|------|----------|----------|-------|
| 09:00–09:45 | Data Warehouse Fundamentals | 45 min | Bronze/Silver/Gold layers |
| 09:45–10:30 | Fact & Dimension Tables | 45 min | Star schema design |
| 10:30–11:15 | Slowly Changing Dimensions (SCD) | 45 min | Type 1, 2, 3 patterns |
| 11:15–12:00 | Cardinality & Index Strategy | 45 min | Analytics optimization |
| 12:00–13:00 | **Lunch Break** | 60 min | – |
| 13:00–13:45 | Designing for Billion-Row Systems | 45 min | Partitioning, compression |
| 13:45–14:30 | Final Project 1: Uber DWH | 45 min | Build Bronze → Silver → Gold |
| 14:30–15:15 | Final Project 2: EDA & Analysis | 45 min | Exploratory data analysis |
| 15:15–15:35 | Production Debugging Scenario | 20 min | Full system diagnosis |

---

## 🎯 Core Topics

### 1. Data Warehouse Layers (Bronze/Silver/Gold)

**Data flows through layers of increasing refinement.**

```
RAW DATA → BRONZE (Raw Copy) → SILVER (Cleaned) → GOLD (Analytics)
                ↓                  ↓                  ↓
            Trips CSV        Deduped, joined      Star schema
            Drivers CSV      Validated             Fact tables
            Reviews CSV      Aggregated            Dimensions
                                                   Metrics
```

#### Bronze Layer (Raw, Unprocessed)

```sql
-- Bronze: Exact copy of source data
CREATE TABLE bronze_trips (
  id INT,
  driver_id INT,
  rider_id INT,
  pickup_location VARCHAR(500),
  dropoff_location VARCHAR(500),
  fare DECIMAL(10, 2),
  distance_km DECIMAL(8, 2),
  status VARCHAR(50),
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  _ingested_at TIMESTAMP DEFAULT NOW(),
  _source_file VARCHAR(500)
);

-- Bronze: Load raw (no transformations)
INSERT INTO bronze_trips 
SELECT * FROM raw_csv_import;
```

#### Silver Layer (Cleaned, Validated)

```sql
-- Silver: Business logic, deduplication, validation
CREATE TABLE silver_trips AS
SELECT 
  id,
  driver_id,
  rider_id,
  TRIM(pickup_location) as pickup_location,
  TRIM(dropoff_location) as dropoff_location,
  CASE 
    WHEN fare <= 0 THEN NULL  -- Validation
    ELSE fare 
  END as fare,
  CASE 
    WHEN distance_km <= 0 THEN NULL
    ELSE distance_km 
  END as distance_km,
  LOWER(status) as status,
  started_at,
  CASE 
    WHEN completed_at < started_at THEN NULL  -- Validation
    ELSE completed_at 
  END as completed_at,
  _ingested_at,
  ROW_NUMBER() OVER (PARTITION BY id, started_at ORDER BY _ingested_at DESC) as rn
FROM bronze_trips
WHERE _ingested_at >= NOW() - INTERVAL '1 day';  -- Incremental load

-- Remove duplicates (keep latest version)
DELETE FROM silver_trips WHERE rn > 1;
```

#### Gold Layer (Analytics-Ready)

```sql
-- Gold: Fact tables, dimensions, metrics
CREATE TABLE gold_fact_trips (
  trip_id INT PRIMARY KEY,
  date_id INT,  -- FK to gold_dim_date
  driver_id INT,  -- FK to gold_dim_driver
  rider_id INT,  -- FK to gold_dim_rider
  fare DECIMAL(10, 2),
  distance_km DECIMAL(8, 2),
  trip_duration_minutes INT,
  status_id INT,  -- FK to gold_dim_status
  _dw_created_at TIMESTAMP
);

CREATE TABLE gold_dim_driver (
  driver_id INT PRIMARY KEY,
  name VARCHAR(100),
  city VARCHAR(50),
  vehicle_type VARCHAR(50),
  is_active BOOLEAN,
  _dw_start_date DATE,
  _dw_end_date DATE,  -- SCD Type 2
  _dw_is_current BOOLEAN
);
```

### 2. Fact vs Dimension Tables (Star Schema)

**Fact Table:** Measures, aggregates, transactions. Many rows, few columns.

**Dimension Table:** Descriptive attributes. Few rows, many columns.

```
               gold_dim_driver
                    ↑
                    | (FK)
                    |
gold_dim_date ←---- gold_fact_trips ----→ gold_dim_rider
    ↑                    |                     ↑
   FK                   FK                    FK
                        ↓
              gold_dim_trip_status

Star Schema: Fact in center, dimensions around
```

**Example Query (Fast):**

```sql
SELECT 
  d.city,
  d.vehicle_type,
  DATE_TRUNC('month', dat.date) as month,
  COUNT(f.trip_id) as trip_count,
  SUM(f.fare) as total_revenue,
  AVG(f.trip_duration_minutes) as avg_duration
FROM gold_fact_trips f
JOIN gold_dim_date dat ON f.date_id = dat.date_id
JOIN gold_dim_driver d ON f.driver_id = d.driver_id
WHERE d.is_active = true AND dat.date >= '2026-01-01'
GROUP BY d.city, d.vehicle_type, DATE_TRUNC('month', dat.date)
ORDER BY total_revenue DESC;
```

**Why Fast?**
1. Fact table pre-aggregated (fewer rows to scan).
2. Dimension tables pre-joined (no complex JOINs on raw data).
3. Indexes on FK columns (driver_id, date_id, status_id).

### 3. Slowly Changing Dimensions (SCD)

**Handle dimension attribute changes over time.**

#### Type 1: Overwrite (Latest Only)

```sql
-- If driver name changes, just update (no history)
UPDATE gold_dim_driver SET name = 'John Doe New' WHERE driver_id = 5;

-- Old name is lost
```

#### Type 2: Keep History (Most Common)

```sql
-- If driver city changes, create new row
-- Old row: _dw_is_current = false, _dw_end_date = today
-- New row: _dw_is_current = true, _dw_end_date = NULL

-- Before change (driver 5 in NYC)
SELECT * FROM gold_dim_driver WHERE driver_id = 5;
-- driver_id=5, city='New York', _dw_is_current=true, _dw_end_date=NULL

-- Driver moved to SF
INSERT INTO gold_dim_driver 
VALUES (5, 'John Driver', 'San Francisco', ..., _dw_start_date=TODAY, _dw_end_date=NULL, _dw_is_current=true);

-- Update old row
UPDATE gold_dim_driver 
SET _dw_is_current = false, _dw_end_date = TODAY - INTERVAL '1 day'
WHERE driver_id = 5 AND _dw_is_current = true AND _dw_start_date < TODAY;

-- Now facts can reference: 
-- Old facts (before move) → old driver record
-- New facts (after move) → new driver record
```

#### Type 3: Limited History (Hybrid)

```sql
-- Keep current AND previous value
CREATE TABLE gold_dim_driver_scd3 (
  driver_id INT PRIMARY KEY,
  name VARCHAR(100),
  name_previous VARCHAR(100),  -- Previous value
  city VARCHAR(50),
  city_previous VARCHAR(50),
  _dw_updated_at TIMESTAMP
);

-- City changed: SF → NYC
UPDATE gold_dim_driver_scd3
SET city_previous = city, city = 'New York', _dw_updated_at = NOW()
WHERE driver_id = 5;
```

### 4. Cardinality Estimation for Analytics

**High-cardinality columns:** Many distinct values (bad for partitioning).
**Low-cardinality columns:** Few distinct values (good for partitioning).

```sql
-- Check cardinality
SELECT 
  attname,
  n_distinct,
  ROUND(100.0 * n_distinct / 1000000, 2) as cardinality_percent
FROM pg_stats
WHERE tablename = 'gold_fact_trips'
ORDER BY n_distinct DESC;

-- Output:
trip_id: 1000000 (100%) ← High cardinality, bad for GROUP BY?
date_id: 365 (0.04%) ← Low cardinality, good for partitioning
driver_id: 50000 (5%) ← Medium, OK for partitioning
status_id: 5 (0.0005%) ← Very low, bad to partition by
```

**Index Strategy for Analytics:**

```sql
-- Fact table indexes (focus on FK + filtering)
CREATE INDEX idx_fact_trips_date ON gold_fact_trips(date_id);
CREATE INDEX idx_fact_trips_driver ON gold_fact_trips(driver_id);
CREATE INDEX idx_fact_trips_status ON gold_fact_trips(status_id);

-- Composite for common queries
CREATE INDEX idx_fact_trips_date_driver ON gold_fact_trips(date_id, driver_id);

-- Dimension indexes (FK lookups)
CREATE INDEX idx_dim_driver_pk ON gold_dim_driver(driver_id);
CREATE INDEX idx_dim_driver_city ON gold_dim_driver(city);

-- Covering index for common SELECT
CREATE INDEX idx_fact_trips_covering ON gold_fact_trips(date_id, driver_id)
  INCLUDE (fare, trip_duration_minutes);
```

### 5. Designing for Billion-Row Systems

**At 1B rows, every decision compounds.**

```sql
-- PARTITIONING: By date (most important)
CREATE TABLE gold_fact_trips (
  trip_id INT,
  date_id INT,
  driver_id INT,
  ...
) PARTITION BY RANGE (date_id);

-- Each year ~365 million rows (2 months per partition)
-- Partition pruning: Query 1 year of data → 6 partitions scanned, not all

-- COMPRESSION: Large VARCHAR columns
-- PostgreSQL: TOAST (The Oversized-Attribute Storage Technique)
-- Automatically compresses columns > 2KB

-- STATS: Analyze more frequently
ALTER TABLE gold_fact_trips SET (autovacuum_analyze_scale_factor = 0.001);
-- Triggers ANALYZE every 0.1% of rows changed (vs default 10%)

-- INCREMENTAL LOADS: Never full reload
INSERT INTO gold_fact_trips
SELECT * FROM silver_trips
WHERE _ingested_at > (SELECT MAX(_dw_created_at) FROM gold_fact_trips)
  AND _ingested_at <= NOW();
```

---

## 📚 10 Terms of the Day

| Term | Definition | Example | Category | Mastery |
|------|-----------|---------|----------|---------|
| **Bronze Layer** | Raw, unprocessed data copy | CSV imported as-is | DWH | |
| **Silver Layer** | Cleaned, validated, deduplicated | Removed NULLs, fixed dates | DWH | |
| **Gold Layer** | Analytics-ready, star schema | Fact + dimension tables | DWH | |
| **Fact Table** | Measurements, transactions, aggregates | gold_fact_trips (1B rows) | Schema | |
| **Dimension Table** | Descriptive attributes, slowly changing | gold_dim_driver (50k rows) | Schema | |
| **Star Schema** | Fact at center, dimensions around | Standard DWH design | Schema | |
| **Snowflake Schema** | Dimensions normalized further | Star schema with more tables | Schema | |
| **Slowly Changing Dimension** | Track attribute changes over time | Driver city changed: SCD Type 2 | Pattern | |
| **ETL** | Extract, Transform, Load pipeline | CSV → Bronze → Silver → Gold | Process | |
| **Cardinality** | Number of distinct values in column | High: trip_id; Low: status_id | Analysis | |

---

## 🧪 Final Projects (Uber Database)

### Final Project 1: Build Uber Data Warehouse (Bronze → Silver → Gold)

**Objective:** Design and build complete DWH for Uber trips, drivers, reviews.

**Step 1: Create Bronze Layer**

```sql
-- Bronze: Raw copies with metadata
CREATE TABLE bronze_drivers (
  id INT,
  name VARCHAR(100),
  rating DECIMAL(3, 2),
  city VARCHAR(50),
  is_active BOOLEAN,
  vehicle_type VARCHAR(50),
  created_at TIMESTAMP,
  _ingested_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE bronze_trips (
  id INT,
  driver_id INT,
  rider_id INT,
  pickup_location VARCHAR(500),
  dropoff_location VARCHAR(500),
  fare DECIMAL(10, 2),
  distance_km DECIMAL(8, 2),
  status VARCHAR(20),
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  _ingested_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE bronze_reviews (
  id INT,
  trip_id INT,
  reviewer_id INT,
  reviewee_id INT,
  rating INT,
  comment TEXT,
  created_at TIMESTAMP,
  _ingested_at TIMESTAMP DEFAULT NOW()
);

-- Load from source (simulate with INSERT INTO ... SELECT)
INSERT INTO bronze_drivers SELECT * FROM drivers;
INSERT INTO bronze_trips SELECT * FROM trips;
INSERT INTO bronze_reviews SELECT * FROM reviews;
```

**Step 2: Create Silver Layer**

```sql
CREATE TABLE silver_drivers AS
SELECT 
  id,
  TRIM(name) as name,
  CASE WHEN rating < 1 OR rating > 5 THEN NULL ELSE rating END as rating,
  UPPER(city) as city,
  is_active,
  vehicle_type,
  created_at,
  _ingested_at,
  ROW_NUMBER() OVER (PARTITION BY id ORDER BY _ingested_at DESC) as rn
FROM bronze_drivers;

DELETE FROM silver_drivers WHERE rn > 1;  -- Dedup

CREATE TABLE silver_trips AS
SELECT 
  id,
  driver_id,
  rider_id,
  TRIM(pickup_location) as pickup_location,
  TRIM(dropoff_location) as dropoff_location,
  CASE WHEN fare <= 0 THEN NULL ELSE fare END as fare,
  CASE WHEN distance_km <= 0 THEN NULL ELSE distance_km END as distance_km,
  LOWER(status) as status,
  started_at,
  CASE WHEN completed_at < started_at THEN NULL ELSE completed_at END as completed_at,
  _ingested_at
FROM bronze_trips
WHERE started_at IS NOT NULL
  AND driver_id IS NOT NULL
  AND rider_id IS NOT NULL;
```

**Step 3: Create Gold Layer (Star Schema)**

```sql
-- Dimension: Date
CREATE TABLE gold_dim_date (
  date_id INT PRIMARY KEY,
  date DATE,
  year INT,
  month INT,
  day INT,
  day_of_week VARCHAR(10),
  is_weekend BOOLEAN
);

-- Populate date dimension (2026-01-01 to 2026-12-31)
INSERT INTO gold_dim_date
SELECT 
  TO_CHAR(d, 'YYYYMMDD')::INT as date_id,
  d as date,
  EXTRACT(YEAR FROM d)::INT as year,
  EXTRACT(MONTH FROM d)::INT as month,
  EXTRACT(DAY FROM d)::INT as day,
  TO_CHAR(d, 'Day') as day_of_week,
  EXTRACT(DOW FROM d) IN (0, 6) as is_weekend
FROM GENERATE_SERIES('2026-01-01'::DATE, '2026-12-31'::DATE, '1 day'::INTERVAL) d;

-- Dimension: Driver (SCD Type 2)
CREATE TABLE gold_dim_driver (
  driver_sk INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  driver_id INT,
  name VARCHAR(100),
  city VARCHAR(50),
  vehicle_type VARCHAR(50),
  _dw_start_date DATE DEFAULT CURRENT_DATE,
  _dw_end_date DATE,
  _dw_is_current BOOLEAN DEFAULT TRUE
);

INSERT INTO gold_dim_driver (driver_id, name, city, vehicle_type)
SELECT DISTINCT id, name, city, vehicle_type FROM silver_drivers;

-- Dimension: Trip Status
CREATE TABLE gold_dim_trip_status (
  status_id INT PRIMARY KEY,
  status_name VARCHAR(50)
);

INSERT INTO gold_dim_trip_status VALUES
  (1, 'Completed'),
  (2, 'Cancelled'),
  (3, 'No Show'),
  (4, 'In Progress');

-- Fact: Trips
CREATE TABLE gold_fact_trips (
  trip_sk INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  trip_id INT,
  date_sk INT,
  driver_sk INT,
  rider_id INT,
  fare DECIMAL(10, 2),
  distance_km DECIMAL(8, 2),
  trip_duration_minutes INT,
  status_id INT,
  _dw_created_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (date_sk) REFERENCES gold_dim_date(date_id),
  FOREIGN KEY (driver_sk) REFERENCES gold_dim_driver(driver_sk),
  FOREIGN KEY (status_id) REFERENCES gold_dim_trip_status(status_id)
);

INSERT INTO gold_fact_trips (trip_id, date_sk, driver_sk, rider_id, fare, distance_km, trip_duration_minutes, status_id)
SELECT 
  t.id,
  TO_CHAR(t.started_at, 'YYYYMMDD')::INT,
  d.driver_sk,
  t.rider_id,
  t.fare,
  t.distance_km,
  EXTRACT(EPOCH FROM (t.completed_at - t.started_at))::INT / 60,
  CASE t.status
    WHEN 'completed' THEN 1
    WHEN 'cancelled' THEN 2
    WHEN 'no_show' THEN 3
    ELSE 4
  END
FROM silver_trips t
JOIN gold_dim_driver d ON t.driver_id = d.driver_id AND d._dw_is_current = TRUE;

-- Create indexes
CREATE INDEX idx_fact_trips_date ON gold_fact_trips(date_sk);
CREATE INDEX idx_fact_trips_driver ON gold_fact_trips(driver_sk);
CREATE INDEX idx_fact_trips_status ON gold_fact_trips(status_id);
```

### Final Project 2: Exploratory Data Analysis (EDA) & Insights

**Query 1: Driver Revenue & Activity**

```sql
SELECT 
  d.name,
  d.city,
  COUNT(f.trip_sk) as trip_count,
  SUM(f.fare) as total_revenue,
  AVG(f.fare) as avg_fare,
  AVG(f.trip_duration_minutes) as avg_duration,
  MAX(dat.date) as last_trip_date
FROM gold_fact_trips f
JOIN gold_dim_driver d ON f.driver_sk = d.driver_sk
JOIN gold_dim_date dat ON f.date_sk = dat.date_id
WHERE d._dw_is_current = TRUE AND f.status_id = 1
GROUP BY d.driver_sk, d.name, d.city
HAVING COUNT(f.trip_sk) > 10
ORDER BY total_revenue DESC
LIMIT 20;
```

**Query 2: City Performance Trends**

```sql
SELECT 
  d.city,
  dat.year,
  dat.month,
  COUNT(f.trip_sk) as trips,
  SUM(f.fare) as revenue,
  AVG(f.distance_km) as avg_distance
FROM gold_fact_trips f
JOIN gold_dim_driver d ON f.driver_sk = d.driver_sk
JOIN gold_dim_date dat ON f.date_sk = dat.date_id
WHERE f.status_id = 1
GROUP BY d.city, dat.year, dat.month
ORDER BY d.city, dat.year, dat.month;
```

**Query 3: Peak Hours & Days**

```sql
SELECT 
  EXTRACT(DOW FROM dat.date) as day_of_week,
  EXTRACT(HOUR FROM st.started_at) as hour_of_day,
  COUNT(f.trip_sk) as trip_count,
  AVG(f.fare) as avg_fare
FROM gold_fact_trips f
JOIN gold_dim_date dat ON f.date_sk = dat.date_id
JOIN silver_trips st ON f.trip_id = st.id
WHERE f.status_id = 1
GROUP BY EXTRACT(DOW FROM dat.date), EXTRACT(HOUR FROM st.started_at)
ORDER BY trip_count DESC;
```

---

## 🔥 Full Production Debugging Scenario

**Production Alert (3 AM):** Data warehouse reports zero revenue for past 2 hours. Dashboard frozen.

### Investigation Steps

```sql
-- Step 1: Check gold layer data freshness
SELECT MAX(_dw_created_at) as last_fact_insert FROM gold_fact_trips;
-- Result: 2026-03-13 01:45:00 ← 2 hours old, ETL stopped!

-- Step 2: Check silver layer
SELECT MAX(_ingested_at) as last_silver FROM silver_trips;
-- Result: 2026-03-13 03:42:00 ← Data arriving, but not in gold

-- Step 3: Check ETL job logs
SELECT * FROM etl_logs WHERE process_name = 'silver_to_gold' 
ORDER BY executed_at DESC LIMIT 10;
-- Result: Last job failed at 01:45 with "Memory exceeded"

-- Step 4: Check work_mem and memory usage
SHOW work_mem;  -- 4MB (too small for large INSERT)
SELECT 
  datname,
  SUM(heap_blks_read) as disk_reads,
  SUM(heap_blks_hit) as memory_hits
FROM pg_statio_user_tables
GROUP BY datname;
```

### Root Cause

ETL INSERT INTO gold_fact_trips spilled to disk due to small work_mem.

### Solution

```sql
-- Immediate: Restart ETL with larger work_mem
SET work_mem = '1GB';

-- Catch up: Insert missing 2 hours of data
INSERT INTO gold_fact_trips (trip_id, date_sk, driver_sk, rider_id, fare, distance_km, trip_duration_minutes, status_id)
SELECT 
  t.id,
  TO_CHAR(t.started_at, 'YYYYMMDD')::INT,
  d.driver_sk,
  t.rider_id,
  t.fare,
  t.distance_km,
  EXTRACT(EPOCH FROM (t.completed_at - t.started_at))::INT / 60,
  CASE t.status
    WHEN 'completed' THEN 1
    WHEN 'cancelled' THEN 2
    WHEN 'no_show' THEN 3
    ELSE 4
  END
FROM silver_trips t
JOIN gold_dim_driver d ON t.driver_id = d.driver_id AND d._dw_is_current = TRUE
WHERE t._ingested_at > (SELECT MAX(_dw_created_at) FROM gold_fact_trips)
  AND t._ingested_at <= NOW();

-- Long-term: Update ETL config
-- ALTER DATABASE dwh_production SET work_mem = '1GB';

-- Dashboard refresh: Invalidate cache
DELETE FROM dashboard_cache WHERE table_name = 'gold_fact_trips';
```

---

## ✅ Recap Checklist

- [ ] Understand Bronze/Silver/Gold layering
- [ ] Can design star schema (fact + dimensions)
- [ ] Know SCD Type 1, 2, 3 patterns
- [ ] Can estimate cardinality and plan indexes
- [ ] Completed Final Project 1 (build full DWH)
- [ ] Completed Final Project 2 (EDA queries)
- [ ] Understand billion-row design considerations
- [ ] Can diagnose real ETL failures (memory, timing)
- [ ] Know incremental load patterns
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) – From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** — Please like, subscribe and support the original creator!

---

## 🎓 10-Day Bootcamp Complete!

You've learned:
- **Days 1-3:** SQL fundamentals, JOINs, aggregations
- **Days 4-5:** Window functions, advanced analytics
- **Days 6-7:** Subqueries, CTEs, views, procedures, triggers
- **Day 8:** Indexes, execution plans, cost-based optimization
- **Day 9:** Partitioning, performance at scale, 30 quick wins
- **Day 10:** Data warehouse design, star schema, full production systems

**Next Steps:**
1. Review weak spots from topic tracker
2. Practice LeetCode SQL problems
3. Build projects with real datasets
4. Study advanced topics: replication, distributed SQL, tuning edge cases
5. Interview prep: Explain your DWH design to a peer

---

## 🧭 Navigation

**← [Day 9: Partitions & Performance](./day-09-partitions-performance.md) | [Study Kit →](../study-kit/)**

---

*Last updated: 13 March 2026 | [Bootcamp Home](../README.md)*
