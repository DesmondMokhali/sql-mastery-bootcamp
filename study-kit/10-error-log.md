# 🐛 The Error Log

A systematic record of your mistakes and misconceptions throughout the bootcamp. Learning from errors is the fastest path to mastery.

---

## How to Use This Error Log

1. **After each practice session:** Record any mistakes you made
2. **Categorize:** Is it logical, syntactic, performance, or NULL handling?
3. **Understand:** Write WHY you got it wrong
4. **Review regularly:** Revisit entries on the "Review On" date
5. **Track patterns:** Notice which topics repeat; focus more practice there
6. **Progress:** Watch yourself move from "didn't understand" to "avoid easily"

---

## Daily Error Log Template

| Date | Topic | What I Got Wrong | Why | Correct Understanding | Review On |
|------|-------|------------------|-----|----------------------|-----------|
| 2024-01-10 | JOINs | Used LEFT JOIN instead of INNER JOIN | Didn't think about NULL rows from unmatched left table | INNER JOIN = both tables must match; LEFT JOIN = keep all left rows even if no match | 2024-01-17 |
| 2024-01-11 | GROUP BY | Grouped by `driver_id, name` but got duplicate rows | NAME is not unique; GROUP BY should only include grouping columns or aggregated columns | GROUP BY only columns being aggregated on, or all non-aggregated columns in SELECT | 2024-01-18 |
| 2024-01-12 | NULL Handling | WHERE age = NULL returned no rows | NULL is special; = NULL always evaluates to unknown, not true or false | Use IS NULL or IS NOT NULL for NULL checks; = NULL never matches | 2024-01-19 |
| 2024-01-13 | Aggregates | COUNT(*) and COUNT(column) returned different values | COUNT(*) includes NULLs; COUNT(column) skips NULLs | COUNT(*) = all rows; COUNT(column) = rows where column is not null | 2024-01-20 |
| 2024-01-14 | Subqueries | Correlated subquery was slow (O(n) scan per row) | Ran separate subquery for every row instead of once | Use JOIN instead of correlated subquery; or materialize with CTE | 2024-01-21 |

---

## Pre-Filled Common Mistakes (Days 1-3)

### Mistake 1: NULL Comparison Error

**Date:** Common Beginner Mistake  
**Topic:** NULL Handling  
**What I Got Wrong:** `SELECT * FROM trips WHERE completed_at = NULL`  
**Why:** NULL is not a value; = operator doesn't work with NULL (returns UNKNOWN, not true or false)  
**Correct Understanding:** Use `WHERE completed_at IS NULL` for NULL checks. The expression `NULL = NULL` evaluates to UNKNOWN, not TRUE.  
**Review On:** Day 2  

---

### Mistake 2: DISTINCT vs GROUP BY Confusion

**Date:** Common Beginner Mistake  
**Topic:** Aggregation  
**What I Got Wrong:** Used `GROUP BY` when `DISTINCT` was intended; couldn't use aggregate functions  
**Why:** Confused that both remove duplicates; didn't understand GROUP BY also aggregates  
**Correct Understanding:**
- `DISTINCT` removes duplicate rows; can't use aggregates
- `GROUP BY` collapses rows by value; enables aggregates
- Different output in most cases
**Review On:** Day 3  

---

### Mistake 3: Missing WHERE Clause in DELETE

**Date:** Common Beginner Mistake  
**Topic:** DML - Dangerous Operations  
**What I Got Wrong:** `DELETE FROM trips` deleted ALL trips instead of specific ones  
**Why:** Forgot WHERE clause; got careless; didn't double-check before executing  
**Correct Understanding:** ALWAYS use WHERE clause in DELETE (except intentional TRUNCATE); test SELECT first; consider transactions  
**Review On:** Day 2  

---

### Mistake 4: Implicit Type Conversion Error

**Date:** Common Beginner Mistake  
**Topic:** Data Types  
**What I Got Wrong:** `WHERE id = '5'` when id was INT; worked but less efficient  
**Why:** Implicit conversion happened; didn't think about type matching  
**Correct Understanding:** Match data types explicitly: `WHERE id = 5` (not '5'). Avoids implicit conversion and index bypass.  
**Review On:** Day 3  

---

