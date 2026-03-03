# 📊 Day 5: Aggregates & Window Functions — Advanced Data Analysis
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) – From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** — Please like, subscribe and support the original creator!

---

## 📊 Quick Stats

| Metric | Value |
|--------|-------|
| **Video Duration** | 3h 12m 29s |
| **Key Terms** | 10 |
| **Lab Exercises** | 5 |
| **Difficulty** | ⭐⭐⭐ Advanced |

---

## 🕐 Daily Schedule

| Time | Activity | Duration | Focus |
|------|----------|----------|-------|
| **09:00–10:30** | Core Theory + Structured Watching | 90 min | GROUP BY, aggregates, window functions |
| **10:30–10:40** | Transition Buffer | 10 min | Rest & notes review |
| **10:40–11:55** | Lab Engineering | 75 min | Progressive aggregate exercises |
| **11:55–12:05** | Transition Buffer | 10 min | Hydrate & reset |
| **12:05–12:35** | Recap Session | 30 min | Consolidate learning |
| **12:35–12:45** | Transition Buffer | 10 min | Mental break |
| **12:45–13:30** | Deep Dive / Engine Thinking | 45 min | Aggregation internals, memory usage |
| **13:30–13:40** | Transition Buffer | 10 min | Prepare for assessment |
| **13:40–14:10** | Quiz + Pressure Simulation | 30 min | Apply knowledge under pressure |

---

## 🎯 Core Focus Topics

### 1. GROUP BY — Organizing Rows into Groups

**GROUP BY** divides rows into groups and applies aggregate functions to each group:

```sql
-- Simple GROUP BY: One group per city
SELECT 
    city,
    COUNT(*) AS driver_count,
    AVG(rating) AS avg_rating
FROM drivers
GROUP BY city;

-- Result:
-- city          | driver_count | avg_rating
-- Los Angeles   | 150          | 4.52
-- New York      | 200          | 4.61
-- San Francisco | 100          | 4.73

-- Multiple columns in GROUP BY: Group by city AND active status
SELECT 
    city,
    is_active,
    COUNT(*) AS driver_count
FROM drivers
GROUP BY city, is_active;

-- GROUP BY without aggregate (rare, returns one row per group)
SELECT city FROM drivers GROUP BY city;
-- Returns one row per distinct city
```

**Key rule:** Every non-aggregated column in SELECT must be in GROUP BY:

```sql
-- WRONG: name not in GROUP BY
SELECT city, name, COUNT(*)  -- Error! name is not aggregated or in GROUP BY
FROM drivers
GROUP BY city;

-- CORRECT: Include name in GROUP BY (if meaningful)
SELECT city, name, COUNT(*) AS driver_count
FROM drivers
GROUP BY city, name;
-- Now each (city, name) combination is a group

-- Or aggregate the name (though this doesn't make semantic sense)
SELECT city, STRING_AGG(DISTINCT name, ', ') AS driver_names, COUNT(*)
FROM drivers
GROUP BY city;
```

---

### 2. HAVING — Filtering Groups (Not Rows)

**HAVING** filters *groups* after aggregation (while WHERE filters *rows* before aggregation):

```sql
-- WHERE filters rows BEFORE grouping
SELECT 
    city,
    COUNT(*) AS driver_count,
    AVG(rating) AS avg_rating
FROM drivers
WHERE rating >= 4.0  -- Filter to 4.0+ rated drivers only
GROUP BY city;

-- HAVING filters groups AFTER aggregation
SELECT 
    city,
    COUNT(*) AS driver_count,
    AVG(rating) AS avg_rating
FROM drivers
GROUP BY city
HAVING COUNT(*) >= 50;  -- Only cities with 50+ drivers

-- Combined: WHERE and HAVING together
SELECT 
    city,
    COUNT(*) AS driver_count,
    AVG(rating) AS avg_rating
FROM drivers
WHERE is_active = true              -- Filter rows first
GROUP BY city
HAVING AVG(rating) >= 4.5           -- Filter groups second
  AND COUNT(*) >= 10;               -- Multiple HAVING conditions

-- Cost breakdown:
-- WHERE: Reduced 100k rows to ~70k active drivers
-- GROUP BY: Aggregated 70k rows into ~20 groups
-- HAVING: Reduced 20 groups to ~8 high-performing cities
```

