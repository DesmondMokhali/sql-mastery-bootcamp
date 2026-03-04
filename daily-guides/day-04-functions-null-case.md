# ⚙️ Day 4: Functions, NULL & CASE - Transforming Data Safely
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) - From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** - Please like, subscribe and support the original creator!

---

## 📊 Quick Stats

| Metric | Value |
|--------|-------|
| **Video Duration** | 4h 41m 27s |
| **Key Terms** | 10 |
| **Lab Exercises** | 5 |
| **Difficulty** | ⭐⭐⭐ Advanced |

---

## 🕐 Daily Schedule

| Time | Activity | Duration | Focus |
|------|----------|----------|-------|
| **09:00-10:30** | Core Theory + Structured Watching | 90 min | Functions, NULL logic, CASE statements |
| **10:30-10:40** | Transition Buffer | 10 min | Rest & notes review |
| **10:40-11:55** | Lab Engineering | 75 min | Progressive function exercises |
| **11:55-12:05** | Transition Buffer | 10 min | Hydrate & reset |
| **12:05-12:35** | Recap Session | 30 min | Consolidate learning |
| **12:35-12:45** | Transition Buffer | 10 min | Mental break |
| **12:45-13:30** | Deep Dive / Engine Thinking | 45 min | Function optimization, index usage |
| **13:30-13:40** | Transition Buffer | 10 min | Prepare for assessment |
| **13:40-14:10** | Quiz + Pressure Simulation | 30 min | Apply knowledge under pressure |

---

## 🎯 Core Focus Topics

### 1. String Functions - Manipulating Text

String functions transform, extract, or analyze text data. Common ones:

```sql
-- UPPER / LOWER: Case conversion
SELECT UPPER('san francisco');  -- 'SAN FRANCISCO'
SELECT LOWER('SAN FRANCISCO');  -- 'san francisco'

-- LENGTH: Count characters
SELECT LENGTH('Alice');  -- 5
SELECT LENGTH(name) FROM drivers;

-- SUBSTRING: Extract portion
SELECT SUBSTRING('san francisco', 1, 3);  -- 'san'
SELECT SUBSTRING(email FROM POSITION('@' IN email) + 1);  -- Extract domain

-- CONCAT: Join strings
SELECT CONCAT('Driver ', name, ' in ', city);  -- 'Driver Alice in San Francisco'
SELECT name || ' (' || city || ')';  -- Same with ||

-- TRIM: Remove leading/trailing whitespace
SELECT TRIM('  Alice  ');  -- 'Alice'
SELECT LTRIM('---Alice', '-');  -- 'Alice'
SELECT RTRIM('Alice---', '-');  -- 'Alice'

-- REPLACE: Substitute text
SELECT REPLACE('San Francisco', 'San', 'North');  -- 'North Francisco'

-- SPLIT_PART / ARRAY operations
SELECT SPLIT_PART('Alice,Bob,Charlie', ',', 2);  -- 'Bob' (2nd element)
```

**Why it matters:** String functions enable data cleaning, validation, and formatting. Misused, they destroy index performance.

---

### 2. Numeric Functions - Math and Aggregation

Numeric functions perform calculations and transformations on numbers:

```sql
-- ROUND: Round to N decimal places
SELECT ROUND(25.567, 2);  -- 25.57
SELECT ROUND(25.567, 0);  -- 26

-- ABS: Absolute value
SELECT ABS(-15.5);  -- 15.5

-- CEIL / FLOOR: Round up or down
SELECT CEIL(25.2);  -- 26
SELECT FLOOR(25.9);  -- 25

-- MOD: Modulo (remainder)
SELECT MOD(17, 5);  -- 2 (17 = 3*5 + 2)

-- POWER / SQRT: Exponentiation and root
SELECT POWER(2, 3);  -- 8 (2^3)
SELECT SQRT(16);  -- 4

-- Random numbers
SELECT RANDOM() * 100;  -- Float between 0 and 100

-- Aggregate numeric functions (require GROUP BY or window functions)
SELECT AVG(fare), MIN(fare), MAX(fare), SUM(fare) FROM trips;
```

**Why it matters:** Numeric functions enable calculations for pricing, statistics, and business logic.

---

### 3. Date/Time Functions - Handling Temporal Data

