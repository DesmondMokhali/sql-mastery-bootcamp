# 🔀 Logic Flow Diagrams
**Visual Reference for SQL Concepts & Execution Flows**

---

## 1. SQL Logical Processing Order

**The order PostgreSQL *logically* evaluates a query (not always physical order):**

```
SELECT ... FROM ... JOIN ... ON ...
  ↓
1. FROM
   Get table(s)
  ↓
2. JOIN / ON
   Match rows between tables
  ↓
3. WHERE
   Filter rows (conditions on individual rows)
  ↓
4. GROUP BY
   Organize into groups
  ↓
5. HAVING
   Filter groups (conditions on aggregates)
  ↓
6. SELECT
   Choose which columns to return
  ↓
7. DISTINCT
   Remove duplicates
  ↓
8. ORDER BY
   Sort rows
  ↓
9. LIMIT
   Return top N rows
  ↓
Result set
```

**Example query with each phase:**

```sql
SELECT driver_id, COUNT(*) as trip_count, AVG(fare) as avg_fare
FROM trips
WHERE fare > 10                           ← WHERE (phase 3)
GROUP BY driver_id                        ← GROUP BY (phase 4)
HAVING COUNT(*) > 5                       ← HAVING (phase 5)
ORDER BY avg_fare DESC                    ← ORDER BY (phase 8)
LIMIT 10;                                 ← LIMIT (phase 9)
-- SELECT happens last (phase 6)
```

---

## 2. PostgreSQL SELECT Execution Path

**What actually happens when you run a SELECT:**

```
User types query
  ↓
1. PARSER
   ├─ Check syntax validity
   ├─ Tokenize query
   └─ Build parse tree
  ↓
2. ANALYZER / SEMANTIC CHECKER
   ├─ Validate table names exist
   ├─ Validate column names exist
   ├─ Resolve data types
   ├─ Expand * to column list
   └─ Build query tree
  ↓
3. REWRITER (rules system)
   ├─ Apply view expansions
   ├─ Apply rules
   └─ Rewrite query
  ↓
4. PLANNER / OPTIMIZER
   ├─ Generate possible plans
   │  ├─ Seq scan + filter
   │  ├─ Index scan
   │  ├─ Nested loop join
   │  ├─ Hash join
   │  └─ Merge join
   │
   ├─ Estimate cost of each
   │  ├─ IO cost (disk reads)
   │  ├─ CPU cost (row processing)
   │  └─ Memory cost
   │
   └─ Choose lowest-cost plan
  ↓
5. EXECUTOR
   ├─ Execute plan tree top-to-bottom
   ├─ Fetch rows from tables/indexes
   ├─ Apply filters
   ├─ Join rows
   ├─ Aggregate
   └─ Sort
  ↓
Result set returned to user
```

**Key insight:** Planner chooses once, executor runs once. This is why EXPLAIN output matters.

---

## 3. JOIN Types (Venn Diagram Style)

```
INNER JOIN:
┌─────────┬────────────┐
│ Left    │ RIGHT      │  ← Only overlapping part
│    ┌────┴────┐       │
│    │ MATCH   │       │
│    └────┬────┘       │
│         │            │
└─────────┴────────────┘


LEFT JOIN:
┌─────────┬────────────┐
│ Left    │ RIGHT      │  ← All left + matches from right
│    ┌────┴────┐       │
│    │ MATCH   │       │  NULLs fill unmatched right cols
│    └────┬────┘       │
│    UNMATCHED         │
└─────────┴────────────┘


FULL OUTER JOIN:
┌─────────┬────────────┐
│ Left    │ RIGHT      │  ← Everything
│    ┌────┴────┐       │
│    │ MATCH   │       │  NULLs fill unmatched
│    └────┬────┘       │
│ UNMATCHED UNMATCHED  │
└─────────┴────────────┘


CROSS JOIN:
All combinations (no matching logic):
A1 × B1 = A1-B1
A1 × B2 = A1-B2
A2 × B1 = A2-B1
A2 × B2 = A2-B2
(every row from left with every row from right)
```

---

## 4. B-Tree Index Structure

```
Root node (one entry point)
       [M | Z]              ← Branch values
       /    |    \
      /     |     \
   [A-D] [N-S]  [U-Y]      ← Internal nodes (decision points)
    |      |      |
┌──┴──┬──┬──┬──┬──┬──┬──┐   ← Leaf nodes (actual data pointers)
│ A │ B│ C│ D│ E│...│ Z │
└────┴──┴──┴──┴──┴──┴──┘
     ↓   ↓   ↓
   ROW ROW ROW            ← Heap pages (actual table data)


Search for key=C:
1. Start at root: C < M? Yes → left
2. Middle node: C < N? Yes → left
3. Leaf: Find C → Get row pointer
4. Fetch row from heap page
Cost: O(log N) tree traversals + 1 heap fetch
```

