# 🏭 Case Study Workbook

10 real-world production case studies using the Uber ride-sharing database. Each case teaches a critical lesson about SQL performance, design, or debugging.

---

## How to Use This Workbook

1. **Read Scenario:** Understand the business problem
2. **Study Tables:** Review schema relevant to the case
3. **Answer Investigation Questions:** Think before reading diagnosis
4. **Review Diagnosis:** Understand root cause
5. **Study Solution SQL:** Learn the fix
6. **Apply Lessons:** Implement prevention checklist

---

# CASE STUDY 1: Slow Primary Key Lookup

## Scenario
A support analyst reports that searching for a specific trip by ID takes 15+ seconds, but the query looks simple: `SELECT * FROM trips WHERE id = 123456`.

## Problem Statement
The trip table has 50 million rows. Direct PK lookup should be instant (<10ms), but it's timing out.

## Table Definition
```sql
CREATE TABLE trips (
  id SERIAL PRIMARY KEY,
  driver_id INT NOT NULL,
  rider_id INT NOT NULL,
  pickup_location VARCHAR(255),
  dropoff_location VARCHAR(255),
  fare DECIMAL(10,2),
  distance_km DECIMAL(6,2),
  duration_minutes INT,
  status VARCHAR(20),
  requested_at TIMESTAMPTZ,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ
);
```

## Investigation Questions

1. Why would a primary key lookup be slow if PK guarantees fast access?
2. What EXPLAIN ANALYZE output would indicate the problem?
3. What could cause a sequential scan instead of index lookup?
4. How would you diagnose if the index itself is corrupted?

## Diagnosis

**Root Causes (in order of likelihood):**

1. **Index Not Created:** PK constraint doesn't auto-create index in all cases
2. **Index Corrupted:** Index exists but is damaged or inconsistent
3. **Statistics Stale:** Optimizer thinks full scan cheaper than index
4. **Table Bloat:** Dead rows from heavy deletes; sequential scan picks them all up
5. **Wrong Data Type:** Comparing INT id to VARCHAR '123456' forces conversion

**EXPLAIN ANALYZE Output (Problem):**
```
Seq Scan on trips (cost=0.00..2500000.00 rows=1) (actual time=15000.00..15000.00 rows=1)
  Filter: (id = 123456)
```
Sequential scan = performance problem for 50M rows.

**EXPLAIN ANALYZE Output (Expected):**
```
Index Scan using trips_pkey on trips (cost=0.14..8.16 rows=1) (actual time=0.05..0.10 rows=1)
  Index Cond: (id = 123456)
```
Index scan = instant; <1ms.

## Solution SQL

```sql
-- Step 1: Verify primary key exists
SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'trips' AND constraint_type = 'PRIMARY KEY';

-- Step 2: Check if index exists
SELECT indexname FROM pg_indexes WHERE tablename = 'trips' AND indexname LIKE '%pkey%';

-- Step 3: If missing, create index on primary key
CREATE INDEX trips_pkey ON trips (id);

-- Step 4: Analyze table to update statistics
ANALYZE trips;

-- Step 5: Run EXPLAIN ANALYZE to verify fix
EXPLAIN ANALYZE SELECT * FROM trips WHERE id = 123456;

-- Step 6: If index scan still not chosen, check for table bloat
VACUUM FULL trips;  -- Reclaim space from dead rows
ANALYZE trips;

-- Step 7: Re-test
EXPLAIN ANALYZE SELECT * FROM trips WHERE id = 123456;
```

## Lessons Learned

- **PRIMARY KEY constraint ≠ automatic index** in some databases; verify index created
- **Statistics matter:** `ANALYZE` tells optimizer table size, dead rows, selectivity
- **Table bloat grows with age:** Heavy deletes leave dead rows; VACUUM reclaims space
- **Always verify with EXPLAIN ANALYZE** before and after optimization

## Prevention Checklist

- [ ] Explicitly create index: `CREATE INDEX ON trips (id)` even if PK exists
- [ ] Schedule regular `VACUUM` and `ANALYZE` (nightly or hourly for high-volume tables)
- [ ] Monitor index bloat: `SELECT * FROM pg_stat_user_indexes WHERE idx_blks_read > threshold`
- [ ] Test PKLookups during load testing; don't assume they're fast
- [ ] Alert on query performance regression (>2x slower than baseline)

---

# CASE STUDY 2: Table Bloat After Mass Delete

## Scenario
Nightly cleanup job deletes 10 million old cancelled trips. Next morning, full table scan queries are slow even though data is smaller.

## Problem Statement
Deleted rows are marked as "dead" but space is not reclaimed. Table file size stays same; sequential scan reads dead + live rows.

## Table Definition
```sql
CREATE TABLE trips (
  id SERIAL PRIMARY KEY,
  driver_id INT, rider_id INT, fare DECIMAL(10,2),
  status VARCHAR(20), created_at TIMESTAMPTZ, ...
);

CREATE INDEX idx_trips_status ON trips(status);
CREATE INDEX idx_trips_created ON trips(created_at);
```

## Investigation Questions