---

### 3. PARTITION BY — Window Function Grouping

**PARTITION BY** divides rows into windows (like GROUP BY) but keeps all rows (unlike GROUP BY which collapses groups):

```sql
-- GROUP BY: Collapses to one row per group
SELECT city, AVG(rating) FROM drivers GROUP BY city;
-- Result: 8 rows (one per city)

-- PARTITION BY: Keeps all rows, adds window aggregates
SELECT 
    id,
    name,
    city,
    rating,
    AVG(rating) OVER (PARTITION BY city) AS city_avg_rating
FROM drivers;
-- Result: All drivers (100k rows) with city average on each row

-- Window function without PARTITION BY (one window = all rows)
SELECT 
    id,
    name,
    rating,
    AVG(rating) OVER () AS overall_avg_rating,
    rating - (AVG(rating) OVER ()) AS diff_from_avg
FROM drivers;
```

---

### 4. Ranking Functions — ROW_NUMBER, RANK, DENSE_RANK

**Ranking functions** assign numeric ranks to rows within a partition:

```sql
-- ROW_NUMBER: Sequential numbering (1, 2, 3...)
SELECT 
    city,
    name,
    rating,
    ROW_NUMBER() OVER (PARTITION BY city ORDER BY rating DESC) AS rank_in_city
FROM drivers;
-- Result (San Francisco):
-- name        | rating | rank_in_city
-- Alice       | 4.9    | 1
-- Bob         | 4.8    | 2
-- Charlie     | 4.8    | 3  (different from RANK!)
-- David       | 4.7    | 4

-- RANK: Handles ties (skips numbers after ties)
-- Result (same data with RANK):
-- name        | rating | rank
-- Alice       | 4.9    | 1
-- Bob         | 4.8    | 2
-- Charlie     | 4.8    | 2  (tied with Bob!)
-- David       | 4.7    | 4  (skips 3!)

-- DENSE_RANK: Handles ties (doesn't skip numbers)
-- Result (same data with DENSE_RANK):
-- name        | rating | dense_rank
-- Alice       | 4.9    | 1
-- Bob         | 4.8    | 2
-- Charlie     | 4.8    | 2
-- David       | 4.7    | 3  (doesn't skip!)

-- Practical example: Find top 3 drivers per city
WITH ranked_drivers AS (
    SELECT 
        city,
        name,
        rating,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY rating DESC) AS rank
    FROM drivers
)
SELECT * FROM ranked_drivers WHERE rank <= 3;
```

---

### 5. Lead/Lag — Accessing Previous/Next Rows

**LEAD** and **LAG** access data from adjacent rows within a partition:

```sql
-- LAG: Previous row in partition
SELECT 
    driver_id,
    completed_at,
    fare,
    LAG(fare) OVER (PARTITION BY driver_id ORDER BY completed_at) AS prev_fare,
    fare - LAG(fare) OVER (PARTITION BY driver_id ORDER BY completed_at) AS fare_diff
FROM trips
WHERE status = 'completed'
ORDER BY driver_id, completed_at;

-- Result (Driver 1):
-- completed_at      | fare  | prev_fare | fare_diff
-- 2026-03-01 10:00  | 25.00 | NULL      | NULL      (no previous)
-- 2026-03-01 14:00  | 30.00 | 25.00     | 5.00
-- 2026-03-02 09:00  | 28.00 | 30.00     | -2.00

-- LEAD: Next row in partition
SELECT 
    driver_id,
    completed_at,
    fare,
    LEAD(fare) OVER (PARTITION BY driver_id ORDER BY completed_at) AS next_fare
FROM trips
ORDER BY driver_id, completed_at;

-- Practical: Find trips after payment delays
SELECT 
    t1.trip_id,
    t1.fare AS first_fare,
    LEAD(t1.trip_id) OVER (PARTITION BY t1.driver_id ORDER BY t1.completed_at) AS next_trip_id,
    LEAD(t1.fare) OVER (PARTITION BY t1.driver_id ORDER BY t1.completed_at) AS next_fare
FROM trips t1
WHERE t1.status = 'completed';
```

