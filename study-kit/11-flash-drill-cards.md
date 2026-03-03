# ⚡ Flash Drill Cards

100 rapid-fire Q&A cards to test your SQL knowledge. Use these daily to build muscle memory and quick recall. Each card targets a specific concept; difficulty-tagged for progressive practice.

---

## How to Use Flash Cards

1. **Quick Recall:** Answer in your head before reading answer
2. **Speed Round:** Aim to answer 20 rapid-fire cards in <2 minutes (5 sec per card)
3. **Struggle Cards:** Mark cards where you hesitated; review daily
4. **Mix Topics:** Don't drill only easy cards; rotate difficulty
5. **Progressive:** Start with [EASY], move to [MEDIUM], then [HARD]

---

## DAY 1-2: FOUNDATIONS (Cards 1-10)

**CARD 1:** [EASY] SELECT Syntax
**Q:** What is the keyword to retrieve data from a table?
**A:** SELECT

---

**CARD 2:** [EASY] WHERE Clause
**Q:** What clause filters rows based on conditions?
**A:** WHERE

---

**CARD 3:** [EASY] Data Types
**Q:** In PostgreSQL, what data type stores text up to 100 characters?
**A:** VARCHAR(100) or CHARACTER VARYING(100)

---

**CARD 4:** [EASY] Primary Key
**Q:** What constraint ensures uniqueness and not null?
**A:** PRIMARY KEY

---

**CARD 5:** [EASY] NULL Handling
**Q:** True or False: `WHERE age = NULL` finds rows where age is null.
**A:** FALSE. Use `WHERE age IS NULL` instead.

---

**CARD 6:** [MEDIUM] INSERT Syntax
**Q:** Write the correct INSERT syntax for adding a driver with name 'John' and city 'Jozi'.
**A:** `INSERT INTO drivers (name, city) VALUES ('John', 'Jozi');`

---

**CARD 7:** [MEDIUM] UPDATE Syntax
**Q:** How do you update driver id=5 to set rating=4.8?
**A:** `UPDATE drivers SET rating = 4.8 WHERE id = 5;`

---

**CARD 8:** [MEDIUM] DELETE with WHERE
**Q:** What is the dangerous consequence of `DELETE FROM trips` without WHERE?
**A:** Deletes ALL trips in the table permanently.

---

**CARD 9:** [MEDIUM] LIMIT and OFFSET
**Q:** What does `LIMIT 10 OFFSET 20` do?
**A:** Skips first 20 rows, then returns next 10 rows.

---

**CARD 10:** [EASY] ORDER BY
**Q:** Does `ORDER BY fare DESC` show lowest or highest fares first?
**A:** Highest fares first (DESC = descending).

---

## DAY 3-4: JOINs & FILTERING (Cards 11-20)

**CARD 11:** [EASY] INNER JOIN
**Q:** Does INNER JOIN return unmatched rows from the left table?
**A:** No. INNER JOIN returns only matching rows from both tables.

---

**CARD 12:** [EASY] LEFT JOIN
**Q:** What does LEFT JOIN do with unmatched left rows?
**A:** Keeps them with NULL values for right table columns.

---

**CARD 13:** [MEDIUM] JOIN ON Condition
**Q:** What happens if you write `FROM drivers, trips` without ON condition?
**A:** Cartesian product; every driver matched with every trip.

---

**CARD 14:** [MEDIUM] Multiple JOINs
**Q:** Can you join 3+ tables in one query?
**A:** Yes. `FROM t1 JOIN t2 ON ... JOIN t3 ON ...`

---

**CARD 15:** [MEDIUM] FULL OUTER JOIN
**Q:** What is the SQL for FULL OUTER JOIN?
**A:** `FULL OUTER JOIN` (or FULL JOIN); includes all rows from both tables.

---

**CARD 16:** [EASY] LIKE Pattern
**Q:** What does `WHERE name LIKE 'J%'` return?
**A:** Names starting with 'J'.

---

**CARD 17:** [EASY] LIKE Wildcards
**Q:** In LIKE, what does underscore `_` match?
**A:** Single character.

---

