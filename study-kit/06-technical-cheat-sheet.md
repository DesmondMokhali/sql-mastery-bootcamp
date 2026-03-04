# ⚡ 2-Page Technical Cheat Sheet
**Quick Reference for SQL Syntax & Performance Tips**

---

## 📌 SQL Syntax Quick Reference

### SELECT & Filtering

```sql
-- Basic SELECT
SELECT col1, col2 FROM table_name;
SELECT * FROM table_name;
SELECT DISTINCT col1 FROM table_name;

-- WHERE conditions
WHERE col > 5
WHERE col BETWEEN 1 AND 10
WHERE col IN (1, 2, 3)
WHERE col LIKE 'pattern%'
WHERE col IS NULL
WHERE col IS NOT NULL
WHERE col1 = col2 OR col1 != col2

-- ORDER & LIMIT
ORDER BY col1 ASC, col2 DESC
LIMIT 10 OFFSET 5  -- Skip 5, return next 10

-- CASE expression
CASE 
  WHEN condition1 THEN value1
  WHEN condition2 THEN value2
  ELSE default_value
END

-- NULL handling
COALESCE(col, 0)  -- Return first non-NULL
NULLIF(col1, col2)  -- Return NULL if col1=col2
```

---

## 🔗 All JOIN Syntax

```sql
-- INNER JOIN (only matches)
SELECT * FROM drivers d
INNER JOIN trips t ON d.id = t.driver_id;

-- LEFT JOIN (all left + matches)
SELECT * FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id;

-- RIGHT JOIN (all right + matches)
SELECT * FROM trips t
RIGHT JOIN drivers d ON t.driver_id = d.id;

-- FULL OUTER JOIN (all from both)
SELECT * FROM drivers d
FULL OUTER JOIN trips t ON d.id = t.driver_id;

-- CROSS JOIN (all combinations)
SELECT * FROM drivers d
CROSS JOIN riders r;
-- Same as: FROM drivers, riders

-- Self-join (table to itself)
SELECT d1.name, d2.name
FROM drivers d1
JOIN drivers d2 ON d1.city = d2.city AND d1.id < d2.id;

-- Multiple JOINs
SELECT * FROM drivers d
JOIN trips t ON d.id = t.driver_id
JOIN reviews r ON t.id = r.trip_id
WHERE d.is_active = true;
```

---

## 📊 Aggregation & GROUP BY

```sql
-- Aggregates
COUNT(*)           -- All rows
COUNT(col)         -- Non-NULL rows
SUM(col)           -- Total
AVG(col)           -- Average
MIN(col), MAX(col) -- Minimum, maximum
STDDEV(col)        -- Standard deviation
STRING_AGG(col, ',') -- Concatenate strings

-- GROUP BY
SELECT driver_id, COUNT(*) as trip_count
FROM trips
GROUP BY driver_id;

-- GROUP BY multiple columns
SELECT driver_id, status, COUNT(*)
FROM trips
GROUP BY driver_id, status;

-- HAVING (filter aggregates)
SELECT driver_id, COUNT(*) as trip_count
FROM trips
GROUP BY driver_id
HAVING COUNT(*) > 10;

-- WHERE vs HAVING
WHERE col > 5      -- Filter rows before GROUP BY
HAVING COUNT(*) > 10  -- Filter groups after GROUP BY
```

---

## 🪟 Window Function Syntax

```sql
-- Basic window function
SELECT 
  driver_id,
  fare,
  ROW_NUMBER() OVER (ORDER BY fare DESC) as rn
FROM trips;

-- With PARTITION BY
SELECT 
  driver_id,
  fare,
  ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY fare DESC) as rank_in_driver
FROM trips;

-- Window functions
ROW_NUMBER()           -- 1, 2, 3, 4, 5
RANK()                 -- 1, 2, 2, 4, 5 (ties skip)
DENSE_RANK()           -- 1, 2, 2, 3, 4 (ties no skip)
LAG(col, 1)            -- Previous row's value
LEAD(col, 1)           -- Next row's value
FIRST_VALUE(col)       -- First row in frame
LAST_VALUE(col)        -- Last row in frame

-- Aggregates as window functions
SUM(col) OVER (ORDER BY date)  -- Running total
AVG(col) OVER (PARTITION BY driver_id)  -- Per-group average
COUNT(*) OVER (PARTITION BY city)  -- Count per city

-- Frame specification
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  -- Running
ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING  -- Sliding 5-row window
ROWS UNBOUNDED PRECEDING  -- From start to current (default)

-- NTH_VALUE, PERCENT_RANK
NTH_VALUE(col, 2) OVER (ORDER BY col)  -- 2nd value in frame
PERCENT_RANK() OVER (ORDER BY col)  -- 0.0-1.0
CUME_DIST() OVER (ORDER BY col)  -- Cumulative distribution
NTILE(4) OVER (ORDER BY col)  -- Quartile (1-4)
```

