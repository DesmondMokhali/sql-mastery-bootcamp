# 📦 Day 7: Views, Procedures & Triggers
**Wednesday, 11 March 2026**  
**Video: [15:35:02–18:23:42](https://www.youtube.com/watch?v=SSKVgrwhzus)**

---

## 📅 Today's Schedule

| Time | Activity | Duration | Focus |
|------|----------|----------|-------|
| 09:00–09:45 | Views (Standard & Materialized) | 45 min | Abstraction, reusability |
| 09:45–10:30 | Stored Procedures Fundamentals | 45 min | Writing, executing, control flow |
| 10:30–11:15 | Triggers (Before, After, INSTEAD OF) | 45 min | Automation, data integrity |
| 11:15–12:00 | Temp Tables vs CTEs vs Views | 45 min | When to use what |
| 12:00–13:00 | **Lunch Break** | 60 min | – |
| 13:00–13:45 | Plan Cache & Performance Implications | 45 min | Procedure caching, sniffing |
| 13:45–14:30 | Lab Exercises 1–3 | 45 min | Hands-on coding |
| 14:30–15:15 | Lab Exercises 4–5 | 45 min | Pressure scenario |
| 15:15–15:35 | Wrap-up & Recap | 20 min | Checklist & homework |

---

## 🎯 Core Topics

### 1. Standard Views

**View = Stored SELECT query.** No data stored; executes query each time.

```sql
-- Create a view of high-rated drivers
CREATE VIEW vw_premium_drivers AS
SELECT 
  d.id,
  d.name,
  d.city,
  COUNT(t.id) as trip_count,
  AVG(r.rating) as avg_rating
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
LEFT JOIN reviews r ON t.id = r.trip_id AND r.reviewer_id != d.id
GROUP BY d.id, d.name, d.city;

-- Query the view like a table
SELECT * FROM vw_premium_drivers WHERE avg_rating > 4.8;
```

**Pros:** Abstraction, reusability, security (hide columns), simplify complex queries.

**Cons:** Each query re-executes underlying SELECT (no caching).

### 2. Materialized Views

**Snapshot of data.** Stored physically; must be refreshed.

```sql
-- PostgreSQL: Materialized view
CREATE MATERIALIZED VIEW mv_driver_stats AS
SELECT 
  d.id,
  d.name,
  COUNT(t.id) as trip_count,
  AVG(t.fare) as avg_fare,
  MAX(t.fare) as max_fare
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id, d.name;

-- Refresh data (full scan)
REFRESH MATERIALIZED VIEW mv_driver_stats;

-- Faster queries (pre-computed)
SELECT * FROM mv_driver_stats WHERE avg_fare > 40;
```

**Trade-off:** Fast reads, stale data (until refresh).

### 3. Stored Procedures

**Reusable SQL code with control flow, parameters, transactions.**

```sql
-- Simple procedure: Add trip and payment
CREATE PROCEDURE add_trip_with_payment(
  p_driver_id INT,
  p_rider_id INT,
  p_fare DECIMAL(10, 2),
  p_distance DECIMAL(8, 2),
  p_payment_method VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
  -- Insert trip
  INSERT INTO trips (driver_id, rider_id, fare, distance_km, status, started_at)
  VALUES (p_driver_id, p_rider_id, p_fare, p_distance, 'completed', NOW());
  
  -- Insert payment
  INSERT INTO payments (trip_id, amount, method, paid_at, status)
  VALUES (LASTVAL(), p_fare, p_payment_method, NOW(), 'success');
  
  -- Commit both or rollback both
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE NOTICE 'Error: %', SQLERRM;
END;
$$;

-- Call the procedure
CALL add_trip_with_payment(5, 3, 45.50, 12.3, 'credit_card');
```

**Control Flow Example:**

```sql
CREATE PROCEDURE validate_driver_and_assign(
  p_driver_id INT,
  OUT p_assignment_status VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_is_active BOOLEAN;
  v_rating DECIMAL;
BEGIN
  -- Check driver status
  SELECT is_active INTO v_is_active FROM drivers WHERE id = p_driver_id;
  
  IF NOT v_is_active THEN
    p_assignment_status := 'Driver inactive';
    RETURN;
  END IF;
  
  -- Check rating
  SELECT AVG(rating) INTO v_rating 
  FROM reviews 
  WHERE reviewee_id = p_driver_id;
  
  IF v_rating < 4.0 THEN
    p_assignment_status := 'Low rating';
    RETURN;
  END IF;
  
  p_assignment_status := 'Ready for assignment';
END;
$$;
```

### 4. Triggers

**Automatically execute code before/after INSERT, UPDATE, DELETE.**

```sql
-- Trigger: Auto-calculate trip distance
CREATE TRIGGER calculate_trip_distance
BEFORE INSERT ON trips
FOR EACH ROW
EXECUTE FUNCTION set_trip_distance();

CREATE FUNCTION set_trip_distance()
RETURNS TRIGGER AS $$
BEGIN
  -- Example: haversine formula or geocoding call
  NEW.distance_km := SQRT(
    POWER((CAST(SUBSTRING(NEW.dropoff_location, 1, 5) AS DECIMAL) - 
           CAST(SUBSTRING(NEW.pickup_location, 1, 5) AS DECIMAL)), 2)
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**AFTER Trigger: Audit trail**

```sql
CREATE TABLE trip_audit (
  audit_id SERIAL PRIMARY KEY,
  trip_id INT,
  old_status VARCHAR(50),
  new_status VARCHAR(50),
  changed_at TIMESTAMP
);

CREATE TRIGGER audit_trip_status
AFTER UPDATE ON trips
FOR EACH ROW
EXECUTE FUNCTION log_trip_change();

CREATE FUNCTION log_trip_change()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO trip_audit (trip_id, old_status, new_status, changed_at)
  VALUES (NEW.id, OLD.status, NEW.status, NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**INSTEAD OF Trigger: Updateable views**

```sql
CREATE TRIGGER update_driver_view
INSTEAD OF UPDATE ON vw_premium_drivers
FOR EACH ROW
EXECUTE FUNCTION handle_driver_update();

CREATE FUNCTION handle_driver_update()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE drivers SET name = NEW.name, city = NEW.city WHERE id = NEW.id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 5. Temp Tables

**Session-scoped or transaction-scoped temporary storage.**

```sql
-- Create temp table (exists for session)
CREATE TEMP TABLE temp_driver_summary AS
SELECT 
  d.id,
  d.name,
  COUNT(t.id) as trip_count,
  SUM(t.fare) as total_revenue
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
GROUP BY d.id, d.name;

-- Use it
SELECT * FROM temp_driver_summary WHERE total_revenue > 1000;

-- Dropped automatically at end of session
```

---

## 📚 10 Terms of the Day

| Term | Definition | Example | Category | Mastery |
|------|-----------|---------|----------|---------|
| **View** | Stored SELECT query; no data cached | `CREATE VIEW vw_name AS SELECT ...` | Structure | |
| **Materialized View** | Snapshot of data; physically stored | `CREATE MATERIALIZED VIEW mv_name` | Performance | |
| **Stored Procedure** | Reusable SQL code with parameters | `CREATE PROCEDURE proc_name(...)` | Structure | |
| **Trigger** | Auto-executes on INSERT/UPDATE/DELETE | `BEFORE INSERT FOR EACH ROW` | Automation | |
| **Temp Table** | Session-scoped table | `CREATE TEMP TABLE` | Structure | |
| **Plan Cache** | DB caches compiled query plans | Reuse = faster execution | Performance | |
| **Parameter Sniffing** | Procedure uses first param to build plan | Good params → good plan; bad params → slow | Performance | |
| **INSTEAD OF Trigger** | Replaces action (e.g., update view) | Updateable views | Advanced | |
| **Row-Level Trigger** | Fires for EACH row affected | `FOR EACH ROW` | Granularity | |
| **Statement-Level Trigger** | Fires once per statement | `FOR EACH STATEMENT` | Granularity | |

---

## 🧪 Lab Exercises (Uber Database)

### Lab 1: Create a View — Active Drivers Dashboard
**Create a view `vw_active_drivers_performance` showing: driver name, city, trip count, avg rating, total revenue, status.**

```sql
-- Write CREATE VIEW statement
-- Join drivers, trips, reviews, payments
```

**Solution:**
```sql
CREATE VIEW vw_active_drivers_performance AS
SELECT 
  d.id as driver_id,
  d.name,
  d.city,
  d.is_active,
  d.rating as profile_rating,
  COUNT(DISTINCT t.id) as trip_count,
  AVG(r.rating) as avg_review_rating,
  SUM(p.amount) as total_revenue
FROM drivers d
LEFT JOIN trips t ON d.id = t.driver_id
LEFT JOIN reviews r ON t.id = r.trip_id AND r.reviewee_id = d.id
LEFT JOIN payments p ON t.id = p.trip_id AND p.status = 'success'
WHERE d.is_active = true
GROUP BY d.id, d.name, d.city, d.is_active, d.rating;
```

### Lab 2: Stored Procedure — Complete a Trip
**Create procedure `complete_trip(p_trip_id INT)` that:**
- **Updates trip status to 'completed'**
- **Inserts review record (reviewer_id = 1, rating = random 3-5)**
- **Handles errors gracefully**

```sql
-- Write procedure with error handling
```

**Solution:**
```sql
CREATE PROCEDURE complete_trip(p_trip_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
  v_driver_id INT;
  v_rider_id INT;
  v_random_rating INT;
BEGIN
  -- Get driver and rider
  SELECT driver_id, rider_id INTO v_driver_id, v_rider_id
  FROM trips WHERE id = p_trip_id;
  
  IF v_driver_id IS NULL THEN
    RAISE EXCEPTION 'Trip % not found', p_trip_id;
  END IF;
  
  -- Update trip
  UPDATE trips SET status = 'completed', completed_at = NOW() WHERE id = p_trip_id;
  
  -- Insert review (rider reviews driver)
  v_random_rating := 3 + FLOOR(RANDOM() * 3)::INT;
  INSERT INTO reviews (trip_id, reviewer_id, reviewee_id, rating, created_at)
  VALUES (p_trip_id, v_rider_id, v_driver_id, v_random_rating, NOW());
  
  RAISE NOTICE 'Trip % completed with rating %', p_trip_id, v_random_rating;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Error completing trip: %', SQLERRM;
    ROLLBACK;
END;
$$;

-- Call it
CALL complete_trip(42);
```

### Lab 3: Trigger — Enforce Payment Status
**Create trigger that prevents trip completion if payment status is NOT 'success'.**

```sql
-- Write trigger + function
-- ON trips BEFORE UPDATE
-- Check linked payment status
```

**Solution:**
```sql
CREATE FUNCTION check_payment_before_trip_complete()
RETURNS TRIGGER AS $$
DECLARE
  v_payment_status VARCHAR;
BEGIN
  -- Only check if status is changing to 'completed'
  IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
    SELECT status INTO v_payment_status FROM payments WHERE trip_id = NEW.id LIMIT 1;
    
    IF v_payment_status != 'success' THEN
      RAISE EXCEPTION 'Cannot complete trip: payment status is %', v_payment_status;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_payment_before_complete
BEFORE UPDATE ON trips
FOR EACH ROW
EXECUTE FUNCTION check_payment_before_trip_complete();
```

### Lab 4: Materialized View — Monthly Revenue Report
**Create materialized view `mv_monthly_revenue` with: year, month, city, total_revenue, trip_count, avg_fare.**

```sql
-- Use CREATE MATERIALIZED VIEW
-- Group by EXTRACT(YEAR, started_at), EXTRACT(MONTH, started_at), city
```

**Solution:**
```sql
CREATE MATERIALIZED VIEW mv_monthly_revenue AS
SELECT 
  EXTRACT(YEAR FROM t.started_at)::INT as year,
  EXTRACT(MONTH FROM t.started_at)::INT as month,
  d.city,
  SUM(p.amount) as total_revenue,
  COUNT(t.id) as trip_count,
  AVG(t.fare) as avg_fare
FROM trips t
JOIN drivers d ON t.driver_id = d.id
LEFT JOIN payments p ON t.id = p.trip_id AND p.status = 'success'
WHERE t.status = 'completed'
GROUP BY EXTRACT(YEAR FROM t.started_at), EXTRACT(MONTH FROM t.started_at), d.city
ORDER BY year DESC, month DESC, total_revenue DESC;

-- Index for fast queries
CREATE INDEX idx_monthly_revenue_city ON mv_monthly_revenue(city);
```

### Lab 5: Pressure Scenario — Insert Suddenly Slow
**PRESSURE: After adding an audit trigger, INSERT trips became 10x slower. Fix it.**

**Scenario:**
```sql
CREATE TRIGGER log_all_trip_inserts
AFTER INSERT ON trips
FOR EACH ROW
EXECUTE FUNCTION log_to_audit_table();

CREATE FUNCTION log_to_audit_table()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_log (table_name, action, record_id, changed_at)
  VALUES ('trips', 'INSERT', NEW.id, NOW());
  
  -- EXPENSIVE: Full table scan to check for duplicates!
  INSERT INTO fraud_detection (trip_id, risk_score)
  SELECT NEW.id, COUNT(*) / 1000.0
  FROM trips t
  WHERE ABS(EXTRACT(EPOCH FROM (t.created_at - NOW()))) < 60;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**Issues:**
1. Trigger does expensive fraud check on EVERY insert.
2. Full table scan for recent trips (no index).
3. Runs synchronously → blocks INSERT.

**Solution:**
```sql
-- FAST: Move expensive work to async, index the check
CREATE FUNCTION log_to_audit_table()
RETURNS TRIGGER AS $$
BEGIN
  -- Quick logging only
  INSERT INTO audit_log (table_name, action, record_id, changed_at)
  VALUES ('trips', 'INSERT', NEW.id, NOW());
  
  -- Defer fraud check to separate job queue or async task
  PERFORM pg_notify('fraud_detection', json_build_object(
    'trip_id', NEW.id, 'fare', NEW.fare
  )::text);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add index for quick lookups if you must do in-trigger check
CREATE INDEX idx_trips_created_at ON trips(created_at DESC);
```

---

## 🔍 Deep Dive: Trigger Overhead & Hidden Costs

### Execution Flow with Triggers

```
INSERT trip → BEFORE triggers → INSERT → AFTER triggers → Return
  ↓                                        ↓
  Log trigger (50ms)              Audit trigger (100ms)
  Validate trigger (20ms)         Fraud check trigger (500ms)
                                  ────────────────────
                                  Total: 670ms vs 10ms without triggers!
```

### Procedure Plan Cache Problem

**Parameter Sniffing in Action:**

```sql
-- First call with p_limit = 10 → plan assumes small result
CALL get_top_drivers(10);  -- 50ms, cached plan A

-- Second call with p_limit = 100000 → uses OLD plan A → SLOW!
CALL get_top_drivers(100000);  -- 5000ms, wrong plan!

CREATE PROCEDURE get_top_drivers(p_limit INT)
LANGUAGE plpgsql
AS $$
BEGIN
  -- Plan generated from FIRST parameter value
  RETURN QUERY
  SELECT * FROM trips ORDER BY fare DESC LIMIT p_limit;
END;
$$;
```

**Solution: Recompile or use hints**

```sql
-- Force plan recompilation (expensive, use rarely)
ALTER PROCEDURE get_top_drivers(INT) RESET all;

-- Or: Use dynamic SQL to avoid plan caching
CREATE PROCEDURE get_top_drivers_dynamic(p_limit INT)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY EXECUTE 'SELECT * FROM trips ORDER BY fare DESC LIMIT ' || p_limit;
END;
$$;
```

---

## 🔥 Pressure Scenario: Insert Suddenly Slow After Trigger

**Production Alert (midnight):** Inserts to `trips` table slowed from 100 inserts/sec to 10 inserts/sec after deploying new audit trigger.

### Diagnosis

```sql
-- New trigger added:
CREATE TRIGGER audit_trip_insert
AFTER INSERT ON trips
FOR EACH ROW
EXECUTE FUNCTION audit_every_trip_insert();

CREATE FUNCTION audit_every_trip_insert()
RETURNS TRIGGER AS $$
BEGIN
  -- PROBLEM: Doing audit for EVERY single trip
  INSERT INTO trip_audit SELECT * FROM trips WHERE id = NEW.id;
  
  -- PROBLEM 2: Synchronous — blocks user transaction
  PERFORM heavy_ml_fraud_check(NEW.id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### Root Causes

1. **Synchronous trigger** — User waits for trigger completion.
2. **Row-level overhead** — Runs for every row (bulk inserts are murdered).
3. **Extra work** — Unnecessary SELECT, fraud checks on all trips.

### Solution

```sql
-- OPTIMIZED: Async, batch processing
CREATE FUNCTION audit_trip_insert_async()
RETURNS TRIGGER AS $$
BEGIN
  -- Quick audit: just log the ID
  INSERT INTO trip_audit_queue (trip_id, inserted_at)
  VALUES (NEW.id, NOW());
  
  -- Queue fraud check as background job
  PERFORM pg_notify('fraud_queue', NEW.id::text);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_trip_insert
AFTER INSERT ON trips
FOR EACH ROW
EXECUTE FUNCTION audit_trip_insert_async();

-- Separate process: consume fraud_queue asynchronously
-- Or batch process: SELECT FROM trip_audit_queue LIMIT 1000
```

---

## ✅ Recap Checklist

- [ ] Understand views (standard vs materialized)
- [ ] Can write a basic stored procedure with parameters
- [ ] Know trigger syntax: BEFORE/AFTER, FOR EACH ROW/STATEMENT
- [ ] Understand INSTEAD OF trigger use case
- [ ] Can spot synchronous trigger performance problems
- [ ] Understand plan cache & parameter sniffing
- [ ] Know when to use temp table vs view
- [ ] Attempted Lab 1–5 without solutions
- [ ] Can explain trigger overhead in own words
- [ ] Watched video segment [15:35:02–18:23:42](https://www.youtube.com/watch?v=SSKVgrwhzus)

---

## 🧭 Navigation

**← [Day 6: Subqueries & CTEs](./day-06-subqueries-cte.md) | [Day 8: Indexes & Execution Plans →](./day-08-indexes-execution-plans.md)**

---

*Last updated: 11 March 2026 | [Bootcamp Home](../README.md)*
