# 📝 Mock Exam Repository

Three full-length practice exams covering Days 1-10 of the bootcamp. Each exam includes scoring rubrics, answer keys, and difficulty ratings to simulate real assessment conditions.

---

## How to Use These Exams

- **Time yourself:** Use the recommended time limit
- **Attempt all questions:** Don't skip; mark uncertain answers
- **Review afterwards:** Use answer key and explanations
- **Track patterns:** Note which topics you struggle with
- **Retake after one week:** Measure improvement

---

# EXAM 1: FOUNDATIONS (Days 1-3)

**Level:** Beginner  
**Time Limit:** 45 minutes  
**Question Count:** 20 (15 MCQ + 5 SQL Writing)  
**Passing Score:** 70% (14/20)

---

## MCQ Section (1-15)

**Q1:** Which SQL keyword is used to retrieve data from a table?
- A) SELECT
- B) RETRIEVE
- C) FETCH
- D) EXTRACT

**Q2:** What does a PRIMARY KEY constraint ensure?
- A) Data is sorted alphabetically
- B) Values are unique and not null
- C) Values can be searched quickly
- D) Values are backed up daily

**Q3:** In the table structure `drivers(id INT, name VARCHAR(50), city VARCHAR(50))`, what type is the `city` column?
- A) INTEGER
- B) DECIMAL
- C) CHARACTER VARYING
- D) TIMESTAMP

**Q4:** Which clause filters rows based on conditions?
- A) SELECT
- B) WHERE
- C) GROUP BY
- D) ORDER BY

**Q5:** What does `DISTINCT` do in a SELECT statement?
- A) Sorts results alphabetically
- B) Removes duplicate rows
- C) Groups rows by value
- D) Counts unique values

**Q6:** Which of these is a valid date-time data type in PostgreSQL?
- A) DATE
- B) DATETIME
- C) TIMESTAMP
- D) Both A and C

**Q7:** What is the result of this query?
```sql
SELECT COUNT(*) FROM drivers;
```
- A) List all drivers
- B) Return number of drivers
- C) Count distinct drivers
- D) Return column names

**Q8:** Which statement correctly inserts a new driver?
- A) `INSERT drivers VALUES('John', 'Jozi')`
- B) `INSERT INTO drivers (name, city) VALUES ('John', 'Jozi')`
- C) `INSERT RECORD drivers SET name='John'`
- D) `APPEND drivers (name, city) ('John', 'Jozi')`

**Q9:** What does `UPDATE drivers SET rating = 4.5 WHERE id = 1` do?
- A) Adds new row with rating 4.5
- B) Changes driver with id=1's rating to 4.5
- C) Creates new column rating
- D) Sets all drivers' rating to 4.5

**Q10:** Which is the correct syntax to delete rows?
- A) `DELETE FROM drivers WHERE id = 5`
- B) `DELETE drivers WHERE id = 5`
- C) `REMOVE FROM drivers WHERE id = 5`
- D) `DROP ROW drivers WHERE id = 5`

**Q11:** What does `ORDER BY fare DESC` do?
- A) Arranges ascending by fare
- B) Arranges descending by fare
- C) Groups by fare
- D) Counts fare values

**Q12:** In the query `SELECT * FROM trips WHERE pickup_location LIKE 'Johannes%'`, what does LIKE do?
- A) Exact match only
- B) Pattern matching with wildcards
- C) Searches for word boundaries
- D) Case-sensitive matching

**Q13:** What is NULL in SQL?
- A) Zero
- B) Empty string
- C) Unknown or missing value
- D) False

**Q14:** Which operator is used to check for NULL values?
- A) `= NULL`
- B) `!= NULL`
- C) `IS NULL`
- D) `NULL`

**Q15:** What does `LIMIT 10` do?
- A) Skips first 10 rows
- B) Returns maximum 10 rows
- C) Limits to 10 characters
- D) Filters 10 values

---

## SQL Writing Section (16-20)