---

### 6. NTILE — Distributing Rows into Buckets

**NTILE(n)** divides rows into n equal buckets (quartiles, deciles, etc.):

```sql
-- Divide all drivers into 4 quartiles by rating
SELECT 
    name,
    rating,
    NTILE(4) OVER (ORDER BY rating) AS quartile
FROM drivers;

-- Result:
-- name    | rating | quartile
-- Alice   | 4.9    | 4  (top 25%)
-- Bob     | 4.8    | 4
-- Charlie | 4.5    | 3  (50-75%)
-- David   | 4.2    | 2  (25-50%)
-- Eve     | 3.8    | 1  (bottom 25%)

-- Practical: Find drivers in top quartile per city
WITH quartiled AS (
    SELECT 
        city,
        name,
        rating,
        NTILE(4) OVER (PARTITION BY city ORDER BY rating) AS city_quartile
    FROM drivers
)
SELECT * FROM quartiled WHERE city_quartile = 4;
```

---

## 📖 10 Terms of the Day

| Term | Definition | Why It Matters |
|------|-----------|---|
| **Aggregate** | Function that combines multiple rows into single value (COUNT, SUM, AVG, MIN, MAX) | Aggregates only work with GROUP BY or window functions |
| **Partition** | Subset of rows (in window functions) grouped by PARTITION BY clause | PARTITION BY divides data without collapsing rows (unlike GROUP BY) |
| **Frame** | Subset of partition (in window functions) defined by ROWS/RANGE clause | Frames enable moving averages and running totals |
| **Rank** | Position in ordered list; RANK handles ties by skipping numbers | RANK(1,2,2,4); useful for rankings with ties |
| **Dense_Rank** | Position in ordered list; DENSE_RANK doesn't skip after ties | DENSE_RANK(1,2,2,3); no gaps in ranking sequence |
| **Row_Number** | Sequential numbering within partition; ignores ties | ROW_NUMBER(1,2,3); treats ties as separate rows |
| **Ntile** | Distributes rows into n equal buckets (quartiles, deciles) | NTILE(4) divides into 4 equal groups |
| **Lead** | Returns value from next row in partition | LAG returns previous row; useful for comparing sequential trips |
| **Lag** | Returns value from previous row in partition | Enables trip-to-trip comparison and change detection |
| **Work_mem** | Memory allocated per operation (sorting, hashing); spills to disk if exceeded | Large aggregates need more work_mem; monitors memory usage |

---

## 🔧 Lab Engineering: Progressive SQL Exercises

### Exercise 1: Easy — Basic GROUP BY with Aggregates

**Task:** Get trip statistics by city: count, average fare, min/max fare.

**Solution:**
```sql
SELECT 
    COALESCE(d.city, 'Unknown') AS city,
    COUNT(t.id) AS trip_count,
    ROUND(AVG(t.fare), 2) AS avg_fare,
    MIN(t.fare) AS min_fare,
    MAX(t.fare) AS max_fare
FROM trips t
LEFT JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
GROUP BY d.city
ORDER BY trip_count DESC;
```

**Learning:** GROUP BY aggregates rows by column. COUNT, AVG, MIN, MAX are common aggregates. COALESCE handles NULLs from left join.

---

### Exercise 2: Medium — HAVING Filters and Multi-Column GROUP BY

**Task:** Find driver-city pairs with 10+ trips and average fare > $30, ranked by completion rate.

**Solution:**
```sql
SELECT 
    d.city,
    d.name,
    COUNT(t.id) AS trip_count,
    ROUND(AVG(t.fare), 2) AS avg_fare,
    ROUND(100.0 * COUNT(CASE WHEN t.status = 'completed' THEN 1 END) 
          / NULLIF(COUNT(t.id), 0), 2) AS completion_rate
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.city, d.name
HAVING COUNT(t.id) >= 10 
  AND AVG(t.fare) > 30.00
ORDER BY completion_rate DESC, trip_count DESC;
```

