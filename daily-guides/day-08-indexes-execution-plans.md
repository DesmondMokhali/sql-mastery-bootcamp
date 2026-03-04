# 🚀 Day 8: Indexes & Execution Plans
**Thursday, 12 March 2026**  
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) - From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** - Please like, subscribe and support the original creator!

---

## 📅 Today's Schedule

| Time | Activity | Duration | Focus |
|------|----------|----------|-------|
| 09:00-09:45 | B-Tree Index Structure | 45 min | Nodes, splits, balance |
| 09:45-10:30 | Clustered vs Non-Clustered | 45 min | Postgres heap tables, leaf pages |
| 10:30-11:15 | EXPLAIN ANALYZE Deep Dive | 45 min | Reading plans, cost model |
| 11:15-12:00 | Bitmap Scans & Index Types | 45 min | BRIN, Hash, GIN |
| 12:00-13:00 | **Lunch Break** | 60 min | - |
| 13:00-13:45 | Statistics & ANALYZE | 45 min | pg_statistic, cardinality, selectivity |
| 13:45-14:30 | Lab Exercises 1-3 | 45 min | Hands-on indexing |
| 14:30-15:15 | Lab Exercises 4-5 | 45 min | Pressure scenario |
| 15:15-15:35 | Wrap-up & Recap | 20 min | Checklist & homework |

---

## 🎯 Core Topics

### 1. B-Tree Index Structure

**Balanced tree with ordered keys; logarithmic lookup O(log n).**

```
        [Root Node: M, Z]
       /      |        \
   [A-D]   [N-S]    [U-Y]    ← Internal nodes (pages)
    |        |         |
  [A][B][C][D]  [N][O]...[S]  [U][V]...[Y]  ← Leaf nodes (point to data)
```

```sql
-- Create B-Tree index (default)
CREATE INDEX idx_trips_driver_fare ON trips(driver_id, fare);

-- Multi-column index is SORTED: driver_id ASC, then fare ASC within each driver
-- Queries benefit:
SELECT * FROM trips WHERE driver_id = 5 AND fare > 40;  -- ✓ Index used efficiently
SELECT * FROM trips WHERE fare > 40 AND driver_id = 5;  -- ✓ Still works, optimizer reorders
SELECT * FROM trips WHERE fare > 40;  -- ✗ Slower (must scan all leaf nodes)
```

### 2. Clustered vs Non-Clustered (Postgres Heap Reality)

**PostgreSQL has NO clustered index.** All tables are heap files. Every index points to heap.

```
Heap File (Trips Table)
┌─────────────────────────────┐
│ Page 1: (t1, t2, t3)        │
│ Page 2: (t4, t5, t6)        │
│ Page 3: (t7, t8, t9)        │
└─────────────────────────────┘

Index: driver_id
┌──────────────────────────────┐
│ 1 → (page 2, offset 3)       │  ← Points to heap location
│ 2 → (page 1, offset 1)       │
│ 3 → (page 3, offset 2)       │
└──────────────────────────────┘
```

**Query with index:**

```sql
SELECT fare FROM trips WHERE driver_id = 5;

-- 1. Index lookup: driver_id = 5 → (page X, offset Y)
-- 2. HEAP FETCH: Go to page X, read row Y, extract fare
-- Cost: Index cost + heap fetch cost (random IO, slow!)
```

### 3. EXPLAIN ANALYZE: Reading the Plan

```sql
EXPLAIN ANALYZE SELECT * FROM trips WHERE driver_id = 5 AND fare > 40;

-- Output:
Index Scan using idx_trips_driver_fare on trips  (cost=0.29..45.67 rows=12 width=100)
  Index Cond: (driver_id = 5 AND fare > 40::numeric)
  Actual Rows: 256  ← MISMATCH! Estimated 12, got 256 (bad stats)
  Buffers: shared hit=15 blks=10ms actual=250ms
  Planning Time: 0.234 ms
  Execution Time: 45.123 ms
```

**Reading the Plan:**

| Term | Meaning | Interpretation |
|------|---------|-----------------|
| `cost=0.29..45.67` | Estimated CPU cost units | 0.29 = startup, 45.67 = total |
| `rows=12` | Estimated rows matching filter | Used for plan choice |
| `Actual Rows=256` | Actual rows returned | If very different, stats are stale |
| `Buffers: shared hit=15` | 15 buffer cache hits (memory) | Good |
| `Buffers: shared read=10` | 10 physical disk reads | Bad (slower) |

### 4. Index-Only Scan (Performance Sweet Spot)

**Query returns only indexed columns → no heap fetch needed!**