**Q16:** Write a SELECT statement that retrieves all drivers from Johannesburg.
```
Answer:
```

**Q17:** Write an INSERT statement to add a new rider named 'Alice Johnson' with email 'alice@gmail.com'.
```
Answer:
```

**Q18:** Write an UPDATE statement to mark driver with id=3 as inactive (is_active = false).
```
Answer:
```

**Q19:** Write a SELECT statement that shows trips ordered by fare from highest to lowest, limiting to 5 results.
```
Answer:
```

**Q20:** Write a DELETE statement to remove all cancelled trips.
```
Answer:
```

---

## Answer Key - EXAM 1

**MCQ Answers:**
1. A | 2. B | 3. C | 4. B | 5. B | 6. D | 7. B | 8. B | 9. B | 10. A | 11. B | 12. B | 13. C | 14. C | 15. B

**SQL Writing Answers:**

**Q16:** Correct Answer:
```sql
SELECT * FROM drivers WHERE city = 'Johannesburg';
```
Grading: 1 point for correct WHERE, 1 point for correct table name

**Q17:** Correct Answer:
```sql
INSERT INTO riders (name, email) VALUES ('Alice Johnson', 'alice@gmail.com');
```
Grading: 1 point for INSERT INTO syntax, 1 point for correct columns, 1 point for values

**Q18:** Correct Answer:
```sql
UPDATE drivers SET is_active = false WHERE id = 3;
```
Grading: 1 point for UPDATE syntax, 1 point for WHERE condition

**Q19:** Correct Answer:
```sql
SELECT * FROM trips ORDER BY fare DESC LIMIT 5;
```
Grading: 1 point for ORDER BY DESC, 1 point for LIMIT

**Q20:** Correct Answer:
```sql
DELETE FROM trips WHERE status = 'cancelled';
```
Grading: 1 point for DELETE syntax, 1 point for correct WHERE clause

---

## Difficulty Ratings - EXAM 1

| Q# | Difficulty | Topic |
|----|-----------|-------|
| 1-7 | Easy | Basic commands, terminology |
| 8-12 | Easy | DML syntax, operators |
| 13-15 | Easy | NULL handling, LIMIT |
| 16-17 | Easy | SELECT, INSERT |
| 18-19 | Medium | UPDATE, ORDER BY, LIMIT |
| 20 | Medium | DELETE with WHERE |

---

---

# EXAM 2: INTERMEDIATE (Days 4-7)

**Level:** Intermediate  
**Time Limit:** 45 minutes  
**Question Count:** 20 (10 MCQ + 10 SQL Writing)  
**Passing Score:** 70% (14/20)

---

## MCQ Section (1-10)

**Q1:** What is the result of an INNER JOIN with no matches?
- A) All left table rows
- B) All right table rows
- C) Empty result set
- D) All columns from both tables

**Q2:** Which aggregate function ignores NULL values?
- A) COUNT(*)
- B) COUNT(column)
- C) SUM
- D) Both B and C

**Q3:** What does `GROUP BY driver_id` do?
- A) Orders results by driver_id
- B) Collapses rows by driver_id, one row per unique value
- C) Filters to specific driver_id
- D) Counts rows grouped by driver_id

**Q4:** Which clause filters aggregate results?
- A) WHERE
- B) GROUP BY
- C) HAVING
- D) ORDER BY

**Q5:** A CTE (Common Table Expression) is created using which keyword?
- A) CREATE
- B) WITH
- C) DECLARE
- D) DEFINE

**Q6:** What does a LEFT JOIN return?
- A) All rows from right table + matches from left
- B) All rows from left table + matches from right
- C) Only matching rows
- D) Cartesian product

**Q7:** Which function converts text to uppercase?
- A) CONVERT
- B) UPPER
- C) TEXT
- D) TOCASE

**Q8:** What does `COALESCE(column1, column2, 'default')` do?
- A) Combines columns
- B) Returns first non-NULL value or default
- C) Merges rows
- D) Calculates sum