**Learning:** HAVING filters groups (after aggregation). Multiple columns in GROUP BY create (city, name) groups. NULLIF prevents division by zero.

---

### Exercise 3: Hard — Window Functions with PARTITION BY and RANK

**Task:** Show each driver's trips with percentile rank within their city, and compare to city average.

**Solution:**
```sql
WITH driver_trips AS (
    SELECT 
        d.id,
        d.name,
        d.city,
        t.id AS trip_id,
        t.fare,
        t.completed_at,
        ROW_NUMBER() OVER (PARTITION BY d.id ORDER BY t.completed_at DESC) AS trip_recency_rank,
        PERCENT_RANK() OVER (PARTITION BY d.city ORDER BY t.fare DESC) AS city_fare_percentile,
        AVG(t.fare) OVER (PARTITION BY d.city) AS city_avg_fare
    FROM drivers d
    LEFT JOIN trips t ON d.id = t.driver_id
    WHERE t.status = 'completed'
)
SELECT 
    city,
    name,
    trip_id,
    fare,
    completed_at,
    trip_recency_rank,
    ROUND(city_fare_percentile * 100, 1) AS fare_percentile_in_city,
    ROUND(city_avg_fare, 2) AS city_avg_fare,
    ROUND(fare - city_avg_fare, 2) AS fare_vs_city_avg
FROM driver_trips
ORDER BY city, name, trip_recency_rank
LIMIT 50;
```

**Learning:** Window functions keep all rows (unlike GROUP BY). PARTITION BY creates groups within windows. PERCENT_RANK ranks 0.0–1.0. Multiple window functions in one query combine analyses.

---

### Exercise 4: Challenge — Lead/Lag for Temporal Analysis

**Task:** Analyze trip patterns: consecutive trips per driver, fare changes, and gaps between trips.

**Solution:**
```sql
WITH trip_sequence AS (
    SELECT 
        driver_id,
        id AS trip_id,
        completed_at,
        fare,
        ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY completed_at) AS trip_num,
        LAG(completed_at) OVER (PARTITION BY driver_id ORDER BY completed_at) AS prev_trip_end,
        LAG(fare) OVER (PARTITION BY driver_id ORDER BY completed_at) AS prev_fare,
        LEAD(completed_at) OVER (PARTITION BY driver_id ORDER BY completed_at) AS next_trip_start,
        LEAD(fare) OVER (PARTITION BY driver_id ORDER BY completed_at) AS next_fare,
        EXTRACT(EPOCH FROM (completed_at - LAG(completed_at) OVER (PARTITION BY driver_id ORDER BY completed_at))) / 3600 AS hours_since_last_trip,
        LEAD(fare) OVER (PARTITION BY driver_id ORDER BY completed_at) - fare AS fare_change_to_next
    FROM trips
    WHERE status = 'completed'
)
SELECT 
    driver_id,
    trip_num,
    trip_id,
    TO_CHAR(completed_at, 'YYYY-MM-DD HH:MI') AS trip_time,
    fare,
    ROUND(hours_since_last_trip, 1) AS hours_since_prev,
    ROUND(fare_change_to_next, 2) AS next_fare_change,
    CASE 
        WHEN hours_since_last_trip < 1 THEN 'Back-to-back'
        WHEN hours_since_last_trip < 4 THEN 'Same day'
        WHEN hours_since_last_trip < 24 THEN 'Next day'
        ELSE 'Multi-day gap'
    END AS gap_category
FROM trip_sequence
WHERE driver_id IN (SELECT driver_id FROM trip_sequence GROUP BY driver_id HAVING COUNT(*) >= 5)
ORDER BY driver_id, trip_num;
```

**Learning:** LAG/LEAD enable sequential analysis. EXTRACT(EPOCH FROM ...) converts intervals to seconds. Window functions over time enable temporal pattern detection.