1. Why does deleting data not free space?
2. What is table "bloat"?
3. How does bloat affect sequential scans?
4. What's the difference between `DELETE` and `TRUNCATE`?

## Diagnosis

**Root Cause:** PostgreSQL uses MVCC (Multi-Version Concurrency Control). Deleted rows marked as dead but storage not freed until `VACUUM` runs.

**Problem Symptoms:**
- Table file size unchanged after massive delete
- Sequential scans slow (read live + dead rows)
- Indexes also bloated (index entries for dead rows)

**Why Bloat Matters:**
- 10M deleted rows out of 50M = 20% of scan is wasted reading dead rows
- Sequential scan cost increases; optimizer less likely to use index
- Disk I/O increases unnecessarily

## Solution SQL

```sql
-- Step 1: Check table and index bloat
SELECT schemaname, tablename, round(pg_total_relation_size(schemaname||'.'||tablename) / 1024 / 1024) as size_mb
FROM pg_tables
WHERE tablename = 'trips';

-- Step 2: Delete old records (the original operation)
DELETE FROM trips WHERE status = 'cancelled' AND created_at < '2024-01-01';

-- Step 3: Reclaim space with VACUUM
VACUUM trips;  -- Removes dead rows
ANALYZE trips;  -- Updates statistics

-- OR use VACUUM FULL for aggressive reclamation (locks table)
VACUUM FULL trips;  -- Must lock table; use during maintenance window

-- Step 4: Reindex to compact indexes
REINDEX TABLE trips;

-- Step 5: Verify space reclaimed
SELECT schemaname, tablename, round(pg_total_relation_size(schemaname||'.'||tablename) / 1024 / 1024) as size_mb
FROM pg_tables
WHERE tablename = 'trips';

-- Step 6: Verify query performance restored
EXPLAIN ANALYZE SELECT * FROM trips WHERE status = 'completed' LIMIT 1000;
```

## Lessons Learned

- **DELETE doesn't free space immediately:** Use VACUUM to reclaim
- **TRUNCATE is faster for clearing table:** Minimal logging; immediate space reclaim
- **Table bloat degrades performance:** Monitor and vacuum regularly
- **Batch deletions wisely:** Delete in chunks to avoid holding too many locks

## Prevention Checklist

- [ ] Schedule `VACUUM ANALYZE` nightly on high-volume tables
- [ ] Use `TRUNCATE` instead of `DELETE FROM table` when clearing entire table
- [ ] Monitor table bloat: `SELECT * FROM pg_stat_user_tables WHERE dead_tuples > live_tuples`
- [ ] Set `autovacuum` parameters appropriately for your table size
- [ ] For large deletes, do in batches: `DELETE FROM trips LIMIT 10000` in loop

---

# CASE STUDY 3: JOIN Regression Mystery

## Scenario
A report query joins `trips`, `drivers`, and `reviews` tables. It ran in 2 seconds last week, now takes 40 seconds. No schema changes. Data size unchanged.

## Problem Statement
Unexplained query regression; query plan must have changed.

## Table Definitions
```sql
CREATE TABLE drivers (id SERIAL PK, name VARCHAR, rating DECIMAL(3,2), ...);
CREATE TABLE trips (id SERIAL PK, driver_id INT FK, ..., created_at TIMESTAMPTZ);
CREATE TABLE reviews (id SERIAL PK, trip_id INT FK, reviewee_id INT, rating INT, ...);

CREATE INDEX idx_trips_driver_id ON trips(driver_id);
CREATE INDEX idx_reviews_trip_id ON reviews(trip_id);
```

## Investigation Questions

1. What changed to cause 20x slowdown?
2. How would you compare before/after query plans?
3. What could cause optimizer to choose worse plan?
4. How do you fix without changing query?

## Diagnosis

**Possible Causes:**
1. **Statistics stale:** Optimizer thinks table sizes different than reality
2. **Index corruption:** Index used but degraded performance
3. **Missing index:** New data pattern not supported by indexes
4. **Parameter changes:** Database settings changed (work_mem, random_page_cost)
5. **Query plan regression:** Optimizer chose different (suboptimal) join order

**Investigation Steps:**
```sql
-- Run EXPLAIN ANALYZE on the slow query
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT d.id, d.name, t.id, COUNT(r.id) as review_count
FROM drivers d
JOIN trips t ON d.id = t.driver_id
LEFT JOIN reviews r ON t.id = r.trip_id
WHERE t.created_at > '2024-01-01'
GROUP BY d.id, d.name;

-- Check statistics freshness
SELECT schemaname, tablename, last_vacuum, last_autovacuum, last_analyze
FROM pg_stat_user_tables
WHERE tablename IN ('drivers', 'trips', 'reviews');

-- Look for missing indexes on join columns
SELECT * FROM pg_stat_user_indexes
WHERE schemaname = 'public' AND idx_scan = 0;
```

## Solution SQL