```sql
-- Create index with trip_id, driver_id, fare
CREATE INDEX idx_trips_driver_metrics ON trips(driver_id, fare, trip_id);

-- Query: Return only indexed columns
EXPLAIN ANALYZE
SELECT driver_id, fare FROM trips WHERE driver_id = 5 AND fare > 40;

-- Output:
Index Only Scan using idx_trips_driver_metrics on trips
  Index Cond: (driver_id = 5 AND fare > 40)
  Heap Fetches: 0  ← NO HEAP FETCH! Pure index scan (fast)
  Actual Rows: 256
```

### 5. Bitmap Scan (Multiple Conditions)

**PostgreSQL: Combine multiple index results with AND/OR.**

```sql
EXPLAIN ANALYZE
SELECT * FROM trips WHERE driver_id = 5 OR fare > 100 OR status = 'completed';

-- Output:
Bitmap Heap Scan on trips  (cost=...)
  Recheck Cond: ((driver_id = 5) OR (fare > 100) OR (status = 'completed'))
  ├─ Bitmap Index Scan using idx_driver_id ...
  ├─ Bitmap Index Scan using idx_fare ...
  └─ Bitmap Index Scan using idx_status ...
```

**How it works:**
1. Each index returns a bitmap of matching row positions.
2. Combine bitmaps with OR → union of positions.
3. Heap scan in page order (efficient for multiple conditions).

### 6. Cost-Based Optimizer & Statistics

**PostgreSQL estimates cost in arbitrary units. Lower = faster.**

```
Cost = (seq_page_cost × pages) + (cpu_tuple_cost × tuples)
```

**Default values:**
```sql
-- PostgreSQL settings
seq_page_cost = 1.0          -- Cost to read one page sequentially
random_page_cost = 4.0       -- Cost to read one page randomly
cpu_tuple_cost = 0.01        -- Cost to process one tuple
```

**Example: Index scan vs sequential scan**

```sql
-- Seq Scan: Read all pages (1000 pages × 1.0) + (100k tuples × 0.01) = 2000 cost
-- Index Scan: Read index (10 pages × 4.0) + fetch heap (100 pages × 4.0) = 440 cost
-- → Index wins if filtering to < 10% rows
```

### 7. Statistics: pg_statistic Table

```sql
-- View table statistics
SELECT schemaname, tablename, attname, avg_width, n_distinct, correlation
FROM pg_stats
WHERE tablename = 'trips';

-- Refresh statistics (VACUUM ANALYZE)
VACUUM ANALYZE trips;

-- Force re-sample for column
ANALYZE trips(driver_id);
```

**Correlation metric:**
```
correlation = -1: Perfect inverse (high IDs → low values)
correlation = 0:  Random
correlation = 1:  Perfect match (high IDs → high values)

High |correlation| → Index likely to fetch pages in order (faster!)
```

---

## 📚 10 Terms of the Day

| Term | Definition | Example | Category | Mastery |
|------|-----------|---------|----------|---------|
| **B-Tree Index** | Balanced tree for sorted key lookup | CREATE INDEX idx_name ON table(col) | Structure | |
| **Heap Fetch** | Random IO to table after index lookup | 256 heap fetches = 256 page reads | Performance | |
| **Bitmap Scan** | Combine multiple indexes with OR/AND | Bitmap Index Scan + Bitmap Heap Scan | Execution | |
| **Index Only Scan** | Return query from index alone (0 heap fetches) | Index contains all queried columns | Performance | |
| **Cost Estimate** | Optimizer's predicted unit cost | cost=0.29..45.67 | Estimation | |
| **Actual Rows** | Real rows returned vs estimated | Actual Rows=256, plan estimated 12 | Diagnosis | |
| **Selectivity** | Fraction of rows matching filter | 10% selectivity = filter removes 90% | Estimation | |
| **pg_statistic** | System table of column stats | attname, n_distinct, avg_width | Metadata | |
| **ANALYZE** | Collect table/column statistics | ANALYZE trips; or VACUUM ANALYZE | Maintenance | |
| **Correlation** | Order relationship between index & table | correlation=1 → index clustered | Statistics | |

---

## 🧪 Lab Exercises (Uber Database)

### Lab 1: Index Design for Query Performance
**Create indexes to make this query fast. Run EXPLAIN ANALYZE before and after.**

```sql
SELECT driver_id, COUNT(*) as trips, AVG(fare) as avg_fare
FROM trips
WHERE started_at > NOW() - INTERVAL '30 days'
AND status = 'completed'
GROUP BY driver_id
ORDER BY avg_fare DESC
LIMIT 10;
```

