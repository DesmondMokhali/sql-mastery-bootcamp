# 📚 Acronym & Glossary Sheet

Your comprehensive reference for SQL terminology, acronyms, and definitions. Organized alphabetically with real-world context and common misconceptions.

---

## Core SQL & Database Concepts

| Term | Acronym | Definition | Real-World Context |
|------|---------|-----------|-------------------|
| Attribute | - | A column in a table; a named property of an entity | `email` is an attribute of the `riders` table |
| Cardinality | - | The number of rows in a table or the relationship multiplicity | A driver has cardinality of 10 if there are 10 driver records |
| Composite Key | - | Primary key made of multiple columns | `(driver_id, date)` as PK in earnings table ensures one record per driver per day |
| Constraint | - | A rule enforced on column data (NOT NULL, UNIQUE, CHECK, FK) | `UNIQUE(email)` ensures no duplicate emails in riders table |
| Cursor | - | A database object to traverse result set row-by-row | Used in stored procedures to loop through results |
| Database | DB | Organized collection of structured data | PostgreSQL instance containing all Uber rideshare data |
| Degree | - | Number of columns in a table | The `trips` table has degree of 15 (15 columns) |
| Denormalization | - | Intentional data redundancy for performance | Storing `driver_name` in trips table to avoid JOIN for reporting |
| Entity | - | A thing or person we store data about | Driver, Rider, Trip are entities |
| Foreign Key | FK | Column(s) referencing PK in another table; enforces referential integrity | `trips.driver_id` FK references `drivers.id` |
| Granularity | - | Level of detail in data; how broken down records are | Trip-level granularity (one row per trip) vs hour-level (aggregated by hour) |
| Index | - | Database object that speeds up retrieval; sorted copy of column(s) | B-Tree index on `driver_id` in trips table speeds up lookups |
| Instance | - | Individual row; specific occurrence of an entity | A single trip record; a single driver record |
| Join | - | Combine rows from multiple tables based on related columns | `INNER JOIN drivers ON trips.driver_id = drivers.id` |
| Metadata | - | Data about data; schema information | Column names, data types, table descriptions in system catalog |
| Normalization | - | Process of organizing data to minimize redundancy | 1NF, 2NF, 3NF, BCNF are normalization forms |
| Null | NULL | Absence of a value; unknown or not applicable | Trip `completed_at` is NULL if trip not yet completed |
| Primary Key | PK | Column(s) uniquely identifying each row | `id` in drivers table; guarantees uniqueness and not null |
| Query | - | Request for data from database; SELECT statement | `SELECT * FROM drivers WHERE city = 'Johannesburg'` |
| Referential Integrity | RI | Property ensuring FK values exist as PK in referenced table | Cannot insert trip with non-existent driver_id |
| Relation | - | Formal term for table; set of tuples (rows) with attributes (columns) | The `drivers` relation has 10 tuples |
| Row | - | Single record in a table; horizontal structure | One driver record; one trip record |
| Schema | - | Database structure; tables, columns, types, constraints | Uber DB schema includes drivers, trips, payments tables |
| Surrogate Key | - | Artificial PK created for uniqueness, not business meaning | `id SERIAL` in trips table; no business meaning, just unique identifier |
| Table | - | Organized data structure with rows and columns | `drivers`, `trips`, `payments` are tables |
| Tuple | - | Formal term for row; ordered list of values | A single trip tuple contains (id, driver_id, rider_id, ...) |
| View | - | Virtual table derived from query; appears as table but is computed | `high_rated_drivers` view shows drivers with rating > 4.5 |

---

## DDL (Data Definition Language) & DML (Data Manipulation Language)