---

### Exercise 5: Stretch — Complex Window Frames and Running Aggregates

**Task:** Calculate 7-day rolling average fare per driver, rank drivers by volatility, show trend direction.

**Solution:**
```sql
WITH daily_stats AS (
    SELECT 
        driver_id,
        DATE(completed_at) AS trip_date,
        AVG(fare) AS daily_avg_fare,
        COUNT(*) AS daily_trip_count,
        SUM(fare) AS daily_total_fare
    FROM trips
    WHERE status = 'completed'
    GROUP BY driver_id, DATE(completed_at)
),
rolling_avg AS (
    SELECT 
        driver_id,
        trip_date,
        daily_avg_fare,
        daily_trip_count,
        daily_total_fare,
        AVG(daily_avg_fare) OVER (
            PARTITION BY driver_id 
            ORDER BY trip_date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_7day_avg,
        STDDEV_POP(daily_avg_fare) OVER (
            PARTITION BY driver_id 
            ORDER BY trip_date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_7day_volatility,
        FIRST_VALUE(daily_avg_fare) OVER (
            PARTITION BY driver_id 
            ORDER BY trip_date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS week_start_fare,
        LAST_VALUE(daily_avg_fare) OVER (
            PARTITION BY driver_id 
            ORDER BY trip_date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS week_end_fare
    FROM daily_stats
)
SELECT 
    d.id,
    d.name,
    ra.trip_date,
    ra.daily_avg_fare,
    ROUND(ra.rolling_7day_avg, 2) AS rolling_7day_avg,
    ROUND(ra.rolling_7day_volatility, 2) AS volatility,
    ROUND((ra.week_end_fare - ra.week_start_fare) / NULLIF(ra.week_start_fare, 0) * 100, 1) AS week_trend_pct,
    RANK() OVER (PARTITION BY ra.trip_date ORDER BY ra.rolling_7day_volatility DESC) AS volatility_rank_daily,
    CASE 
        WHEN ra.week_end_fare > ra.week_start_fare THEN 'Uptrend'
        WHEN ra.week_end_fare < ra.week_start_fare THEN 'Downtrend'
        ELSE 'Flat'
    END AS trend_direction
FROM rolling_avg ra
INNER JOIN drivers d ON ra.driver_id = d.id
WHERE ra.trip_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY d.id, ra.trip_date DESC
LIMIT 100;
```

**Learning:** ROWS frame clause (ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) enables rolling aggregates. FIRST_VALUE/LAST_VALUE extract window boundaries. STDDEV_POP measures volatility. Combining CTEs with complex windows creates powerful analytics.

---

## 🧠 Deep Dive: Aggregation Internals & Memory

### How GROUP BY Works Internally

GROUP BY executes in stages:

```
Stage 1: SORT (or HASH)
┌─────────────────────────────────┐
│ Row: Driver 1, Fare 25          │
│ Row: Driver 2, Fare 30          │
│ Row: Driver 1, Fare 28          │ ─→ Sort by driver_id
│ Row: Driver 3, Fare 20          │
│ Row: Driver 2, Fare 35          │
└─────────────────────────────────┘

Sorted:
Driver 1, 25
Driver 1, 28
Driver 2, 30
Driver 2, 35
Driver 3, 20

Stage 2: AGGREGATE
┌──────────────────────┐
│ Driver 1: [25, 28]   │ → Aggregate: COUNT=2, AVG=26.5
│ Driver 2: [30, 35]   │ → Aggregate: COUNT=2, AVG=32.5
│ Driver 3: [20]       │ → Aggregate: COUNT=1, AVG=20.0
└──────────────────────┘

Result:
Driver 1, 26.5
Driver 2, 32.5
Driver 3, 20.0
```

**Two aggregation strategies:**

1. **Sort-based aggregation** (GroupAggregate)
   - Sorts input by GROUP BY columns
   - Aggregates consecutive rows with same group key
   - Memory: O(1) per group (process one group at a time)
   - I/O: Requires sorting (expensive for large data)

