# 🏗️ Day 2: DDL, DML & Filtering — Building and Modifying Data
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) – From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** — Please like, subscribe and support the original creator!

---

## 📊 Quick Stats

| Metric | Value |
|--------|-------|
| **Video Duration** | 1h 15m 26s |
| **Key Terms** | 10 |
| **Lab Exercises** | 5 |
| **Difficulty** | ⭐⭐ Intermediate |

---

## 🕐 Daily Schedule

| Time | Activity | Duration | Focus |
|------|----------|----------|-------|
| **09:00–10:30** | Core Theory + Structured Watching | 90 min | DDL/DML fundamentals, ACID transactions |
| **10:30–10:40** | Transition Buffer | 10 min | Rest & notes review |
| **10:40–11:55** | Lab Engineering | 75 min | Progressive DDL/DML exercises |
| **11:55–12:05** | Transition Buffer | 10 min | Hydrate & reset |
| **12:05–12:35** | Recap Session | 30 min | Consolidate learning |
| **12:35–12:45** | Transition Buffer | 10 min | Mental break |
| **12:45–13:30** | Deep Dive / Engine Thinking | 45 min | MVCC and physical storage |
| **13:30–13:40** | Transition Buffer | 10 min | Prepare for assessment |
| **13:40–14:10** | Quiz + Pressure Simulation | 30 min | Apply knowledge under pressure |

---

## 🎯 Core Focus Topics

### 1. DDL — Data Definition Language

**DDL** controls the *structure* of the database: creating, altering, and dropping tables, indexes, and schemas.

```sql
-- CREATE: Define a new table
CREATE TABLE trips (
    id BIGINT PRIMARY KEY,
    driver_id BIGINT NOT NULL,
    rider_id BIGINT NOT NULL,
    fare DECIMAL(10, 2),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ALTER: Modify table structure
ALTER TABLE trips ADD COLUMN rating INT;
ALTER TABLE trips DROP COLUMN rating;
ALTER TABLE trips RENAME TO ride_history;

-- DROP: Remove table entirely
DROP TABLE trips;

-- Safer: DROP IF EXISTS (doesn't error if table missing)
DROP TABLE IF EXISTS trips;
```

**Characteristics:**
- **Immediate effect:** Changes are committed automatically (auto-commit enabled)
- **Structural impact:** Affects the entire table/schema, not individual rows
- **Locking:** DDL often requires exclusive locks (table unavailable during ALTER)

---

### 2. DML — Data Manipulation Language

**DML** operates on the *data* inside tables: inserting, updating, and deleting rows.

```sql
-- INSERT: Add new rows
INSERT INTO drivers (id, name, rating, city) 
VALUES (1, 'Alice', 4.8, 'San Francisco');

-- Bulk insert
INSERT INTO drivers (id, name, rating, city) VALUES
    (2, 'Bob', 4.5, 'Los Angeles'),
    (3, 'Charlie', 4.9, 'New York');

-- UPDATE: Modify existing rows
UPDATE drivers 
SET rating = 4.9 
WHERE id = 1;

-- DELETE: Remove rows
DELETE FROM drivers 
WHERE city = 'Denver' AND rating < 3.0;
```

**Characteristics:**
- **Transactional:** Can be rolled back (unlike DDL)
- **Row-based:** Affects specific rows matching conditions
- **Performance-sensitive:** DELETE/UPDATE on large tables can be slow

---

### 3. WHERE Clause Mechanics — Predicate Evaluation

The WHERE clause filters rows using **predicates** (boolean conditions). Understanding predicate evaluation is crucial for both correctness and performance.

```sql
-- Simple predicate
SELECT * FROM trips WHERE status = 'completed';

-- Multiple predicates (AND = all must be true)
SELECT * FROM trips 
WHERE status = 'completed' 
  AND fare > 20.00
  AND driver_id = 5;

-- OR predicates (at least one true)
SELECT * FROM trips 
WHERE city = 'NYC' 
   OR city = 'LA';

-- NOT (negation)
SELECT * FROM trips 
WHERE status != 'cancelled';  -- equivalent to NOT status = 'cancelled'

-- Complex logic
SELECT * FROM trips 
WHERE (status = 'completed' OR status = 'pending')
  AND fare > 15.00
  AND (driver_id = 5 OR driver_id = 10);
```