**Q9:** A VIEW is best for which scenario?
- A) Storing large results for reuse
- B) Complex query used frequently by many users
- C) One-time analysis
- D) Improving write performance

**Q10:** Which correctly joins three tables?
- A) `SELECT * FROM t1, t2, t3`
- B) `SELECT * FROM t1 JOIN t2 JOIN t3 ON conditions`
- C) `SELECT * FROM t1 JOIN t2 ON cond1 JOIN t3 ON cond2`
- D) Both B and C

---

## SQL Writing Section (11-20)

**Q11:** Write a query showing driver_id and trip count for drivers with more than 5 trips.
```
Answer:
```

**Q12:** Write a query to find the average fare per city using GROUP BY.
```
Answer:
```

**Q13:** Write a LEFT JOIN query showing all riders and their trip count (if any).
```
Answer:
```

**Q14:** Write a CTE query to find drivers earning more than the average.
```
Answer:
```

**Q15:** Write a query using CASE to categorize trips as 'short' (<5km), 'medium' (5-15km), 'long' (>15km).
```
Answer:
```

**Q16:** Write a query using COALESCE to show driver name or 'Unknown' if null.
```
Answer:
```

**Q17:** Write a query to find drivers whose average rating is above 4.5, using HAVING.
```
Answer:
```

**Q18:** Write a UNION query combining active drivers and active riders (one column each).
```
Answer:
```

**Q19:** Write a query creating a VIEW for high-value trips (>$50) with driver and rider names using JOINs.
```
Answer:
```

**Q20:** Write a query using aggregate functions to show per-day trip statistics (count, avg fare, max distance).
```
Answer:
```

---

## Answer Key - EXAM 2

**MCQ Answers:**
1. C | 2. D | 3. B | 4. C | 5. B | 6. B | 7. B | 8. B | 9. B | 10. C

**SQL Writing Answers:**

**Q11:**
```sql
SELECT driver_id, COUNT(*) as trip_count
FROM trips
GROUP BY driver_id
HAVING COUNT(*) > 5;
```

**Q12:**
```sql
SELECT pickup_location as city, AVG(fare) as avg_fare
FROM trips
GROUP BY pickup_location;
```

**Q13:**
```sql
SELECT r.id, r.name, COUNT(t.id) as trip_count
FROM riders r
LEFT JOIN trips t ON r.id = t.rider_id
GROUP BY r.id, r.name;
```

**Q14:**
```sql
WITH avg_earnings AS (
  SELECT AVG(net_amount) as avg_earn FROM driver_earnings
)
SELECT d.id, d.name, AVG(de.net_amount) as earnings
FROM drivers d
JOIN driver_earnings de ON d.id = de.driver_id
WHERE de.net_amount > (SELECT avg_earn FROM avg_earnings)
GROUP BY d.id, d.name;
```

**Q15:**
```sql
SELECT id, driver_id, distance_km,
  CASE 
    WHEN distance_km < 5 THEN 'short'
    WHEN distance_km BETWEEN 5 AND 15 THEN 'medium'
    ELSE 'long'
  END as distance_category
FROM trips;
```

**Q16:**
```sql
SELECT id, COALESCE(name, 'Unknown') as driver_name
FROM drivers;
```

**Q17:**
```sql
SELECT d.id, d.name, AVG(r.rating) as avg_rating
FROM drivers d
LEFT JOIN reviews r ON d.id = r.reviewee_id
GROUP BY d.id, d.name
HAVING AVG(r.rating) > 4.5;
```

**Q18:**
```sql
SELECT name FROM drivers WHERE is_active = true
UNION
SELECT name FROM riders WHERE is_active = true;
```

**Q19:**
```sql
CREATE VIEW high_value_trips AS
SELECT t.id, d.name as driver_name, r.name as rider_name, t.fare, t.status
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
INNER JOIN riders r ON t.rider_id = r.id
WHERE t.fare > 50;
```

