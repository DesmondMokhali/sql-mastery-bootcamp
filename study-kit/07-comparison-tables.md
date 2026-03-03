# 📊 Comparison Tables

A quick reference guide for understanding the differences between similar SQL concepts, performance characteristics, and when to use each approach.

---

## 1. JOIN Types Comparison

| Type | Returns | Use Case | Performance | Example |
|------|---------|----------|-------------|---------|
| **INNER JOIN** | Only matching rows | Default; most common; filter to matches only | Fast when indexed on FK | `SELECT * FROM drivers INNER JOIN trips ON drivers.id = trips.driver_id` |
| **LEFT JOIN** | All left table rows + matching right | Preserve all left records even if no match | Same as INNER if indexed | `SELECT * FROM drivers LEFT JOIN trips ON drivers.id = trips.driver_id` |
| **RIGHT JOIN** | All right table rows + matching left | Less common; opposite of LEFT | Same as INNER if indexed | `SELECT * FROM trips RIGHT JOIN drivers ON trips.driver_id = drivers.id` |
| **FULL OUTER JOIN** | All rows from both tables | Reconciliation, finding unmatched records | Slower; may need UNION approach | `SELECT * FROM drivers FULL OUTER JOIN trips ON drivers.id = trips.driver_id` |
| **CROSS JOIN** | Cartesian product (n × m rows) | Rare; calendar generation, all combinations | Very slow with large tables | `SELECT * FROM drivers CROSS JOIN riders` |

---

## 2. INDEX Types Comparison

| Type | Best For | Limitations | When To Use |
|------|----------|-------------|-------------|
| **B-Tree** | General purpose; range queries | None; default index | Every indexed column unless specific need |
| **Hash** | Equality comparisons | No range queries; not ordered | Exact match lookups only |
| **GIN** (Generalized Inverted) | Full-text search, JSON, arrays | Slower writes; large size | Text search, JSONB queries, array operations |
| **GiST** (Generalized Search Tree) | Geometric data, full-text | Slower than B-Tree; requires maintenance | Geographic coordinates, polygon searches |
| **BRIN** (Block Range Index) | Very large sequential tables | Only for naturally ordered data | Time-series data, append-only tables with millions of rows |

---

## 3. CTE vs Subquery vs Derived Table vs Temp Table

| Approach | Syntax | Scope | Reusability | Performance | Best For |
|----------|--------|-------|-------------|-------------|----------|
| **CTE** (WITH clause) | `WITH cte AS (SELECT...) SELECT...` | Current query only | Can reference multiple times | Optimized; inlined or materialized | Recursive queries, readability, multi-step logic |
| **Subquery** | `SELECT * FROM (SELECT...) AS sub` | Current query only | Single reference | Optimized by optimizer | Simple one-off nested logic |
| **Derived Table** | Same as subquery; inline in FROM | Current query only | Single reference | Optimized | Inline filtering, temporary result sets |
| **Temp Table** | `CREATE TEMP TABLE; INSERT; SELECT;` | Session scope | Multiple queries in session | Materialized; slower creation | Large intermediate results, multiple uses in same session |

---

## 4. DELETE vs TRUNCATE vs DROP

| Operation | Target | Reversible | Speed | Space | Use Case |
|-----------|--------|-----------|-------|-------|----------|
| **DELETE** | Rows | Yes (ROLLBACK) | Slow; generates logs | Space not released | Remove specific rows; audit trail needed |
| **TRUNCATE** | All rows | Yes (ROLLBACK) | Fast; minimal logs | Space released | Clear entire table; high-volume cleanup |
| **DROP** | Table structure + data | Yes (ROLLBACK) | Fastest | All space released | Remove entire table; start fresh |

---

## 5. WHERE vs HAVING

| Clause | When Applied | Aggregates Allowed | Row Grouping | Use Case |
|--------|--------------|-------------------|--------------|----------|
| **WHERE** | Before GROUP BY; row-level | No | Individual rows | Filter raw data; exclude rows before aggregation |
| **HAVING** | After GROUP BY; group-level | Yes | Grouped rows | Filter aggregated results; post-GROUP BY conditions |

**Example:**
```sql
-- WHERE: filters before grouping (faster)
SELECT driver_id, COUNT(*) as trips 
FROM trips 
WHERE status = 'completed' 
GROUP BY driver_id;

-- HAVING: filters after grouping (slower)
SELECT driver_id, COUNT(*) as trips 
FROM trips 
GROUP BY driver_id 
HAVING COUNT(*) > 10;
```