**Solution:**
```sql
-- Index 1: Support WHERE clause filtering
CREATE INDEX idx_trips_date_status ON trips(started_at DESC, status);

-- Index 2: Index-only scan for GROUP BY / ORDER BY (if possible)
CREATE INDEX idx_trips_metrics ON trips(driver_id, fare, started_at, status);

-- ANALYZE to update statistics
ANALYZE trips;

-- Compare before/after
EXPLAIN ANALYZE SELECT driver_id, COUNT(*) as trips, AVG(fare) as avg_fare
FROM trips
WHERE started_at > NOW() - INTERVAL '30 days'
AND status = 'completed'
GROUP BY driver_id
ORDER BY avg_fare DESC
LIMIT 10;
```

### Lab 2: Diagnose Index Mismatch - Estimated vs Actual Rows
**Run EXPLAIN ANALYZE. If estimated rows ≠ actual rows, update statistics.**

```sql
-- Your query with mismatch
EXPLAIN ANALYZE
SELECT * FROM trips
WHERE driver_id = 42 AND fare BETWEEN 20 AND 100;

-- If: "Rows=50, Actual Rows=5000"
-- Problem: Outdated statistics
```

**Solution:**
```sql
-- Step 1: Check current stats
SELECT attname, n_distinct, avg_width
FROM pg_stats
WHERE tablename = 'trips' AND attname = 'driver_id';

-- Step 2: Refresh statistics
VACUUM ANALYZE trips;

-- Step 3: Re-run EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT * FROM trips
WHERE driver_id = 42 AND fare BETWEEN 20 AND 100;
-- Should now be closer to reality
```

### Lab 3: Index-Only Scan Optimization
**Modify the index to return query WITHOUT heap fetches.**

```sql
-- Current slow query: Heap Fetches: 1250
SELECT driver_id, fare, status FROM trips WHERE driver_id IN (1, 2, 3);

-- Challenge: Make EXPLAIN ANALYZE show "Heap Fetches: 0"
```

**Solution:**
```sql
-- Create index covering ALL queried columns
CREATE INDEX idx_trips_only_scan ON trips(driver_id, fare, status);

-- Re-run query
EXPLAIN ANALYZE
SELECT driver_id, fare, status FROM trips WHERE driver_id IN (1, 2, 3);

-- Should show:
-- Index Only Scan using idx_trips_only_scan
-- Heap Fetches: 0  ← SUCCESS!
```

### Lab 4: Bitmap Scan Scenario
**Create indexes for multi-condition query. Observe bitmap scan.**

```sql
-- Multi-condition query: Use bitmap scan
SELECT COUNT(*) FROM trips
WHERE (driver_id = 5 OR driver_id = 10)
AND (status = 'completed' OR status = 'cancelled')
AND fare > 25;
```

**Solution:**
```sql
-- Create indexes for each major condition
CREATE INDEX idx_trips_driver ON trips(driver_id);
CREATE INDEX idx_trips_status ON trips(status);
CREATE INDEX idx_trips_fare ON trips(fare);

-- Run EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT COUNT(*) FROM trips
WHERE (driver_id = 5 OR driver_id = 10)
AND (status = 'completed' OR status = 'cancelled')
AND fare > 25;

-- Expected output: Bitmap Heap Scan combining three indexes
```

### Lab 5: Pressure Scenario - Estimated 100, Actual 1,000,000
**PRESSURE: Planner estimates 100 rows but actually gets 1M. Query becomes O(n²). Fix.**

**Scenario:**
```sql
-- Planner: "This will return ~100 rows"
-- Reality: Returns 1,000,000 rows
-- Impact: Hash join plan becomes horrifically slow

EXPLAIN ANALYZE
SELECT t.*, r.rating
FROM trips t
LEFT JOIN reviews r ON t.id = r.trip_id
WHERE t.started_at > NOW() - INTERVAL '1 day';

-- Output:
Hash Join
  Hash Cond: (t.id = r.trip_id)
  Rows: 100 (estimated)   ← WRONG!
  Actual Rows: 1000000    ← ACTUAL!
  Buffers: reads=50000, writes=20000  ← Disk thrashing!
```

**Root Cause:** Statistics stale. High cardinality column (`started_at`) has no index.

**Solution:**
```sql
-- 1. Refresh statistics aggressively
ANALYZE trips(started_at);

-- 2. Create statistics on expression (if needed)
CREATE STATISTICS started_at_stats ON started_at FROM trips;

-- 3. Add index for common date filter
CREATE INDEX idx_trips_started_at ON trips(started_at DESC);

-- 4. Replan
EXPLAIN ANALYZE
SELECT t.*, r.rating
FROM trips t
LEFT JOIN reviews r ON t.id = r.trip_id
WHERE t.started_at > NOW() - INTERVAL '1 day';
-- Should now estimate closer to 1M rows and choose streaming (merge join)
```

---

## 🔍 Deep Dive: Execution Plan & B-Tree Internals

### B-Tree Structure Breakdown