**Q20:**
```sql
SELECT DATE(requested_at) as trip_date, 
  COUNT(*) as trip_count,
  AVG(fare) as avg_fare,
  MAX(distance_km) as max_distance
FROM trips
GROUP BY DATE(requested_at)
ORDER BY trip_date DESC;
```

---

## Difficulty Ratings - EXAM 2

| Q# | Difficulty | Topic |
|----|-----------|-------|
| 1-7 | Medium | JOINs, aggregates, functions |
| 8-10 | Medium | COALESCE, VIEWs, multi-table joins |
| 11-13 | Medium | GROUP BY/HAVING, JOINs, aggregates |
| 14-16 | Hard | CTEs, CASE, COALESCE combined |
| 17-20 | Hard | Complex filtering, VIEWs, window-like aggregates |

---

---

# EXAM 3: ADVANCED (Days 8-10)

**Level:** Advanced  
**Time Limit:** 45 minutes  
**Question Count:** 20 (5 MCQ + 15 SQL Writing + 3 Scenario-Based)  
**Passing Score:** 70% (14/20)

---

## MCQ Section (1-5)

**Q1:** What does EXPLAIN ANALYZE show that EXPLAIN doesn't?
- A) Estimated rows and cost
- B) Actual rows, timing, and real execution data
- C) Index usage only
- D) Memory allocation only

**Q2:** A WINDOW FUNCTION with PARTITION BY creates how many groups?
- A) One group (entire table)
- B) One group per partition value
- C) One group per row
- D) No groups; window functions never partition

**Q3:** What is the PRIMARY PURPOSE of indexing on a foreign key column?
- A) Enforce referential integrity
- B) Speed up JOIN operations
- C) Compress data
- D) Enable automatic backups

**Q4:** In a MERGE JOIN, what must be true about input data?
- A) Indexed columns only
- B) Sorted in same order
- C) Same data types only
- D) No NULLs allowed

**Q5:** Which is most efficient for finding ALL trips with duration between 20-30 minutes?
- A) Full table scan
- B) Hash index on duration
- C) B-Tree index on duration
- D) Bitmap index on duration

---

## SQL Writing Section (6-20)

**Q6:** Write a window function query showing each trip's rank among all trips by driver (1st, 2nd, etc.).
```
Answer:
```

**Q7:** Write a query using ROW_NUMBER() to get the top 3 highest-earning trips per driver.
```
Answer:
```

**Q8:** Write a recursive CTE to show all trips within N hops of a driver (simplified example).
```
Answer:
```

**Q9:** Write a query using EXPLAIN ANALYZE and explain what a high "Actual Rows" count means.
```
Answer:
```

**Q10:** Write a query to identify unused indexes (or a strategy for finding them).
```
Answer:
```

**Q11:** Write a query using window functions to show running total of earnings per driver.
```
Answer:
```

**Q12:** Write a partitioned query showing trips with their percentile ranking by fare within each city.
```
Answer:
```

**Q13:** Write a query combining multiple CTEs to analyze driver performance metrics (trips, revenue, avg rating).
```
Answer:
```

**Q14:** Write an UPDATE statement using a subquery to increase rating for drivers with >10 completed trips.
```
Answer:
```

**Q15:** Write a query detecting N+1 query patterns or inefficient correlated subqueries (and fix it).
```
Answer:
```

**Q16:** Write a query using CROSS JOIN LATERAL to join each driver with their top 3 trips.
```
Answer:
```

**Q17:** Write a materialized view creation query for daily driver statistics with refresh strategy.
```
Answer:
```

**Q18:** Write a query analyzing query performance: sequential scan vs index scan tradeoff.
```
Answer:
```

**Q19:** Write a query to denormalize trip data for analytics (adding driver/rider name to trips table).
```
Answer:
```

**Q20:** Write a partitioning strategy query (example: partition trips table by month).
```
Answer:
```

---