---

## 6. GROUP BY vs PARTITION BY

| Feature | GROUP BY | PARTITION BY (Window Function) |
|---------|----------|--------------------------------|
| **Function** | Collapses rows into groups | Adds calculated column; keeps all rows |
| **Output Rows** | One row per group | Same as input; one result per row |
| **Available Columns** | Only grouped cols + aggregates | Any original column + window result |
| **Performance** | Slower for large datasets | Faster when you need detail + aggregate |
| **Window Frame** | N/A | Can specify ROWS/RANGE within partition |

**Example:**
```sql
-- GROUP BY: collapses data
SELECT driver_id, COUNT(*) as trip_count
FROM trips
GROUP BY driver_id;
-- Output: 1 row per driver

-- PARTITION BY: keeps detail
SELECT driver_id, trip_id, status,
       COUNT(*) OVER (PARTITION BY driver_id) as total_trips
FROM trips;
-- Output: all original rows + new column
```

---

## 7. View vs Materialized View

| Aspect | View | Materialized View |
|--------|------|-------------------|
| **Storage** | No; computed on each query | Yes; stored as physical table |
| **Freshness** | Always current | Stale until refreshed |
| **Query Speed** | Slower; underlying query runs each time | Faster; reads pre-computed data |
| **Update Overhead** | None; always reflects source | High; must REFRESH to update |
| **Index Support** | No indexes on view itself | Can add indexes to materialized data |
| **Use Case** | Simple abstractions, logical views | Analytics, heavy aggregations, dashboards |

```sql
-- View: runs query every time
CREATE VIEW driver_stats AS
SELECT driver_id, AVG(rating) FROM reviews GROUP BY driver_id;

-- Materialized View: stores result
CREATE MATERIALIZED VIEW driver_stats AS
SELECT driver_id, AVG(rating) FROM reviews GROUP BY driver_id;
-- Must refresh: REFRESH MATERIALIZED VIEW driver_stats;
```

---

## 8. Nested Loop vs Hash Join vs Merge Join

| Join Method | Works Best On | Algorithm | Speed | Memory | When Used |
|-------------|---------------|-----------|-------|--------|-----------|
| **Nested Loop** | Small inner table | Outer loop × inner scan | Slow; O(n×m) | Minimal | No index; random access acceptable |
| **Hash Join** | No sort needed; memory available | Build hash table; probe | Fast for large sets | High | Large tables; no sort; enough RAM |
| **Merge Join** | Pre-sorted data or index | Scan both tables in order | Very fast | Low | Sorted data; index exists; best for range joins |

**Optimizer chooses based on:** table size, available indexes, sort order, available memory.

---

## 9. EXPLAIN vs EXPLAIN ANALYZE

| Feature | EXPLAIN | EXPLAIN ANALYZE |
|---------|---------|-----------------|
| **What It Shows** | Optimizer's plan; estimated rows/cost | Actual execution; real rows/timing |
| **Runs Query** | No; only plans | Yes; executes and measures |
| **Speed** | Instant | Takes time (actually runs query) |
| **Accuracy** | Estimates only | Ground truth with real data |
| **Best For** | Quick plan review, not blocking | Performance debugging, actual bottlenecks |
| **Production Safe** | Yes; just planning | Depends on query; may be slow or have side effects |

```sql
-- Plan only (fast, estimated)
EXPLAIN SELECT * FROM trips WHERE driver_id = 5;

-- Actual execution (slow, real numbers)
EXPLAIN ANALYZE SELECT * FROM trips WHERE driver_id = 5;
```

---

## 10. Row Store vs Column Store

| Aspect | Row Store (OLTP) | Column Store (OLAP) |
|--------|------------------|-------------------|
| **Storage Layout** | Data by row; all columns together | Data by column; column grouped |
| **Query Pattern** | Few columns, many rows | Many columns, few rows |
| **Write Performance** | Fast; single insert | Slow; write to multiple column files |
| **Read Performance** | Slow for analytics; reads unused columns | Fast; reads only needed columns |
| **Compression** | Moderate | Excellent; column-specific compression |
| **Typical Use** | OLTP databases (Postgres, MySQL) | Data warehouses (Snowflake, Redshift) |
| **Example** | `drivers` table in transactional system | Analytics warehouse for BI reporting |

**Trade-off:** Row stores optimize for transactional speed; column stores optimize for analytical throughput.

---

**Last Updated:** Study Kit - Day 1  
**Use Case:** Print this, bookmark it, reference during query writing practice.
