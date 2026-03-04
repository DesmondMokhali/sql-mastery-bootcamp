# ⚡ Day 9: Partitioning & Performance at Scale
**Friday, 13 March 2026**  
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) - From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** - Please like, subscribe and support the original creator!

---

## 📅 Today's Schedule

| Time | Activity | Duration | Focus |
|------|----------|----------|-------|
| 09:00-09:45 | Partitioning Strategies | 45 min | Range, List, Hash partitions |
| 09:45-10:30 | Partition Pruning & Elimination | 45 min | How optimizer skips partitions |
| 10:30-11:15 | Performance at Billion-Row Scale | 45 min | IO vs CPU bottlenecks |
| 11:15-12:00 | Parallel Query Execution | 45 min | Work_mem, Shared Buffers, memory grants |
| 12:00-13:00 | **Lunch Break** | 60 min | - |
| 13:00-13:45 | 30 Quick Performance Tips | 45 min | Practical optimizations |
| 13:45-14:30 | Lab Exercises 1-3 | 45 min | Hands-on partitioning |
| 14:30-15:15 | Lab Exercises 4-5 | 45 min | Pressure scenario |
| 15:15-15:35 | Wrap-up & Recap | 20 min | Checklist & homework |

---

## 🎯 Core Topics

### 1. Range Partitioning

**Divide table by column ranges (e.g., dates, IDs).**

```sql
-- Partition trips by date (monthly)
CREATE TABLE trips_partitioned (
  id SERIAL,
  driver_id INT,
  rider_id INT,
  fare DECIMAL(10, 2),
  started_at TIMESTAMP,
  status VARCHAR(20)
) PARTITION BY RANGE (DATE_TRUNC('month', started_at));

CREATE TABLE trips_2026_03 PARTITION OF trips_partitioned
  FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');

CREATE TABLE trips_2026_04 PARTITION OF trips_partitioned
  FOR VALUES FROM ('2026-04-01') TO ('2026-05-01');

-- Insert automatically routes to correct partition
INSERT INTO trips_partitioned VALUES (...);  -- Routes to trips_2026_03 or trips_2026_04
```

**Benefits:**
- **Partition pruning:** Query filters `started_at > '2026-03-15'` → only scan trips_2026_03, trips_2026_04, etc.
- **Faster deletes:** Drop old partition instead of DELETE (instant).
- **Index per partition:** Smaller indexes, cache-friendly.

### 2. List Partitioning

**Divide by discrete column values.**

```sql
-- Partition trips by city
CREATE TABLE trips_by_city (
  id SERIAL,
  driver_id INT,
  city VARCHAR(50),
  fare DECIMAL(10, 2),
  ...
) PARTITION BY LIST (city);

CREATE TABLE trips_nyc PARTITION OF trips_by_city
  FOR VALUES IN ('New York', 'NYC');

CREATE TABLE trips_sf PARTITION OF trips_by_city
  FOR VALUES IN ('San Francisco', 'SF');

CREATE TABLE trips_other PARTITION OF trips_by_city
  FOR VALUES IN (DEFAULT);  -- Catch-all

-- Query city='NYC' → scans ONLY trips_nyc partition
SELECT * FROM trips_by_city WHERE city = 'NYC';
```

### 3. Hash Partitioning

**Divide by hash of column (evenly distribute).**

```sql
-- Partition trips by driver_id hash (4 partitions)
CREATE TABLE trips_hash (
  id SERIAL,
  driver_id INT,
  fare DECIMAL(10, 2),
  ...
) PARTITION BY HASH (driver_id);

CREATE TABLE trips_hash_0 PARTITION OF trips_hash FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE trips_hash_1 PARTITION OF trips_hash FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE trips_hash_2 PARTITION OF trips_hash FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE trips_hash_3 PARTITION OF trips_hash FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Evenly distributes across 4 partitions by driver_id hash
```

### 4. Partition Pruning (The Magic)

**Optimizer skips partitions not matching WHERE clause.**