### Mistake 5: JOIN Without ON Condition (Cartesian Product)

**Date:** Common Beginner Mistake  
**Topic:** JOINs  
**What I Got Wrong:** `SELECT * FROM drivers, trips` returned millions of rows (10 drivers × 50 trips = 500)  
**Why:** Forgot ON condition; got implicit cross join  
**Correct Understanding:** Always use `JOIN ... ON` with clear condition. `FROM t1, t2` is Cartesian product (avoid).  
**Review On:** Day 3  

---

## Error Categories Breakdown

### Logical Errors (Understanding What To Query)
- Thinking LEFT JOIN = INNER JOIN
- Wrong aggregate function (COUNT vs SUM)
- Forgetting GROUP BY when aggregating multiple groups
- Using DISTINCT instead of GROUP BY

**Prevention:** Visualize the result before writing; trace through sample data

---

### Syntax Errors (SQL Code Structure)
- WHERE = NULL (should be IS NULL)
- Missing commas in column lists
- Missing ON in JOIN
- Wrong keyword order (WHERE before GROUP BY)

**Prevention:** Run EXPLAIN before EXECUTE; read error message carefully

---

### Performance Misconceptions
- Assuming DISTINCT faster than GROUP BY
- Not indexing join columns
- Using SELECT * instead of specific columns
- Correlated subqueries when JOIN would work

**Prevention:** Use EXPLAIN ANALYZE; measure before optimizing

---

### NULL Handling Errors
- = NULL comparisons
- Forgetting NULL in aggregates (COUNT(*) vs COUNT(column))
- Not using COALESCE for null-safe operations
- Assuming NULL = FALSE

**Prevention:** Treat NULL as special (unknown); test with NULL values in practice

---

## Error-to-Mastery Progression Tracker

Track your improvement as you encounter and overcome errors:

```
Stage 1: Don't Know (Made error in practice, didn't understand why)
  → Action: Review answer key, re-read documentation

Stage 2: Understand (Know why mistake happened)
  → Action: Repeat similar exercise without error

Stage 3: Recognize (Catch error before executing)
  → Action: Practice more complex variations

Stage 4: Prevent (Structure approach to avoid error)
  → Action: Teach someone else or mentor

Stage 5: Master (Error doesn't occur; instinct is correct)
  → Action: Move to next topic
```

**Example Progression - NULL Handling:**
- Stage 1 (Day 1): `WHERE age = NULL` returns no results (confused)
- Stage 2 (Day 2): Understand IS NULL vs = NULL
- Stage 3 (Day 2): Catch `= NULL` in your own code before executing
- Stage 4 (Day 3): Write queries avoiding NULL issues from start
- Stage 5 (Day 4): Instinctively use IS NULL; NULL logic second nature

---

## Your Personal Error Log (Fill During Practice)

| Date | Topic | What I Got Wrong | Why | Correct Understanding | Review On |
|------|-------|------------------|-----|----------------------|-----------|
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |

---

## Weekly Error Summary Template

**Week of: ___________**

**Errors Made This Week:** _____  
**Most Common Category:** _____ (Logical / Syntax / Performance / NULL)  
**Topics To Review:** _____  
**Improvement Areas:** _____  
**Confidence Increase:** _____ %  

---

## Patterns to Watch For

### Pattern 1: "I Keep Forgetting WHERE in DELETE"
- **Root Cause:** Muscle memory from SELECT (no WHERE often okay)
- **Solution:** Always write `DELETE FROM table WHERE condition = true;` (literally write "= true" as reminder)
- **Prevention Checklist:**
  - [ ] Write SELECT version first
  - [ ] Run SELECT to see what DELETE will remove
  - [ ] Only then change SELECT to DELETE
  - [ ] Add comment: `-- Deletes X rows`

### Pattern 2: "My Aggregates Are Wrong"
- **Root Cause:** Not understanding which columns need aggregation
- **Solution:** Before grouping, ask: "Am I reducing rows? Then I need GROUP BY."
- **Prevention Checklist:**
  - [ ] List all SELECT columns
  - [ ] Identify: grouped columns vs aggregate columns
  - [ ] If >1 non-aggregated column, add GROUP BY
  - [ ] Test: Do I get one row per group?