## Scenario-Based Questions (21-23)

**Scenario 1: Query Performance Regression**

A query that previously ran in 2 seconds is now taking 30 seconds. The query is:
```sql
SELECT t.id, t.fare, d.name, r.name
FROM trips t
JOIN drivers d ON t.driver_id = d.id
JOIN riders r ON t.rider_id = r.id
WHERE d.city = 'Johannesburg' AND t.status = 'completed'
ORDER BY t.created_at DESC
LIMIT 100;
```

**Q21:** Diagnose the issue and propose a solution.
```
Answer:
```

**Scenario 2: Incorrect Aggregation Results**

This query returns unexpected counts:
```sql
SELECT d.id, d.name, COUNT(*) as trip_count
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
LEFT JOIN reviews r ON t.id = r.trip_id
GROUP BY d.id, d.name;
```

**Q22:** Identify the problem and write the corrected query.
```
Answer:
```

**Scenario 3: Data Warehouse Aggregation Query Optimization**

A dashboard needs to show daily metrics for 100 cities across 3 years of data (approx 1 million rows). The query is slow:
```sql
SELECT DATE(requested_at) as day, pickup_location, 
  COUNT(*) as trips, AVG(fare) as avg_fare, SUM(distance_km) as total_distance
FROM trips
WHERE requested_at >= '2021-01-01'
GROUP BY DATE(requested_at), pickup_location
ORDER BY day DESC;
```

**Q23:** Propose an optimization strategy including indexing, materialization, and query redesign.
```
Answer:
```

---

## Answer Key - EXAM 3

**MCQ Answers:**
1. B | 2. B | 3. B | 4. B | 5. C

**SQL Writing Answers:**

**Q6:**
```sql
SELECT id, driver_id, status,
  ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY created_at) as trip_rank
FROM trips;
```

**Q7:**
```sql
SELECT * FROM (
  SELECT id, driver_id, fare,
    ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY fare DESC) as rn
  FROM trips
) ranked
WHERE rn <= 3;
```

**Q8:**
```sql
WITH RECURSIVE trip_hops AS (
  SELECT id, driver_id, 1 as hop FROM trips WHERE driver_id = 5
  UNION ALL
  SELECT t.id, t.driver_id, h.hop + 1
  FROM trips t
  JOIN trip_hops h ON t.driver_id = h.driver_id
  WHERE h.hop < 2
)
SELECT DISTINCT * FROM trip_hops;
```

**Q9:**
```sql
EXPLAIN ANALYZE
SELECT t.id, d.name, COUNT(*) as trip_count
FROM trips t
JOIN drivers d ON t.driver_id = d.id
WHERE t.status = 'completed'
GROUP BY t.id, d.name;
-- High "Actual Rows" means many rows scanned; may indicate index not used or 
-- filter too broad; consider indexes on (status, driver_id)
```

**Q10:**
```sql
-- Query to find unused indexes (PostgreSQL):
SELECT i.relname as index_name, ix.indrelname as table_name
FROM pg_stat_user_indexes i
WHERE i.idx_scan = 0
ORDER BY i.idx_blks_read DESC;
-- Indexes with 0 scans are unused; drop to improve write performance
```

**Q11:**
```sql
SELECT driver_id, earned_at, net_amount,
  SUM(net_amount) OVER (PARTITION BY driver_id ORDER BY earned_at 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM driver_earnings
ORDER BY driver_id, earned_at;
```

**Q12:**
```sql
SELECT id, pickup_location, fare,
  PERCENT_RANK() OVER (PARTITION BY pickup_location ORDER BY fare) * 100 as percentile
FROM trips
ORDER BY pickup_location, percentile DESC;
```

