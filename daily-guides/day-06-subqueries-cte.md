# 🔄 Day 6: Subqueries, CTEs & Optimization
**Tuesday, 10 March 2026**  
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) - From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** - Please like, subscribe and support the original creator!

---

## 📅 Today's Schedule

| Time | Activity | Duration | Focus |
|------|----------|----------|-------|
| 09:00-09:45 | Subquery Types Deep Dive | 45 min | Scalar, inline, correlated |
| 09:45-10:30 | Common Table Expressions (CTEs) | 45 min | WITH clause, readability |
| 10:30-11:15 | Derived Tables & Inline Views | 45 min | FROM clause subqueries |
| 11:15-12:00 | Performance Comparison | 45 min | Subquery vs CTE vs JOIN |
| 12:00-13:00 | **Lunch Break** | 60 min | - |
| 13:00-13:45 | CTE Recursive Patterns | 45 min | Advanced CTEs |
| 13:45-14:30 | Lab Exercises 1-3 | 45 min | Hands-on coding |
| 14:30-15:15 | Lab Exercises 4-5 | 45 min | Pressure scenario |
| 15:15-15:35 | Wrap-up & Recap | 20 min | Checklist & homework |

---

## 🎯 Core Topics

### 1. Subquery Types

**Scalar Subquery** - Returns one row, one column. Can appear in SELECT, WHERE, or HAVING.

```sql
-- Find drivers who earn more than average
SELECT 
  driver_id,
  name,
  (SELECT AVG(fare) FROM trips) as avg_fare
FROM drivers
WHERE driver_id IN (
  SELECT driver_id 
  FROM trips 
  GROUP BY driver_id 
  HAVING AVG(fare) > 50
);
```

**Inline Subquery (FROM)** - Subquery in FROM clause becomes a temporary dataset.

```sql
-- Subqueries in FROM are called derived tables
SELECT 
  driver_stats.driver_id,
  driver_stats.trip_count,
  driver_stats.avg_rating
FROM (
  SELECT 
    d.driver_id,
    COUNT(t.id) as trip_count,
    AVG(r.rating) as avg_rating
  FROM drivers d
  LEFT JOIN trips t ON d.id = t.driver_id
  LEFT JOIN reviews r ON t.id = r.trip_id
  GROUP BY d.driver_id
) driver_stats
WHERE driver_stats.trip_count > 10;
```

**Correlated Subquery** - References outer query tables. Executes once per outer row.

```sql
-- Find trips more expensive than that driver's average
SELECT 
  t.id,
  t.fare,
  (SELECT AVG(fare) 
   FROM trips t2 
   WHERE t2.driver_id = t.driver_id) as driver_avg
FROM trips t
WHERE t.fare > (
  SELECT AVG(fare) 
  FROM trips t2 
  WHERE t2.driver_id = t.driver_id
);
```

### 2. Common Table Expressions (CTEs)

**Named temporary result sets** - readable, reusable, modular.

```sql
WITH driver_stats AS (
  SELECT 
    driver_id,
    COUNT(*) as trip_count,
    AVG(fare) as avg_fare,
    MAX(rating) as best_rating
  FROM trips t
  LEFT JOIN reviews r ON t.id = r.trip_id
  GROUP BY driver_id
),
active_drivers AS (
  SELECT * FROM drivers WHERE is_active = true
)
SELECT 
  ad.name,
  ad.city,
  ds.trip_count,
  ds.avg_fare,
  ds.best_rating
FROM active_drivers ad
JOIN driver_stats ds ON ad.id = ds.driver_id
WHERE ds.trip_count > 5
ORDER BY ds.avg_fare DESC;
```

### 3. Derived Tables vs CTEs

**Derived Table** - Anonymous inline subquery in FROM.

```sql
SELECT * FROM (
  SELECT driver_id, AVG(fare) as avg_fare
  FROM trips
  GROUP BY driver_id
) t
WHERE t.avg_fare > 40;
```

**CTE** - Named, readable, reusable within same query.