```sql
-- Step 1: Update statistics (most common fix)
ANALYZE drivers;
ANALYZE trips;
ANALYZE reviews;

-- Step 2: Re-run EXPLAIN ANALYZE to check plan
EXPLAIN (ANALYZE, BUFFERS)
SELECT d.id, d.name, t.id, COUNT(r.id) as review_count
FROM drivers d
JOIN trips t ON d.id = t.driver_id
LEFT JOIN reviews r ON t.id = r.trip_id
WHERE t.created_at > '2024-01-01'
GROUP BY d.id, d.name;

-- Step 3: If still slow, check join order (hint to optimizer)
-- Rewrite with explicit JOIN order if needed
EXPLAIN (ANALYZE, BUFFERS)
SELECT /*+ BitmapScan(t) */ d.id, d.name, t.id, COUNT(r.id) as review_count
FROM drivers d
JOIN trips t ON d.id = t.driver_id
JOIN reviews r ON t.id = r.trip_id
WHERE t.created_at > '2024-01-01'
GROUP BY d.id, d.name;

-- Step 4: If that works, the issue was optimizer mischoosing join order
-- Solution: add more selective index or explicit hints

-- Step 5: Verify fix
-- Save execution time and run nightly ANALYZE to prevent recurrence
```

## Lessons Learned

- **Statistics drive optimizer decisions:** Stale stats cause bad plans
- **EXPLAIN ANALYZE is your debugging tool:** Always compare before/after
- **Small data changes can cause big plan changes:** Selectivity matters
- **Regular ANALYZE prevents regressions:** Schedule daily on production

## Prevention Checklist

- [ ] Run daily `ANALYZE` on tables with frequent data changes
- [ ] Monitor slow query logs for regressions (>2x baseline)
- [ ] Save baseline EXPLAIN ANALYZE output for critical queries
- [ ] Alert when statistics not updated for >24 hours
- [ ] Test query plans with realistic data volumes during development

---

# CASE STUDY 4: Index Ignored by Optimizer

## Scenario
You create an index on a frequently queried column, but EXPLAIN shows the optimizer still chooses sequential scan instead of the new index.

## Problem Statement
`WHERE city = 'Johannesburg'` should use index on `city`, but sequential scan chosen.

## Table Definition
```sql
CREATE TABLE drivers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  city VARCHAR(50),
  rating DECIMAL(3,2),
  is_active BOOLEAN,
  created_at TIMESTAMPTZ
);

-- Index created:
CREATE INDEX idx_drivers_city ON drivers(city);
```

## Investigation Questions

1. When does optimizer choose to ignore an index?
2. What is "index selectivity"?
3. When is sequential scan actually faster?
4. How do you force index usage if optimizer is wrong?

## Diagnosis

**Root Causes (in order):**

1. **Low selectivity:** `city = 'Johannesburg'` matches 30% of rows (not selective enough for index)
2. **Statistics stale:** Optimizer thinks city matches 90% of rows (too many for index)
3. **Wrong index type:** Hash index can't do range queries; B-Tree can
4. **Cost configuration:** `random_page_cost` set wrong; sequential scan looks cheaper
5. **Table too small:** For small tables (<10K rows), sequential scan faster than index

**Investigation:**
```sql
-- Check selectivity
SELECT city, COUNT(*) as count, 
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM drivers), 2) as pct
FROM drivers
GROUP BY city
ORDER BY pct DESC;
-- If 'Johannesburg' > 5%, sequential scan might be chosen

-- Check index statistics
SELECT indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
WHERE indexname = 'idx_drivers_city';
-- 0 scans = index not being used

-- Run EXPLAIN with index hint
EXPLAIN SELECT * FROM drivers WHERE city = 'Johannesburg';
```

## Solution SQL

```sql
-- Step 1: Update statistics
ANALYZE drivers;

-- Step 2: Re-check EXPLAIN
EXPLAIN SELECT * FROM drivers WHERE city = 'Johannesburg';

-- Step 3: If sequential scan still chosen (and selectivity is high), 
-- force index with index hint (PostgreSQL syntax):
SET enable_seqscan = off;
EXPLAIN SELECT * FROM drivers WHERE city = 'Johannesburg';
SET enable_seqscan = on;  -- Restore to normal

-- Step 4: If forcing index doesn't help, it's a selectivity issue
-- Solution: Create partial index on most-searched city
CREATE INDEX idx_drivers_jozi ON drivers(id) 
WHERE city = 'Johannesburg' AND is_active = true;

-- Step 5: Use the partial index
EXPLAIN SELECT * FROM drivers WHERE city = 'Johannesburg' AND is_active = true;

-- Step 6: For very low selectivity, add covering index
CREATE INDEX idx_drivers_city_cover ON drivers(city) INCLUDE (id, name, rating);

-- Step 7: Verify index is now used
EXPLAIN SELECT id, name, rating FROM drivers WHERE city = 'Johannesburg';
```

## Lessons Learned

- **Index selectivity threshold ~5%:** Below this, sequential scan often faster
- **Partial indexes useful for filtered queries:** Only index rows you frequently search
- **Covering indexes avoid table lookup:** Include columns in index to cover full query
- **Statistics impact selectivity estimation:** Stale stats cause bad index choices

## Prevention Checklist