**Predicate Pushdown Optimization:**
The optimizer pushes predicates as early as possible (before JOINs) to minimize rows processed:

```sql
-- Slow: Filter after join (processes many rows)
SELECT d.name, t.fare
FROM drivers d
JOIN trips t ON d.id = t.driver_id
WHERE d.city = 'NYC';  -- Filter applied AFTER join

-- Fast: Push predicate into drivers table scan
-- Optimizer rewrites this to filter drivers first, then join
-- Fewer rows to join = faster query
```

---

### 4. Transactions Basics — ACID Guarantees

A **transaction** is a sequence of SQL statements treated as a single unit. Transactions enforce ACID:

```sql
BEGIN TRANSACTION;

-- Multiple statements in one transaction
UPDATE drivers SET rating = 4.9 WHERE id = 1;
INSERT INTO drivers (id, name, rating) VALUES (999, 'Test', 4.0);
DELETE FROM drivers WHERE id = 999;  -- Oops, deleted test data

-- Entire transaction rolls back
ROLLBACK;

-- Or commit if everything worked
COMMIT;
```

**ACID Properties:**
- **Atomicity:** All-or-nothing; partial results never written
- **Consistency:** Database moves from one valid state to another
- **Isolation:** Concurrent transactions don't interfere
- **Durability:** Committed data survives crashes

```sql
-- Explicit transaction control
BEGIN;
  INSERT INTO trips (driver_id, rider_id, fare) VALUES (1, 5, 25.50);
  INSERT INTO payments (trip_id, amount) VALUES (CURRVAL('trips_id_seq'), 25.50);
COMMIT;  -- Both statements succeed or both fail

-- Savepoints for partial rollback
BEGIN;
  UPDATE drivers SET rating = 4.0 WHERE id = 1;
  SAVEPOINT sp1;
  UPDATE drivers SET rating = 3.0 WHERE id = 2;  -- Oops, mistake
  ROLLBACK TO sp1;  -- Undo only the second UPDATE
  UPDATE drivers SET rating = 4.5 WHERE id = 2;  -- Correct update
COMMIT;
```

---

### 5. NULL Handling in Filtering

**NULL** represents "unknown" or "missing" data. NULL behaves differently in WHERE clauses:

```sql
-- NULL comparisons don't work with =
SELECT * FROM drivers WHERE rating = NULL;  -- Returns 0 rows (incorrect!)

-- Use IS NULL / IS NOT NULL
SELECT * FROM drivers WHERE rating IS NULL;      -- Correct
SELECT * FROM drivers WHERE rating IS NOT NULL;  -- Correct

-- NULL in predicates: three-valued logic
SELECT * FROM drivers WHERE rating > 4.0;
-- Returns drivers with rating > 4.0
-- Does NOT return drivers with NULL rating (NULL > 4.0 is unknown)

-- Checking for missing data in filters
SELECT * FROM trips 
WHERE completed_at IS NOT NULL 
  AND status = 'completed';
```

---

## 📖 10 Terms of the Day

| Term | Definition | Why It Matters |
|------|-----------|---|
| **DDL** | Data Definition Language (CREATE, ALTER, DROP); defines schema structure | DDL is auto-committed and locks tables; plan DDL carefully |
| **DML** | Data Manipulation Language (INSERT, UPDATE, DELETE); modifies data | DML is transactional and can be rolled back; supports ACID guarantees |
| **TCL** | Transaction Control Language (COMMIT, ROLLBACK, SAVEPOINT); manages transactions | TCL ensures consistency; ROLLBACK prevents partial updates |
| **MVCC** | Multi-Version Concurrency Control; allows readers while writers modify data | MVCC enables isolation without locks; fundamental to PostgreSQL |
| **Dead Tuple** | Row version marked for deletion but not yet removed from disk | Dead tuples slow seq scans and increase disk usage; requires vacuuming |
| **Vacuum** | PostgreSQL maintenance process that removes dead tuples and reclaims space | Without VACUUM, disk bloat increases I/O; autovacuum should run regularly |
| **WAL** | Write-Ahead Logging; records changes to log before applying to pages | WAL ensures durability; can replay logs after crashes |
| **ACID** | Atomicity, Consistency, Isolation, Durability; database reliability guarantees | ACID protects against data loss and corruption; critical for production |
| **Predicate Filter** | WHERE condition applied to evaluate row membership | Predicates are applied early (pushed down) to minimize rows processed |
| **Tuple** | Single row in a table; PostgreSQL's term for row (has multiple versions in MVCC) | Understanding tuples (and tuple versions) explains MVCC and vacuuming |

