# 🔗 Day 3: Joins — Combining Data from Multiple Tables
**Date:** Thursday, 5 March 2026 | **Video:** 02:47:57 – 04:02:09 | [![YouTube](https://img.shields.io/badge/YouTube-Watch-red?logo=youtube)](https://www.youtube.com/watch?v=SSKVgrwhzus)

---

## 📊 Quick Stats

| Metric | Value |
|--------|-------|
| **Video Duration** | 1h 14m 12s |
| **Key Terms** | 10 |
| **Lab Exercises** | 5 |
| **Difficulty** | ⭐⭐ Intermediate |

---

## 🕐 Daily Schedule

| Time | Activity | Duration | Focus |
|------|----------|----------|-------|
| **09:00–10:30** | Core Theory + Structured Watching | 90 min | Join types, join predicates, cardinality |
| **10:30–10:40** | Transition Buffer | 10 min | Rest & notes review |
| **10:40–11:55** | Lab Engineering | 75 min | Progressive join exercises |
| **11:55–12:05** | Transition Buffer | 10 min | Hydrate & reset |
| **12:05–12:35** | Recap Session | 30 min | Consolidate learning |
| **12:35–12:45** | Transition Buffer | 10 min | Mental break |
| **12:45–13:30** | Deep Dive / Engine Thinking | 45 min | Join algorithms, cardinality estimation |
| **13:30–13:40** | Transition Buffer | 10 min | Prepare for assessment |
| **13:40–14:10** | Quiz + Pressure Simulation | 30 min | Apply knowledge under pressure |

---

## 🎯 Core Focus Topics

### 1. INNER JOIN — Only Matching Rows

An **INNER JOIN** returns rows where the join condition is true *on both sides*. Non-matching rows are discarded.

```sql
-- Simple INNER JOIN
SELECT d.id, d.name, t.id AS trip_id, t.fare
FROM drivers d
INNER JOIN trips t ON d.id = t.driver_id;

-- Result:
-- Only rows where driver exists AND trip exists
-- If driver has no trips → not in result
-- If trip has no driver → not in result

-- Equivalent to:
SELECT d.id, d.name, t.id AS trip_id, t.fare
FROM drivers d, trips t
WHERE d.id = t.driver_id;
```

**Visual:**
```
Drivers:        Trips:
ID | Name       ID | Driver_ID
1  | Alice      101| 1
2  | Bob        102| 1
3  | Charlie    103| 4 (no driver)

INNER JOIN result:
ID | Name       | Trip_ID
1  | Alice      | 101
1  | Alice      | 102
-- Charlie (ID 3) not in result (no matching trip)
-- Trip 103 not in result (driver 4 doesn't exist)
```

**When to use:** When you only care about rows with matches in both tables.

---

### 2. LEFT JOIN — All Rows from Left Table

A **LEFT JOIN** returns *all rows from the left table*, plus matching rows from the right table. Non-matches get NULL.

```sql
-- LEFT JOIN keeps all drivers
SELECT d.id, d.name, t.id AS trip_id, t.fare
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id;

-- Result includes:
-- - All drivers (even those with no trips)
-- - Trips matched to drivers (with NULLs for non-matching drivers)

-- Drivers with no trips appear with NULL trip columns:
-- ID | Name       | Trip_ID | Fare
-- 1  | Alice      | 101     | 25.50
-- 1  | Alice      | 102     | 30.00
-- 2  | Bob        | NULL    | NULL  (no trips)
-- 3  | Charlie    | NULL    | NULL  (no trips)
```

**Visual:**
```
Drivers (left):          Trips (right):
ID | Name              ID | Driver_ID | Fare
1  | Alice             101| 1         | 25.50
2  | Bob               102| 1         | 30.00
3  | Charlie           103| 4         | 15.00

LEFT JOIN result:
ID | Name       | Trip_ID | Fare
1  | Alice      | 101     | 25.50
1  | Alice      | 102     | 30.00
2  | Bob        | NULL    | NULL     (all drivers included)
3  | Charlie    | NULL    | NULL
```

**When to use:** When you want all records from the "main" table, with optional details from a reference table.

---

### 3. RIGHT JOIN — All Rows from Right Table

A **RIGHT JOIN** is the reverse of LEFT JOIN: all rows from the *right* table, with matching rows from the left.

```sql
-- RIGHT JOIN keeps all trips
SELECT d.id, d.name, t.id AS trip_id, t.fare
FROM drivers d
RIGHT JOIN trips t ON d.id = t.driver_id;

-- Result includes:
-- - All trips (even those with missing drivers)
-- - Drivers matched to trips (with NULLs for unmatched trips)

-- Trip 103 (driver 4 doesn't exist):
-- ID | Name    | Trip_ID | Fare
-- 1  | Alice   | 101     | 25.50
-- 1  | Alice   | 102     | 30.00
-- NULL| NULL   | 103     | 15.00  (driver doesn't exist)
```

**Tip:** RIGHT JOIN is rarely used in practice. Rewrite as LEFT JOIN by swapping table order:
```sql
-- Instead of:
SELECT * FROM drivers d RIGHT JOIN trips t ON ...

-- Write (clearer):
SELECT * FROM trips t LEFT JOIN drivers d ON ...
```

---

### 4. FULL OUTER JOIN — All Rows from Both Tables

A **FULL OUTER JOIN** returns *all rows from both tables*. Rows with no match get NULL on the non-matching side.

```sql
-- FULL OUTER JOIN keeps all drivers AND all trips
SELECT 
    COALESCE(d.id, t.driver_id) AS driver_id,
    d.name,
    t.id AS trip_id,
    t.fare
FROM drivers d
FULL OUTER JOIN trips t ON d.id = t.driver_id;

-- Result:
-- ID | Name       | Trip_ID | Fare
-- 1  | Alice      | 101     | 25.50
-- 1  | Alice      | 102     | 30.00
-- 2  | Bob        | NULL    | NULL     (driver with no trips)
-- 3  | Charlie    | NULL    | NULL
-- 4  | NULL       | 103     | 15.00   (trip with no driver)
```

**Visual:**
```
LEFT table (drivers)    RIGHT table (trips)
┌──────────┐           ┌──────────┐
│ A (ID 1) │           │ X (D1)   │
│ B (ID 2) │           │ Y (D1)   │
│ C (ID 3) │           │ Z (D4)   │
└──────────┘           └──────────┘

FULL OUTER JOIN:
A matches X, Y
B matches (nothing)
C matches (nothing)
Z matches (nothing, D4 not in drivers)

Result: A-X, A-Y, B-NULL, C-NULL, NULL-Z
```

**When to use:** When finding records in either table that don't match (outlier detection, data quality checks).

---

### 5. Join Predicates — The Heart of Joins

The **ON clause** defines the join condition. It determines which rows from left and right tables are considered "matching."

```sql
-- Standard join predicate (equality on foreign key)
FROM drivers d
INNER JOIN trips t ON d.id = t.driver_id

-- Complex join predicate (multiple conditions)
FROM drivers d
INNER JOIN trips t ON d.id = t.driver_id 
  AND d.city = t.pickup_city
  AND t.status = 'completed'

-- Non-equality predicate (range join)
FROM trips t
INNER JOIN reviews r ON r.trip_id = t.id 
  AND r.created_at BETWEEN t.completed_at AND t.completed_at + INTERVAL '7 days'
  -- Reviews created within 7 days of trip completion
```

**Key distinction: ON vs WHERE**
```sql
-- ON clause: affects which rows are joined
-- WHERE clause: filters after join

SELECT d.id, d.name, COUNT(t.id) AS trip_count
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id

-- WHERE filters after join (may eliminate drivers if filter is strict)
WHERE t.status = 'completed';
-- This filters out drivers with no completed trips
-- Result: only drivers with at least 1 completed trip

-- Contrast with:
SELECT d.id, d.name, COUNT(t.id) AS trip_count
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id 
  AND t.status = 'completed'  -- Filter in ON clause
WHERE t.status = 'completed' OR t.status IS NULL;
-- Drivers with no completed trips are included
-- Result: all drivers, with trip counts for completed trips only
```

---

### 6. Cartesian Products — The Anti-Pattern

A **Cartesian product** occurs when there's no join condition, resulting in *every* row from the left table matched with *every* row from the right table. It's almost always unintentional.

```sql
-- WRONG: Missing join condition
SELECT d.id, d.name, t.id AS trip_id
FROM drivers d, trips t;
-- Result: |drivers| × |trips| rows (millions if both tables are large!)

-- Example with small tables:
-- Drivers: 3 rows, Trips: 4 rows
-- Result: 3 × 4 = 12 rows (each driver paired with each trip)

-- CORRECT: Include join condition
SELECT d.id, d.name, t.id AS trip_id
FROM drivers d
INNER JOIN trips t ON d.id = t.driver_id;
-- Result: only matching rows
```

**Detecting Cartesian Products:**
```sql
-- If result row count = left_rows × right_rows, you have a Cartesian product
SELECT COUNT(*) FROM drivers;  -- 1,000 rows
SELECT COUNT(*) FROM trips;    -- 10,000 rows

SELECT COUNT(*) FROM drivers d, trips t;
-- Result: 10,000,000 rows ← Cartesian product!

-- Fix: Add ON clause
SELECT COUNT(*) FROM drivers d
INNER JOIN trips t ON d.id = t.driver_id;
-- Result: ~5,000 rows ← reasonable
```

---

## 📖 10 Terms of the Day

| Term | Definition | Why It Matters |
|------|-----------|---|
| **Join Predicate** | ON condition defining which rows match; determines join semantics | Incorrect predicates produce wrong results; ON vs WHERE distinction is crucial |
| **Cardinality** | Number of rows a table has; also refers to ratio of distinct values | High cardinality = many distinct values; affects join strategy (hash vs nested loop) |
| **Nested Loop Join** | Algorithm: outer loop through left table, inner loop searches right table for matches | Simple but slow on large tables; O(n × m) comparisons |
| **Hash Join** | Algorithm: hash left table values, then probe right table; O(n + m) | Fast for large tables; requires hash match on join column |
| **Merge Join** | Algorithm: both tables sorted, then merged; O(n + m) | Efficient if tables already sorted; useful with ORDER BY |
| **Driving Table** | Left table in join (scanned first); determines join direction | Choosing small driving table can improve performance |
| **Inner Table** | Right table in join (scanned for matches); searched once per outer row | If using Nested Loop, inner table is searched many times |
| **Fanout** | Number of matching rows in right table for each left row | High fanout = many duplicates in result; affects result size |
| **Cross Join** | Cartesian product of two tables; intentional (rare) or accidental (bug) | Every left row matched with every right row; usually unintended |
| **Selectivity** | Fraction of rows that match a condition (0.0 = none, 1.0 = all) | Low selectivity on join predicate = few matches; affects cardinality |

---

## 🔧 Lab Engineering: Progressive SQL Exercises

### Exercise 1: Easy — Simple INNER JOIN

**Task:** Get all completed trips with driver names and rider names.

**Solution:**
```sql
SELECT 
    t.id AS trip_id,
    d.name AS driver_name,
    r.name AS rider_name,
    t.fare,
    t.completed_at
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
INNER JOIN riders r ON t.rider_id = r.id
WHERE t.status = 'completed'
ORDER BY t.completed_at DESC;
```

**Learning:** Two sequential INNER JOINs filter to only completed trips with existing drivers and riders.

---

### Exercise 2: Medium — LEFT JOIN with NULL Handling

**Task:** List all drivers with their trip count (including drivers with no trips yet).

**Solution:**
```sql
SELECT 
    d.id,
    d.name,
    d.city,
    COUNT(t.id) AS trip_count,
    MAX(t.completed_at) AS last_trip
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id, d.name, d.city
ORDER BY trip_count DESC;
```

**Learning:** LEFT JOIN keeps all drivers. COUNT(t.id) counts non-NULL trips (0 for drivers with no trips). NULL last_trip for inactive drivers.

---

### Exercise 3: Hard — Complex Join with Multiple Predicates

**Task:** Find drivers who completed high-value trips (>$50) in their own city, with payment confirmation within 1 hour.

**Solution:**
```sql
SELECT 
    d.id,
    d.name,
    d.city,
    t.id AS trip_id,
    t.fare,
    p.amount,
    (p.paid_at - t.completed_at) AS payment_delay
FROM drivers d
INNER JOIN trips t 
    ON d.id = t.driver_id 
    AND t.fare > 50.00
    AND t.status = 'completed'
    AND t.pickup_location LIKE '%' || d.city || '%'
INNER JOIN payments p 
    ON t.id = p.trip_id
    AND p.paid_at <= t.completed_at + INTERVAL '1 hour'
ORDER BY t.fare DESC;
```

**Learning:** Multiple conditions in ON clause filter before join. Complex predicates are more efficient in ON than WHERE.

---

### Exercise 4: Challenge — FULL OUTER JOIN for Data Quality

**Task:** Find data integrity issues: trips with no driver, drivers with trips no longer in system, and summarize by city.

**Solution:**
```sql
SELECT 
    COALESCE(d.city, 'UNKNOWN') AS city,
    COUNT(CASE WHEN d.id IS NOT NULL AND t.id IS NOT NULL THEN 1 END) 
        AS valid_trips,
    COUNT(CASE WHEN d.id IS NULL THEN 1 END) 
        AS orphaned_trips,
    COUNT(CASE WHEN t.id IS NULL THEN 1 END) 
        AS inactive_drivers
FROM drivers d
FULL OUTER JOIN trips t ON d.id = t.driver_id
GROUP BY COALESCE(d.city, 'UNKNOWN')
HAVING COUNT(CASE WHEN d.id IS NULL THEN 1 END) > 0
    OR COUNT(CASE WHEN t.id IS NULL THEN 1 END) > 0
ORDER BY city;
```

**Learning:** FULL OUTER JOIN reveals both types of data quality issues. COALESCE handles NULL cities from missing drivers.

---

### Exercise 5: Stretch — Multi-Table Join with Window Functions & Analytics

**Task:** Find drivers in each city with their percentile ranking (by avg rating), trip velocity (trips/day), and comparison to city average.

**Solution:**
```sql
WITH driver_stats AS (
    SELECT 
        d.id,
        d.name,
        d.city,
        d.rating,
        COUNT(t.id) AS trip_count,
        ROUND(COUNT(t.id)::NUMERIC / 
              NULLIF(DATE_PART('day', NOW() - d.created_at), 0), 2) 
            AS trips_per_day,
        AVG(t.fare) AS avg_fare,
        COUNT(DISTINCT r.id) AS unique_reviewers
    FROM drivers d
    LEFT JOIN trips t ON d.id = t.driver_id 
        AND t.status = 'completed'
    LEFT JOIN reviews r ON t.id = r.trip_id
    GROUP BY d.id, d.name, d.city, d.rating
),
city_avg AS (
    SELECT 
        city,
        AVG(rating) AS city_avg_rating,
        AVG(trips_per_day) AS city_avg_velocity
    FROM driver_stats
    GROUP BY city
)
SELECT 
    ds.id,
    ds.name,
    ds.city,
    ds.rating,
    ds.trips_per_day,
    PERCENT_RANK() OVER (PARTITION BY ds.city ORDER BY ds.rating) 
        AS rating_percentile,
    ds.avg_fare,
    ROUND(ds.rating - ca.city_avg_rating, 2) AS rating_diff_from_city_avg,
    ROUND(ds.trips_per_day - ca.city_avg_velocity, 2) AS velocity_diff_from_city_avg
FROM driver_stats ds
INNER JOIN city_avg ca ON ds.city = ca.city
ORDER BY ds.city, ds.rating DESC;
```

**Learning:** CTEs organize complex multi-join logic. Window functions (PERCENT_RANK) compute within partitions. NULLIF prevents division by zero.

---

## 🧠 Deep Dive: Join Algorithms & Cardinality

### Nested Loop Join — The Simple but Slow Algorithm

**Nested Loop Join** scans the outer table once, and for each row, scans the inner table.

```
Algorithm:
FOR each row in left_table:
    FOR each row in right_table:
        IF join_condition matches:
            output row

Cost: O(n × m)
Time: 1 + n*m disk reads (n = left rows, m = right rows)
```

**Example:**
```
Drivers: 1,000 rows
Trips: 100,000 rows

Nested Loop cost:
- Scan drivers table: 1 pass
- For each driver (1,000): scan trips table (100,000)
- Total scans: 1 + (1,000 × 100,000) = 100,000,001 row comparisons

Time: ~1 hour (extremely slow!)
```

**When Nested Loop is acceptable:**
```sql
-- Small driving table (< 100 rows)
SELECT * FROM sessions s
INNER JOIN users u ON s.user_id = u.id
WHERE s.id IN (1, 2, 3, ...);  -- Only 10 sessions

-- Cost: 10 × n (n = users table rows)
-- Acceptable because left table is tiny
```

**Visual:**
```
Left (Drivers):           Right (Trips):
ID=1 ────────────────→ Search for Driver 1 trips
                       → Found: 2 trips
ID=2 ────────────────→ Search for Driver 2 trips
                       → Found: 0 trips
ID=3 ────────────────→ Search for Driver 3 trips
                       → Found: 5 trips
...
```

---

### Hash Join — The Fast Algorithm for Large Tables

**Hash Join** builds a hash table from one table, then probes it with rows from the other.

```
Algorithm:
1. Build phase: Hash all values in right_table on join column
2. Probe phase: For each row in left_table, lookup its hash value

Cost: O(n + m)
Time: 2 passes (build right table hash, then scan left)
```

**Example:**
```
Drivers: 1,000 rows
Trips: 100,000 rows

Hash Join cost:
1. Build hash table from trips.driver_id: 100,000 reads
2. Scan drivers and probe hash: 1,000 reads
Total: 101,000 reads (not 100 million!)

Time: ~0.1 seconds (massively faster!)
```

**Hash Join Requirements:**
- Join column must be **hashable** (most types are)
- Enough **memory** to hold hash table
- If hash table exceeds work_mem, spills to disk (slower)

**Example:**
```
Step 1 (Build):
trips table: driver_id → hash values
Hash Table:
1 → [Trip 101, Trip 102, ...]
2 → [Trip 103, ...]
3 → [Trip 104, ...]

Step 2 (Probe):
drivers table: ID=1 → lookup hash(1) → [Trip 101, Trip 102]
               ID=2 → lookup hash(2) → [Trip 103]
               ID=3 → lookup hash(3) → [Trip 104]
```

---

### Merge Join — Sorted Access

**Merge Join** works on pre-sorted tables, eliminating need for hashing or nested loops.

```
Algorithm:
1. Both tables must be sorted on join column
2. Scan both simultaneously, merging matches

Cost: O(n + m) if sorted, or O(n log n + m log m) if sorting needed
Time: Fast if tables already sorted; sorting cost dominates otherwise
```

**When Merge Join is optimal:**
```sql
-- If trips table is already sorted by driver_id
CREATE INDEX idx_trips_driver ON trips(driver_id);

SELECT * FROM drivers d
INNER JOIN trips t ON d.id = t.driver_id
ORDER BY d.id;

-- Merge Join can output sorted results directly
```

---

### Cardinality — Predicting Join Size

**Cardinality** is the number of rows; understanding it helps predict join output.

```sql
-- Left table: 1,000 drivers
-- Right table: 100,000 trips
-- Assumption: each driver has ~10 trips on average

-- Cardinality of join result:
-- 1,000 drivers × 10 trips/driver = 10,000 rows (the fanout)

-- If one driver has 1,000 trips (high fanout):
-- Result might be larger than expected (unexpected row explosion)

-- Use EXPLAIN to see actual cardinality:
EXPLAIN SELECT * FROM drivers d
INNER JOIN trips t ON d.id = t.driver_id;

-- Output: "... rows=10000"
-- If actual rows >> 10000, high fanout is likely
```

---

### Selectivity — Filtering Impact

**Selectivity** measures what fraction of rows match a condition.

```sql
-- High selectivity (few matches):
WHERE driver_id = 1  -- Only 1 driver, returns ~10 rows
Selectivity: 10 / 100,000 = 0.0001 (0.01%)

-- Low selectivity (many matches):
WHERE status = 'completed'  -- 50% of all trips
Selectivity: 50,000 / 100,000 = 0.5 (50%)

-- Join selectivity:
SELECT * FROM drivers d
INNER JOIN trips t ON d.id = t.driver_id
WHERE t.fare > 50;  -- Only high-fare trips

Selectivity of WHERE: 20% of trips
Result: 1,000 × 100,000 × 0.2 = 20,000 rows
```

---

## 🚨 Pressure Scenario: Join Suddenly 100x Slower After Data Growth

### Scenario
A previously fast join query degrades when the trips table grows:

```sql
-- Was fast (10 ms) with 10k trips
SELECT d.id, d.name, COUNT(t.id) AS trip_count
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id, d.name;

-- Now slow (1000 ms) with 10M trips
-- Query logic unchanged, but performance collapsed
```

### Step-by-Step Diagnosis

**Step 1: Check the query plan**
```sql
EXPLAIN ANALYZE SELECT d.id, d.name, COUNT(t.id) AS trip_count
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id, d.name;

-- Output (good): Hash Join (cost 100..200)
-- Output (bad): Nested Loop Join (cost 100..5000000)
-- ↑ Nested Loop on 10M trips = disaster!
```

**Step 2: Check if statistics are stale**
```sql
-- Table grew but stats weren't updated
ANALYZE trips;  -- Update table statistics

-- Rerun EXPLAIN ANALYZE
-- If plan changes to Hash Join, problem solved
```

**Step 3: Check for missing index on join column**
```sql
-- If no index on trips.driver_id, Nested Loop is chosen
CREATE INDEX idx_trips_driver_id ON trips(driver_id);

-- Rerun query (may still use Hash Join, but index helps)
```

**Step 4: Check work_mem**
```sql
-- If work_mem is too small, Hash Join can't allocate enough memory
SHOW work_mem;  -- Default: 4MB (too small for 10M rows hash table)

-- Set larger work_mem for this session
SET work_mem = '256MB';

EXPLAIN ANALYZE SELECT ...;
-- Hash Join might kick in with more memory available
```

### Solution SQL

```sql
-- Immediate: Update statistics and set work_mem
ANALYZE trips;
SET work_mem = '256MB';

-- Create index on join column (if missing)
CREATE INDEX idx_trips_driver_id ON trips(driver_id);

-- Verify plan changed to Hash Join
EXPLAIN ANALYZE SELECT d.id, d.name, COUNT(t.id) AS trip_count
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id, d.name;
-- Should show "Hash Join" instead of "Nested Loop"

-- Long-term: Adjust work_mem in postgresql.conf
-- shared_buffers = 25% of RAM
-- work_mem = (total RAM / max_connections) / 4
```

### Lessons Learned
1. **Join algorithm choice depends on table size and statistics**
2. **Stale statistics** cause planner to choose slow algorithms (Nested Loop)
3. **Index on join column** helps optimizer make better decisions
4. **work_mem limits hash table size**; larger work_mem enables Hash Join
5. **EXPLAIN ANALYZE** reveals which join algorithm is used; compare before/after optimization

---

## ✅ Recap Checklist

- [ ] Explain INNER JOIN (returns only matching rows)
- [ ] Explain LEFT JOIN (all left rows + matching right rows)
- [ ] Explain FULL OUTER JOIN (all rows from both tables)
- [ ] Distinguish ON clause (join condition) from WHERE clause (row filter)
- [ ] Recognize and avoid Cartesian products
- [ ] Understand join predicate and how it affects result
- [ ] Define cardinality and fanout (duplicate rows in result)
- [ ] Explain Nested Loop Join algorithm and when it's slow
- [ ] Explain Hash Join algorithm and why it's faster on large tables
- [ ] Diagnose slow joins using EXPLAIN and fix with indexes or statistics

---

## 🔗 Navigation

[**← Day 2: DDL, DML & Filtering**](./day-02-ddl-dml-filtering.md) | [**Day 4: Functions, NULL & CASE**](./day-04-functions-null-case.md) →

**Repository:** [sql-mastery-bootcamp](https://github.com/your-username/sql-mastery-bootcamp)