**CARD 18:** [MEDIUM] IN Clause
**Q:** Write WHERE clause for driver_id in (1, 5, 10).
**A:** `WHERE driver_id IN (1, 5, 10)`

---

**CARD 19:** [MEDIUM] BETWEEN Operator
**Q:** What does `WHERE fare BETWEEN 10 AND 50` return?
**A:** Fares >= 10 AND <= 50 (inclusive on both ends).

---

**CARD 20:** [MEDIUM] Compound Conditions
**Q:** How do you combine multiple WHERE conditions?
**A:** Use AND / OR / NOT operators.

---

## DAY 5: AGGREGATES & GROUPING (Cards 21-30)

**CARD 21:** [EASY] COUNT Function
**Q:** What does `COUNT(*)` return?
**A:** Total number of rows (including NULLs).

---

**CARD 22:** [EASY] COUNT vs COUNT(column)
**Q:** What's the difference between `COUNT(*)` and `COUNT(email)`?
**A:** COUNT(*) counts all rows; COUNT(email) skips NULL emails.

---

**CARD 23:** [EASY] SUM Function
**Q:** What does `SUM(fare)` return with values [10, 20, NULL, 30]?
**A:** 60 (NULLs are skipped; 10+20+30).

---

**CARD 24:** [EASY] AVG Function
**Q:** What does `AVG(rating)` return with values [4, 4, NULL, 5]?
**A:** 4.33 (NULL skipped; (4+4+5)/3).

---

**CARD 25:** [MEDIUM] GROUP BY
**Q:** What does `GROUP BY driver_id` produce?
**A:** One row per unique driver_id; used with aggregates.

---

**CARD 26:** [MEDIUM] GROUP BY Multiple Columns
**Q:** Can you GROUP BY multiple columns?
**A:** Yes. `GROUP BY city, vehicle_type` groups by both.

---

**CARD 27:** [MEDIUM] HAVING Clause
**Q:** When is HAVING used instead of WHERE?
**A:** HAVING filters AFTER GROUP BY; filters groups, not individual rows.

---

**CARD 28:** [MEDIUM] HAVING vs WHERE
**Q:** Can you use aggregate functions in WHERE?
**A:** No. Use HAVING for aggregate conditions. WHERE filters before GROUP BY.

---

**CARD 29:** [HARD] GROUP BY with Multiple Aggregates
**Q:** Write query: trips per driver, average fare per driver, max distance per driver.
**A:** `SELECT driver_id, COUNT(*), AVG(fare), MAX(distance_km) FROM trips GROUP BY driver_id;`

---

**CARD 30:** [EASY] DISTINCT
**Q:** What does `SELECT DISTINCT city FROM drivers` return?
**A:** Each unique city once (no duplicates).

---

## DAY 6: FUNCTIONS & NULL HANDLING (Cards 31-40)

**CARD 31:** [EASY] UPPER Function
**Q:** What does `UPPER('john')` return?
**A:** 'JOHN' (converts to uppercase).

---

**CARD 32:** [EASY] LOWER Function
**Q:** What does `LOWER('JOHN')` return?
**A:** 'john' (converts to lowercase).

---

**CARD 33:** [EASY] LENGTH Function
**Q:** What does `LENGTH('hello')` return?
**A:** 5 (number of characters).

---

**CARD 34:** [MEDIUM] SUBSTRING
**Q:** What does `SUBSTRING('hello', 1, 3)` return?
**A:** 'hel' (characters 1-3; 1-indexed).

---

**CARD 35:** [MEDIUM] CONCAT Function
**Q:** How do you concatenate 'John' and 'Doe' with space?
**A:** `CONCAT('John', ' ', 'Doe')` or `'John' || ' ' || 'Doe'` in PostgreSQL.

---

**CARD 36:** [EASY] COALESCE
**Q:** What does `COALESCE(NULL, NULL, 'default')` return?
**A:** 'default' (first non-NULL value).

---

**CARD 37:** [MEDIUM] COALESCE Multiple
**Q:** What does `COALESCE(phone, email, 'no contact')` do?
**A:** Returns phone if not null, else email, else 'no contact'.

---