| Term | Acronym | Definition | Real-World Context |
|------|---------|-----------|-------------------|
| Alter | - | DDL command to modify table structure | `ALTER TABLE drivers ADD COLUMN license_number VARCHAR(20)` |
| Create | - | DDL command to create new object (table, view, index) | `CREATE TABLE trips (id SERIAL PRIMARY KEY, ...)` |
| Data Definition Language | DDL | Commands that define/modify schema: CREATE, ALTER, DROP | DDL defines structure; used by DBAs to build database |
| Data Manipulation Language | DML | Commands that modify data: INSERT, UPDATE, DELETE, SELECT | DML modifies/retrieves data; used in applications daily |
| Delete | - | DML command to remove rows; generates undo logs | `DELETE FROM trips WHERE status = 'cancelled'` |
| Drop | - | DDL command to remove object completely | `DROP TABLE trips` removes table and all data permanently |
| Grant | - | DCL command to assign permissions | `GRANT SELECT ON drivers TO analyst_user` |
| Insert | - | DML command to add new rows to table | `INSERT INTO drivers (name, email) VALUES ('John', 'john@uber.com')` |
| Revoke | - | DCL command to remove permissions | `REVOKE DELETE ON trips FROM intern_user` |
| Truncate | - | DDL command to remove all rows efficiently; minimal logging | `TRUNCATE TABLE trips` removes all trips; keeps structure |
| Update | - | DML command to modify existing rows | `UPDATE drivers SET rating = 4.8 WHERE id = 5` |

---

## Transactions & ACID Properties

| Term | Acronym | Definition | Real-World Context |
|------|---------|-----------|-------------------|
| Acid | ACID | Atomicity, Consistency, Isolation, Durability; database reliability guarantee | All database transactions must be ACID compliant |
| Atomicity | A | Transaction all succeeds or all fails; no partial updates | Either payment completes fully or rolls back; no half-charged trips |
| Commit | - | Save transaction permanently; point of no return | `COMMIT` makes UPDATE to driver earnings permanent |
| Consistency | C | Data integrity maintained before and after transaction | Trip fare ≥ 0 and distance > 0 always held true |
| Durability | D | Committed data survives failures (crashes, power loss) | Completed trip data persists even after server crash |
| Isolation | I | Concurrent transactions don't interfere; various levels (READ UNCOMMITTED to SERIALIZABLE) | Two riders booking simultaneously don't double-book driver |
| Rollback | - | Undo transaction; restore to state before BEGIN | `ROLLBACK` cancels failed payment attempt |
| Savepoint | - | Intermediate point within transaction for partial rollback | `SAVEPOINT s1; ... ROLLBACK TO s1;` |
| Transaction | TXN | Logical unit of work; BEGIN, DML commands, COMMIT/ROLLBACK | Booking trip: reserve driver + accept payment + create trip = 1 transaction |

---

## Indexes & Performance

| Term | Acronym | Definition | Real-World Context |
|------|---------|-----------|-------------------|
| B-Tree | - | Balanced tree index structure; default, works for range queries | Most common index type; supports <, >, BETWEEN efficiently |
| Bitmap Index | - | Index storing row bitmap per distinct value; space-efficient | Good for low-cardinality columns (status: completed/cancelled/in_progress) |
| Clustered Index | - | Index determining physical row order; one per table | Primary key implicitly creates clustered index in some databases |
| Column Store | - | Index/storage format grouping column values together | Analytical databases (Redshift) use column store for fast aggregations |
| Composite Index | - | Index on multiple columns; order matters | Index on (driver_id, created_at) supports filtering by both efficiently |
| Covering Index | - | Index containing all columns needed for query; avoids table access | Index on (driver_id, rating) covers query `SELECT rating FROM drivers WHERE driver_id = 5` |
| Execution Plan | - | Step-by-step breakdown of how query accesses data | EXPLAIN shows sequential scan vs index scan vs hash join |
| Full Table Scan | FTS | Reading entire table; no index used | Slow operation avoided when indexed columns used in WHERE |
| Hash Index | - | Index using hash function; O(1) for equality only | Fast equality lookups; no range query support |
| Partial Index | - | Index on subset of rows matching WHERE condition | Index on active drivers only: `WHERE is_active = true` |
| Row ID | ROWID | Internal identifier for physical row location | Used by database to access row directly |
| Selective Index | - | Index on column with high selectivity (many distinct values) | Index driver_id (high selectivity) more useful than status (low selectivity) |

---

## Query Execution & Optimization