- [ ] Check selectivity before creating index: >5% rows = index candidate
- [ ] Use `ANALYZE` before expecting index usage
- [ ] Create partial indexes for filtered WHERE clauses
- [ ] Create covering indexes if query only needs indexed columns
- [ ] Monitor index usage: `idx_scan > 0` means index is working
- [ ] Drop unused indexes (0 scans over 1 week) to improve write performance

---

# CASE STUDY 5: Memory Spike from Window Function

## Scenario
A report query using window functions suddenly causes memory spike and out-of-memory error. Query computes running totals for driver earnings by month.

## Problem Statement
Window function with large frame size requires buffering many rows in memory.

## Query
```sql
SELECT driver_id, earned_at, net_amount,
  SUM(net_amount) OVER (
    PARTITION BY driver_id 
    ORDER BY earned_at 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) as running_total
FROM driver_earnings
WHERE earned_at >= '2020-01-01'
ORDER BY driver_id, earned_at;
```

## Investigation Questions

1. Why does window function with UNBOUNDED PRECEDING cause memory issues?
2. What frame size is safe?
3. How do you optimize window functions for large datasets?
4. When should you use materialized views instead?

## Diagnosis

**Root Cause:** Window frame `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` requires keeping all preceding rows in memory for each partition. With 3 years of daily data, driver partitions can have 1000+ rows; millions across all drivers.

**Problem:** Default `work_mem` (4MB) insufficient; spills to disk; causes slowness then OOM.

## Solution SQL

```sql
-- Step 1: Check available memory
SELECT setting FROM pg_settings WHERE name = 'work_mem';

-- Step 2: Increase work_mem for this session (if possible)
SET work_mem = '256MB';

-- Step 3: Optimize window function query
SELECT driver_id, earned_at, net_amount,
  SUM(net_amount) OVER (
    PARTITION BY driver_id 
    ORDER BY earned_at 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) as running_total
FROM driver_earnings
WHERE earned_at >= '2024-01-01'  -- Narrow date range
ORDER BY driver_id, earned_at;

-- Step 4: Or use materialized view for historical data
CREATE MATERIALIZED VIEW driver_earnings_running_total AS
SELECT driver_id, earned_at, net_amount,
  SUM(net_amount) OVER (
    PARTITION BY driver_id 
    ORDER BY earned_at 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) as running_total
FROM driver_earnings
WHERE earned_at >= '2020-01-01';

-- Step 5: Index the materialized view for fast queries
CREATE INDEX idx_earnings_running_driver_date 
ON driver_earnings_running_total(driver_id, earned_at);

-- Step 6: Query materialized view instead (instant response)
SELECT * FROM driver_earnings_running_total 
WHERE driver_id = 5 AND earned_at >= '2024-01-01';

-- Step 7: Refresh materialized view nightly
REFRESH MATERIALIZED VIEW driver_earnings_running_total;
```

## Lessons Learned

- **UNBOUNDED frames = memory intensive:** Keep frame size bounded when possible
- **Materialized views solve repetitive window calculations:** Pre-compute, refresh nightly
- **work_mem limits window function memory:** Increase for large aggregations
- **Narrow date ranges reduce memory:** Filter in WHERE, not window frame

## Prevention Checklist

- [ ] Test window functions with representative data volume
- [ ] Use bounded frames: `ROWS BETWEEN 100 PRECEDING AND CURRENT ROW`
- [ ] Monitor memory usage during window function queries
- [ ] Use materialized views for frequently-accessed running totals
- [ ] Schedule nightly refresh of materialized views

---

# CASE STUDY 6: CTE Trap - Materialization vs Inlining

## Scenario
Developer creates a CTE for code readability, but query suddenly becomes slow. Same logic in subquery version runs instantly.

## Problem Statement
CTE is sometimes inlined (good) or materialized (bad) depending on optimizer decision.

## Slow Query (CTE)
```sql
WITH high_earners AS (
  SELECT driver_id FROM driver_earnings 
  WHERE net_amount > 100
  GROUP BY driver_id
  HAVING COUNT(*) > 50
)
SELECT t.id, t.fare, d.name
FROM trips t
JOIN high_earners he ON t.driver_id = he.driver_id
JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
LIMIT 100;
```

## Investigation Questions

1. When does CTE get inlined vs materialized?
2. What's the performance difference?
3. How do you force inlining or materialization?
4. When should you avoid CTEs?

## Diagnosis

**Root Cause:** CTE without aggregates can be inlined (merged into main query). But CTE with `GROUP BY HAVING` gets materialized (full scan needed). Optimizer materializes CTE, then joins against materialized result; much slower than inlining.

## Solution SQL