**CARD 38:** [EASY] IS NULL
**Q:** True or False: `WHERE created_at IS NULL` finds missing creation dates.
**A:** TRUE.

---

**CARD 39:** [MEDIUM] CASE Statement
**Q:** Write CASE for trip length: <5km='short', 5-15='medium', >15='long'.
**A:** `CASE WHEN distance < 5 THEN 'short' WHEN distance <= 15 THEN 'medium' ELSE 'long' END`

---

**CARD 40:** [MEDIUM] CASE with Multiple Conditions
**Q:** Can CASE have multiple WHEN conditions?
**A:** Yes. Each WHEN is tested in order; first match wins.

---

## DAY 7: CTEs & SUBQUERIES (Cards 41-50)

**CARD 41:** [MEDIUM] CTE Syntax
**Q:** What keyword starts a Common Table Expression?
**A:** WITH

---

**CARD 42:** [MEDIUM] CTE Definition
**Q:** What is a CTE used for?
**A:** Named subquery; readable multi-step queries; reusable within same query.

---

**CARD 43:** [MEDIUM] CTE Example
**Q:** Write a CTE that defines active_drivers as drivers where is_active = true.
**A:** `WITH active_drivers AS (SELECT * FROM drivers WHERE is_active = true) SELECT * FROM active_drivers;`

---

**CARD 44:** [MEDIUM] Multiple CTEs
**Q:** Can you define multiple CTEs in one query?
**A:** Yes. `WITH cte1 AS (...), cte2 AS (...) SELECT ...`

---

**CARD 45:** [HARD] Recursive CTE
**Q:** What keyword enables recursive CTEs?
**A:** RECURSIVE (e.g., `WITH RECURSIVE cte AS ...`)

---

**CARD 46:** [MEDIUM] Subquery in WHERE
**Q:** What is a subquery?
**A:** Query within a query; returns result set used by outer query.

---

**CARD 47:** [MEDIUM] Subquery in FROM
**Q:** Can you use a subquery in FROM clause?
**A:** Yes. Creates derived table: `FROM (SELECT ...) AS subquery_name`

---

**CARD 48:** [HARD] Correlated Subquery
**Q:** What's the performance issue with correlated subqueries?
**A:** Runs subquery once per outer row (O(n)); slower than JOIN.

---

**CARD 49:** [MEDIUM] Subquery Returns Multiple Rows
**Q:** How do you handle subquery returning multiple rows in WHERE?
**A:** Use IN: `WHERE driver_id IN (SELECT ...)`

---

**CARD 50:** [MEDIUM] EXISTS Operator
**Q:** What does `EXISTS (SELECT 1 FROM trips WHERE driver_id = d.id)` check?
**A:** Whether any trip exists for that driver (true/false).

---

## DAY 8: VIEWS & DDL (Cards 51-60)

**CARD 51:** [MEDIUM] VIEW Definition
**Q:** What is a VIEW?
**A:** Virtual table; stored query result (computed on each access).

---

**CARD 52:** [MEDIUM] CREATE VIEW
**Q:** Write syntax to create a view of high-rated drivers.
**A:** `CREATE VIEW high_rated_drivers AS SELECT * FROM drivers WHERE rating > 4.5;`

---

**CARD 53:** [MEDIUM] Materialized View
**Q:** What's the difference between VIEW and MATERIALIZED VIEW?
**A:** VIEW computed each time; MATERIALIZED VIEW pre-computed and stored (faster reads, stale data).

---

**CARD 54:** [MEDIUM] REFRESH MATERIALIZED VIEW
**Q:** How do you update a materialized view?
**A:** `REFRESH MATERIALIZED VIEW view_name;`

---

**CARD 55:** [EASY] CREATE TABLE
**Q:** What DDL command creates a new table?
**A:** CREATE TABLE

---

**CARD 56:** [MEDIUM] ALTER TABLE
**Q:** How do you add a new column to existing table?
**A:** `ALTER TABLE table_name ADD COLUMN column_name data_type;`

---

**CARD 57:** [EASY] DROP TABLE
**Q:** What does `DROP TABLE trips` do?
**A:** Removes entire table and all data permanently.

---