---

## 📋 CTE (WITH Clause) Syntax

```sql
-- Single CTE
WITH cte_name AS (
  SELECT col1, col2 FROM table_name
)
SELECT * FROM cte_name;

-- Multiple CTEs
WITH cte1 AS (
  SELECT driver_id, AVG(fare) as avg_fare FROM trips GROUP BY driver_id
),
cte2 AS (
  SELECT driver_id, COUNT(*) as trip_count FROM trips GROUP BY driver_id
)
SELECT cte1.*, cte2.trip_count
FROM cte1
JOIN cte2 ON cte1.driver_id = cte2.driver_id;

-- Recursive CTE (generate sequences, tree walk)
WITH RECURSIVE numbers AS (
  SELECT 1 as n
  UNION ALL
  SELECT n + 1 FROM numbers WHERE n < 100
)
SELECT * FROM numbers;
```

---

## 🏗️ Database Objects

### Views
```sql
CREATE VIEW vw_name AS SELECT ...;
CREATE MATERIALIZED VIEW mv_name AS SELECT ...;
DROP VIEW vw_name;
REFRESH MATERIALIZED VIEW mv_name;
```

### Stored Procedures (PostgreSQL)
```sql
CREATE PROCEDURE proc_name(param1 INT, param2 VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO table_name VALUES (param1, param2);
  COMMIT;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Error: %', SQLERRM;
  ROLLBACK;
END;
$$;

CALL proc_name(5, 'value');
```

### Triggers
```sql
CREATE TRIGGER trigger_name
BEFORE INSERT ON table_name
FOR EACH ROW
EXECUTE FUNCTION trigger_function();

CREATE FUNCTION trigger_function()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_table VALUES (NEW.id, NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### Indexes
```sql
-- Basic index
CREATE INDEX idx_name ON table_name(col1);

-- Composite index
CREATE INDEX idx_name ON table_name(col1, col2);

-- Covering index (includes extra columns)
CREATE INDEX idx_name ON table_name(col1) INCLUDE (col2, col3);

-- Unique index
CREATE UNIQUE INDEX idx_name ON table_name(col1);

-- Partial index (conditional)
CREATE INDEX idx_name ON table_name(col1) WHERE status = 'active';

-- Drop index
DROP INDEX idx_name;
```

---

## 🔍 EXPLAIN & PERFORMANCE

### EXPLAIN ANALYZE Reading Guide

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM trips WHERE driver_id = 5;

-- Output:
Seq Scan on trips  (cost=0.00..45.67 rows=12 width=100)
  Filter: (driver_id = 5)
  Actual Rows: 256  ← MISMATCH! Stats stale
  Buffers: shared hit=10, read=5  ← 10 in-memory, 5 disk
  Planning Time: 0.234 ms
  Execution Time: 45.123 ms

-- Interpretation:
cost=0.00..45.67     = startup=0.00, total=45.67 (cost units)
rows=12              = estimated rows
Actual Rows=256      = real rows (vs estimated)
Buffers: shared hit  = cache hits (fast)
Buffers: read        = disk reads (slow)
```

### Key Metrics to Watch

```
Index Scan vs Seq Scan?
  → If table < 10k rows, Seq Scan OK
  → If filtering < 5% rows, Index Scan better

Heap Fetches: X
  → 0 = perfect (index-only scan)
  → > 1000 = maybe add INCLUDE to index

Rows mismatch (estimated vs actual)?
  → Run ANALYZE table_name;
  → Check statistics: SELECT * FROM pg_stats WHERE tablename='table';

Memory vs Disk?
  → Buffers: hit >> read = good (cache)
  → Buffers: read >> hit = bad (disk bound)
```