```sql
-- Query: Find March trips
SELECT * FROM trips_partitioned
WHERE started_at >= '2026-03-01' AND started_at < '2026-04-01';

-- Execution Plan:
Append
  ├─ Seq Scan on trips_2026_03  ← Only scans THIS partition (pruning!)
  └─ [trips_2026_04 pruned]     ← Other partitions eliminated
  └─ [trips_2026_05 pruned]

-- WITHOUT partition pruning: Would scan ALL 12 monthly partitions
-- WITH partition pruning: Scans ~1/12 of data → 12x faster!
```

**Partition pruning requires:**
1. WHERE clause directly on partition key: `WHERE started_at >= '2026-03-01'`
2. NOT through expression: `WHERE EXTRACT(MONTH FROM started_at) = 3` (no pruning!)

### 5. Performance at Billion-Row Scale

#### IO vs CPU Bottleneck Detection

```sql
-- Check query performance metrics
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT driver_id, AVG(fare)
FROM trips
WHERE started_at > NOW() - INTERVAL '1 year'
GROUP BY driver_id;

-- Output:
Planning Time: 0.234 ms
Execution Time: 45234.123 ms  ← 45 seconds!

Buffers: shared hit=1000 (memory), read=50000 (disk)
  → 50,000 disk reads = IO BOUND (slow)
```

**IO-Bound Query:** Disk reads dominate.
- **Signal:** High buffer reads, slow execution, linear growth with data.
- **Solution:** Partitioning, indexes, caching, SSD, parallel workers.

```sql
-- Check CPU vs IO balance
-- CPU: Planning/execution time proportional to rows processed
-- IO: Read/write operations from disk

-- CPU-bound query (fast IO, slow CPU):
SELECT * FROM billion_row_table
WHERE id BETWEEN 1 AND 1000000;  -- 1M rows in memory, scanning slowly

-- IO-bound query (slow IO, fast CPU):
SELECT * FROM billion_row_table
WHERE random_column = 42;  -- Few rows but must scan whole table on disk
```

### 6. Parallel Query Execution

**PostgreSQL: Execute single query across multiple workers.**

```sql
-- PostgreSQL settings for parallelism
max_parallel_workers_per_gather = 4  -- Up to 4 workers per query
max_parallel_workers = 8             -- Total workers system-wide
work_mem = '256MB'                   -- Memory per worker for sort/hash
shared_buffers = '4GB'               -- Shared cache for all connections

-- Query automatically parallelized (if cost > parallel_threshold)
EXPLAIN SELECT COUNT(*)
FROM billion_row_table
WHERE status = 'completed';

-- Output:
Finalize Aggregate
  └─ Gather
     ├─ Partial Aggregate [Worker 0]  ← Parallel computation
     ├─ Partial Aggregate [Worker 1]
     ├─ Partial Aggregate [Worker 2]
     └─ Seq Scan [Worker 3]
```

**Memory Grants:** Each worker reserves `work_mem` for sorting/hashing.
- 4 workers × 256MB = 1GB total for one query.
- Careful: Many concurrent queries × large work_mem = OOM crash!

### 7. 30 Quick Performance Tips

**Indexing (1-5)**
1. Index filtered columns in WHERE clauses.
2. Index JOIN keys (ON conditions).
3. Create composite indexes (driver_id, fare) for common patterns.
4. Avoid over-indexing (slows INSERT/UPDATE).
5. Use index-only scans where possible (INCLUDE columns).

**Query Patterns (6-10)**
6. Move filters into CTEs early (avoid materializing all data).
7. Use DISTINCT ON when you only need first row per group.
8. Replace NOT IN with NOT EXISTS (NOT IN fails on NULL).
9. Avoid SELECT * (only fetch needed columns).
10. Use LIMIT early in aggregations if possible.

**Joins (11-15)**
11. Join on indexed columns (foreign keys ideally).
12. Filter small table first, then large table.
13. Use INNER JOIN instead of LEFT if you don't need unmatched rows.
14. Avoid joining on expressions: `ON CAST(a AS INT) = b` (no index).
15. Pre-aggregate before joining large tables.

**Aggregation (16-20)**
16. GROUP BY indexed columns for faster aggregation.
17. Use HAVING after GROUP BY to filter aggregates.
18. DISTINCT is slower than GROUP BY (0 rows).
19. Use window functions instead of self-joins for row numbers.
20. Materialize intermediate aggregates in CTEs.

