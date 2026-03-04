# 🧠 Active Recall Question Bank
**120+ Questions to Test & Build Your SQL Mastery**

---

## 📖 How to Use This

**Active recall** = forcing your brain to retrieve information.

**Method:**
1. Read question
2. **Close this file** (don't peek at answer)
3. Write/speak your answer
4. Check answer (blockquote below)
5. Grade yourself: ✅ Correct, ⚠️ Partial, ❌ Wrong
6. Review answer explanation if wrong

**Goal:** Move from "I've heard of this" → "I know this cold"

---

## 🎯 Conceptual Questions (Days 1-3)

### Q1: Explain the difference between WHERE and HAVING

> **Answer:** WHERE filters rows BEFORE grouping (on table rows). HAVING filters rows AFTER grouping (on aggregate results). WHERE can't use aggregate functions; HAVING must. Example: `WHERE fare > 20` (before GROUP BY), `HAVING COUNT(*) > 10` (after GROUP BY).

### Q2: Why does `SELECT COUNT(*) FROM trips WHERE driver_id IN (SELECT NULL)` return 0?

> **Answer:** `IN (NULL)` is a special case. NULL comparisons always return UNKNOWN, never TRUE. So no rows match. Fix: Use `NOT EXISTS` for safer NULL handling. `IN (NULL, 1, 2)` → only matches 1 or 2.

### Q3: Can you use LIMIT without ORDER BY?

> **Answer:** Technically yes, but it's meaningless. LIMIT returns first N rows in arbitrary order (usually insertion order, but not guaranteed). Always pair LIMIT with ORDER BY for predictable results.

### Q4: What's the difference between DISTINCT and GROUP BY with no aggregate?

> **Answer:** Both remove duplicates. `SELECT DISTINCT city FROM drivers` = `SELECT city FROM drivers GROUP BY city`. GROUP BY is slightly slower (extra aggregation overhead) but clearer intent.

### Q5: Explain CROSS JOIN in one sentence

> **Answer:** Creates all possible combinations of two tables. 5 drivers × 10 riders = 50 rows. Use case: Generate all possible pairings for assignment algorithms.

---

## 🎯 JOIN Questions (Day 2)

### Q6: LEFT JOIN returns all rows from LEFT table, but what if they don't match?

> **Answer:** NULLs fill the missing columns from the RIGHT table. Example: `drivers LEFT JOIN trips` → drivers with no trips show NULL for trip columns (id, fare, etc.).

### Q7: Why does `INNER JOIN ... ON a.id = b.id AND b.status = 'completed'` differ from `INNER JOIN ... ON a.id = b.id WHERE b.status = 'completed'`?

> **Answer:** They're equivalent for INNER JOIN (both filter the same way). But for LEFT JOIN they differ: the first filters in the join (some left rows may disappear), the second filters after (left rows preserved, right columns may be NULL). Always use WHERE for filtering unless deliberately filtering in the join.

### Q8: Can you JOIN on non-key columns?

> **Answer:** Yes! JOIN doesn't care if the column is a key or not. `JOIN drivers d ON trips.driver_id = d.id` works fine. Any equality (or other operator) works.

### Q9: What's a self-join? When would you use it?

> **Answer:** Joining a table to itself. Example: Find all pairs of drivers in the same city: `SELECT d1.name, d2.name FROM drivers d1 JOIN drivers d2 ON d1.city = d2.city AND d1.id < d2.id`. The `id < d2.id` prevents duplicates (Alice-Bob, Bob-Alice).

### Q10: FULL OUTER JOIN with 3 tables?

> **Answer:** Possible but tricky. Chain them: `t1 FULL JOIN t2 ON ... FULL JOIN t3 ON ...`. Usually you want multiple LEFT JOINs for clarity. FULL is rare in practice.

---

## 🎯 Window Function Questions (Days 4-5)

### Q11: What does `ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY fare DESC)` do?

> **Answer:** Assigns sequential numbers (1, 2, 3...) to rows within each driver_id partition, ordered by fare descending. So the highest fare trip gets #1, next highest #2, etc. Useful for "top N per group".

### Q12: Difference between ROW_NUMBER, RANK, and DENSE_RANK?

> **Answer:** 
> - ROW_NUMBER: Always unique (1, 2, 3, 4)
> - RANK: Ties get same rank, skips next (1, 2, 2, 4)
> - DENSE_RANK: Ties get same rank, no skip (1, 2, 2, 3)
> For tied salaries: ROW_NUMBER gives 1,2,3. RANK gives 1,2,2,4. DENSE_RANK gives 1,2,2,3.

### Q13: Can you use PARTITION BY without ORDER BY?

> **Answer:** Yes, but result is usually meaningless. ORDER BY defines the sort order of rows in the frame. Without it, frame order is undefined. Always include ORDER BY for predictable results.

### Q14: What does `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` mean?

> **Answer:** Creates a running total frame: from first row to current row. Example: cumulative sum of fares: row 1 = sum of row 1, row 2 = sum of rows 1-2, row 3 = sum of rows 1-3. (Default for SUM, AVG if you use ORDER BY).

### Q15: How do you get "top 3 trips per driver" using window functions?

> **Answer:** 
> ```sql
> WITH ranked AS (
>   SELECT *, ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY fare DESC) as rn
>   FROM trips
> )
> SELECT * FROM ranked WHERE rn <= 3;
> ```

---

## 🎯 CTE & Subquery Questions (Day 6)

### Q16: What's the difference between CTE and subquery?

> **Answer:** Functionally similar. CTE (WITH clause) is more readable, reusable, can be recursive. Subquery (FROM or WHERE) is inline, less readable. Performance: modern DBs optimize both similarly. Prefer CTEs for clarity.

### Q17: Can you reference a CTE twice in same query?

> **Answer:** Yes! And the CTE is materialized once, reused twice. Example:
> ```sql
> WITH driver_stats AS (SELECT driver_id, AVG(fare) FROM trips GROUP BY driver_id)
> SELECT * FROM driver_stats WHERE fare > 50
> UNION
> SELECT * FROM driver_stats WHERE fare < 20;
> ```

### Q18: What's a correlated subquery? Is it fast?

> **Answer:** Subquery that references outer table. Example: `SELECT * FROM trips t WHERE fare > (SELECT AVG(fare) FROM trips WHERE driver_id = t.driver_id)`. Executes once per outer row (N+1 problem). Usually slow. Fix: Use JOIN or CTE.

### Q19: Can you use window functions in a subquery?

> **Answer:** Yes! Example:
> ```sql
> SELECT * FROM (
>   SELECT *, ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY fare DESC) as rn
>   FROM trips
> ) ranked
> WHERE rn = 1;
> ```

### Q20: What's a recursive CTE? Give one-word use case.

> **Answer:** Self-referencing CTE. Use case: **Hierarchies** (org charts, file systems) or **sequences** (generate numbers 1-100). Example: Walk a tree structure.

---

## 🎯 Views, Procedures, Triggers (Day 7)

### Q21: View vs Materialized View in one sentence?

> **Answer:** View: stored query, executed each time. Materialized: snapshot, stored physically, must refresh. View is slower on repeated queries; materialized view has stale data risk.

### Q22: Can you UPDATE through a view?

> **Answer:** Only if view is "simple" (single table, no aggregation). Complex views (JOINs, GROUP BY) need INSTEAD OF trigger to be updateable.

### Q23: What's parameter sniffing in stored procedures?

> **Answer:** Procedure uses first parameter values to build execution plan, caches it. If second call has very different parameters, the cached plan may be suboptimal. Example: CALL proc(10) → plan for 10 rows. CALL proc(1000000) → uses same plan, slow.

### Q24: When would you use a trigger instead of application logic?

> **Answer:** Triggers enforce rules in database (guaranteed, even if app buggy). Example: Audit trail (log every INSERT), data validation (prevent invalid status), cascading updates (SCD Type 2). Trade-off: harder to debug, hidden logic.

### Q25: Why is synchronous trigger performance bad?

> **Answer:** User waits for trigger to complete before INSERT returns. At scale (1000 inserts/sec), each 10ms trigger = 10 second backlog. Solution: Async (queue) or move logic to app.

---

## 🎯 Indexes & Execution (Day 8)

### Q26: Why does `WHERE EXTRACT(MONTH FROM date_col) = 3` not use index on date_col?

> **Answer:** Expression prevents index use. Index stores original date values, not extracted months. Optimizer can't use index for expression evaluation. Fix: Pre-compute `CASE WHEN EXTRACT(MONTH FROM date_col) = 3 THEN 1 ELSE 0 END` as computed column with index, or filter after index scan.

### Q27: What's a covering index?

> **Answer:** Index that includes all columns needed for query → index-only scan (0 heap fetches). Example: `CREATE INDEX idx ON trips(driver_id) INCLUDE (fare, distance_km)` covers `SELECT driver_id, fare, distance_km FROM trips WHERE driver_id = 5`.

### Q28: Read this plan: `Index Scan using idx ... Heap Fetches: 50,000`. Is it good?

> **Answer:** Bad. 50,000 heap fetches = 50,000 random IO operations (slow). Fix: Make index covering (INCLUDE columns) → index-only scan → 0 heap fetches.

### Q29: What does `cost=0.29..45.67 rows=12` mean?

> **Answer:** Startup cost=0.29 (time to return first row), total cost=45.67 (all rows), estimated rows=12. Optimizer uses these to choose plan. If actual rows >> 12, stats are stale (run ANALYZE).

### Q30: Can you have too many indexes?

> **Answer:** Yes. Each index slows INSERT/UPDATE/DELETE (extra work to maintain). Trade-off: faster SELECTs, slower writes. Rule of thumb: 3-5 indexes per table max. Index on heavily updated columns is usually bad.

---

## 🎯 Partitioning & Scale (Day 9)

### Q31: What's partition pruning?

> **Answer:** Optimizer skips partitions not matching WHERE filter. Example: `WHERE date >= '2026-03-01'` on monthly partitions → only scan March partition, skip other months. Must filter on partition key for pruning.

### Q32: Why is partition pruning important?

> **Answer:** If table has 12 months of data and you query 1 month, partition pruning scans 1/12 the data (12x faster). Without pruning: scan all months.

### Q33: Difference between range, list, and hash partitioning?

> **Answer:**
> - **Range:** By value ranges (dates, IDs). Best for time-series.
> - **List:** By discrete values (cities, statuses). Best for categorical.
> - **Hash:** Distributed evenly. Best for load balancing, no natural partition key.

### Q34: Does index still work after partitioning?

> **Answer:** Yes, but indexes are per-partition. Query on unpartitioned table uses global index. On partitioned table: local indexes per partition. Still works same way.

### Q35: What happens if you query across all partitions?

> **Answer:** Optimizer scans all partitions (no pruning). Equivalent to unpartitioned query. Slowdown if partitions span different storage (SSD vs HDD) or if metadata lookup is expensive.

---

## 🎯 Data Warehouse (Day 10)

### Q36: Why Bronze/Silver/Gold layers?

> **Answer:** 
> - **Bronze:** Raw, never touched (data lineage)
> - **Silver:** Cleaned, validated, business logic applied
> - **Gold:** Analytics-ready, star schema, aggregates
> Separation allows you to debug at each layer, reuse silver layer for multiple gold purposes.

### Q37: Fact vs Dimension table?

> **Answer:** 
> - **Fact:** Measurements, transactions (many rows: millions). Narrow: few columns.
> - **Dimension:** Attributes, descriptive (few rows: thousands). Wide: many columns.
> Fact: trips, sales. Dimension: drivers, products, dates.

### Q38: Why is star schema fast for analytics?

> **Answer:** Facts pre-join dimensions, pre-aggregate at load time. Analytics queries use pre-computed metrics. Alternative (raw tables): would scan millions of rows, do all calculations at query time.

### Q39: What's SCD Type 2? Why use it?

> **Answer:** Keep history of dimension changes. Old records: mark inactive (end_date = yesterday). New records: mark current (is_current = true). Allows historical analysis (what was this driver's city on date X?).

### Q40: Cardinality: high vs low?

> **Answer:** High: many distinct values (trip_id: 1M distinct). Low: few distinct values (status: 5 distinct). High-cardinality columns are bad for GROUP BY (too many groups), good for WHERE (narrow results). Low-cardinality: good for partitioning.

---

## 🚀 Rapid-Fire Questions (30 seconds each)

### Q41: `NULL = NULL` returns what?
> NULL (unknown), not true

### Q42: `COUNT(NULL)` returns what?
> 0 (NULL rows ignored)

### Q43: `SUM(NULL)` returns what?
> NULL (aggregate treats NULL as absent)

### Q44: `COALESCE(NULL, NULL, 5)` returns what?
> 5 (first non-NULL value)

### Q45: `CASE WHEN NULL THEN 'yes' ELSE 'no' END` returns what?
> 'no' (NULL is not true)

### Q46: Can you ORDER BY alias from SELECT?
> Yes: `SELECT fare AS price ORDER BY price`

### Q47: Can you GROUP BY alias?
> **PostgreSQL:** Yes. **MySQL:** No. **SQL Server:** No.

### Q48: `UNION` vs `UNION ALL` difference?
> UNION removes duplicates (slower). UNION ALL keeps duplicates (faster).

### Q49: Can you JOIN without ON?
> Yes, CROSS JOIN (all combinations). `FROM t1 JOIN t2` without ON = `FROM t1 CROSS JOIN t2`

### Q50: `LEFT JOIN ... WHERE right_table.col IS NOT NULL` = what?
> INNER JOIN (filters out unmatched left rows)

### Q51: What does `INTERSECT` do?
> Returns rows present in BOTH queries (common rows)

### Q52: What does `EXCEPT` do?
> Returns rows in first query but NOT in second (difference)

### Q53: Max columns in single index?
> PostgreSQL: 32. Most use 3-5 (diminishing returns).

### Q54: How do you drop an index without downtime?
> `DROP INDEX CONCURRENTLY idx_name` (PostgreSQL syntax)

### Q55: Can you create unique index on NULLable column?
> Yes, but multiple NULLs allowed (NULL != NULL)

### Q56: What's a partial index?
> Index on subset of rows: `CREATE INDEX idx ON trips(driver_id) WHERE status='completed'`. Faster, smaller.

### Q57: Can you rename a table?
> Yes: `ALTER TABLE old_name RENAME TO new_name`

### Q58: What's a foreign key?
> Constraint linking two tables: `FOREIGN KEY (driver_id) REFERENCES drivers(id)`. Prevents orphan rows.

### Q59: Cascade vs restrict foreign key?
> **Cascade:** Delete parent → auto-delete children. **Restrict:** Delete parent → error if children exist.

### Q60: Can you have transaction spanning multiple statements?
> Yes: `BEGIN; ... COMMIT;` wraps statements in single transaction (all-or-nothing).

---

## 💡 Explain-Like-I'm-5 Section

### Q61: What's a JOIN?

> **Simple answer:** Imagine two lists. You want to match them by a common ID. JOIN puts matching rows side-by-side. If match doesn't exist, LEFT JOIN still shows the row (with empty columns for the other list).

### Q62: What's a GROUP BY?

> **Simple answer:** Organize rows into buckets (by city, driver, etc.). Then COUNT each bucket, SUM each bucket, etc. Like sorting coins into piles and counting each pile.

### Q63: What's a window function?

> **Simple answer:** For each row, calculate something considering nearby rows (your "window"). Like: for each trip, show that trip's fare AND the running total of all fares for that driver.

### Q64: What's an index?

> **Simple answer:** Like a book's index. Instead of reading all pages, you look up a word in the index and jump directly. Database index: instead of scanning all rows, jump directly to rows you want.

### Q65: What's a view?

> **Simple answer:** A saved query. You use it like a table, but it's really running a query behind the scenes each time.

### Q66: What's a trigger?

> **Simple answer:** Automatic action. "If someone inserts into this table, THEN automatically log it in this other table." No human action needed.

### Q67: What's a CTE?

> **Simple answer:** A named temporary query you write at the top with WITH. Makes complex queries more readable (break into chunks, name each chunk, reference it later).

### Q68: What's a subquery?

> **Simple answer:** A query inside another query. Like Russian nesting dolls: outer query uses results of inner query.

### Q69: What's a partition?

> **Simple answer:** Split one big table into many smaller tables (by date, city, etc.). Query only the small tables you need → faster.

### Q70: What's a star schema?

> **Simple answer:** One big FACTS table in center (sales, trips). Many small DIMENSION tables around it (products, drivers). Makes analytics queries fast because facts are pre-organized.

---

## 📊 Score Yourself

Track your active recall progress:

| Category | Questions | Correct | Score |
|----------|-----------|---------|-------|
| Conceptual (1-5) | 5 | | |
| JOIN (6-10) | 5 | | |
| Window (11-15) | 5 | | |
| CTE (16-20) | 5 | | |
| Views/Procs (21-25) | 5 | | |
| Indexes (26-30) | 5 | | |
| Partitioning (31-35) | 5 | | |
| Warehouse (36-40) | 5 | | |
| Rapid-Fire (41-60) | 20 | | |
| Explain-Like-5 (61-70) | 10 | | |
| **TOTAL** | **70** | | |

**Target:** 60+ correct (86%+) = ready for interviews

---

*Last updated: 13 March 2026*