---

## 🖥️ PostgreSQL System Commands

```sql
-- Database & connection
\l                           -- List databases
\c database_name             -- Connect to database
\d                           -- List tables
\d table_name                -- Describe table
\df                          -- List functions

-- Statistics
VACUUM ANALYZE table_name;   -- Update stats
SELECT * FROM pg_stats WHERE tablename='table_name';  -- View stats

-- Configuration
SHOW work_mem;               -- Show current setting
SET work_mem = '1GB';        -- Set for session
ALTER DATABASE db SET work_mem = '1GB';  -- Permanent

-- Query diagnostics
EXPLAIN (ANALYZE, BUFFERS) SELECT ...;  -- Full analysis
EXPLAIN (FORMAT json) SELECT ...;  -- JSON output

-- Index info
SELECT * FROM pg_indexes WHERE tablename='table_name';  -- List indexes
SELECT * FROM pg_stat_user_indexes;  -- Index usage stats

-- Slow query log (if enabled)
SELECT query, mean_exec_time FROM pg_stat_statements
ORDER BY mean_exec_time DESC LIMIT 10;  -- Top slow queries
```

---

## 🚀 Top 15 Performance Quick-Wins

| # | Optimization | Impact | Effort |
|---|---|---|---|
| 1 | **Index WHERE columns** | 10-100x | 1 min |
| 2 | **Index JOIN keys (FK)** | 5-50x | 1 min |
| 3 | **Use INNER not LEFT** (if possible) | 2-5x | 2 min |
| 4 | **LIMIT early in aggregation** | 5-10x | 3 min |
| 5 | **Filter before GROUP BY** | 2-10x | 3 min |
| 6 | **Move filter into CTE** | 3-10x | 2 min |
| 7 | **Use DISTINCT ON not GROUP BY** (if possible) | 2-3x | 3 min |
| 8 | **Pre-aggregate large tables** | 10-100x | 10 min |
| 9 | **Partition by date/range** | 2-10x | 30 min |
| 10 | **Make index covering (INCLUDE)** | 2-5x | 3 min |
| 11 | **Increase work_mem** (if sorting/hashing) | 2-10x | 2 min |
| 12 | **Run VACUUM ANALYZE** (stale stats) | 2-10x | 1 min |
| 13 | **Use EXISTS not IN** (with subquery) | 2-5x | 2 min |
| 14 | **SELECT only needed columns** | 1-2x | 1 min |
| 15 | **Avoid expression in WHERE** (e.g., EXTRACT) | 2-5x | 5 min |

---

## 🎯 NULL Handling Patterns

```sql
-- NULL comparisons
NULL = NULL          -- Returns NULL (not true!)
NULL IS NULL         -- Returns true
col IS NOT NULL      -- Check for non-NULL
COALESCE(col, 0)     -- Replace NULL with 0

-- NULL in aggregates
SELECT COUNT(col)    -- Excludes NULLs
SELECT COUNT(*)      -- Includes NULLs
SELECT SUM(col)      -- Returns NULL if all input is NULL
SELECT AVG(col)      -- Same (excludes NULLs)

-- NULL in conditions
WHERE col IN (1, NULL)    -- Only matches 1 (NULL ignored in IN)
WHERE col NOT IN (1, NULL) -- Always false! (NULL breaks NOT IN)
                           -- Fix: Use NOT EXISTS instead

-- NULL in CASE
CASE WHEN col = NULL THEN 'yes'  -- Never true (NULL != NULL)
CASE WHEN col IS NULL THEN 'yes' -- Correct
```

---

## 📈 CASE Expression Patterns

