# 📚 Day 1: SQL Foundations - Building the Mental Model
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) - From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** - Please like, subscribe and support the original creator!

---

## 📊 Quick Stats

| Metric | Value |
|--------|-------|
| **Video Duration** | 1h 32m 31s |
| **Key Terms** | 10 |
| **Lab Exercises** | 5 |
| **Difficulty** | ⭐ Beginner |

---

## 🕐 Daily Schedule

| Time | Activity | Duration | Focus |
|------|----------|----------|-------|
| **09:00-10:30** | Core Theory + Structured Watching | 90 min | Database fundamentals, logical query processing |
| **10:30-10:40** | Transition Buffer | 10 min | Rest & notes review |
| **10:40-11:55** | Lab Engineering | 75 min | Progressive SQL exercises |
| **11:55-12:05** | Transition Buffer | 10 min | Hydrate & reset |
| **12:05-12:35** | Recap Session | 30 min | Consolidate learning |
| **12:35-12:45** | Transition Buffer | 10 min | Mental break |
| **12:45-13:30** | Deep Dive / Engine Thinking | 45 min | Storage engine internals |
| **13:30-13:40** | Transition Buffer | 10 min | Prepare for assessment |
| **13:40-14:10** | Quiz + Pressure Simulation | 30 min | Apply knowledge under pressure |

---

## 🎯 Core Focus Topics

### 1. Database vs Table vs Row vs Column - The Hierarchy

A **database** is a collection of related tables and metadata. Think of it as a filing cabinet. A **table** is a structured dataset with rows and columns-like a spreadsheet. A **row** (or tuple) is a single record. A **column** (or attribute) is a field.

```sql
-- Example: Uber-style drivers table structure
CREATE TABLE drivers (
    id BIGINT PRIMARY KEY,           -- column: unique identifier
    name VARCHAR(255),               -- column: driver name
    rating DECIMAL(3, 2),            -- column: numeric rating
    city VARCHAR(100),               -- column: location
    is_active BOOLEAN,               -- column: status flag
    created_at TIMESTAMP             -- column: registration time
);
-- One row = one driver record
```

**Why it matters:** Understanding the hierarchy helps you reason about data relationships and structure queries correctly.

---

### 2. Primary Key - The Foundation of Identity

A **Primary Key** is a column (or set of columns) that uniquely identifies each row. It enforces:
- **Uniqueness:** No two rows can have the same PK value
- **NOT NULL:** Every row must have a PK value
- **Clustered index:** In most DBs, PKs create a physical ordering

```sql
-- Good: Single column primary key
CREATE TABLE riders (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

-- Composite primary key (rare, but valid)
CREATE TABLE reviews (
    trip_id BIGINT,
    reviewer_id BIGINT,
    PRIMARY KEY (trip_id, reviewer_id)  -- combination is unique
);
```

**Why it matters:** PKs guarantee data integrity and enable efficient lookups. Queries can navigate the database reliably.

---

### 3. Logical Query Processing Order - How SQL "Thinks"

SQL doesn't execute in the order it's written. Instead, the database engine follows **Logical Query Processing Order:**

1. **FROM** - Which tables?
2. **WHERE** - Which rows?
3. **GROUP BY** - Aggregate rows
4. **HAVING** - Filter groups
5. **SELECT** - Which columns?
6. **ORDER BY** - Sort results
7. **LIMIT** - Top N rows

```sql
-- Example demonstrating logical order
SELECT 
    driver_id,
    COUNT(*) AS trip_count,
    AVG(fare) AS avg_fare
FROM trips
WHERE status = 'completed'  -- Step 2: Filter rows BEFORE grouping
GROUP BY driver_id          -- Step 3: Group rows
HAVING COUNT(*) > 10        -- Step 4: Filter groups (not rows!)
ORDER BY avg_fare DESC      -- Step 6: Sort by fare
LIMIT 5;                    -- Step 7: Top 5 results

-- Key insight: WHERE works on rows, HAVING works on groups
```

**Why it matters:** This order explains why you can't use aliases in WHERE (aliases come later in SELECT) and why you must aggregate in GROUP BY before HAVING filters.

---

### 4. SELECT Execution Flow - From Bytes to Results

When you run a SELECT query, the database:
1. **Finds candidate rows** using indexes or table scans
2. **Filters rows** (WHERE clause)
3. **Aggregates data** (GROUP BY)
4. **Filters aggregates** (HAVING)
5. **Projects columns** (SELECT)
6. **Sorts results** (ORDER BY)
7. **Limits output** (LIMIT)

```sql
-- Simple query: SELECT * FROM drivers WHERE city = 'San Francisco'
-- Flow:
-- (a) Find rows where city = 'San Francisco' (uses index if available)
-- (b) Fetch those rows from disk
-- (c) Return all columns (*)
-- (d) Apply LIMIT if specified
```