---

## 5. PostgreSQL MVCC (Multi-Version Concurrency Control)

**How PostgreSQL handles multiple readers/writers without locking:**

```
Table version 1 (t=1):
┌────────────────────┐
│ trip_id=1, fare=50 │  xmin=100, xmax=NULL (active)
│ trip_id=2, fare=60 │  xmin=101, xmax=NULL (active)
└────────────────────┘

Transaction 1 updates trip 1: fare=50→55
  ↓
Table version 2 (t=2):
┌────────────────────┐
│ trip_id=1, fare=50 │  xmin=100, xmax=105 (old, dead)
│ trip_id=1, fare=55 │  xmin=105, xmax=NULL (new, active)
│ trip_id=2, fare=60 │  xmin=101, xmax=NULL (active)
└────────────────────┘

Transaction reader at xmin=100 sees version 1
Transaction reader at xmin=106 sees version 2
(No locks, no blocking!)

VACUUM cleanup removes dead versions:
┌────────────────────┐
│ trip_id=1, fare=55 │  xmin=105, xmax=NULL
│ trip_id=2, fare=60 │  xmin=101, xmax=NULL
└────────────────────┘
```

---

## 6. Hash Join Execution

```
Build Phase:
┌─────────────┐
│ Smaller     │  Read smaller table
│ table       │  Build hash table (in memory)
│ (drivers)   │  Hash value → list of rows
└──────┬──────┘
       │ Hash table:
       └─→ ┌──────────────────┐
           │ hash(5) → driver5 │
           │ hash(10) → driver10│
           │ hash(3) → driver3 │
           └──────────────────┘

Probe Phase:
┌──────────┐  For each row in larger table
│ Larger   │  Compute hash
│ table    │  Look up in hash table
│ (trips)  │  Return matching rows
└────┬─────┘
     │
     ├─ trip with driver_id=5
     │  hash(5) → find driver5 → match ✓
     │
     ├─ trip with driver_id=10
     │  hash(10) → find driver10 → match ✓
     │
     └─ trip with driver_id=7
        hash(7) → not found → no match ✗

Result: Matched rows from join
```

---

## 7. Nested Loop Join

```
For each row in outer table:
  For each row in inner table:
    If join condition matches:
      Include in result

Example: drivers × trips
┌────────────────────┐
│ Driver 1           │ ← Outer table
├────────────────────┤
│ ├─ Trip A (match)  │ ← Inner table scan
│ ├─ Trip B (match)  │
│ └─ Trip C (no)     │
│                    │
│ Driver 2           │ ← Outer table
├────────────────────┤
│ ├─ Trip A (no)     │ ← Inner table scan again!
│ ├─ Trip B (no)     │
│ └─ Trip C (match)  │
└────────────────────┘

Cost: O(m × n) where m=outer rows, n=inner rows
Fast for: Small inner table (fits in cache)
Slow for: Large inner table (repeated scans)
```

---

## 8. Execution Plan Tree (Real Example)

```sql
SELECT d.name, COUNT(t.id) as trip_count, AVG(t.fare)
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
WHERE d.city = 'NYC'
GROUP BY d.id, d.name;
```

**Plan tree (root = output):**

```
              HashAggregate
             /              \
        GROUP BY         Aggregate
        (count, avg)
           |
        Hash Join
        /         \
     Seq Scan    Seq Scan
     (drivers)   (trips)
     Filter:
     city='NYC'
     ~500 rows    ~100,000 rows
           \         /
            Join result
            ~50,000 rows
              |
              ↓
         GROUP BY result
         ~500 groups
              |
              ↓
           Output
```

**Execution (bottom-up):**
1. Seq Scan drivers, filter city='NYC' → 500 rows
2. Seq Scan trips → 100,000 rows
3. Hash Join on driver_id → 50,000 matched rows
4. HashAggregate GROUP BY driver_id → 500 groups
5. Return aggregated result

---

## 9. Data Warehouse Bronze/Silver/Gold Layers