```sql
-- Step 1: Check EXPLAIN of slow CTE query
EXPLAIN (ANALYZE, BUFFERS)
WITH high_earners AS (
  SELECT driver_id FROM driver_earnings 
  WHERE net_amount > 100
  GROUP BY driver_id
  HAVING COUNT(*) > 50
)
SELECT t.id, t.fare, d.name
FROM trips t
JOIN high_earners he ON t.driver_id = he.driver_id
JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
LIMIT 100;
-- If materialization is problem, you'll see full CTE scan

-- Step 2: Rewrite as subquery to force inlining
EXPLAIN (ANALYZE, BUFFERS)
SELECT t.id, t.fare, d.name
FROM trips t
JOIN (
  SELECT driver_id FROM driver_earnings 
  WHERE net_amount > 100
  GROUP BY driver_id
  HAVING COUNT(*) > 50
) he ON t.driver_id = he.driver_id
JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
LIMIT 100;
-- Much faster if inlined

-- Step 3: Force CTE materialization if needed
WITH high_earners AS NOT MATERIALIZED (
  SELECT driver_id FROM driver_earnings 
  WHERE net_amount > 100
  GROUP BY driver_id
  HAVING COUNT(*) > 50
)
SELECT t.id, t.fare, d.name
FROM trips t
JOIN high_earners he ON t.driver_id = he.driver_id
JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
LIMIT 100;
-- Try NOT MATERIALIZED to force inlining (PostgreSQL 12+)

-- Step 4: Or use temp table for definite materialization
CREATE TEMP TABLE high_earners AS
SELECT driver_id FROM driver_earnings 
WHERE net_amount > 100
GROUP BY driver_id
HAVING COUNT(*) > 50;

SELECT t.id, t.fare, d.name
FROM trips t
JOIN high_earners he ON t.driver_id = he.driver_id
JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
LIMIT 100;
-- Explicit temp table; you control materialization
```

## Lessons Learned

- **CTEs can be inlined or materialized:** Optimizer decides; unpredictable
- **Simple CTEs usually inlined:** Good for readability without performance cost
- **CTEs with aggregates often materialized:** Know this trade-off
- **Test with EXPLAIN ANALYZE:** Don't assume CTEs are fast
- **Subqueries more transparent:** Optimizer behavior more predictable

## Prevention Checklist

- [ ] Use CTEs for readability; but verify with EXPLAIN ANALYZE
- [ ] Rewrite as subquery if CTE slow; compare plans
- [ ] Force materialization with temp tables if need control
- [ ] Monitor CTE query plans; alert on regressions
- [ ] Document why CTE chosen; may need adjustment later

---

# CASE STUDY 7: Trigger Cascade Disaster

## Scenario
A single DELETE on the `drivers` table cascades and deletes millions of rows across `trips`, `driver_earnings`, and `reviews` tables. What should have been a 5-second cleanup took 2 hours.

## Problem Statement
Cascading foreign keys with triggers caused unintended mass deletion and performance collapse.

## Schema
```sql
CREATE TABLE drivers (id SERIAL PK, ...);
CREATE TABLE trips (
  id SERIAL PK, 
  driver_id INT FK REFERENCES drivers(id) ON DELETE CASCADE,
  ...
);
CREATE TABLE driver_earnings (
  id SERIAL PK,
  driver_id INT FK REFERENCES drivers(id) ON DELETE CASCADE,
  ...
);
CREATE TABLE reviews (
  id SERIAL PK,
  trip_id INT FK REFERENCES trips(id) ON DELETE CASCADE,
  ...
);
```

## Investigation Questions

1. What is a cascading delete?
2. When should you use ON DELETE CASCADE vs ON DELETE RESTRICT?
3. How do you predict cascade impact?
4. How do you safely delete with cascades?

## Diagnosis

**Root Cause:** Multiple foreign keys with `ON DELETE CASCADE` create chain reactions. Deleting 1 driver cascades to:
- All 50,000 trips for that driver
- All 40,000 earnings records for that driver
- All 250,000 reviews for those trips

Total: 340,000 row deletes; each triggering other cascades.

## Solution SQL

```sql
-- Step 1: Understand cascade impact BEFORE deleting
-- Query to predict deletions
WITH driver_to_delete AS (
  SELECT 5 as driver_id  -- Driver to delete
)
SELECT 
  'drivers' as table_name, COUNT(*) as rows_affected
FROM drivers WHERE id IN (SELECT driver_id FROM driver_to_delete)
UNION ALL
SELECT 'trips', COUNT(*) FROM trips 
WHERE driver_id IN (SELECT driver_id FROM driver_to_delete)
UNION ALL
SELECT 'driver_earnings', COUNT(*) FROM driver_earnings 
WHERE driver_id IN (SELECT driver_id FROM driver_to_delete)
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews 
WHERE trip_id IN (
  SELECT id FROM trips 
  WHERE driver_id IN (SELECT driver_id FROM driver_to_delete)
);

-- Step 2: Delete in reverse cascade order (children first)
BEGIN;  -- Wrap in transaction

-- Delete reviews (deepest in cascade)
DELETE FROM reviews WHERE trip_id IN (
  SELECT id FROM trips WHERE driver_id = 5
);

-- Delete earnings
DELETE FROM driver_earnings WHERE driver_id = 5;

-- Delete trips
DELETE FROM trips WHERE driver_id = 5;

-- Finally delete driver
DELETE FROM drivers WHERE id = 5;

COMMIT;  -- All-or-nothing

-- Step 3: If cascades too dangerous, change FK constraint
-- (Do this in maintenance window)
ALTER TABLE trips DROP CONSTRAINT trips_driver_id_fkey;
ALTER TABLE trips ADD CONSTRAINT trips_driver_id_fkey 
  FOREIGN KEY (driver_id) REFERENCES drivers(id) 
  ON DELETE RESTRICT;  -- Prevent delete if trips exist

-- Step 4: Now deletes require explicit cleanup
-- This will fail if trips exist:
DELETE FROM drivers WHERE id = 5;
-- ERROR: update or delete on table "drivers" violates foreign key constraint

-- Step 5: Must delete children explicitly
DELETE FROM reviews WHERE trip_id IN (
  SELECT id FROM trips WHERE driver_id = 5
);
DELETE FROM driver_earnings WHERE driver_id = 5;
DELETE FROM trips WHERE driver_id = 5;
DELETE FROM drivers WHERE id = 5;  -- Now succeeds
```