**Partitioning & Structure (21-25)**
21. Partition large tables (> 1GB) by date or range.
22. Partition pruning: Filter directly on partition key.
23. Keep partition sizes between 100MB-1GB.
24. Archive old partitions separately.
25. Use UNLOGGED tables for temporary data (faster, risky).

**Caching & Configuration (26-30)**
26. Increase `shared_buffers` (1/4 of RAM is typical).
27. Increase `work_mem` for sort/hash operations.
28. Run VACUUM ANALYZE regularly to update statistics.
29. Monitor slow queries (enable log_min_duration_statement).
30. Test changes on replica before production.

---

## 📚 10 Terms of the Day

| Term | Definition | Example | Category | Mastery |
|------|-----------|---------|----------|---------|
| **Partition Pruning** | Optimizer skips unmatched partitions | WHERE started_at >= '2026-03-01' | Optimization | |
| **Range Partition** | Divide table by column value ranges | PARTITION BY RANGE (date_column) | Strategy | |
| **List Partition** | Divide table by discrete values | PARTITION BY LIST (city) | Strategy | |
| **Hash Partition** | Divide evenly by hash function | PARTITION BY HASH (driver_id) | Strategy | |
| **Parallel Worker** | Subprocess running part of query | Worker 0, Worker 1, ... | Execution | |
| **work_mem** | Memory per worker for sort/hash | 256MB per worker × 4 workers | Configuration | |
| **Shared Buffers** | Cache for all database pages | 4GB total system cache | Configuration | |
| **IO Bound** | Query performance limited by disk reads | 50k disk reads = IO bottleneck | Diagnosis | |
| **CPU Bound** | Query performance limited by CPU time | Scanning 1M rows slowly = CPU | Diagnosis | |
| **Query Plan** | Optimizer's execution strategy | EXPLAIN shows the plan | Diagnosis | |

---

## 🧪 Lab Exercises (Uber Database)

### Lab 1: Range Partition - Monthly Trips Table
**Create partitioned trips table by month. Verify partition pruning.**

```sql
-- Create partitioned table
-- Insert sample data for Jan, Feb, Mar
-- Run EXPLAIN on March query → should show only March partition scanned
```

**Solution:**
```sql
-- Drop old table if exists
DROP TABLE IF EXISTS trips_partitioned CASCADE;

-- Create partitioned table (by month)
CREATE TABLE trips_partitioned (
  id SERIAL,
  driver_id INT,
  rider_id INT,
  fare DECIMAL(10, 2),
  started_at TIMESTAMP,
  status VARCHAR(20)
) PARTITION BY RANGE (DATE_TRUNC('month', started_at));

-- Create partitions
CREATE TABLE trips_2026_01 PARTITION OF trips_partitioned
  FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
  
CREATE TABLE trips_2026_02 PARTITION OF trips_partitioned
  FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');
  
CREATE TABLE trips_2026_03 PARTITION OF trips_partitioned
  FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');

-- Index each partition
CREATE INDEX idx_trips_2026_01_driver ON trips_2026_01(driver_id);
CREATE INDEX idx_trips_2026_02_driver ON trips_2026_02(driver_id);
CREATE INDEX idx_trips_2026_03_driver ON trips_2026_03(driver_id);

-- Verify partition pruning
EXPLAIN (ANALYZE)
SELECT * FROM trips_partitioned
WHERE started_at >= '2026-03-01' AND started_at < '2026-04-01';

-- Expected: Only trips_2026_03 scanned, others pruned
```

### Lab 2: List Partition - Trips by City
**Partition trips by city (NYC, SF, LA, Other). Check pruning.**

```sql
-- PARTITION BY LIST (city)
-- Create 4 partitions
-- Query city='NYC' → should prune other cities
```

**Solution:**
```sql
CREATE TABLE trips_by_city (
  id SERIAL,
  driver_id INT,
  city VARCHAR(50),
  fare DECIMAL(10, 2),
  started_at TIMESTAMP
) PARTITION BY LIST (city);

CREATE TABLE trips_nyc PARTITION OF trips_by_city
  FOR VALUES IN ('New York', 'NYC', 'Manhattan');

CREATE TABLE trips_sf PARTITION OF trips_by_city
  FOR VALUES IN ('San Francisco', 'SF', 'Bay Area');

CREATE TABLE trips_la PARTITION OF trips_by_city
  FOR VALUES IN ('Los Angeles', 'LA', 'Long Beach');

CREATE TABLE trips_other PARTITION OF trips_by_city
  FOR VALUES IN (DEFAULT);

-- Verify pruning
EXPLAIN (ANALYZE)
SELECT COUNT(*) FROM trips_by_city WHERE city = 'NYC';

-- Expected: Only trips_nyc scanned
```