```
         Root (Block 73)
        [150, 300, 450]  ← Branch values, max 3 keys/node
       /       |        \
   [1-149]  [150-299]  [300-449]  [450+]  ← Internal nodes
     |         |          |         |
  Leaf Nodes (Actual data pages)
  [1,5,12,15,..] [150,156,198,...] etc.
```

**Index Lookup: Find driver_id = 250**
1. Start at root: 250 > 150? Yes. 250 > 300? No. → Go to middle node.
2. Middle node: 250 > 150? Yes. 250 > 300? No. → Go to leaf.
3. Leaf: Scan for 250 → Found → Return heap pointer.

**Cost: O(log n) tree traversals + 1 heap fetch.**

### Execution Plan Tree (Real Example)

```sql
SELECT d.name, COUNT(t.id)
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
WHERE d.city = 'NYC'
GROUP BY d.id, d.name;
```

**Plan Tree:**

```
                    HashAggregate
                    /            \
              GROUP BY        Hash Join
              (aggregate)     /         \
                           Seq Scan    Seq Scan
                         (drivers)    (trips)
                         Filter:
                       d.city='NYC'
```

**Reading it bottom-up:**
1. Seq Scan on drivers (filter city = 'NYC') → ~500 rows.
2. Seq Scan on trips (all rows) → ~100,000 rows.
3. Hash Join: Load 500 drivers into hash table, probe trips → 100k probes.
4. HashAggregate: Combine rows, count per driver.

---

## 🔥 Pressure Scenario: Estimated 100, Actual 1,000,000

**Production Alert:** Query planner estimates 100 rows, but realizes 1M rows mid-execution. Query switches to disk-spilling hash join, crawls.

### Diagnosis Steps

```sql
-- 1. Run EXPLAIN (plan) vs EXPLAIN ANALYZE (plan + actual)
EXPLAIN (ANALYZE, BUFFERS)
SELECT t.id, d.name, r.rating
FROM trips t
JOIN drivers d ON t.driver_id = d.id
LEFT JOIN reviews r ON t.id = r.trip_id
WHERE t.started_at > NOW() - INTERVAL '1 day';

-- 2. Look for: "Actual Rows" >> "Rows" (estimated)
-- 3. Check if joining memory-resident hash table with unexpectedly large probes

-- 4. Examine statistics on join key
SELECT attname, n_distinct, most_common_vals
FROM pg_stats
WHERE tablename = 'trips' AND attname = 'started_at';
```

### Root Cause

**Statistics for `started_at` are stale.** Last ANALYZE was 1 week ago; data has changed.

```sql
-- Before ANALYZE: Planner thinks 1-day trips = 100 rows
-- After 1M rows inserted for today: Actually 1M rows but planner doesn't know

-- Memory-resident hash table assumes 100 rows:
-- Hash Table Size = 100 rows × avg_width ≈ 10KB
-- Reality: 1M rows × avg_width ≈ 100MB → spills to disk!
```

### Solution

```sql
-- 1. IMMEDIATE: Force replan with current stats
ANALYZE trips;

-- 2. LONG-TERM: Rebuild statistics regularly
-- In PostgreSQL: Set auto ANALYZE or cron job
ALTER TABLE trips SET (autovacuum_analyze_scale_factor = 0.01);
-- Triggers ANALYZE when 1% of rows change

-- 3. OPTIONAL: Hint the planner (if using pg_hint_plan extension)
/*+ HashJoin(t r) */ -- Force hash join
SELECT ...;

-- 4. OPTIONAL: Pre-aggregate if possible
WITH recent_trips AS (
  SELECT id, driver_id FROM trips
  WHERE started_at > NOW() - INTERVAL '1 day'
)
SELECT rt.id, d.name, r.rating
FROM recent_trips rt
JOIN drivers d ON rt.driver_id = d.id
LEFT JOIN reviews r ON rt.id = r.trip_id;
```

---

## ✅ Recap Checklist

- [ ] Understand B-Tree structure & search cost O(log n)
- [ ] Know PostgreSQL uses heap tables (every index → heap fetch)
- [ ] Can read EXPLAIN output: cost, rows, actual rows, buffers
- [ ] Understand index-only scan (0 heap fetches = fast)
- [ ] Can spot bitmap scan scenario (multiple indexes combined)
- [ ] Know VACUUM ANALYZE updates statistics
- [ ] Understand cost-based optimizer (seq_page_cost, random_page_cost)
- [ ] Can diagnose estimated rows ≠ actual rows
- [ ] Attempted Lab 1-5 without solutions
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) - From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** - Please like, subscribe and support the original creator!

---

## 🧭 Navigation

**← [Day 7: Views & Procedures](./day-07-views-procedures-triggers.md) | [Day 9: Partitions & Performance →](./day-09-partitions-performance.md)**

---

*Last updated: 12 March 2026 | [Bootcamp Home](../README.md)*