Date functions manipulate timestamps and dates:

```sql
-- CURRENT_DATE / CURRENT_TIMESTAMP
SELECT CURRENT_DATE;       -- 2026-03-06
SELECT CURRENT_TIMESTAMP;  -- 2026-03-06 14:30:45.123456+00:00

-- EXTRACT: Get specific component
SELECT EXTRACT(YEAR FROM CURRENT_TIMESTAMP);    -- 2026
SELECT EXTRACT(MONTH FROM CURRENT_TIMESTAMP);   -- 3
SELECT EXTRACT(DAY FROM CURRENT_TIMESTAMP);     -- 6
SELECT EXTRACT(HOUR FROM CURRENT_TIMESTAMP);    -- 14

-- DATE_TRUNC: Round to specific unit
SELECT DATE_TRUNC('month', CURRENT_TIMESTAMP);  -- 2026-03-01 00:00:00
SELECT DATE_TRUNC('day', CURRENT_TIMESTAMP);    -- 2026-03-06 00:00:00

-- DATE_PART: Like EXTRACT (deprecated in PostgreSQL 14+, use EXTRACT)
SELECT DATE_PART('year', CURRENT_TIMESTAMP);

-- INTERVAL: Date arithmetic
SELECT CURRENT_TIMESTAMP - INTERVAL '7 days';    -- 7 days ago
SELECT CURRENT_TIMESTAMP + INTERVAL '1 month';   -- 1 month from now

-- AGE: Calculate difference between two timestamps
SELECT AGE(completed_at, started_at) FROM trips;  -- Duration as interval

-- TO_CHAR: Format dates
SELECT TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH:MI:SS');  -- '2026-03-06 14:30:45'

-- CAST / :: : Convert types
SELECT CAST(CURRENT_DATE AS TIMESTAMP);  -- Convert date to timestamp
SELECT CURRENT_DATE::TIMESTAMP;          -- Same with :: shorthand
```

**Why it matters:** Date functions are essential for time-series analysis, filtering by date range, and calculating durations.

---

### 4. NULL Behavior - Three-Valued Logic

NULL represents unknown or missing data. NULL has special rules:

```sql
-- NULL comparisons always return unknown (NULL)
SELECT 5 = NULL;        -- NULL (not false!)
SELECT NULL = NULL;     -- NULL (you can't compare unknowns)

-- Conditional logic with NULL
SELECT CASE 
    WHEN 5 > NULL THEN 'TRUE'
    WHEN 5 <= NULL THEN 'FALSE'
    ELSE 'UNKNOWN'  -- This executes (5 > NULL is NULL)
END;

-- NULL in boolean expressions
SELECT TRUE AND NULL;   -- NULL
SELECT FALSE AND NULL;  -- FALSE (FALSE AND anything = FALSE)
SELECT TRUE OR NULL;    -- TRUE (TRUE OR anything = TRUE)
SELECT FALSE OR NULL;   -- NULL

-- NULL propagation in functions
SELECT CONCAT('Alice', NULL);  -- NULL (one NULL makes result NULL)
SELECT COALESCE('Alice', NULL); -- 'Alice' (returns first non-NULL)
SELECT NULLIF(5, 5);           -- NULL (returns NULL if values match)

-- NULL in WHERE filters out NULL rows
SELECT * FROM drivers WHERE rating > 4.0;  -- Doesn't include rating=NULL rows
SELECT * FROM drivers WHERE rating IS NULL;     -- Only NULL ratings
SELECT * FROM drivers WHERE rating IS NOT NULL; -- Exclude NULLs
```

**Three-Valued Logic Truth Table:**
```
AND Truth Table:         OR Truth Table:
┌─────┬─────┬──────┐    ┌─────┬─────┬──────┐
│  A  │  B  │ A∧B  │    │  A  │  B  │ A∨B  │
├─────┼─────┼──────┤    ├─────┼─────┼──────┤
│ T   │ T   │  T   │    │ T   │ T   │  T   │
│ T   │ F   │  F   │    │ T   │ F   │  T   │
│ T   │ NULL│ NULL │    │ T   │ NULL│  T   │
│ F   │ T   │  F   │    │ F   │ T   │  T   │
│ F   │ F   │  F   │    │ F   │ F   │  F   │
│ F   │ NULL│  F   │    │ F   │ NULL│ NULL │
│ NULL│ T   │ NULL │    │ NULL│ T   │  T   │
│ NULL│ F   │  F   │    │ NULL│ F   │ NULL │
│ NULL│NULL │ NULL │    │ NULL│NULL │ NULL │
└─────┴─────┴──────┘    └─────┴─────┴──────┘
```