**Why it matters:** Understanding this flow helps you optimize queries and predict performance bottlenecks.

---

### 5. Intro to EXPLAIN - Reading the Query Plan

`EXPLAIN` shows the **query plan**-the engine's step-by-step strategy for executing your query.

```sql
EXPLAIN SELECT * FROM drivers WHERE city = 'San Francisco';

-- Output example (PostgreSQL):
-- Seq Scan on drivers  (cost=0.00..35.50 rows=10 width=100)
--   Filter: (city = 'San Francisco')
-- 
-- Interpretation:
-- - Sequential scan: checking every row
-- - cost: estimated CPU work (0.00 startup, 35.50 total)
-- - rows: estimated number of matching rows
-- - width: average row size in bytes

-- Better with an index:
CREATE INDEX idx_drivers_city ON drivers(city);
EXPLAIN SELECT * FROM drivers WHERE city = 'San Francisco';

-- Output:
-- Index Scan using idx_drivers_city on drivers
--   Index Cond: (city = 'San Francisco')
-- Much faster!
```

**Why it matters:** EXPLAIN reveals inefficiencies. If a query is slow, EXPLAIN shows why (seq scan instead of index scan, missing joins, etc.).

---

## 📖 10 Terms of the Day

| Term | Definition | Why It Matters |
|------|-----------|---|
| **Heap** | Unordered storage of table data on disk; rows stored as they're inserted | Most data is heap-based. Understanding heap scans explains sequential I/O |
| **Page** | Basic storage unit (8KB in PostgreSQL); holds multiple rows | I/O is measured in pages; fewer pages = faster queries |
| **Index** | Data structure (usually B-Tree) mapping column values to row locations | Indexes enable fast lookups without scanning entire table |
| **B-Tree** | Balanced tree structure (columns sorted); most common index type | Efficient range queries and sorted access; O(log n) lookup time |
| **Predicate** | Condition in WHERE/HAVING (e.g., `city = 'NYC'`) | Predicates determine which rows are processed; critical for performance |
| **Projection** | Choosing specific columns in SELECT | Projecting fewer columns reduces data transferred from disk |
| **Seq Scan** | Sequential scan; reading every row from heap start to end | Slow but correct; necessary when no index exists or condition isn't SARGable |
| **Index Scan** | Using an index to find rows instead of scanning heap | Fast for selective predicates; reduces I/O dramatically |
| **Logical Order** | SQL's conceptual execution order (FROM → WHERE → GROUP BY → SELECT) | Explains why certain syntax is invalid (aliases, aggregates placement) |
| **Physical Execution** | Actual steps the engine takes (may differ from logical order) | Engine optimizes physical execution; EXPLAIN reveals the actual plan |

---

## 🔧 Lab Engineering: Progressive SQL Exercises

**Database Setup:**
```sql
CREATE TABLE drivers (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255),
    rating DECIMAL(3, 2),
    city VARCHAR(100),
    is_active BOOLEAN,
    created_at TIMESTAMP
);

CREATE TABLE riders (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(100),
    created_at TIMESTAMP
);

CREATE TABLE trips (
    id BIGINT PRIMARY KEY,
    driver_id BIGINT,
    rider_id BIGINT,
    pickup_location VARCHAR(255),
    dropoff_location VARCHAR(255),
    fare DECIMAL(10, 2),
    status VARCHAR(50),
    started_at TIMESTAMP,
    completed_at TIMESTAMP
);

CREATE TABLE payments (
    id BIGINT PRIMARY KEY,
    trip_id BIGINT,
    amount DECIMAL(10, 2),
    method VARCHAR(50),
    paid_at TIMESTAMP
);

CREATE TABLE reviews (
    id BIGINT PRIMARY KEY,
    trip_id BIGINT,
    reviewer_id BIGINT,
    rating INT,
    comment TEXT,
    created_at TIMESTAMP
);
```

---

### Exercise 1: Easy - Basic Table Scan & SELECT

**Task:** Get the name and rating of all active drivers in San Francisco.

**Solution:**
```sql
SELECT name, rating
FROM drivers
WHERE is_active = true
  AND city = 'San Francisco';
```

**Learning:** This is a simple filtered SELECT. The engine will likely seq scan the `drivers` table (since we might not have an index yet) and apply both predicates.

---

### Exercise 2: Medium - Adding Conditions & WHERE Logic

**Task:** Find all trips that were completed in the last 30 days with fare > $25. Order by fare descending.

**Solution:**
```sql
SELECT id, driver_id, rider_id, fare, completed_at
FROM trips
WHERE status = 'completed'
  AND fare > 25.00
  AND completed_at >= NOW() - INTERVAL '30 days'
ORDER BY fare DESC;
```

**Learning:** Multiple predicates filter rows before sorting. The WHERE clause is evaluated before ORDER BY, following logical processing order.