**CARD 58:** [EASY] TRUNCATE vs DELETE
**Q:** True or False: TRUNCATE is slower than DELETE.
**A:** FALSE. TRUNCATE is faster (minimal logging; faster cleanup).

---

**CARD 59:** [MEDIUM] Constraints
**Q:** Name 4 types of constraints.
**A:** PRIMARY KEY, UNIQUE, NOT NULL, FOREIGN KEY, CHECK

---

**CARD 60:** [MEDIUM] FOREIGN KEY
**Q:** What does a FOREIGN KEY constraint enforce?
**A:** Referential integrity; foreign key value must exist as primary key in referenced table.

---

## DAY 9: WINDOW FUNCTIONS & PERFORMANCE (Cards 61-70)

**CARD 61:** [HARD] Window Function
**Q:** What's the key difference between window functions and GROUP BY?
**A:** Window functions keep all rows; GROUP BY collapses to one row per group.

---

**CARD 62:** [HARD] ROW_NUMBER() Function
**Q:** What does `ROW_NUMBER() OVER (ORDER BY fare DESC)` do?
**A:** Ranks each row 1, 2, 3... in fare-descending order.

---

**CARD 63:** [HARD] PARTITION BY
**Q:** What does `ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY fare DESC)` do?
**A:** Ranks trips within each driver, resetting for new driver.

---

**CARD 64:** [HARD] RANK vs ROW_NUMBER
**Q:** What's the difference between RANK() and ROW_NUMBER()?
**A:** RANK() gives same rank for ties; ROW_NUMBER() unique sequential numbers.

---

**CARD 65:** [HARD] Running Total
**Q:** How do you calculate running total with window function?
**A:** `SUM(column) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`

---

**CARD 66:** [MEDIUM] EXPLAIN Command
**Q:** What does EXPLAIN show?
**A:** Optimizer's query execution plan (estimated costs and steps).

---

**CARD 67:** [MEDIUM] EXPLAIN ANALYZE
**Q:** What does EXPLAIN ANALYZE show that EXPLAIN doesn't?
**A:** Actual execution time, actual rows scanned (vs estimated).

---

**CARD 68:** [MEDIUM] INDEX Definition
**Q:** What does an INDEX do?
**A:** Speeds up retrieval by storing sorted copy of column(s).

---

**CARD 69:** [MEDIUM] B-Tree Index
**Q:** When is a B-Tree index used?
**A:** Default index; supports equality and range queries (<, >, BETWEEN).

---

**CARD 70:** [HARD] Index Selectivity
**Q:** When is an index more beneficial?
**A:** High selectivity (many distinct values); avoids index when <5% of rows filtered.

---

## DAY 10: ADVANCED CONCEPTS (Cards 71-80)

**CARD 71:** [HARD] Execution Plan
**Q:** What's the most expensive operation in an execution plan?
**A:** Full table scan (Sequential Scan); index scan is faster.

---

**CARD 72:** [HARD] Join Methods
**Q:** Name three join methods an optimizer can choose.
**A:** Nested Loop, Hash Join, Merge Join

---

**CARD 73:** [HARD] Merge Join Requirement
**Q:** What must be true for a Merge Join to be efficient?
**A:** Data must be pre-sorted or indexed in both tables.

---

**CARD 74:** [HARD] Normalization
**Q:** What is database normalization?
**A:** Organizing data to minimize redundancy (1NF, 2NF, 3NF, BCNF).

---

**CARD 75:** [HARD] Denormalization Trade-off
**Q:** Why would you intentionally denormalize data?
**A:** Faster reads by reducing joins; trade-off is slower writes and potential inconsistency.

---

**CARD 76:** [HARD] Partitioning
**Q:** What does table partitioning do?
**A:** Divides table into smaller sub-tables by value (e.g., by date); faster range queries.

---

**CARD 77:** [HARD] Cardinality
**Q:** What is cardinality in database context?
**A:** Number of unique values in column; high cardinality (many unique) good for indexing.

---

**CARD 78:** [HARD] Transaction ACID
**Q:** What does ACID guarantee?
**A:** Atomicity (all-or-nothing), Consistency (valid state), Isolation (no interference), Durability (survives failures).