---

### 5. CASE Expression - Conditional Logic

**CASE** allows conditional logic in SQL (like if/else in programming):

```sql
-- Simple CASE (equality comparison)
SELECT 
    driver_id,
    CASE status
        WHEN 'completed' THEN 'Done'
        WHEN 'pending' THEN 'In Progress'
        WHEN 'cancelled' THEN 'Cancelled'
        ELSE 'Unknown'
    END AS status_label
FROM trips;

-- Searched CASE (arbitrary conditions)
SELECT 
    driver_id,
    fare,
    CASE 
        WHEN fare > 100 THEN 'Premium'
        WHEN fare >= 50 THEN 'Standard'
        WHEN fare >= 20 THEN 'Economy'
        ELSE 'Budget'
    END AS fare_tier
FROM trips;

-- CASE with NULL handling
SELECT 
    driver_id,
    rating,
    CASE 
        WHEN rating IS NULL THEN 'Unrated'
        WHEN rating >= 4.8 THEN 'Excellent'
        WHEN rating >= 4.0 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS rating_category
FROM drivers;

-- CASE in aggregations
SELECT 
    driver_id,
    COUNT(*) AS total_trips,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) AS completed_trips,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled_trips,
    ROUND(100.0 * COUNT(CASE WHEN status = 'completed' THEN 1 END) 
          / COUNT(*), 2) AS completion_rate
FROM trips
GROUP BY driver_id;
```

**CASE vs IF in programming:**
- CASE is an *expression* (returns value), not a statement
- Can be used in SELECT, WHERE, ORDER BY, and aggregates
- Each WHEN is evaluated in order; first match wins

---

### 6. Deterministic vs Non-Deterministic Functions

A **deterministic** function always returns the same output for the same input. A **non-deterministic** function may return different outputs.

```sql
-- DETERMINISTIC: Same input = same output
SELECT LENGTH('Alice');         -- Always 5
SELECT UPPER('alice');          -- Always 'ALICE'
SELECT ROUND(25.567, 2);        -- Always 25.57

-- NON-DETERMINISTIC: Output varies
SELECT RANDOM();                -- Different each call
SELECT CURRENT_TIMESTAMP;       -- Different each call
SELECT NOW();                   -- Different each call

-- Why it matters for indexes:
-- Only deterministic functions can use indexes effectively

-- WRONG: Function in WHERE prevents index usage (non-deterministic)
SELECT * FROM drivers WHERE RANDOM() > 0.5;  -- Must scan entire table

-- WRONG: Function on indexed column prevents index usage
SELECT * FROM drivers WHERE UPPER(name) = 'ALICE';  -- Can't use index on name
-- Better: use case-insensitive collation or case-insensitive index

-- CORRECT: Use function on constant, not column
SELECT * FROM drivers WHERE name = UPPER('alice');  -- Can use index on name
```

---

### 7. SARGable Predicates - Index-Friendly Conditions

**SARG** = Searchable Argument. A **SARGable** predicate can use an index.

```sql
-- SARGABLE (index can be used)
SELECT * FROM trips WHERE fare > 50.00;
SELECT * FROM drivers WHERE city = 'NYC' AND rating >= 4.0;
SELECT * FROM trips WHERE completed_at >= '2026-01-01';

-- NOT SARGABLE (index cannot be used, must scan all rows)
SELECT * FROM trips WHERE YEAR(completed_at) = 2026;
-- Reason: Function applied to column; index can't help

-- Fix: Rewrite to be SARGable
SELECT * FROM trips 
WHERE completed_at >= '2026-01-01' 
  AND completed_at < '2027-01-01';
-- Now the engine can use an index on completed_at

-- NOT SARGABLE: Negative condition
SELECT * FROM drivers WHERE rating != 4.5;
-- Engine must check every row (could be anything except 4.5)

-- SARGable alternative (with caveats)
SELECT * FROM drivers WHERE rating < 4.5 OR rating > 4.5;
-- But still might need full scan if selectivity is low
```