### Lab 3: Hash Partition - Distribute Load
**Create hash partition by driver_id (4 partitions). Check even distribution.**

```sql
-- PARTITION BY HASH (driver_id) with 4 partitions
-- Insert sample data
-- Check row count per partition (should be ~equal)
```

**Solution:**
```sql
CREATE TABLE trips_hash (
  id SERIAL,
  driver_id INT,
  fare DECIMAL(10, 2),
  started_at TIMESTAMP
) PARTITION BY HASH (driver_id);

CREATE TABLE trips_hash_0 PARTITION OF trips_hash FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE trips_hash_1 PARTITION OF trips_hash FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE trips_hash_2 PARTITION OF trips_hash FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE trips_hash_3 PARTITION OF trips_hash FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Check distribution
SELECT tableoid::regclass as partition, COUNT(*) as row_count
FROM trips_hash
GROUP BY tableoid
ORDER BY partition;

-- Expected: ~equal distribution (±5%)
```

### Lab 4: Performance Comparison - Partitioned vs Unpartitioned
**Run same query on partitioned and unpartitioned table. Compare execution time.**

```sql
-- Query: Find trips from March 2026
-- Run on trips_partitioned (from Lab 1)
-- Run on original trips table
-- Compare execution time and buffers
```

**Solution:**
```sql
-- Unpartitioned query
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT COUNT(*), AVG(fare) FROM trips
WHERE started_at >= '2026-03-01' AND started_at < '2026-04-01';

-- Partitioned query
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT COUNT(*), AVG(fare) FROM trips_partitioned
WHERE started_at >= '2026-03-01' AND started_at < '2026-04-01';

-- Compare:
-- Partitioned should have: Lower buffers read, faster execution time
-- Reason: Partition pruning skips 11 months of data
```

### Lab 5: Pressure Scenario - Query Fine on Small Dataset, Collapses at Scale
**PRESSURE: Query runs in 100ms on 1M rows. At 100M rows, timeout (5min). Fix.**

**Scenario:**
```sql
-- SLOW at 100M rows (nested loop, memory spill, thrashing)
SELECT d.name, COUNT(t.id) as trip_count, AVG(t.fare) as avg_fare
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id, d.name
ORDER BY trip_count DESC;

-- Execution plan on 1M rows: Hash Aggregate (50ms)
-- Execution plan on 100M rows: Hash Aggregate (disk spill, 5min timeout)
```

**Root Cause:** Hash aggregate spills to disk when trip table is huge.

**Solution:**
```sql
-- OPTION 1: Increase work_mem (system-wide or session)
SET work_mem = '1GB';  -- Per-worker memory

-- OPTION 2: Partition trips table (by driver_id or date)
-- Then parallelize: 4 workers × smaller partitions = fits in work_mem

-- OPTION 3: Pre-aggregate in smaller batches (if possible)
WITH trip_agg AS (
  SELECT driver_id, COUNT(*) as trip_count, AVG(fare) as avg_fare
  FROM trips
  WHERE started_at > NOW() - INTERVAL '30 days'  -- Filter first
  GROUP BY driver_id
)
SELECT d.name, ta.trip_count, ta.avg_fare
FROM drivers d
JOIN trip_agg ta ON d.id = ta.driver_id
ORDER BY ta.trip_count DESC;

-- OPTION 4: Use parallel execution
SET max_parallel_workers_per_gather = 4;
SET max_parallel_workers = 8;
-- Enables automatic parallelization
```

---

## 🔍 Deep Dive: Partition Pruning & Execution Plans

### Partition Pruning Decision Tree