```
┌──────────────────────────────────────────────┐
│                   DATA SOURCE                 │
│              (CSV, APIs, DBs)                 │
└────────────────┬─────────────────────────────┘
                 │
                 ↓
        ┌─────────────────┐
        │  BRONZE LAYER   │  Raw, unmodified copy
        │                 │  - trips (exact source)
        │  Raw Data       │  - drivers (exact source)
        │                 │  - reviews (exact source)
        │  _ingested_at   │  Meta: when loaded
        └────────┬────────┘
                 │
        Data Validation
        Deduplication
        Cleaning
                 │
                 ↓
        ┌─────────────────┐
        │  SILVER LAYER   │  Cleaned, validated
        │                 │  - trips (deduplicated)
        │  Clean Data     │  - drivers (NULLs handled)
        │                 │  - reviews (validated)
        │  _ingested_at   │  Format: standardized
        │  rn (dedup)     │
        └────────┬────────┘
                 │
        Business Logic
        Aggregation
        Star Schema Build
                 │
                 ↓
        ┌──────────────────┐
        │   GOLD LAYER     │  Analytics-ready
        │                  │
        │   Fact Tables:   │  - fact_trips (1B rows)
        │   - fact_trips   │  - Dimensions pre-joined
        │                  │
        │   Dimensions:    │  - dim_driver
        │   - dim_driver   │  - dim_date
        │   - dim_date     │  - dim_status
        │   - dim_status   │
        │                  │
        │   Aggregates:    │  - agg_daily_revenue
        │   - agg_*        │  - agg_driver_metrics
        └────────┬─────────┘
                 │
                 ↓
      ┌──────────────────────┐
      │  Analytics / BI      │
      │  - Dashboards        │
      │  - Reports           │
      │  - Ad-hoc Queries    │
      └──────────────────────┘
```

---

## 10. Star Schema Visualization

```
                    DIM_DATE
                  (365 rows)
                  ┌─────────┐
                  │ date_id │
                  │  year   │ ← Foreign Key from FACT
                  │  month  │
                  │   day   │
                  └────┬────┘
                       │
                       ↓
    ┌──────────────────────────────────────┐
    │        FACT_TRIPS (1B rows)          │  ← Center (transactional)
    ├──────────────────────────────────────┤
    │ trip_sk (PK)                         │
    │ date_sk (FK → dim_date)              │  ← Joins to dimensions
    │ driver_sk (FK → dim_driver)          │
    │ rider_id (FK → dim_rider)            │
    │ status_id (FK → dim_status)          │
    │ ─────────────────────────────        │
    │ fare (measure)                       │  ← Numerical values
    │ distance_km (measure)                │
    │ trip_duration_minutes (measure)      │
    └──────────────────────────────────────┘
       ↗         ↖              ↗         ↖
      /            \          /            \
     /              \        /              \
DIM_DRIVER      DIM_RIDER    DIM_STATUS   (more dimensions)
(50k rows)      (100k rows)   (5 rows)

Queries join FACT to DIMENSIONs:
SELECT d.city, SUM(f.fare)
FROM fact_trips f
JOIN dim_driver d ON f.driver_sk = d.driver_sk
WHERE f.date_sk IN (SELECT date_sk FROM dim_date WHERE month=3)
GROUP BY d.city;
```

---

## 11. Index Decision Tree

```
Query: SELECT * FROM trips WHERE driver_id = 5 AND fare > 40

Decision Tree:
┌─ Does query have WHERE clause? YES
│  └─ Are filtered columns used frequently? YES
│     └─ Create index on driver_id? YES
│
├─ Does WHERE have multiple conditions? YES
│  ├─ Are conditions correlated? (do they appear together?)
│  │  └─ YES → Create composite: (driver_id, fare)
│  │  └─ NO → Create separate indexes
│  │
│  └─ Create bitmap index strategy:
│     └─ Multiple indexes + bitmap scans
│
├─ Does query SELECT only indexed columns? YES
│  └─ Make index covering: INCLUDE (all SELECT cols)
│     └─ Result: Index-only scan (0 heap fetches)
│
└─ Is column updated frequently? YES
   └─ Be careful: index maintenance cost
      └─ Maybe not worth it if writes >> reads
```

---

## 12. Partition Pruning Decision Flow

```
Query: SELECT * FROM trips_partitioned 
       WHERE started_at >= '2026-03-01' AND started_at < '2026-04-01'

Partitions: monthly (Jan, Feb, Mar, Apr, ...)

Pruning Decision:
┌────────────────────────────────────┐
│ Optimizer analyzes each partition  │
└────────────────────────────────────┘
  │
  ├─ Partition Jan
  │  └─ Does [Jan 1, Feb 1) intersect [Mar 1, Apr 1)?
  │     └─ NO → PRUNE ✗
  │
  ├─ Partition Feb
  │  └─ Does [Feb 1, Mar 1) intersect [Mar 1, Apr 1)?
  │     └─ NO → PRUNE ✗
  │
  ├─ Partition Mar
  │  └─ Does [Mar 1, Apr 1) intersect [Mar 1, Apr 1)?
  │     └─ YES → SCAN ✓
  │
  ├─ Partition Apr
  │  └─ Does [Apr 1, May 1) intersect [Mar 1, Apr 1)?
  │     └─ NO → PRUNE ✗
  │
  └─ (rest pruned)

Result: Only partition Mar scanned
Speed: 12x faster (1/12 of data)
```

---

*Last updated: 13 March 2026 | Print and post on your monitor!*