## Lessons Learned

- **ON DELETE CASCADE dangerous:** Use ON DELETE RESTRICT for data safety
- **Cascades compound:** Multiple cascades create exponential deletions
- **Test delete impact first:** Query to see cascade extent before deleting
- **Explicit delete safer:** Code explicit deletion order; easier to debug
- **Transactions protect:** Wrap cascading deletes in transactions; roll back if needed

## Prevention Checklist

- [ ] Use ON DELETE RESTRICT for critical foreign keys
- [ ] Use ON DELETE CASCADE only for purely dependent data (e.g., order_items with order)
- [ ] Query cascade impact before big deletes
- [ ] Wrap dangerous deletes in transactions
- [ ] Alert on large multi-table deletes
- [ ] Test delete procedures in staging environment

---

# CASE STUDY 8: Stale Statistics Break Query Plans

## Scenario
A query runs in <100ms in morning but times out by evening. No schema changes. Data grew from 1M to 5M rows during day. Optimizer still thinks 1M rows; chooses wrong plan.

## Problem Statement
Auto-vacuum didn't keep up with data growth; statistics stale; optimizer makes wrong decisions.

## Investigation Questions

1. How often should ANALYZE run?
2. What's the impact of stale statistics?
3. How do you diagnose stale stats?
4. When does auto-vacuum run?

## Diagnosis

**Root Cause:** Nightly batch insert 4M rows. Auto-vacuum configured to run rarely. Statistics not updated during day. By evening, optimizer's row count estimates wildly off; chooses bad plans.

## Solution SQL

```sql
-- Step 1: Check last analysis time
SELECT schemaname, tablename, last_analyze, last_autovacuum
FROM pg_stat_user_tables
WHERE tablename = 'trips'
ORDER BY last_analyze DESC;

-- Step 2: Check estimated vs actual rows
EXPLAIN (FORMAT JSON) SELECT COUNT(*) FROM trips;
-- Look at Plans[0].Plan Rows; compare to actual

SELECT COUNT(*) FROM trips;  -- Actual row count

-- Step 3: Update statistics manually
ANALYZE trips;

-- Step 4: Re-run problematic query; should be faster
EXPLAIN ANALYZE SELECT * FROM trips WHERE status = 'completed' LIMIT 1000;

-- Step 5: Adjust auto-vacuum settings for high-volume table
ALTER TABLE trips SET (
  autovacuum_vacuum_scale_factor = 0.01,  -- Run more often (1% growth)
  autovacuum_analyze_scale_factor = 0.005, -- Analyze more often (0.5% growth)
  autovacuum_vacuum_cost_delay = 10,       -- Faster vacuum
  autovacuum_vacuum_cost_limit = 1000      -- Higher cost budget
);

-- Step 6: Or force frequent analysis
CREATE OR REPLACE FUNCTION analyze_trips()
RETURNS void AS $$
BEGIN
  ANALYZE trips;
END;
$$ LANGUAGE plpgsql;

-- Schedule as cron job (run every 2 hours)
-- SELECT cron.schedule('analyze_trips', '0 */2 * * *', 'SELECT analyze_trips();');

-- Step 7: Verify auto-vacuum settings
SELECT name, setting FROM pg_settings 
WHERE name LIKE '%autovacuum%' AND name LIKE '%analyze%';
```

## Lessons Learned

- **Statistics drive optimizer:** Stale stats = bad plans
- **Auto-vacuum may be too slow:** Adjust parameters for high-volume tables
- **Schedule frequent ANALYZE:** Especially after bulk loads
- **Monitor statistics freshness:** Alert if not updated in >4 hours for active tables
- **Test with representative data:** Dev database may have different stats than production

## Prevention Checklist

- [ ] Run `ANALYZE` after bulk inserts (>1% of table size)
- [ ] Schedule `ANALYZE` hourly on high-volume tables
- [ ] Monitor auto-vacuum lag: `last_analyze < NOW() - INTERVAL '1 hour'`
- [ ] Adjust auto-vacuum thresholds for large tables
- [ ] Alert on query plan regressions; suspect stale stats first

---

# CASE STUDY 9: Partition Elimination Failure

## Scenario
Partitioned trips table by month for performance. Queries should scan single partition, but EXPLAIN shows all partitions scanned.

## Problem Statement
Partition constraint exclusion not working; optimizer scans all partitions.