**Q13:**
```sql
WITH driver_trips AS (
  SELECT driver_id, COUNT(*) as trip_count
  FROM trips
  WHERE status = 'completed'
  GROUP BY driver_id
),
driver_revenue AS (
  SELECT driver_id, SUM(net_amount) as total_revenue, AVG(net_amount) as avg_revenue
  FROM driver_earnings
  GROUP BY driver_id
),
driver_ratings AS (
  SELECT reviewee_id, AVG(rating) as avg_rating, COUNT(*) as review_count
  FROM reviews
  WHERE reviewer_type = 'rider'
  GROUP BY reviewee_id
)
SELECT d.id, d.name, dt.trip_count, dr.total_revenue, drat.avg_rating
FROM drivers d
LEFT JOIN driver_trips dt ON d.id = dt.driver_id
LEFT JOIN driver_revenue dr ON d.id = dr.driver_id
LEFT JOIN driver_ratings drat ON d.id = drat.reviewee_id
ORDER BY dr.total_revenue DESC;
```

**Q14:**
```sql
UPDATE drivers SET rating = rating + 0.1
WHERE id IN (
  SELECT driver_id FROM trips
  WHERE status = 'completed'
  GROUP BY driver_id
  HAVING COUNT(*) > 10
);
```

**Q15:**
```sql
-- Inefficient (N+1 pattern - correlated subquery):
SELECT d.id, (SELECT COUNT(*) FROM trips WHERE driver_id = d.id) as trip_count
FROM drivers d;

-- Efficient (JOIN + aggregation):
SELECT d.id, COUNT(t.id) as trip_count
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id;
```

**Q16:**
```sql
SELECT d.id, d.name, t.id, t.fare, t.status
FROM drivers d
JOIN LATERAL (
  SELECT id, fare, status
  FROM trips
  WHERE driver_id = d.id
  ORDER BY fare DESC
  LIMIT 3
) t ON true;
```

**Q17:**
```sql
CREATE MATERIALIZED VIEW daily_driver_stats AS
SELECT DATE(earned_at) as stat_date, driver_id,
  SUM(net_amount) as daily_earnings,
  COUNT(*) as daily_trips,
  AVG(net_amount) as avg_trip_earning
FROM driver_earnings
GROUP BY DATE(earned_at), driver_id;

-- Refresh strategy: REFRESH MATERIALIZED VIEW daily_driver_stats;
-- Schedule nightly after daily ETL completes
```

**Q18:**
```sql
-- Query with tradeoff analysis:
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM trips WHERE driver_id = 5;
-- Sequential scan cost: O(n) - scans all rows, slower for large tables
-- Index scan cost: O(log n) - fast if index exists on driver_id, but index 
--   only beneficial if selectivity > ~5% of rows

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM trips WHERE status = 'completed';
-- Low selectivity (>80% of rows are completed); sequential scan faster than 
-- index + lookup
```

**Q19:**
```sql
-- Denormalization: Add driver/rider names to trips for faster analytics reads
ALTER TABLE trips ADD COLUMN driver_name VARCHAR(100);
ALTER TABLE trips ADD COLUMN rider_name VARCHAR(100);

-- Populate with UPDATE + JOIN:
UPDATE trips t SET driver_name = d.name
FROM drivers d WHERE t.driver_id = d.id;

UPDATE trips t SET rider_name = r.name
FROM riders r WHERE t.rider_id = r.id;

-- Trade-off: Faster reads; slower writes (must maintain consistency)
-- Use triggers to keep denormalized columns in sync
```

**Q20:**
```sql
-- Partitioning strategy: Partition trips by month for faster range queries
-- Create partitioned table:
CREATE TABLE trips_partitioned (
  id SERIAL, driver_id INT, rider_id INT, fare DECIMAL, 
  requested_at TIMESTAMPTZ, ...
) PARTITION BY RANGE (DATE_TRUNC('month', requested_at));

-- Create partitions per month:
CREATE TABLE trips_2023_01 PARTITION OF trips_partitioned
  FOR VALUES FROM ('2023-01-01') TO ('2023-02-01');

CREATE TABLE trips_2023_02 PARTITION OF trips_partitioned
  FOR VALUES FROM ('2023-02-01') TO ('2023-03-01');

-- Benefit: Queries on specific months scan single partition; faster; easier 
-- retention management (drop old partitions)
```