```
Query: WHERE started_at >= '2026-03-01' AND started_at < '2026-04-01'
       └─ Partition key: DATE_TRUNC('month', started_at)

Optimizer checks:
  ├─ Partition 2026-01 (covers '2026-01-01' to '2026-02-01')?
  │  └─ Does [2026-01-01, 2026-02-01) intersect [2026-03-01, 2026-04-01)?
  │     └─ NO → PRUNE ✗
  │
  ├─ Partition 2026-02?
  │  └─ NO → PRUNE ✗
  │
  ├─ Partition 2026-03?
  │  └─ YES (intersects) → SCAN ✓
  │
  └─ Partition 2026-04 onwards → PRUNE ✗

Result: Only 2026-03 partition scanned
```

### Memory Spill & work_mem

```
Aggregate (GROUP BY on 100M rows)
├─ work_mem = 256MB allocated
├─ Start reading rows: 1M, 2M, 5M, 10M, 50M
│  └─ Hash table in memory: 50M rows × 200 bytes ≈ 10GB (exceeds 256MB)
│
├─ SPILL TO DISK (expensive!)
│  ├─ Write 10GB to temp file on disk
│  ├─ Read back in batches (random IO, slow)
│  └─ Re-hash and aggregate
│
└─ Total time: 5000ms (mostly disk IO)

Solution: Increase work_mem or reduce rows before aggregating
```

---

## 🔥 Pressure Scenario: Query Fine on 1M, Timeout at 100M

**Production Alert:** Data warehouse ingested 100M trips. Query that took 100ms now times out.

### Root Cause Analysis

```sql
-- On 1M rows: Hash Aggregate (in-memory, 50ms)
-- On 100M rows: Hash Aggregate (memory spill, 300s timeout)

-- Evidence: EXPLAIN output shows
Hash Aggregate
  Disk I/O: 200GB written, 200GB read  ← Thrashing!
  Memory: work_mem exceeded by 40x
  Execution Time: 300000ms
```

### Diagnosis Steps

```sql
-- 1. Check current settings
SHOW work_mem;  -- Default 4MB (way too small!)
SHOW shared_buffers;

-- 2. Run EXPLAIN (not ANALYZE) to see plan
EXPLAIN SELECT d.name, COUNT(t.id)
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id, d.name;

-- 3. If plan shows "Disk usage: ..." → memory spill issue
```

### Solution Layered Approach

```sql
-- LAYER 1: Immediate fix - increase work_mem
SET work_mem = '2GB';
-- Rerun query (should no longer spill)

-- LAYER 2: Partition trips by date
CREATE TABLE trips_partitioned (...) PARTITION BY RANGE (DATE_TRUNC('month', started_at));
-- Each partition smaller, aggregation per partition

-- LAYER 3: Enable parallelization
SET max_parallel_workers_per_gather = 4;
-- Multiple workers = divide memory usage

-- LAYER 4: Pre-aggregate (if querying historical data)
CREATE MATERIALIZED VIEW mv_monthly_driver_stats AS
SELECT 
  DATE_TRUNC('month', started_at) as month,
  driver_id,
  COUNT(*) as trip_count,
  AVG(fare) as avg_fare
FROM trips
GROUP BY month, driver_id;

-- Query precomputed data instead
SELECT d.name, SUM(trip_count), AVG(avg_fare)
FROM drivers d
JOIN mv_monthly_driver_stats mds ON d.id = mds.driver_id
GROUP BY d.id, d.name;
```

---

## ✅ Recap Checklist

- [ ] Understand range, list, hash partitioning strategies
- [ ] Know how partition pruning works (filter on partition key)
- [ ] Can spot IO-bound vs CPU-bound performance issues
- [ ] Understand work_mem and memory spill to disk
- [ ] Know 30 quick performance tips (can recall 15+)
- [ ] Can read parallel execution plans
- [ ] Attempted Lab 1-5 without solutions
- [ ] Understand billion-row scale challenges
- [ ] Can diagnose "works at 1M rows, fails at 100M" scenario
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) - From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** - Please like, subscribe and support the original creator!

---

## 🧭 Navigation

**← [Day 8: Indexes & Execution Plans](./day-08-indexes-execution-plans.md) | [Day 10: Data Warehouse & EDA →](./day-10-projects-dwh-eda.md)**

---

*Last updated: 13 March 2026 | [Bootcamp Home](../README.md)*