## Schema
```sql
CREATE TABLE trips (
  id SERIAL, driver_id INT, fare DECIMAL(10,2),
  created_at TIMESTAMPTZ, ...
) PARTITION BY RANGE (DATE_TRUNC('month', created_at));

CREATE TABLE trips_2024_01 PARTITION OF trips
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
CREATE TABLE trips_2024_02 PARTITION OF trips
  FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
-- ... more months
```

## Investigation Questions

1. What is partition elimination?
2. When does constraint exclusion work?
3. What query patterns prevent elimination?
4. How do you force partition elimination?

## Diagnosis

**Root Cause:** Constraint exclusion requires:
1. Partition key in WHERE clause
2. Constraint-compatible comparison (e.g., `created_at > '2024-01-01'`)
3. `constraint_exclusion` enabled

## Solution SQL

```sql
-- Step 1: Enable constraint exclusion
SET constraint_exclusion = partition;  -- For partitioned tables

-- Step 2: Check EXPLAIN; verify only relevant partition scanned
EXPLAIN SELECT * FROM trips WHERE created_at >= '2024-02-01' AND created_at < '2024-03-01';
-- Should show: Subplans Removed: 10 (means 10 partitions eliminated)

-- Step 3: Non-working query (prevents elimination)
EXPLAIN SELECT * FROM trips WHERE EXTRACT(MONTH FROM created_at) = 2;
-- Will scan all partitions (function makes predicate non-sargable)

-- Step 4: Rewrite to enable elimination
EXPLAIN SELECT * FROM trips 
WHERE created_at >= '2024-02-01' AND created_at < '2024-03-01';
-- Now eliminates other months

-- Step 5: Check if constraint_exclusion is enabled
SELECT setting FROM pg_settings WHERE name = 'constraint_exclusion';
-- Should be 'partition' or 'on'

-- Step 6: If still not working, check partition constraints
SELECT tablename, pg_get_partition_constraintdef(oid)
FROM pg_tables
WHERE tablename LIKE 'trips_%'
ORDER BY tablename;
-- Verify constraints are correct

-- Step 7: Recreate partitions if constraints malformed
ALTER TABLE trips DETACH PARTITION trips_2024_02;
ALTER TABLE trips ATTACH PARTITION trips_2024_02
  FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
```

## Lessons Learned

- **Partition elimination not automatic:** Requires correct WHERE clause
- **Constraint-compatible predicates:** Use direct column comparisons
- **Functions prevent elimination:** `EXTRACT(MONTH FROM date)` disables elimination
- **Enable constraint_exclusion:** Must be 'partition' or 'on'
- **Monitor partition scanning:** Verify elimination works with EXPLAIN

## Prevention Checklist

- [ ] Use direct date comparisons: `WHERE created_at >= '2024-02-01'`
- [ ] Avoid functions on partition key in WHERE
- [ ] Set `constraint_exclusion = partition`
- [ ] Test EXPLAIN for "Subplans Removed" message
- [ ] Alert if partition scans exceed 2 partitions
- [ ] Document partition predicate patterns used

---

# CASE STUDY 10: Billion-Row Analytics Query Timeout

## Scenario
New analytics query aggregates a year of trip data: trips, drivers, riders, payments. Query processes 1 billion rows across 4 large tables. Timeouts after 5 minutes.

## Problem Statement
Massive join + aggregation too slow; needs optimization strategy.

## Query
```sql
SELECT 
  DATE(t.created_at) as trip_date,
  d.city,
  t.vehicle_type,
  COUNT(*) as trip_count,
  AVG(t.fare) as avg_fare,
  SUM(p.amount) as total_revenue,
  AVG(dr.rating) as avg_rating
FROM trips t
JOIN drivers d ON t.driver_id = d.id
JOIN riders r ON t.rider_id = r.id
JOIN payments p ON t.id = p.trip_id
LEFT JOIN reviews dr ON t.id = dr.trip_id AND dr.reviewer_type = 'rider'
WHERE t.created_at >= DATE_TRUNC('day', NOW() - INTERVAL '365 days')
GROUP BY DATE(t.created_at), d.city, t.vehicle_type
ORDER BY trip_date DESC;
```

## Investigation Questions

1. How do you optimize billion-row queries?
2. When should you use materialized views?
3. How does partitioning help?
4. What's the trade-off between correctness and speed?

## Diagnosis

**Problem:** Query must:
- Scan 1B trips rows
- Hash join with drivers (10K rows)
- Hash join with riders (100K rows)
- Hash join with payments (1B rows)
- LEFT join with reviews (500M rows)
- GROUP BY date, city, vehicle_type
- Sort result

This takes too long for real-time; better approach: pre-aggregate.

## Solution SQL