---

## Scenario Answers

**Scenario 1 Answer:**
```
Diagnosis: Likely missing indexes on join columns (driver_id, rider_id) or filter 
columns (city, status). The query must now do full table scans and hash joins 
instead of efficient index-based lookups.

Proposed Solution:
1. Create index: CREATE INDEX idx_trips_driver_id ON trips(driver_id);
2. Create index: CREATE INDEX idx_trips_rider_id ON trips(rider_id);
3. Create composite index: CREATE INDEX idx_drivers_city ON drivers(city);
4. Create covering index: CREATE INDEX idx_trips_status_created 
   ON trips(status, created_at) INCLUDE (driver_id, rider_id, fare);

Verify with: EXPLAIN ANALYZE before/after to confirm index usage.
```

**Scenario 2 Answer:**
```
Problem: The LEFT JOINs without filtering create a Cartesian product of trips 
× reviews. If a trip has 5 reviews, that trip gets counted 5 times per group, 
inflating trip_count.

Corrected Query:
SELECT d.id, d.name, COUNT(DISTINCT t.id) as trip_count
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
LEFT JOIN reviews r ON t.id = r.trip_id
GROUP BY d.id, d.name;

OR better (avoids multiple LEFT JOINs):
SELECT d.id, d.name, COUNT(*) as trip_count
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id, d.name;
-- Use separate query for reviews if needed; avoid multi-level LEFT JOINs
```

**Scenario 3 Answer:**
```
Optimization Strategy:

1. Indexing:
   CREATE INDEX idx_trips_requested_at ON trips(requested_at);
   CREATE INDEX idx_trips_pickup_location_requested_at 
     ON trips(pickup_location, requested_at);

2. Materialization:
   Create a pre-aggregated materialized view:
   CREATE MATERIALIZED VIEW daily_city_metrics AS
   SELECT DATE(requested_at) as day, pickup_location,
     COUNT(*) as trips, AVG(fare) as avg_fare, SUM(distance_km) as total_distance
   FROM trips
   WHERE requested_at >= '2021-01-01'
   GROUP BY DATE(requested_at), pickup_location;
   
   Schedule refresh: REFRESH MATERIALIZED VIEW daily_city_metrics; (nightly)

3. Query Redesign:
   SELECT day, pickup_location, trips, avg_fare, total_distance
   FROM daily_city_metrics
   ORDER BY day DESC;
   -- Reads from pre-computed materialized view; instant response

4. Partitioning (optional for older data):
   Partition trips table by year; archive 2021 data to separate partition
   for faster queries on recent data.

Expected improvement: From seconds to milliseconds; dashboard instant response.
```

---

## Difficulty Ratings - EXAM 3

| Q# | Difficulty | Topic |
|----|-----------|-------|
| 1-5 | Hard | Performance, execution plans, indexes |
| 6-7 | Hard | Window functions, ROW_NUMBER |
| 8 | Expert | Recursive CTEs |
| 9-10 | Expert | EXPLAIN analysis, index diagnostics |
| 11-12 | Hard | Window functions with aggregates |
| 13 | Expert | Multi-CTE performance analysis |
| 14-15 | Hard | Subquery optimization |
| 16-17 | Expert | LATERAL joins, materialized views |
| 18-20 | Expert | Query optimization, partitioning, denormalization |
| 21-23 | Expert | Scenario diagnosis and optimization |

---

**Exam Strategy Tips:**

- Start with MCQ (quick wins)
- Allocate 30 min for SQL writing, 15 min for scenarios
- Write efficient, readable SQL (not just functional)
- Use EXPLAIN ANALYZE to verify solutions
- Scenarios test real-world debugging; explain your reasoning

**Pass Criteria:** 70% = 14/20 points. Review any topic scoring <60% before retesting.