---

### Exercise 3: Hard - Aggregation with GROUP BY

**Task:** List drivers with their trip count and average fare, but only for drivers with 5+ completed trips.

**Solution:**
```sql
SELECT 
    driver_id,
    COUNT(*) AS trip_count,
    AVG(fare) AS avg_fare
FROM trips
WHERE status = 'completed'
GROUP BY driver_id
HAVING COUNT(*) >= 5
ORDER BY avg_fare DESC;
```

**Learning:** Logical order is critical here. WHERE filters rows (before grouping), GROUP BY aggregates, and HAVING filters groups (after aggregation).

---

### Exercise 4: Challenge - Multiple Conditions & Complex Filtering

**Task:** Find active drivers in San Francisco with an average rating ≥ 4.5 who completed at least 10 trips in the last 60 days.

**Solution:**
```sql
SELECT 
    d.id,
    d.name,
    d.rating,
    COUNT(t.id) AS recent_trips,
    AVG(t.fare) AS avg_recent_fare
FROM drivers d
LEFT JOIN trips t 
    ON d.id = t.driver_id 
    AND t.status = 'completed'
    AND t.completed_at >= NOW() - INTERVAL '60 days'
WHERE d.is_active = true
  AND d.city = 'San Francisco'
  AND d.rating >= 4.5
GROUP BY d.id, d.name, d.rating
HAVING COUNT(t.id) >= 10
ORDER BY d.rating DESC;
```

**Learning:** JOIN conditions affect which rows are compared. Adding time filters to the JOIN ON (vs WHERE) changes which rows are included in aggregation.

---

### Exercise 5: Stretch - Multiple Aggregations & Subquery Thinking

**Task:** Find the top 3 drivers (by average rating) who completed trips in the last 30 days AND whose average fare was in the top quartile across all drivers. Include trip count and avg rating.

**Solution:**
```sql
WITH recent_trips AS (
    SELECT 
        driver_id,
        COUNT(*) AS trip_count,
        AVG(fare) AS avg_fare
    FROM trips
    WHERE status = 'completed'
      AND completed_at >= NOW() - INTERVAL '30 days'
    GROUP BY driver_id
),
fare_quartiles AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY avg_fare) AS q3_fare
    FROM recent_trips
)
SELECT 
    d.id,
    d.name,
    d.rating,
    rt.trip_count,
    rt.avg_fare
FROM drivers d
INNER JOIN recent_trips rt ON d.id = rt.driver_id
CROSS JOIN fare_quartiles fq
WHERE d.rating >= 4.5
  AND rt.avg_fare >= fq.q3_fare
ORDER BY d.rating DESC
LIMIT 3;
```

**Learning:** CTEs (Common Table Expressions) organize complex logic. Quartile calculations require nested aggregations. CROSS JOIN adds context without filtering.

---

## 🧠 Deep Dive: Storage Engine Internals

### Heap Storage - How Data Lives on Disk

The **heap** is PostgreSQL's default table storage. Data is unordered; rows are appended as inserted.

```
Heap Structure (simplified):
┌─────────────────────────────────────┐
│ Page 1 (8KB)                        │
│ ┌─ Row 1: Driver ID 1               │
│ ├─ Row 2: Driver ID 3               │
│ ├─ Row 3: Driver ID 2               │
│ └─ Row 4: Driver ID 5 (partial)     │
├─────────────────────────────────────┤
│ Page 2 (8KB)                        │
│ ├─ Row 4 (continued): Driver ID 5   │
│ ├─ Row 5: Driver ID 7               │
│ └─ ...                              │
└─────────────────────────────────────┘

Key: Rows are stored in insertion order, not sorted.
```

**Sequential Scan (Seq Scan):**
- Reads heap pages linearly from start to end
- Cost: O(n) - must check every row
- Acceptable for: Small tables, full-table aggregations
- Example: `SELECT COUNT(*) FROM drivers` (must count all rows)

---

### Index Scan - The B-Tree Advantage

An **index scan** uses a B-Tree to jump directly to relevant rows.

```
B-Tree Index (on city column):

                    ┌──────────────┐
                    │   Root Node   │
                    │  (A-M | N-Z)  │
                    └────┬─────┬────┘
                         │     │
            ┌────────────┘     └──────────────┐
            │                                 │
        ┌───┴───┐                         ┌───┴───┐
        │Leaf:A │                         │Leaf:N │
        │-M     │                         │-Z     │
        │Ptrs→  │                         │Ptrs→  │
        └───────┘                         └───────┘
            │                                 │
            ├─→ Row with city='Austin'       ├─→ Row with city='Seattle'
            └─→ Row with city='Denver'      └─→ Row with city='Toronto'

Key: Index is sorted by column value. Lookup is O(log n).
```