```sql
WITH avg_fares AS (
  SELECT driver_id, AVG(fare) as avg_fare
  FROM trips
  GROUP BY driver_id
)
SELECT * FROM avg_fares WHERE avg_fare > 40;
```

### 4. Recursive CTEs

**Self-referencing CTEs** - Walk hierarchies, generate sequences.

```sql
-- Generate sequence of ride IDs (example only)
WITH RECURSIVE ride_sequence AS (
  SELECT 1 as ride_num
  UNION ALL
  SELECT ride_num + 1 FROM ride_sequence WHERE ride_num < 100
)
SELECT * FROM ride_sequence;
```

### 5. Optimization: Subquery vs CTE vs JOIN

```sql
-- SUBQUERY (correlated) - slow, row-by-row execution
SELECT t.id, t.fare
FROM trips t
WHERE t.fare > (
  SELECT AVG(fare) FROM trips t2 WHERE t2.driver_id = t.driver_id
);

-- CTE - materialized, optimized
WITH driver_avgs AS (
  SELECT driver_id, AVG(fare) as avg_fare FROM trips GROUP BY driver_id
)
SELECT t.id, t.fare
FROM trips t
JOIN driver_avgs da ON t.driver_id = da.driver_id
WHERE t.fare > da.avg_fare;

-- JOIN (best) - single execution plan
SELECT t.id, t.fare
FROM trips t
JOIN (SELECT driver_id, AVG(fare) as avg_fare FROM trips GROUP BY driver_id) da 
  ON t.driver_id = da.driver_id
WHERE t.fare > da.avg_fare;
```

---

## 📚 10 Terms of the Day

| Term | Definition | Example | Category | Mastery |
|------|-----------|---------|----------|---------|
| **CTE** | Common Table Expression; named subquery | `WITH cte AS (...)` | Structure | |
| **Correlated Subquery** | Subquery referencing outer table | `WHERE id > (SELECT ... WHERE id = t.id)` | Execution | |
| **Derived Table** | Subquery in FROM clause | `FROM (SELECT ...) t` | Structure | |
| **Materialization** | CTE stored in memory; saves recalculation | CTE with 10 references = 1 execution | Performance | |
| **Optimization Barrier** | Query optimizer cannot cross (old DBs) | Derived tables block pushdown | Performance | |
| **Inline View** | Another name for derived table | Same as derived table | Terminology | |
| **Scalar Subquery** | Returns 1 row × 1 column | `SELECT (SELECT MAX(fare) FROM trips)` | Structure | |
| **Lateral Join** | PostgreSQL syntax for row-by-row subquery | `LATERAL (SELECT ...)` | Performance | |
| **Recursive CTE** | CTE that references itself | Tree traversal, sequence generation | Advanced | |
| **Execution Tree** | Plan showing how DB executes query | EXPLAIN output | Debugging | |

---

## 🧪 Lab Exercises (Uber Database)

### Lab 1: Scalar Subquery - Driver Above Average
**Find all trips where the fare exceeds that driver's average fare.**

```sql
-- Write query using scalar subquery in WHERE clause
-- Expected: Compare each trip to its driver's avg
```

**Solution:**
```sql
SELECT 
  t.id,
  t.driver_id,
  t.fare,
  (SELECT AVG(fare) FROM trips WHERE driver_id = t.driver_id) as driver_avg
FROM trips t
WHERE t.fare > (SELECT AVG(fare) FROM trips WHERE driver_id = t.driver_id)
ORDER BY t.fare DESC
LIMIT 20;
```

### Lab 2: CTE - Top Drivers by Rating
**Using CTE, find top 10 drivers with highest average rating AND at least 20 trips.**

```sql
-- Write using WITH clause
-- Join drivers, trips, reviews
-- Calculate average rating
-- Filter: trip_count >= 20
-- ORDER BY avg_rating DESC LIMIT 10
```