2. **Hash-based aggregation** (HashAggregate)
   - Builds hash table of groups
   - Inserts each row's aggregates into hash
   - Memory: O(n) where n = number of groups
   - I/O: One pass (no sorting needed)

**Example:**
```sql
SELECT driver_id, COUNT(*) FROM trips GROUP BY driver_id;

-- EXPLAIN output (hash aggregation):
-- Hash Aggregate (cost=5000..6000)
--   Group Key: driver_id
--   -> Seq Scan on trips

-- If work_mem is too small, hash spills to disk:
-- ERROR: Hashagg: spilled, 150% of work_mem exceeded
-- Fix: SET work_mem = '256MB'
```

---

### Window Functions Don't Reduce Rows

Window functions are fundamentally different from GROUP BY:

```
GROUP BY:
┌─────────────────────────────┐
│ 100,000 input rows          │
└──────────────────────────────┘
              ↓
      GROUP and AGGREGATE
              ↓
┌─────────────────────────────┐
│ 50 output rows (one per city)│
└─────────────────────────────┘

Window Function:
┌─────────────────────────────┐
│ 100,000 input rows          │
└──────────────────────────────┘
              ↓
   Add window column per row
              ↓
┌─────────────────────────────┐
│ 100,000 output rows (same)  │
│ + new column with window agg│
└─────────────────────────────┘
```

**Memory cost of window functions:**

```sql
-- Simple window function
SELECT 
    driver_id,
    fare,
    AVG(fare) OVER (PARTITION BY driver_id) AS driver_avg
FROM trips;

-- Memory per row: driver_id (8 bytes) + fare (8 bytes) + driver_avg (8 bytes) = 24 bytes
-- 100,000 rows × 24 bytes = 2.4 MB (no intermediate storage needed)

-- Complex window with frame
SELECT 
    driver_id,
    completed_at,
    fare,
    AVG(fare) OVER (
        PARTITION BY driver_id 
        ORDER BY completed_at 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7day_avg
FROM trips;

-- Must buffer frame rows in memory
-- Frame size: ~7 rows per partition
-- Drivers: 1,000
-- Memory: 1,000 drivers × 7 rows × 24 bytes = 168 KB (manageable)

-- Large partition (all rows):
SELECT 
    driver_id,
    fare,
    ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY fare) AS row_num
FROM trips;  -- 100k rows per driver

-- Memory: 100,000 rows × partition × internal structures
-- Can exceed work_mem; causes spill to disk
```

---

### Sorting Cost in Window Functions

Window functions with ORDER BY require sorting (expensive):

```sql
-- Sort required
SELECT 
    driver_id,
    completed_at,
    fare,
    ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY completed_at) AS trip_num
FROM trips;

-- Sorting cost: O(n log n)
-- 100k rows: ~1.66M comparisons
-- Time: ~100ms (significant)

-- No sort needed (if results already ordered)
SELECT 
    driver_id,
    fare,
    AVG(fare) OVER (PARTITION BY driver_id) AS driver_avg
FROM trips;  -- No ORDER BY = no sorting

-- Check EXPLAIN for "Sort" node
EXPLAIN SELECT ... PARTITION BY driver_id ORDER BY completed_at;
-- Output: Sort (cost=10000..12000)
--   Sort Key: driver_id, completed_at
--   -> Seq Scan on trips
```

---

## 🚨 Pressure Scenario: Window Function Causes Memory Spike

### Scenario
Adding a window function to a query causes memory usage to spike, killing the server:

```sql
-- Simple query (fine)
SELECT driver_id, COUNT(*) FROM trips GROUP BY driver_id;
-- Memory: ~50 MB (hash table of ~1000 groups)

-- Add window function (memory explodes!)
SELECT 
    driver_id,
    completed_at,
    fare,
    ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY completed_at) AS trip_num
FROM trips;
-- Memory: ~500 MB (buffering all rows with ordering)
-- Server memory pressure → query killed or other queries slow down
```

### Step-by-Step Diagnosis