```sql
-- Step 1: Create fact table with pre-aggregated daily metrics
CREATE TABLE daily_trip_metrics (
  metric_date DATE,
  driver_id INT,
  city VARCHAR(50),
  vehicle_type VARCHAR(50),
  trip_count INT,
  avg_fare DECIMAL(10,2),
  total_revenue DECIMAL(15,2),
  avg_rating DECIMAL(3,2),
  created_at TIMESTAMPTZ,
  PRIMARY KEY (metric_date, driver_id, city, vehicle_type)
);

-- Step 2: Populate with initial data
INSERT INTO daily_trip_metrics
SELECT 
  DATE(t.created_at) as metric_date,
  d.id as driver_id,
  d.city,
  t.vehicle_type,
  COUNT(*) as trip_count,
  AVG(t.fare) as avg_fare,
  SUM(p.amount) as total_revenue,
  AVG(dr.rating) as avg_rating,
  NOW() as created_at
FROM trips t
JOIN drivers d ON t.driver_id = d.id
JOIN payments p ON t.id = p.trip_id
LEFT JOIN reviews dr ON t.id = dr.trip_id AND dr.reviewer_type = 'rider'
WHERE t.created_at >= DATE_TRUNC('day', NOW() - INTERVAL '365 days')
GROUP BY DATE(t.created_at), d.id, d.city, t.vehicle_type
ON CONFLICT (metric_date, driver_id, city, vehicle_type) DO UPDATE SET
  trip_count = EXCLUDED.trip_count,
  avg_fare = EXCLUDED.avg_fare,
  total_revenue = EXCLUDED.total_revenue,
  avg_rating = EXCLUDED.avg_rating;

-- Step 3: Create index for fast queries
CREATE INDEX idx_daily_metrics_date_city 
ON daily_trip_metrics(metric_date DESC, city, vehicle_type);

-- Step 4: Original query now instant
SELECT *
FROM daily_trip_metrics
WHERE metric_date >= DATE_TRUNC('day', NOW() - INTERVAL '365 days')
ORDER BY metric_date DESC;

-- Step 5: Refresh daily (after 2:00 AM, after day-end ETL)
-- Run via cron job or scheduled task
INSERT INTO daily_trip_metrics
SELECT 
  DATE(t.created_at) as metric_date,
  d.id as driver_id,
  d.city,
  t.vehicle_type,
  COUNT(*) as trip_count,
  AVG(t.fare) as avg_fare,
  SUM(p.amount) as total_revenue,
  AVG(dr.rating) as avg_rating,
  NOW() as created_at
FROM trips t
JOIN drivers d ON t.driver_id = d.id
JOIN payments p ON t.id = p.trip_id
LEFT JOIN reviews dr ON t.id = dr.trip_id AND dr.reviewer_type = 'rider'
WHERE DATE(t.created_at) = CURRENT_DATE - INTERVAL '1 day'
GROUP BY DATE(t.created_at), d.id, d.city, t.vehicle_type
ON CONFLICT (metric_date, driver_id, city, vehicle_type) DO UPDATE SET
  trip_count = EXCLUDED.trip_count,
  avg_fare = EXCLUDED.avg_fare,
  total_revenue = EXCLUDED.total_revenue,
  avg_rating = EXCLUDED.avg_rating;

-- Step 6: Partition fact table by date for retention
CREATE TABLE daily_trip_metrics_2024_01 
PARTITION OF daily_trip_metrics
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

-- Step 7: Automated refresh script
CREATE OR REPLACE FUNCTION refresh_daily_metrics()
RETURNS void AS $$
BEGIN
  -- Delete yesterday if exists (re-compute due to late data)
  DELETE FROM daily_trip_metrics 
  WHERE metric_date = CURRENT_DATE - INTERVAL '1 day';
  
  -- Recompute yesterday
  INSERT INTO daily_trip_metrics (...)
  SELECT ... WHERE DATE(t.created_at) = CURRENT_DATE - INTERVAL '1 day'
  ...
  
  RAISE NOTICE 'Daily metrics refreshed for %', CURRENT_DATE - INTERVAL '1 day';
END;
$$ LANGUAGE plpgsql;

-- Schedule: SELECT cron.schedule('refresh_metrics', '0 2 * * *', 'SELECT refresh_daily_metrics();');
```

## Lessons Learned

- **Pre-aggregation solves billion-row analytics:** Compute once, query many times
- **Materialized views or fact tables essential:** Store pre-computed metrics
- **Refresh strategy critical:** Update on schedule; handle late-arriving data
- **Partition fact tables:** Enables easy retention management
- **Accept slight staleness:** Real-time analytics on billions = impossible; hourly/daily refresh is practical

## Prevention Checklist

- [ ] Identify heavy analytics queries early in development
- [ ] Build fact tables for frequently-aggregated metrics
- [ ] Partition fact tables by date for retention
- [ ] Schedule refresh after ETL completes
- [ ] Monitor fact table freshness; alert if not refreshed
- [ ] Use incremental refresh: only recompute yesterday, not entire year
- [ ] Document refresh schedule and SLA
- [ ] Test refresh completeness (no gaps)

---

**Case Study Summary**

These 10 cases cover the most common SQL performance and correctness issues in production databases. Master these patterns and you'll solve 80% of real-world problems.

**Progress Path:**
- Cases 1-4: Indexing and basic optimization
- Cases 5-6: Complex query optimization
- Cases 7-8: Data integrity and statistics
- Cases 9-10: Advanced DWH and analytics patterns

**Next Step:** Work through real queries at your company; apply these case frameworks.