---

**CARD 79:** [HARD] Deadlock
**Q:** What is a deadlock?
**A:** Two transactions waiting for each other; neither can proceed.

---

**CARD 80:** [HARD] Query Optimization
**Q:** True or False: Writing more indexes always speeds up queries.
**A:** FALSE. Unused indexes slow writes; selective indexes help.

---

## FINAL TOPICS: INTEGRATION & MASTERY (Cards 81-100)

**CARD 81:** [MEDIUM] UNION
**Q:** What does UNION do?
**A:** Combines results from two queries; removes duplicates.

---

**CARD 82:** [MEDIUM] UNION ALL
**Q:** What does UNION ALL do?
**A:** Combines results from two queries; keeps duplicates.

---

**CARD 83:** [HARD] Performance Troubleshooting
**Q:** First step when query is slow?
**A:** Run EXPLAIN ANALYZE to see actual execution plan.

---

**CARD 84:** [MEDIUM] Data Types
**Q:** Should you use VARCHAR or TEXT for variable-length strings?
**A:** Both are identical in PostgreSQL; VARCHAR(n) with limit is safer.

---

**CARD 85:** [EASY] Comment in SQL
**Q:** How do you write a comment in SQL?
**A:** `-- single line` or `/* multi-line */`

---

**CARD 86:** [HARD] N+1 Problem
**Q:** What is the N+1 query problem?
**A:** Running 1 query to get N rows, then 1 query per row; total N+1 queries.

---

**CARD 87:** [HARD] Solution to N+1
**Q:** How do you fix N+1 queries?
**A:** Use JOIN to combine in single query; or batch load related data.

---

**CARD 88:** [MEDIUM] Date Functions
**Q:** How do you get current date in PostgreSQL?
**A:** `CURRENT_DATE` or `NOW()::DATE`

---

**CARD 89:** [MEDIUM] INTERVAL
**Q:** How do you find records from last 7 days?
**A:** `WHERE created_at > NOW() - INTERVAL '7 days'`

---

**CARD 90:** [HARD] Stats and Indexes
**Q:** How do you update table statistics for optimizer?
**A:** `ANALYZE table_name;` (helps optimizer choose better plans).

---

## SPEED ROUND (Cards 91-100)

**Answer these in <5 seconds each:**

**CARD 91:** [EASY] What does SELECT 1; return?
**A:** Single row with value 1.

---

**CARD 92:** [EASY] True or False: PRIMARY KEY can be NULL.
**A:** FALSE.

---

**CARD 93:** [EASY] Does ORDER BY slow down queries?
**A:** Yes; sorting is expensive.

---

**CARD 94:** [EASY] Can you have multiple PRIMARY KEYs?
**A:** No; only one PRIMARY KEY per table.

---

**CARD 95:** [EASY] True or False: CREATE VIEW requires EXECUTE permission.
**A:** FALSE; requires CREATE permission.

---

**CARD 96:** [MEDIUM] What's the result of SELECT 0/0;
**A:** Error or NULL (depending on database); zero division not allowed.

---

**CARD 97:** [MEDIUM] Does LIMIT without ORDER BY guarantee order?
**A:** No; order is undefined without ORDER BY.

---

**CARD 98:** [MEDIUM] Can you UPDATE in a transaction?
**A:** Yes; UPDATE is DML; can be rolled back.

---

**CARD 99:** [HARD] What's the maximum OFFSET you can use?
**A:** No limit; but inefficient for large offsets (use keyset pagination).

---

**CARD 100:** [HARD] True or False: CTEs are always faster than subqueries.
**A:** FALSE; depends on optimizer; functionally equivalent in modern databases.

---

## Scoring Guide

- **90-100 correct:** Expert level; ready for advanced optimization
- **80-89 correct:** Proficient; solid fundamentals, some advanced gaps
- **70-79 correct:** Competent; fundamentals strong, review medium/hard cards
- **60-69 correct:** Developing; review EASY cards, practice more
- **<60 correct:** Restart fundamentals; use practice queries daily

---

**Usage Tip:** Retake this drill deck weekly. Your speed and accuracy will improve dramatically by Day 10.