| Term | Acronym | Definition | Real-World Context |
|------|---------|-----------|-------------------|
| Access Path | - | Method chosen to retrieve data (FTS, index scan, etc.) | Optimizer chooses between full scan or index-based access |
| Aggregate Function | - | Function computing single value from multiple rows (COUNT, SUM, AVG) | `COUNT(*)` counts all trips; `AVG(rating)` averages driver ratings |
| Cartesian Product | - | Result of joining without proper condition; m × n rows | `CROSS JOIN` or missing JOIN condition produces unwanted large result |
| Correlation Subquery | - | Subquery referencing outer query columns; runs once per outer row | `SELECT * FROM drivers d WHERE EXISTS (SELECT 1 FROM trips WHERE driver_id = d.id)` |
| Derived Table | - | Named subquery in FROM clause; inline view | `SELECT * FROM (SELECT driver_id, COUNT(*) FROM trips GROUP BY driver_id) AS trip_counts` |
| Distinct | - | Remove duplicate rows from result | `SELECT DISTINCT city FROM drivers` shows each city once |
| Equijoin | - | JOIN using = comparison; most common | `INNER JOIN drivers ON trips.driver_id = drivers.id` |
| Explain | - | SQL command showing execution plan | `EXPLAIN SELECT ...` displays planned execution steps |
| Filter | - | Remove rows not meeting condition | WHERE clause filters; most selective filters should run first |
| Function | - | Reusable code computing values (UPPER, LOWER, ABS, etc.) | `UPPER(name)` converts name to uppercase; `ABS(fare)` returns absolute value |
| Group By | - | Aggregate rows by column value(s); reduces output rows | `GROUP BY driver_id` produces one row per unique driver |
| Having | - | Filter groups after aggregation; WHERE for groups | `HAVING COUNT(*) > 5` shows drivers with > 5 trips |
| Join | - | Combine rows from multiple tables | INNER, LEFT, RIGHT, FULL, CROSS join types |
| Nested Query | - | Query within query; subquery | `SELECT * FROM (SELECT * FROM trips WHERE status = 'completed')` |
| Order By | - | Sort result by column(s); ASC or DESC | `ORDER BY created_at DESC` shows newest trips first |
| Optimizer | - | Database component choosing best execution plan | Costs different plans, picks lowest-cost option |
| Predicate | - | Condition evaluated to true/false; WHERE clause element | `driver_id = 5` is a predicate |
| Projection | - | Selection of specific columns; reduces width | SELECT statement projects only needed columns |
| Query Plan | - | Representation of execution strategy | EXPLAIN shows entire query plan as tree |
| Sort | - | Order rows by column values; expensive operation | GROUP BY and ORDER BY may trigger sort |
| Window Function | - | Function operating on set of rows within "window"; keeps all rows | `ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY created_at)` |

---

## Data Warehouse & Analytics

| Term | Acronym | Definition | Real-World Context |
|------|---------|-----------|-------------------|
| Aggregate | - | Summarized data (SUM, COUNT, AVG, etc.) | Daily revenue per driver is aggregated from individual trips |
| Analytics | - | Data analysis to answer business questions | "Which driver earned most this month?" requires analytics |
| Batch Processing | - | Processing large data sets in groups; scheduled jobs | Nightly ETL load of daily trip data into warehouse |
| Business Intelligence | BI | Tools and practices analyzing business data | BI dashboards show driver performance, revenue trends |
| Cube | - | Multi-dimensional data structure for analysis | Time × City × Driver cube allows analysis across dimensions |
| Dimension | - | Reference data attribute for grouping (date, city, driver) | Date, city, vehicle_type are dimensions in trip analysis |
| Data Warehouse | DW | Centralized repository of integrated, historical data | Uber data warehouse stores years of trips for analytics |
| Extract Transform Load | ETL | Process moving data from source to warehouse | ETL extracts trips from live DB, transforms to analytics format, loads to warehouse |
| Fact Table | - | Table storing measurable events; contains FKs to dimensions | Trips fact table has FK to driver, rider, vehicle dimensions |
| Grain | - | Level of detail in fact table | Trip-level grain (one row per trip) vs day-level grain (aggregated by day) |
| Mart | - | Subset of warehouse focused on specific subject | Sales mart, HR mart focused on specific business area |
| Measure | - | Quantitative metric in fact table (fare, distance, duration) | Revenue, trip count, distance are key measures |
| Metadata | - | Data describing database structure | Data dictionary defines all table and column meanings |
| Partition | - | Division of data by value (date partition, city partition) | Trips partitioned by month for faster queries on time range |
| Schema | - | Database structure; in DW context often Star or Snowflake | Star schema has fact table surrounded by dimensions |
| Slowly Changing Dimension | SCD | Dimension data changing over time; handling updates | Driver city changes; must track history (SCD Type 2) |
| Snapshot | - | Point-in-time copy of data for historical analysis | Driver_stats snapshot taken daily to track metrics over time |