### Pattern 3: "My JOINs Return Too Many/Few Rows"
- **Root Cause:** Wrong JOIN type (INNER vs LEFT) or missing condition
- **Solution:** Draw the relationship; think about what "no match" means
- **Prevention Checklist:**
  - [ ] Do I want unmatched rows from left? → LEFT JOIN
  - [ ] Do I need INNER match only? → INNER JOIN
  - [ ] Is ON condition correct? → Test with small data
  - [ ] Result row count = left_rows × matches_per_right_row

### Pattern 4: "NULL Values Breaking My Logic"
- **Root Cause:** Forgetting NULL is special; not like 0 or empty string
- **Solution:** Test queries with NULL values explicitly
- **Prevention Checklist:**
  - [ ] Use `IS NULL` / `IS NOT NULL` not = NULL
  - [ ] Remember: `NULL = NULL` is UNKNOWN
  - [ ] Use COALESCE for null-safe defaults
  - [ ] COUNT(*) vs COUNT(column) when NULLs present

### Pattern 5: "Query Performance Suddenly Slowed"
- **Root Cause:** Missing index, or changed table size, or changed query logic
- **Solution:** Use EXPLAIN ANALYZE to diagnose
- **Prevention Checklist:**
  - [ ] Run EXPLAIN before running large query
  - [ ] Check: Sequential Scan vs Index Scan
  - [ ] If Full Scan with small result, add index
  - [ ] Verify index statistics up-to-date: ANALYZE table;

---

## Anti-Patterns (Things That Look Right But Aren't)

| Anti-Pattern | Why It's Wrong | Correct Approach |
|--------------|----------------|------------------|
| `WHERE age = NULL` | NULL is unknown; = returns UNKNOWN | `WHERE age IS NULL` |
| `COUNT(*)` for nulls | Includes NULLs in count | `COUNT(column)` skips nulls |
| Correlated subquery | Runs subquery per row O(n) | Use JOIN or CTE O(log n) |
| `SELECT *` in production | Brittle to schema changes; slow | Specify exact columns needed |
| `LEFT JOIN + WHERE right_table.column` | Converts to INNER | Use `ON` clause or `IS NOT NULL` |
| No index on FK | Makes JOIN slow | Add index on foreign key columns |
| `GROUP BY column_name` order | Depends on specific value order | Use `ORDER BY` for guaranteed sort |
| Multiple LEFT JOINs | Cartesian product effect | Separate queries or GROUP before JOIN |

---

## Debugging Checklist for Wrong Results

When a query doesn't produce expected results:

1. **[ ] Check Row Count**
   - More rows than expected? Missing WHERE or wrong JOIN type
   - Fewer rows than expected? Over-filtering or wrong join

2. **[ ] Check Column Values**
   - Unexpected NULLs? Check IS NULL handling
   - Unexpected values? Check CASE statements and COALESCE
   - Wrong precision? Check data types and rounding

3. **[ ] Check Aggregates**
   - Aggregate wrong? Check GROUP BY; all non-aggregated columns present?
   - Count off? Check COUNT(*) vs COUNT(column) and NULLs
   - Sum wrong? Check data types (INT vs DECIMAL)

4. **[ ] Review JOINs**
   - Wrong join type? Try INNER, LEFT, RIGHT, FULL
   - Wrong ON condition? Trace relationship manually
   - Cartesian product? Check for missing ON clause

5. **[ ] Use EXPLAIN ANALYZE**
   - Are expected indexes being used?
   - What's the actual row count at each step?
   - Where's the performance bottleneck?

6. **[ ] Add Debug Comments**
   ```sql
   -- Expected: one row per driver
   SELECT driver_id, COUNT(*) as trip_count
   FROM trips
   GROUP BY driver_id;
   -- Result: verify one row per driver with accurate counts
   ```

---

## Final Advice

> **Every error is a lesson. The best learners make mistakes, understand them deeply, and never repeat them.**

- Don't hide errors; analyze them
- Share your errors with peers; they probably made the same one
- Review this log weekly to track improvement
- Celebrate when you catch an error before executing
- The goal isn't to avoid errors; it's to learn from every single one

---

**Last Updated:** Study Kit - Daily Reference  
**Usage:** Fill during practice. Review weekly. Refer before complex queries.