---

## 🔧 Lab Engineering: Progressive SQL Exercises

### Exercise 1: Easy — Basic INSERT and Simple WHERE

**Task:** Insert 3 new drivers and retrieve only those in San Francisco.

**Solution:**
```sql
INSERT INTO drivers (id, name, rating, city, is_active, created_at) VALUES
    (1001, 'Emma', 4.7, 'San Francisco', true, CURRENT_TIMESTAMP),
    (1002, 'Frank', 4.3, 'San Francisco', true, CURRENT_TIMESTAMP),
    (1003, 'Grace', 4.9, 'Los Angeles', true, CURRENT_TIMESTAMP);

SELECT id, name, rating FROM drivers 
WHERE city = 'San Francisco';
```

**Learning:** INSERT specifies columns and values. WHERE filters results. Single predicate is straightforward.

---

### Exercise 2: Medium — UPDATE with Conditional Filtering

**Task:** Update ratings for all drivers in Los Angeles who haven't been active in 90+ days to mark them inactive.

**Solution:**
```sql
UPDATE drivers 
SET is_active = false
WHERE city = 'Los Angeles'
  AND created_at < NOW() - INTERVAL '90 days';
```

**Learning:** Multiple predicates in WHERE use AND logic. UPDATE applies to all matching rows.

---

### Exercise 3: Hard — DELETE with Complex Filtering & Transaction Safety

**Task:** Delete all cancelled trips from the last 30 days, but only for drivers no longer active. Use a transaction.

**Solution:**
```sql
BEGIN;
  DELETE FROM trips
  WHERE status = 'cancelled'
    AND completed_at >= NOW() - INTERVAL '30 days'
    AND driver_id IN (
        SELECT id FROM drivers WHERE is_active = false
    );
  
  -- Verify before committing
  SELECT COUNT(*) FROM trips WHERE status = 'cancelled';
  
COMMIT;
```

**Learning:** Subqueries filter using data from another table. BEGIN/COMMIT ensures all-or-nothing deletion.

---

### Exercise 4: Challenge — Multi-Table Consistency with Foreign Keys & Transactions

**Task:** Add a new trip, link it to an existing driver and rider, create a payment record, and ensure all are inserted atomically. Include a savepoint.

**Solution:**
```sql
BEGIN;
  -- Insert trip
  INSERT INTO trips (id, driver_id, rider_id, pickup_location, 
                     dropoff_location, fare, status, started_at) 
  VALUES (5001, 1, 101, '123 Market St', '456 Mission St', 35.50, 
          'completed', CURRENT_TIMESTAMP);
  
  SAVEPOINT sp_trip;
  
  -- Insert payment (linked to trip via foreign key)
  INSERT INTO payments (id, trip_id, amount, method, paid_at) 
  VALUES (8001, 5001, 35.50, 'credit_card', CURRENT_TIMESTAMP);
  
  SAVEPOINT sp_payment;
  
  -- Insert review
  INSERT INTO reviews (id, trip_id, reviewer_id, rating, comment, created_at) 
  VALUES (6001, 5001, 101, 5, 'Great driver!', CURRENT_TIMESTAMP);
  
COMMIT;
```

**Learning:** Multiple INSERT statements in one transaction guarantee consistency. Savepoints allow partial rollback.

---

### Exercise 5: Stretch — Bulk UPDATE with Cascading Logic & NULL Handling

**Task:** Recalculate and update driver ratings based on their last 100 completed trips (using a subquery). Set rating to NULL for drivers with fewer than 10 trips.