**Solution:**
```sql
WITH driver_metrics AS (
  SELECT 
    d.id,
    d.name,
    d.city,
    COUNT(t.id) as trip_count,
    AVG(r.rating) as avg_rating
  FROM drivers d
  LEFT JOIN trips t ON d.id = t.driver_id
  LEFT JOIN reviews r ON t.id = r.trip_id AND r.reviewer_id = d.id
  GROUP BY d.id, d.name, d.city
)
SELECT * FROM driver_metrics
WHERE trip_count >= 20
ORDER BY avg_rating DESC
LIMIT 10;
```

### Lab 3: Derived Table - Revenue by City
**Find total revenue per city, but only show cities where avg fare > $30.**

```sql
-- Use derived table in FROM
-- Calculate fare per city in derived table
-- Filter in outer query
```

**Solution:**
```sql
SELECT 
  city_stats.city,
  city_stats.total_revenue,
  city_stats.trip_count,
  city_stats.avg_fare
FROM (
  SELECT 
    d.city,
    SUM(t.fare) as total_revenue,
    COUNT(t.id) as trip_count,
    AVG(t.fare) as avg_fare
  FROM drivers d
  JOIN trips t ON d.id = t.driver_id
  GROUP BY d.city
) city_stats
WHERE city_stats.avg_fare > 30
ORDER BY city_stats.total_revenue DESC;
```

### Lab 4: Multiple CTEs - Payment Analysis
**Create CTEs for: (1) driver revenue, (2) payment methods, (3) failed payments. Find drivers with >$1000 revenue but >10% failed payments.**

```sql
-- Multi-CTE pattern: cascade results
-- WHERE filters on joined CTEs
```

**Solution:**
```sql
WITH driver_revenue AS (
  SELECT 
    t.driver_id,
    SUM(t.fare) as total_fare
  FROM trips t
  GROUP BY t.driver_id
),
payment_status AS (
  SELECT 
    t.driver_id,
    COUNT(CASE WHEN p.status = 'failed' THEN 1 END) as failed_count,
    COUNT(p.id) as total_payments,
    ROUND(100.0 * COUNT(CASE WHEN p.status = 'failed' THEN 1 END) / COUNT(p.id), 2) as fail_rate
  FROM trips t
  JOIN payments p ON t.id = p.trip_id
  GROUP BY t.driver_id
)
SELECT 
  dr.driver_id,
  dr.total_fare,
  ps.fail_rate,
  ps.failed_count
FROM driver_revenue dr
JOIN payment_status ps ON dr.driver_id = ps.driver_id
WHERE dr.total_fare > 1000 AND ps.fail_rate > 10
ORDER BY ps.fail_rate DESC;
```

### Lab 5: Pressure Scenario - Recursive Pattern (BONUS)
**PRESSURE: Your CTE-based query runs 2x slower than the original subquery. Debug why and optimize.**

**Scenario:**
```sql
-- SLOW CTE VERSION (materialized everything)
WITH all_trips AS (
  SELECT * FROM trips
),
all_drivers AS (
  SELECT * FROM drivers
),
all_reviews AS (
  SELECT * FROM reviews
)
SELECT ...
FROM all_trips
JOIN all_drivers ON ...
JOIN all_reviews ON ...;
```

**Issue:** CTE materialized ALL rows even though final query filters heavily.

**Solution:**
```sql
-- FAST: Filter before CTE, or use derived table with WHERE
WITH relevant_trips AS (
  SELECT * FROM trips 
  WHERE completed_at > NOW() - INTERVAL '7 days'  -- Filter EARLY
),
driver_ratings AS (
  SELECT driver_id, AVG(rating) FROM reviews GROUP BY driver_id HAVING AVG(rating) > 4.5
)
SELECT rt.*, dr.avg_rating
FROM relevant_trips rt
JOIN driver_ratings dr ON rt.driver_id = dr.driver_id;
```

---

## 🔍 Deep Dive: CTE Execution & Optimization Barriers

### Execution Tree Concept