```sql
-- Simple CASE (when you know the value)
CASE status
  WHEN 'completed' THEN 'Success'
  WHEN 'cancelled' THEN 'Failed'
  ELSE 'Unknown'
END

-- Searched CASE (for conditions)
CASE
  WHEN fare > 100 THEN 'Expensive'
  WHEN fare > 50 THEN 'Moderate'
  ELSE 'Cheap'
END

-- CASE in aggregation
SELECT 
  SUM(CASE WHEN status='completed' THEN fare ELSE 0 END) as completed_revenue,
  SUM(CASE WHEN status='cancelled' THEN fare ELSE 0 END) as cancelled_revenue
FROM trips;

-- CASE for conditional grouping
SELECT
  CASE WHEN fare > 50 THEN 'High' ELSE 'Low' END as price_category,
  COUNT(*)
FROM trips
GROUP BY CASE WHEN fare > 50 THEN 'High' ELSE 'Low' END;
```

---

## 🔐 Transaction & Lock Patterns

```sql
-- Transaction (all-or-nothing)
BEGIN;
  UPDATE table1 SET col1 = value1;
  UPDATE table2 SET col2 = value2;
COMMIT;

-- Rollback on error
BEGIN;
  INSERT INTO table1 VALUES (...);
  -- If error: ROLLBACK (automatic on exception)
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
END;

-- Isolation levels
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;  -- Strictest (slowest)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  -- Default (fastest)

-- Locks
LOCK TABLE table_name IN EXCLUSIVE MODE;  -- Prevent all access
LOCK TABLE table_name IN ACCESS EXCLUSIVE MODE;  -- Most restrictive
```

---

## 📊 Common Patterns & Anti-Patterns

### ❌ ANTI-PATTERNS

```sql
-- 1. Correlated subquery (N+1 problem)
SELECT * FROM trips t
WHERE fare > (SELECT AVG(fare) FROM trips WHERE driver_id = t.driver_id);
-- Slow: Runs subquery per outer row

-- 2. Expression in WHERE (no index use)
SELECT * FROM trips WHERE EXTRACT(MONTH FROM started_at) = 3;
-- Slow: Can't use index on started_at

-- 3. NOT IN with NULL
SELECT * FROM drivers WHERE id NOT IN (SELECT id FROM trips WHERE driver_id IS NULL);
-- Wrong: Returns 0 rows (NULL breaks NOT IN)

-- 4. Using function on indexed column
SELECT * FROM trips WHERE LOWER(status) = 'completed';
-- Slow: Can't use index on status (function applied)
```

### ✅ BETTER PATTERNS

```sql
-- 1. Use JOIN instead of correlated subquery
WITH driver_avgs AS (
  SELECT driver_id, AVG(fare) as avg_fare FROM trips GROUP BY driver_id
)
SELECT t.* FROM trips t
JOIN driver_avgs da ON t.driver_id = da.driver_id
WHERE t.fare > da.avg_fare;

-- 2. Pre-filter with expression, then use index
SELECT * FROM trips 
WHERE started_at >= '2026-03-01' AND started_at < '2026-04-01';
-- Fast: Index on started_at can be used

-- 3. Use NOT EXISTS
SELECT * FROM drivers d
WHERE NOT EXISTS (SELECT 1 FROM trips WHERE driver_id = d.id);

-- 4. Use correct case, avoid functions on columns
SELECT * FROM trips WHERE status = 'completed';
-- Fast: Index on status can be used
```

---

## 📝 Quick Syntax Reminders

| Task | Syntax |
|------|--------|
| Select last N rows | `ORDER BY col DESC LIMIT N` |
| Rank rows | `ROW_NUMBER() OVER (ORDER BY col)` |
| Running total | `SUM(col) OVER (ORDER BY col ROWS UNBOUNDED PRECEDING)` |
| Top N per group | `WHERE rn <= N` after ROW_NUMBER by group |
| Remove duplicates | `SELECT DISTINCT ...` or `GROUP BY ...` |
| Concatenate strings | `STRING_AGG(col, ',')` |
| Pivot table | Use CASE in SELECT + GROUP BY |
| Set operations | `UNION / INTERSECT / EXCEPT` |
| Sub-second timestamp | `NOW()` or `CURRENT_TIMESTAMP` |
| Date arithmetic | `date_col + INTERVAL '1 day'` |
| Type conversion | `CAST(col AS TYPE)` or `col::TYPE` |

---

*Last updated: 13 March 2026 | Bookmark this page!*