**Solution:**
```sql
-- Create a CTE with driver statistics
WITH recent_stats AS (
    SELECT 
        t.driver_id,
        COUNT(r.id) AS review_count,
        AVG(r.rating) AS avg_recent_rating
    FROM trips t
    LEFT JOIN reviews r ON t.id = r.trip_id
    WHERE t.status = 'completed'
      AND t.completed_at >= NOW() - INTERVAL '90 days'
    GROUP BY t.driver_id
)
UPDATE drivers d
SET rating = CASE 
    WHEN rs.review_count >= 10 THEN rs.avg_recent_rating
    ELSE NULL
  END
FROM recent_stats rs
WHERE d.id = rs.driver_id;
```

**Learning:** CTEs organize complex aggregations. CASE statements handle conditional logic. JOINs in UPDATE enable data-driven modifications. NULL used intentionally when insufficient data exists.

---

## 🧠 Deep Dive: MVCC and Physical UPDATE Process

### MVCC — Multi-Version Concurrency Control

MVCC allows **readers** to access data while **writers** modify it—no locks needed. PostgreSQL maintains multiple versions of each row.

```
Timeline:
T1 (10:00): Reader A starts transaction (snapshot at 10:00)
T2 (10:01): Writer B updates driver rating (creates new version)
T3 (10:02): Reader A queries drivers (still sees old version from 10:00)
T4 (10:03): Reader C starts transaction (snapshot at 10:03)
T5 (10:04): Reader C queries drivers (sees version from 10:03, includes B's update)

Mechanism:
────────────────────────────────────────
Row: Driver ID 1 "Alice"
────────────────────────────────────────
│ Version 1 (10:00) │ Version 2 (10:01) │
│ rating: 4.8       │ rating: 4.9       │
│ visible: ✓        │ visible: ✓        │
│ (T1-T3)           │ (T4+)             │
────────────────────────────────────────

Reader A (T1) sees Version 1.
Reader C (T4) sees Version 2.
```

**Benefits:**
- Readers never lock writers (no blocking)
- Writers never lock readers
- Snapshot isolation: each transaction sees a consistent view

---

### Physical UPDATE Process — What Really Happens

When you UPDATE a row, PostgreSQL doesn't modify it in-place. Instead:

1. **Mark old version as invalid** for new transactions
2. **Create new version** at new location on disk
3. **Update index pointers** to new row location
4. **Mark old version as dead tuple** (candidate for vacuum)

```
UPDATE drivers SET rating = 4.9 WHERE id = 1;

Before:
┌──────────────────┐
│ Page 1           │
│ Row 1: ID=1      │
│   rating=4.8     │
│   xmax=0 (valid) │
└──────────────────┘

After:
┌──────────────────┐          ┌──────────────────┐
│ Page 1 (OLD)     │          │ Page 2 (NEW)     │
│ Row 1: ID=1      │          │ Row N: ID=1      │
│   rating=4.8     │ ──────→  │   rating=4.9     │
│   xmax=456       │ marked   │   xmax=0 (valid) │
│   (dead tuple)   │ invalid  │                  │
└──────────────────┘          └──────────────────┘

Index pointer: updated to point to new location (Page 2, Row N)
```

**Cost of UPDATE:**
- Writes new row version (I/O cost)
- Updates indexes (additional I/O)
- Old version remains until VACUUM (disk bloat)

---

### Why DELETE Doesn't Immediately Remove Rows

DELETE sets a **xmax** timestamp on the row, marking it as deleted for future transactions—but the row remains on disk.

```sql
DELETE FROM drivers WHERE id = 1;

Result (in storage):
┌──────────────────┐
│ Page 1           │
│ Row 1: ID=1      │
│   rating=4.9     │
│   xmax=500       │ ← marked as deleted
│   (dead tuple)   │ ← still takes disk space
└──────────────────┘

-- Row is invisible to new transactions
-- But still occupies disk space until VACUUM runs
```

**Why not delete immediately?**
- Other transactions might still see old version (MVCC)
- Immediate delete would break snapshot isolation
- VACUUM runs later to reclaim space

---

### Table Bloat — The Hidden Problem

Without regular VACUUM, dead tuples accumulate, causing **bloat**:

```sql
-- Before VACUUM
SELECT pg_size_pretty(pg_total_relation_size('drivers'));
-- Result: 256 MB (includes dead tuples)

SELECT COUNT(*) FROM drivers;
-- Result: 5,000 live rows

-- Space per row: 256 MB / 5,000 = 51 KB per row (!!)
-- Should be ~1 KB, indicating ~50x bloat

VACUUM drivers;  -- Reclaim space

-- After VACUUM
SELECT pg_size_pretty(pg_total_relation_size('drivers'));
-- Result: 5 MB (dead tuples removed)

-- Space per row: 5 MB / 5,000 = 1 KB ✓
```

---

## 🚨 Pressure Scenario: Table Size Keeps Growing Even After DELETEs

### Scenario
You delete 10 million old records from the `trips` table, but disk usage doesn't decrease:

```sql
-- Delete old cancelled trips (should free space)
DELETE FROM trips WHERE status = 'cancelled' AND created_at < '2025-01-01';
-- Deleted: 10,000,000 rows

-- Check size
SELECT pg_size_pretty(pg_total_relation_size('trips'));
-- Before DELETE: 5 GB
-- After DELETE: 5 GB (unchanged!)  ← Problem!
```

### Step-by-Step Diagnosis

**Step 1: Confirm dead tuples exist**
```sql
-- Check for dead tuples
SELECT schemaname, tablename, last_vacuum, n_dead_tup 
FROM pg_stat_user_tables 
WHERE tablename = 'trips';

-- Output: n_dead_tup = 10,000,000 (dead tuples, not vacuumed yet)
```

**Step 2: Check autovacuum status**
```sql
SELECT * FROM pg_stat_user_tables WHERE tablename = 'trips';
-- last_vacuum: timestamp of last VACUUM
-- If NULL, table has never been explicitly vacuumed

-- Check autovacuum is enabled:
SHOW autovacuum;  -- Should be 'on'
```

**Step 3: Check autovacuum thresholds**
```sql
-- May need tuning if autovacuum hasn't triggered
SHOW autovacuum_vacuum_threshold;      -- Default: 50
SHOW autovacuum_vacuum_scale_factor;   -- Default: 0.1

-- For large tables, thresholds might be too high
-- Table needs (50 + 0.1 * 10,000,000) = 1,000,050 dead tuples to trigger
```

### Solution SQL

```sql
-- Immediate: Manual VACUUM (reclaims space, releases to OS)
VACUUM (VERBOSE, ANALYZE) trips;

-- Result:
-- INFO: vacuuming "public.trips"
-- INFO: scanned index "trips_pkey" 
-- INFO: removed 10000000 dead row versions
-- Space freed!

-- For very large tables, VACUUM FULL is stronger but locks table
-- Only use during maintenance window:
VACUUM FULL ANALYZE trips;  -- Exclusive lock!

-- Long-term: Tune autovacuum for this table
ALTER TABLE trips SET (autovacuum_vacuum_scale_factor = 0.05);
ALTER TABLE trips SET (autovacuum_vacuum_threshold = 100);
-- Lower thresholds = VACUUM runs more frequently = less bloat
```

### Lessons Learned
1. **DELETE doesn't free space immediately**; VACUUM is required
2. **Autovacuum may not run fast enough** for high-churn tables
3. **Bloated tables slow down seq scans** (more pages to read)
4. **Monitor `pg_stat_user_tables.n_dead_tup`** to catch bloat early
5. **Schedule VACUUM FULL** during maintenance windows (causes locks)

---

## ✅ Recap Checklist

- [ ] Define DDL and explain why DDL changes are auto-committed
- [ ] Define DML and explain transactional guarantees (ACID)
- [ ] Write INSERT statements for single and bulk data
- [ ] Write UPDATE statements with multiple WHERE predicates
- [ ] Write DELETE statements and understand transaction safety
- [ ] Explain NULL behavior in WHERE clauses (three-valued logic)
- [ ] Understand MVCC: multiple row versions, snapshot isolation
- [ ] Explain physical UPDATE process (new version, mark old as dead tuple)
- [ ] Explain why DELETE doesn't immediately free space (MVCC)
- [ ] Diagnose table bloat using `pg_stat_user_tables` and fix with VACUUM

---

## 🔗 Navigation

[**← Day 1: SQL Foundations**](./day-01-sql-foundations.md) | [**Day 3: Joins**](./day-03-joins.md) →

**Repository:** [sql-mastery-bootcamp](https://github.com/your-username/sql-mastery-bootcamp)