```
QUERY: CTE + JOIN + Filter
|
├─ CTE Materialization (eager execution)
│  └─ Scan all rows matching CTE logic
│     └─ Store in temp memory/disk
|
├─ Join CTE to outer table
│  └─ Hash join or loop join (depends on rows)
│
└─ Apply WHERE filters
   └─ If filter early, wasted work!
```

### Optimization Barriers (OLD DBs)

**Problem:** Derived tables in older DBs (MySQL 5.6) could NOT be optimized across boundaries.

```sql
-- SLOW (optimizer can't push WHERE into derived table)
SELECT * FROM (
  SELECT * FROM trips  -- Scans ALL trips
) t
WHERE t.fare > 50;

-- FAST (modern DBs optimize this automatically)
SELECT * FROM trips WHERE fare > 50;
```

**Modern DBs (PostgreSQL, MySQL 8.0+)** remove this barrier with **inline optimization**.

### Materialization Strategy

```sql
-- Use CTE materialization when:
-- 1. CTE referenced MULTIPLE times
WITH cte AS (SELECT driver_id, AVG(fare) FROM trips GROUP BY driver_id)
SELECT ... FROM cte
UNION ALL
SELECT ... FROM cte;  -- Reused → benefit from materialization

-- 2. Complex window function or aggregation
WITH complex_calc AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY fare DESC) as rn
  FROM trips
)
SELECT ... FROM complex_calc;
```

---

## 🔥 Pressure Scenario: CTE Made Query Slower

**Production Alert:** A junior dev rewrote queries using CTEs "for readability." Query response time doubled.

### The Problem

```sql
-- ORIGINAL (fast, 200ms)
SELECT d.name, SUM(t.fare) as revenue
FROM drivers d
JOIN trips t ON d.id = t.driver_id
WHERE t.completed_at > NOW() - INTERVAL '30 days'
GROUP BY d.id, d.name;

-- REWRITTEN WITH CTE (slow, 400ms)
WITH all_trips AS (
  SELECT * FROM trips  -- Materializes ALL trips (millions)
),
recent_trips AS (
  SELECT * FROM all_trips
  WHERE completed_at > NOW() - INTERVAL '30 days'
)
SELECT d.name, SUM(rt.fare)
FROM drivers d
JOIN recent_trips rt ON d.id = rt.driver_id
GROUP BY d.id, d.name;
```

### Diagnosis

1. `all_trips` CTE materializes entire trips table into temp storage.
2. Only then does `recent_trips` filter - but damage is done.
3. CTE materialization cost: 2× larger working set.

### Solution

```sql
-- OPTIMIZED CTE (fast, 200ms) - Filter EARLY
WITH recent_trips AS (
  SELECT * FROM trips
  WHERE completed_at > NOW() - INTERVAL '30 days'
)
SELECT d.name, SUM(rt.fare) as revenue
FROM drivers d
JOIN recent_trips rt ON d.id = rt.driver_id
GROUP BY d.id, d.name;
```

**Key:** Push filters into CTEs, avoid intermediate "all data" CTEs.

---

## ✅ Recap Checklist

- [ ] Can explain scalar subquery, inline subquery, correlated subquery
- [ ] Understand CTE syntax and when to use WITH clause
- [ ] Know difference between derived table and CTE
- [ ] Can spot correlated subquery N+1 execution pattern
- [ ] Understand materialization trade-offs
- [ ] Can optimize CTE by filtering early
- [ ] Attempted Lab 1-5 without looking at solutions
- [ ] Explained to someone: "Why CTE might be slower"
- [ ] Read EXPLAIN output for CTE query
> 🎬 **Video:** [SQL Full Course for Beginners (30 Hours) - From Zero to Hero](https://www.youtube.com/watch?v=SSKVgrwhzus) by **[Data with Baraa](https://www.youtube.com/@DataWithBaraa)** - Please like, subscribe and support the original creator!

---

## 🧭 Navigation

**← [Day 5: Window Functions](./day-05-window-functions.md) | [Day 7: Views & Procedures →](./day-07-views-procedures-triggers.md)**

---

*Last updated: 10 March 2026 | [Bootcamp Home](../README.md)*