**Index Scan Benefits:**
- O(log n) lookup instead of O(n)
- Fetches only relevant pages
- Supports range queries (`city >= 'S'`)

**Example:**
```sql
-- Without index: Seq Scan (2 ms, checks 10k rows)
EXPLAIN SELECT * FROM drivers WHERE city = 'San Francisco';

-- With index: Index Scan (0.1 ms, checks ~5 rows)
CREATE INDEX idx_drivers_city ON drivers(city);
EXPLAIN SELECT * FROM drivers WHERE city = 'San Francisco';
```

---

### PostgreSQL 8KB Page Concept

Every I/O operation reads/writes one **page** (8KB). Understanding pages is key to performance:

```
Page Structure:

┌─────────────────────────────────────┐
│ Page Header (24 bytes)              │
│ - Page size, LSN, checksum          │
├─────────────────────────────────────┤
│ ItemPointer Array (row offsets)     │
│ - Pointer to Row 1: Offset 100      │
│ - Pointer to Row 2: Offset 250      │
├─────────────────────────────────────┤
│ Free Space                          │
│                                     │
├─────────────────────────────────────┤
│ Row Data (stored bottom-up)         │
│ Row 2: [Columns...]                 │
│ Row 1: [Columns...]                 │
└─────────────────────────────────────┘

One table scan of 10k rows = ~100 I/O operations (at 100 rows/page).
```

**Why it matters:**
- Queries touching fewer pages are faster
- Indexing can reduce pages read dramatically
- Compression reduces page count

---

## 🚨 Pressure Scenario: Primary Key Lookup Suddenly Slow

### Scenario
Your monitoring alerts trigger: "Driver lookup query spiked from 0.5ms to 150ms over 5 minutes."

```sql
-- This simple query is suddenly slow:
SELECT * FROM drivers WHERE id = 12345;
-- Previously: 0.5ms (index scan)
-- Now: 150ms (query is being rejected or slow-scanned)
```

### Step-by-Step Diagnosis

**Step 1: Check the query plan**
```sql
EXPLAIN ANALYZE SELECT * FROM drivers WHERE id = 12345;
-- Output shows: Seq Scan instead of Index Scan?
-- OR: Index Scan with high actual vs estimated rows?
```

**Step 2: Investigate the index**
```sql
-- Is the index corrupted or bloated?
SELECT * FROM pg_indexes WHERE tablename = 'drivers';

-- Check index size
SELECT pg_size_pretty(pg_relation_size('drivers_pkey'));
-- Unexpectedly large? Might indicate bloat.
```

**Step 3: Check lock contention**
```sql
-- Are other queries holding locks?
SELECT * FROM pg_locks WHERE relation = 'drivers'::regclass;
-- Long-running transaction blocking reads?
```

**Step 4: Monitor active queries**
```sql
SELECT query, state FROM pg_stat_activity 
WHERE state != 'idle';
-- Are many queries running? CPU/I/O saturation?
```

### Solution SQL

```sql
-- Immediate relief: Analyze table stats (may help query planner)
ANALYZE drivers;

-- If index is bloated, rebuild it:
REINDEX INDEX drivers_pkey;

-- If still slow, check for table bloat:
SELECT pg_size_pretty(pg_total_relation_size('drivers'));

-- Last resort: Vacuum full (exclusive lock, but clears bloat)
VACUUM FULL ANALYZE drivers;
```

### Lessons Learned
1. **Index bloat** can silently degrade performance; regular maintenance prevents this
2. **Lock contention** (not index issue) might be the culprit
3. **Stale statistics** cause the planner to choose seq scans; ANALYZE updates stats
4. **EXPLAIN ANALYZE** always reveals the truth; trust the plan, not assumptions

---

## ✅ Recap Checklist

- [ ] Understand the hierarchy: database → table → row → column
- [ ] Explain what a primary key guarantees (uniqueness, NOT NULL, fast access)
- [ ] Recite logical query processing order from memory (FROM→WHERE→GROUP BY→HAVING→SELECT→ORDER BY→LIMIT)
- [ ] Predict execution flow for a multi-condition SELECT query
- [ ] Read a basic EXPLAIN plan and identify seq scan vs index scan
- [ ] Describe heap storage and why rows aren't sorted
- [ ] Explain B-Tree index structure and log(n) lookups
- [ ] Understand why pages matter (8KB = one I/O unit in PostgreSQL)
- [ ] Diagnose slow primary key lookups using EXPLAIN and pg_indexes
- [ ] Know when seq scan is acceptable (small tables, full scans) vs when index is required

---

## 🔗 Navigation

← **Previous Day** | [**Day 2: DDL, DML & Filtering**](./day-02-ddl-dml-filtering.md) →

**Repository:** [sql-mastery-bootcamp](https://github.com/your-username/sql-mastery-bootcamp)