**Step 1: Identify memory pressure**
```sql
-- Check work_mem setting
SHOW work_mem;  -- Default: 4MB (too small!)

-- Monitor actual memory usage
SELECT * FROM pg_stat_activity WHERE query LIKE '%ROW_NUMBER%';
-- Look for high memory usage; query might be in "spilling to disk" mode
```

**Step 2: Check EXPLAIN for Sort/Hash operations**
```sql
EXPLAIN SELECT 
    driver_id,
    completed_at,
    fare,
    ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY completed_at) AS trip_num
FROM trips;

-- Output: WindowAgg (cost=50000..60000)
--   -> Sort (cost=50000..60000)  ← Expensive sorting!
--     Sort Key: driver_id, completed_at
--     -> Seq Scan on trips
```

**Step 3: Increase work_mem (if possible)**
```sql
-- Per-session:
SET work_mem = '256MB';  -- Increase buffer

-- Then rerun query (should be faster, uses less disk spill)
```

**Step 4: Consider query redesign**
```sql
-- If window function is unavoidable, ensure PARTITION BY is sargable
-- Bad: Large partitions (all data in one window)
CREATE INDEX idx_trips_driver_completed 
  ON trips(driver_id, completed_at);  -- Helps with partition ordering

-- Check if you can split into smaller windows
SELECT * FROM (
    SELECT driver_id, completed_at, fare,
           ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY completed_at) AS trip_num
    FROM trips
    WHERE completed_at >= CURRENT_DATE - INTERVAL '7 days'  -- Limit window size
) sub
WHERE trip_num <= 100;  -- Only keep recent trips
```

### Solution SQL

```sql
-- Immediate: Increase work_mem
SET work_mem = '512MB';  -- Or more if available

-- Add supporting index
CREATE INDEX idx_trips_driver_completed 
  ON trips(driver_id, completed_at);

-- Verify memory is available
SHOW work_mem;

-- Rerun query
SELECT 
    driver_id,
    completed_at,
    fare,
    ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY completed_at) AS trip_num
FROM trips
WHERE completed_at >= CURRENT_DATE - INTERVAL '30 days';  -- Limit scope

-- If still problematic, redesign query
-- Example: Split into batches
SELECT * FROM (
    SELECT driver_id, completed_at, fare,
           ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY completed_at DESC) AS trip_num
    FROM trips
    WHERE completed_at >= CURRENT_DATE - INTERVAL '7 days'
) sub
WHERE trip_num <= 20;  -- Top 20 recent trips per driver
```

### Lessons Learned
1. **Window functions require memory** for buffering and sorting
2. **ORDER BY in window** forces sorting; O(n log n) complexity
3. **Large partitions** cause memory pressure; limit partition scope if possible
4. **work_mem limits** aggregation buffer; increase if available
5. **Index on (PARTITION BY, ORDER BY) columns** improves performance
6. **EXPLAIN shows memory cost**; look for Sort and WindowAgg nodes

---

## ✅ Recap Checklist

- [ ] Use GROUP BY to aggregate rows; every non-aggregate column must be in GROUP BY
- [ ] Use HAVING to filter groups (after aggregation), not WHERE (before)
- [ ] Understand PARTITION BY creates groups without collapsing rows (unlike GROUP BY)
- [ ] Use ROW_NUMBER for sequential numbering; RANK/DENSE_RANK for ranked positions
- [ ] Use NTILE to distribute rows into equal buckets (quartiles, deciles, etc.)
- [ ] Use LAG/LEAD to compare adjacent rows (previous/next trip)
- [ ] Understand window frame (ROWS BETWEEN) for rolling aggregates
- [ ] Diagnose memory pressure from window functions using EXPLAIN and work_mem
- [ ] Use indexes on (PARTITION BY, ORDER BY) columns for window function performance
- [ ] Recognize when GROUP BY vs window functions is appropriate

---

## 🔗 Navigation

[**← Day 4: Functions, NULL & CASE**](./day-04-functions-null-case.md) | **Day 6:** Coming Soon →

**Repository:** [sql-mastery-bootcamp](https://github.com/your-username/sql-mastery-bootcamp)