---

## Common Misconceptions (Things Beginners Get Wrong)

1. **NULL is Zero or Empty String**
   - ❌ Wrong: `WHERE age = NULL` won't find NULL values
   - ✅ Correct: NULL is "unknown"; use `WHERE age IS NULL`
   - Impact: Missing data in results; incorrect row counts

2. **DISTINCT and GROUP BY Are Equivalent**
   - ❌ Wrong: Both always produce same result
   - ✅ Correct: DISTINCT removes duplicates; GROUP BY aggregates
   - Impact: GROUP BY can use aggregate functions; DISTINCT cannot

3. **Primary Key = Unique**
   - ❌ Wrong: Any unique column is a primary key
   - ✅ Correct: PK is unique AND not null AND enforces referential integrity
   - Impact: Using UNIQUE instead of PK allows multiple NULLs

4. **Foreign Key Automatically Creates Index**
   - ❌ Wrong: FK creation auto-indexes the column
   - ✅ Correct: FK and index are separate; index must be created explicitly
   - Impact: FK lookups slow without index; JOIN performance suffers

5. **INNER JOIN and WHERE Filtering Are Identical**
   - ❌ Wrong: `trips JOIN drivers ON trips.driver_id = drivers.id WHERE drivers.is_active = true` same as without JOIN
   - ✅ Correct: Filtering in WHERE happens AFTER JOIN; affects row count differently
   - Impact: LEFT JOIN + WHERE in ON vs WHERE clause produces different results

6. **ORDER BY Without LIMIT Guarantees Consistency**
   - ❌ Wrong: Multiple queries return same order without LIMIT
   - ✅ Correct: Database doesn't guarantee order without LIMIT clause
   - Impact: Pagination fails; pagination needs OFFSET/FETCH or keyset

7. **Aggregate Functions Ignore NULL**
   - ❌ Wrong: COUNT(*) ignores NULL; SUM includes NULL values
   - ✅ Correct: COUNT(*) includes NULLs; COUNT(column) and SUM skip NULLs
   - Impact: Incorrect counts and sums; must handle explicitly

8. **Subquery in SELECT Optimized as JOIN**
   - ❌ Wrong: Subquery always slower than JOIN
   - ✅ Correct: Modern optimizers sometimes convert to JOIN; depends on database
   - Impact: Readability trade-off; test performance not assumptions

9. **TRUNCATE Is Same as DELETE**
   - ❌ Wrong: Both remove rows; TRUNCATE just slower DELETE
   - ✅ Correct: TRUNCATE is DDL, fast, non-logged; DELETE is DML, slow, logged
   - Impact: TRUNCATE doesn't trigger triggers; cascading deletes only with DELETE

10. **Index Always Speeds Up Queries**
    - ❌ Wrong: More indexes = faster queries
    - ✅ Correct: Wrong indexes slow writes; unused indexes waste space; selective indexes only help
    - Impact: Over-indexing hurts INSERT/UPDATE/DELETE performance; query plans ignore low-selectivity indexes

---

## Terms That Sound Similar But Aren't

| Pair | Difference |
|------|-----------|
| **View vs Materialized View** | View is computed query; Materialized View is stored snapshot |
| **Primary Key vs Unique Constraint** | PK enforces uniqueness + not null + referential integrity; UNIQUE just uniqueness |
| **Subquery vs CTE** | Subquery inline; CTE named and reusable within same query |
| **Index vs Constraint** | Index speeds retrieval; Constraint enforces data rules |
| **Cursor vs Query** | Cursor loops row-by-row (slow); Query processes set at once (fast) |
| **Partition vs Sharding** | Partition divides one table across disk/memory; Sharding divides across databases |
| **Aggregate vs Window Function** | Aggregate collapses rows; Window function keeps rows |
| **Full Scan vs Full Outer Join** | Full scan reads entire table; Full outer join returns all rows from both tables |
| **Cardinality vs Granularity** | Cardinality is row count; Granularity is level of detail |
| **ACID vs CRUD** | ACID is reliability guarantee; CRUD is basic operations (Create, Read, Update, Delete) |

---

**Last Updated:** Study Kit - Comprehensive Reference  
**Usage:** Bookmark this page. Reference during practice. Understand the "why" not just the "what".