---

## 📖 10 Terms of the Day

| Term | Definition | Why It Matters |
|------|-----------|---|
| **Deterministic** | Function always returns same output for same input; safe for indexes | UPPER(), LENGTH() are deterministic; RANDOM() is not |
| **Volatile** | Function result depends on external state (time, random); can't use indexes | NOW(), RANDOM() are volatile; each call may differ |
| **SARGable** | Searchable Argument; predicate can use index (avoids full table scan) | WHERE `fare > 50` is SARGable; WHERE `YEAR(date) = 2026` is not |
| **Three-Valued Logic** | SQL logic with TRUE, FALSE, and NULL; NULL propagates in conditions | `5 > NULL` is NULL (not FALSE); affects WHERE results |
| **NULL Propagation** | NULL in expression makes result NULL; CONCAT('A', NULL) = NULL | Functions with NULL inputs usually return NULL |
| **COALESCE** | Returns first non-NULL argument; useful for NULL handling | COALESCE(rating, 0) returns rating or 0 if NULL |
| **NULLIF** | Returns NULL if two values match; useful for avoiding division by zero | NULLIF(0, 0) returns NULL; used in division |
| **Predicate Pushdown** | Optimizer moves filters earlier to reduce rows processed | WHERE moved before JOIN; non-SARGable predicates prevent this |
| **Function Inlining** | Optimizer replaces function call with its definition for better optimization | Deterministic functions can be inlined; volatile functions can't |
| **Short-Circuit Evaluation** | Stops evaluating boolean when result is determined | `FALSE AND anything = FALSE` (doesn't evaluate second part) |

---

## 🔧 Lab Engineering: Progressive SQL Exercises

### Exercise 1: Easy - String and Date Functions

**Task:** Create a driver directory showing name (uppercase), city, days active, and account age in years.

**Solution:**
```sql
SELECT 
    id,
    UPPER(name) AS driver_name,
    city,
    ROUND(EXTRACT(DAY FROM AGE(CURRENT_TIMESTAMP, created_at)), 0) 
        AS days_active,
    ROUND(EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, created_at)), 1) 
        AS years_active
FROM drivers
WHERE is_active = true
ORDER BY years_active DESC;
```

**Learning:** UPPER() for formatting, AGE() for duration, EXTRACT() for components. NULL-safe since drivers are pre-filtered.

---

### Exercise 2: Medium - CASE with Multiple Conditions

**Task:** Categorize trips by fare tier and status, showing completion percentage.

**Solution:**
```sql
SELECT 
    CASE 
        WHEN fare >= 100 THEN 'Premium'
        WHEN fare >= 50 THEN 'Standard'
        WHEN fare >= 20 THEN 'Economy'
        ELSE 'Budget'
    END AS fare_tier,
    status,
    COUNT(*) AS trip_count,
    ROUND(100.0 * COUNT(CASE WHEN status = 'completed' THEN 1 END) 
          / COUNT(*), 2) AS completion_pct
FROM trips
GROUP BY fare_tier, status
ORDER BY fare_tier DESC, completion_pct DESC;
```

**Learning:** CASE in SELECT for categorization, CASE in COUNT() for conditional aggregation. Always use CASE in ORDER BY before GROUP BY.

---

### Exercise 3: Hard - NULL Handling with Complex Logic

**Task:** Find drivers with incomplete payment records (missing payments, NULLs, or stale reviews). Flag data quality issues.

**Solution:**
```sql
SELECT 
    d.id,
    d.name,
    COUNT(t.id) AS total_trips,
    COUNT(CASE WHEN p.id IS NULL THEN 1 END) AS missing_payments,
    COUNT(CASE WHEN r.rating IS NULL THEN 1 END) AS unrated_trips,
    ROUND(100.0 * COUNT(CASE WHEN p.id IS NULL THEN 1 END) 
          / NULLIF(COUNT(t.id), 0), 2) AS missing_payment_pct,
    CASE 
        WHEN COUNT(CASE WHEN p.id IS NULL THEN 1 END) > 0 
             THEN 'Missing Payments'
        WHEN COUNT(CASE WHEN r.rating IS NULL THEN 1 END) > COUNT(t.id) * 0.5 
             THEN 'Low Review Rate'
        ELSE 'OK'
    END AS data_quality_flag
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
LEFT JOIN payments p ON t.id = p.trip_id
LEFT JOIN reviews r ON t.id = r.trip_id
GROUP BY d.id, d.name
HAVING COUNT(CASE WHEN p.id IS NULL THEN 1 END) > 0
    OR COUNT(CASE WHEN r.rating IS NULL THEN 1 END) > COUNT(t.id) * 0.5;
```

**Learning:** NULLIF prevents division by zero. LEFT JOINs preserve unmatched rows. CASE for complex logic. HAVING filters aggregates.

---

### Exercise 4: Challenge - SARGable Predicates and Function Optimization

**Task:** Find high-value trips completed in Q1 2026 with premium drivers, using index-friendly queries.

**Solution:**
```sql
-- GOOD: SARGable predicates (can use indexes)
SELECT 
    t.id,
    d.name,
    t.fare,
    t.completed_at,
    CASE 
        WHEN t.fare >= 100 THEN 'Premium'
        WHEN t.fare >= 50 THEN 'Standard'
        ELSE 'Economy'
    END AS tier,
    ROUND(AGE(t.completed_at, t.started_at) 
        EXTRACT(EPOCH FROM AGE(t.completed_at, t.started_at)) / 60, 1) 
        AS duration_minutes
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
  AND t.fare >= 50
  -- SARGable: date range without function
  AND t.completed_at >= '2026-01-01'
  AND t.completed_at < '2026-04-01'
  AND d.rating >= 4.5
ORDER BY t.fare DESC;

-- Index support:
CREATE INDEX idx_trips_status_fare_completed 
  ON trips(status, fare, completed_at) 
  WHERE status = 'completed';
```

**Learning:** Moving functions outside WHERE (AGE calculated in SELECT, not filtered in WHERE) preserves index usage. Date ranges without functions are SARGable.

---

### Exercise 5: Stretch - Complex Nested CASE with Window Functions

**Task:** Rank drivers by performance (completion rate, avg fare, rating), categorize by percentile, show improvement vs previous period.

**Solution:**
```sql
WITH driver_metrics AS (
    SELECT 
        d.id,
        d.name,
        d.city,
        d.rating,
        COUNT(CASE WHEN t.status = 'completed' THEN 1 END)::NUMERIC 
            / NULLIF(COUNT(t.id), 0) AS completion_rate,
        AVG(CASE WHEN t.status = 'completed' THEN t.fare ELSE NULL END) 
            AS avg_fare_completed,
        COUNT(t.id) AS total_trips,
        COUNT(r.id) AS review_count
    FROM drivers d
    LEFT JOIN trips t ON d.id = t.driver_id 
        AND t.completed_at >= CURRENT_DATE - INTERVAL '30 days'
    LEFT JOIN reviews r ON t.id = r.trip_id
    GROUP BY d.id, d.name, d.city, d.rating
),
ranked_metrics AS (
    SELECT 
        *,
        PERCENT_RANK() OVER (ORDER BY completion_rate) AS completion_percentile,
        PERCENT_RANK() OVER (ORDER BY avg_fare_completed) AS fare_percentile,
        ROW_NUMBER() OVER (ORDER BY rating DESC) AS rating_rank
    FROM driver_metrics
)
SELECT 
    id,
    name,
    city,
    ROUND(completion_rate::NUMERIC * 100, 1) AS completion_pct,
    ROUND(avg_fare_completed, 2) AS avg_fare,
    rating,
    CASE 
        WHEN completion_percentile >= 0.9 AND fare_percentile >= 0.8 
            THEN 'Top Performer'
        WHEN completion_percentile >= 0.7 AND fare_percentile >= 0.6 
            THEN 'Strong Performer'
        WHEN completion_percentile >= 0.5 
            THEN 'Meets Standard'
        ELSE 'Needs Improvement'
    END AS performance_tier,
    CASE 
        WHEN review_count = 0 THEN 'No Reviews'
        WHEN review_count < 5 THEN 'Few Reviews'
        ELSE 'Well Reviewed'
    END AS review_status
FROM ranked_metrics
ORDER BY rating_rank;
```

**Learning:** CTEs organize complex logic. Window functions compute percentiles within groups. Nested CASE handles multi-criteria logic. CASE in aggregation (COUNT CASE) is powerful.

---

## 🧠 Deep Dive: Function Impact on Index Usage

### Functions Kill Index Performance

When a function is applied to an **indexed column** in a WHERE clause, the index becomes unusable:

```sql
-- Problem: Function on indexed column
CREATE INDEX idx_drivers_created_at ON drivers(created_at);

SELECT * FROM drivers 
WHERE EXTRACT(YEAR FROM created_at) = 2026;
-- Index NOT used; full table scan required
-- Reason: Index has date/time values, not extracted years

-- Cost breakdown:
-- Table: 100,000 rows
-- Without index: Scan all 100k rows, extract year from each, compare
-- Time: ~500ms (I/O bound)

-- Solution 1: Rewrite without function (SARGable)
SELECT * FROM drivers 
WHERE created_at >= '2026-01-01' 
  AND created_at < '2027-01-01';
-- Index used; only 1,000 matching rows scanned
-- Time: ~10ms (fast!)

-- Solution 2: Use function on constant, not column
SELECT * FROM drivers 
WHERE created_at >= TO_DATE('2026-01-01', 'YYYY-MM-DD');
-- Index can still be used (comparing to constant)
```

**Before vs After:**
```
BAD: Function on column
Query: WHERE YEAR(created_at) = 2026
Plan: Seq Scan on drivers (cost=0..5000 rows=10000)
      Filter: YEAR(created_at) = 2026
Time: 500ms (scan all rows, extract year, filter)

GOOD: Rewrite without function
Query: WHERE created_at >= '2026-01-01' AND created_at < '2027-01-01'
Plan: Index Scan using idx_drivers_created_at (cost=0..100 rows=1000)
      Index Cond: created_at >= '2026-01-01' AND created_at < '2027-01-01'
Time: 10ms (index jumps to relevant rows)
```

---

### Deterministic vs Volatile Functions

Deterministic functions can be **inlined** and optimized; volatile functions cannot:

```sql
-- DETERMINISTIC: UPPER is safe to inline
CREATE INDEX idx_name_upper ON drivers(UPPER(name));
-- Index holds uppercase names; query can use it

SELECT * FROM drivers WHERE UPPER(name) = 'ALICE';
-- Can use index (UPPER is deterministic)

-- VOLATILE: NOW() changes every second
SELECT * FROM logs WHERE created_at > NOW() - INTERVAL '1 hour';
-- Cannot use index effectively (NOW() is volatile, value changes)
-- Each row must be checked at runtime

-- Implications:
-- Deterministic: Can create function-based indexes
-- Volatile: Cannot create function-based indexes; avoid in WHERE
```

---

### Predicate Pushdown with Functions

The optimizer **pushes down** non-function predicates but cannot push down function predicates:

```sql
-- Complex query with function and non-function predicates
SELECT d.id, d.name, t.fare
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
WHERE d.city = 'NYC'           -- Non-function: pushed down (fast)
  AND YEAR(t.created_at) = 2026 -- Function: cannot be pushed down (slow)

-- Optimizer strategy:
-- 1. Filter drivers WHERE city = 'NYC' (index scan: fast)
-- 2. JOIN to trips
-- 3. Apply function filter YEAR(created_at) = 2026 (must check all joined rows)

-- Better: Push date filter to trips table before join
SELECT d.id, d.name, t.fare
FROM drivers d
LEFT JOIN trips t 
    ON d.id = t.driver_id
    AND t.created_at >= '2026-01-01'
    AND t.created_at < '2027-01-01'  -- Pushed into JOIN ON (fast)
WHERE d.city = 'NYC';
```

---

## 🚨 Pressure Scenario: Index Exists But Query Still Doing Seq Scan

### Scenario
An index exists, but EXPLAIN shows Seq Scan instead of Index Scan:

```sql
-- Index created
CREATE INDEX idx_drivers_city ON drivers(city);

-- Query still seq scans
SELECT * FROM drivers WHERE UPPER(city) = 'NYC';
-- Plan: Seq Scan on drivers (cost=0..5000)
-- Index NOT used! Why?
```

### Step-by-Step Diagnosis

**Step 1: Check the actual predicate**
```sql
-- Verify index exists and is on right column
SELECT * FROM pg_indexes WHERE tablename = 'drivers';
-- Output: idx_drivers_city on city column ✓

-- Check query predicate
EXPLAIN SELECT * FROM drivers WHERE UPPER(city) = 'NYC';
-- Plan: Seq Scan ... Filter: (UPPER(city) = 'NYC')
-- Problem: Function UPPER() prevents index usage
```

**Step 2: Rewrite predicate to be SARGable**
```sql
-- Instead of function on column:
SELECT * FROM drivers WHERE UPPER(city) = 'NYC';

-- Rewrite as:
SELECT * FROM drivers WHERE city = 'NYC';
-- Or if case-insensitive match needed:
SELECT * FROM drivers WHERE UPPER(city) = UPPER('nyc');

EXPLAIN SELECT * FROM drivers WHERE city = 'NYC';
-- Plan: Index Scan using idx_drivers_city
-- Much better!
```

**Step 3: Check selectivity**
```sql
-- Even without function, if selectivity is low, optimizer might choose Seq Scan
SELECT COUNT(*) FROM drivers WHERE city = 'NYC';
-- Result: 50,000 rows (out of 100,000 total)
-- Selectivity: 50% - Seq Scan might be chosen (touching 50% of table anyway)

-- Optimizer decision:
-- Seq Scan: Read 100k rows sequentially (fast I/O)
-- Index Scan: Jump to 50k rows (more random I/O)
-- For 50% selectivity, Seq Scan can be faster
```

**Step 4: Check statistics and query plan**
```sql
-- Stale statistics might cause wrong decisions
ANALYZE drivers;  -- Update statistics

EXPLAIN SELECT * FROM drivers WHERE UPPER(city) = 'NYC';
-- Rerun after ANALYZE
```

### Solution SQL

```sql
-- Immediate: Rewrite predicate to be SARGable
SELECT * FROM drivers 
WHERE city = 'NYC';  -- Remove function from column

-- If case-insensitive search is required:
-- Option 1: Use ILIKE (case-insensitive LIKE)
SELECT * FROM drivers WHERE city ILIKE 'nyc';

-- Option 2: Create case-insensitive index
CREATE INDEX idx_drivers_city_lower ON drivers(LOWER(city));
-- Then: WHERE LOWER(city) = 'nyc';
-- Index is used (function is deterministic, index is function-based)

-- Option 3: Use collation
CREATE INDEX idx_drivers_city_collate ON drivers(city COLLATE "C");
SELECT * FROM drivers WHERE city = 'NYC' COLLATE "C";

-- Verify plan changed
EXPLAIN SELECT * FROM drivers WHERE city = 'NYC';
-- Should show "Index Scan using idx_drivers_city"
```

### Lessons Learned
1. **Functions on indexed columns destroy index usage**
2. **Rewrite predicates to be SARGable** (no functions on columns)
3. **Low selectivity** (many matching rows) can make Seq Scan optimal
4. **Function-based indexes** allow indexes on computed values (if deterministic)
5. **EXPLAIN shows actual cost**; trust it over assumptions

---

## ✅ Recap Checklist

- [ ] Use UPPER/LOWER for string case conversion; SUBSTRING for extraction
- [ ] Explain why functions on indexed columns prevent index usage
- [ ] Use CURRENT_TIMESTAMP for current time; EXTRACT/DATE_TRUNC for components
- [ ] Calculate durations with AGE() and EXTRACT(EPOCH FROM ...)
- [ ] Understand three-valued logic (TRUE, FALSE, NULL)
- [ ] Handle NULL with IS NULL / IS NOT NULL; use COALESCE to provide defaults
- [ ] Use CASE for conditional logic in SELECT, WHERE, and aggregations
- [ ] Distinguish deterministic (UPPER, ROUND) from volatile (NOW, RANDOM) functions
- [ ] Write SARGable predicates (no functions on columns) to use indexes
- [ ] Diagnose slow queries with functions using EXPLAIN; rewrite predicates

---

## 🔗 Navigation

[**← Day 3: Joins**](./day-03-joins.md) | [**Day 5: Aggregates & Window Functions**](./day-05-aggregates-window-functions.md) →

**Repository:** [sql-mastery-bootcamp](https://github.com/your-username/sql-mastery-bootcamp)
