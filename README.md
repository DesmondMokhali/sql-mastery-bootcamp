<div align="center">

# SQL Mastery Bootcamp

### Engineering-Level SQL in 10 Days - Free and Open Source

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Duration](https://img.shields.io/badge/Duration-10%20Days-blue)](#the-10-day-plan)
[![Level](https://img.shields.io/badge/Level-Engineering-red)](#what-youll-learn)
[![Database](https://img.shields.io/badge/Database-PostgreSQL-336791)](https://www.postgresql.org/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Video](https://img.shields.io/badge/Video-30%20Hours-FF0000?logo=youtube)](https://www.youtube.com/watch?v=SSKVgrwhzus)
[![Star](https://img.shields.io/github/stars/DesmondMokhali/sql-mastery-bootcamp?style=social)](https://github.com/DesmondMokhali/sql-mastery-bootcamp)

<br/>

**Go from SQL beginner to thinking like a database engineer - in 10 structured days.**

No installations. No fluff. Just PostgreSQL, real pressure scenarios, and a system that works.

<br/>

[Get Started](#quick-start) · [View the Plan](#the-10-day-plan) · [Study Kit](#study-kit) · [Real-World Project](#real-world-project) · [AI Mentor](#ai-mentor-integration)

</div>

---

## What You Will Learn

By the end of this bootcamp you will be able to:

- Write and optimize SQL queries with a deep understanding of how they execute
- Read and interpret `EXPLAIN ANALYZE` output to diagnose slow queries
- Design tables and indexes that perform at millions of rows
- Understand MVCC, WAL, and what PostgreSQL does under the hood
- Build a production-style data warehouse with Bronze, Silver, and Gold layers
- Debug real-world engineering scenarios under pressure

| Day | Topic | You Will Master |
|-----|-------|-----------------|
| 1 | SQL Foundations and SELECT | Query execution flow, heap storage, index vs seq scan |
| 2 | DDL, DML and Filtering | MVCC, dead tuples, VACUUM, ACID transactions |
| 3 | Joins | Nested loop, hash join, cardinality, join predicates |
| 4 | Functions, NULL and CASE | SARGability, predicate pushdown, three-valued logic |
| 5 | Aggregates and Window Functions | Partitioning, frames, ranking, memory usage |
| 6 | Subqueries and CTEs | Materialization, optimization barriers, execution trees |
| 7 | Views, Procedures and Triggers | Trigger overhead, plan cache, hidden performance costs |
| 8 | Indexes and Execution Plans | B-Tree internals, bitmap scan, cost-based optimizer |
| 9 | Partitions and Performance | Partition pruning, parallel query, IO vs CPU bottlenecks |
| 10 | Data Warehouse and Real Project | Star schema, fact/dimension tables, billion-row design |

---

## Who This Is For

- **Backend engineers** building APIs on top of relational databases
- **Data analysts** who want to go beyond SELECT and understand performance
- **Full-stack developers** tired of relying on ORMs without understanding what runs underneath
- **Interview candidates** preparing for SQL and system design rounds
- **Anyone** who has used SQL but never truly understood it

> No prerequisites. Just a browser and 5 hours per day for 10 weekdays.

---

## The 10-Day Plan

Each day follows the same structured 5 hours 10 minutes block:

| Time | Block | Duration |
|------|-------|----------|
| 09:00 - 10:30 | Core Theory and Structured Watching | 90 min |
| 10:30 - 10:40 | Transition Buffer | 10 min |
| 10:40 - 11:55 | Lab Engineering | 75 min |
| 11:55 - 12:05 | Transition Buffer | 10 min |
| 12:05 - 12:35 | Recap Session | 30 min |
| 12:35 - 12:45 | Transition Buffer | 10 min |
| 12:45 - 13:30 | Deep Dive / Engine Thinking | 45 min |
| 13:30 - 13:40 | Transition Buffer | 10 min |
| 13:40 - 14:10 | Quiz and Pressure Simulation | 30 min |

### Day-by-Day Breakdown

| Day | Topic | Video Range | Pressure Scenario |
|-----|-------|-------------|-------------------|
| 1 | SQL Foundations and SELECT | 00:00 - 01:32:31 | Primary key lookup suddenly slow - why? |
| 2 | DDL, DML and Filtering | 01:32:31 - 02:47:57 | Table size keeps growing after DELETEs |
| 3 | Joins | 02:47:57 - 04:02:09 | Join suddenly 100x slower after data growth |
| 4 | Functions, NULL and CASE | 04:02:09 - 08:43:36 | Index exists but query still doing Seq Scan |
| 5 | Aggregates and Window Functions | 08:43:36 - 11:56:05 | Window function causes memory spike |
| 6 | Subqueries and CTEs | 12:40:34 - 15:35:02 | CTE made query slower than subquery |
| 7 | Views, Procedures and Triggers | 15:35:02 - 18:23:42 | Insert suddenly slow after trigger added |
| 8 | Indexes and Execution Plans | 18:23:42 - 21:11:03 | Estimated rows 100, actual rows 1,000,000 |
| 9 | Partitions and Performance | 21:11:03 - 22:24:25 | Query fine on small data, collapses at scale |
| 10 | Data Warehouse and Real Project | 23:21:04 - 29:47:24 | Full production debugging scenario |

---

## Quick Start

**No installation required. Works entirely in your browser.**

### Step 1 - Set up your practice database

1. Go to [db-fiddle.com](https://www.db-fiddle.com)
2. Select **PostgreSQL 15** from the dropdown
3. Copy and paste the contents of [`00-setup/db-fiddle-setup.sql`](00-setup/db-fiddle-setup.sql) into the left panel
4. Click **Run** - your Uber-style ride-sharing database is ready

### Step 2 - Activate your AI mentor

1. Open [Claude](https://claude.ai), [ChatGPT](https://chat.openai.com), or [Gemini](https://gemini.google.com)
2. Paste the **Master System Prompt** from [`00-setup/ai-mentor-prompts.md`](00-setup/ai-mentor-prompts.md)
3. Paste the **Day 1 Morning Prompt** from the same file
4. Your AI mentor is now activated and knows the full curriculum

### Step 3 - Open Day 1 and begin

Open [`daily-guides/day-01-sql-foundations.md`](daily-guides/day-01-sql-foundations.md) and follow the structured blocks.

```bash
# Clone the repo
git clone https://github.com/DesmondMokhali/sql-mastery-bootcamp.git
cd sql-mastery-bootcamp
```

> That is all. No Docker. No local database setup. No configuration. Just open and learn.

---

## Real-World Project

Every lab session uses a real **Uber-style ride-sharing database** - not toy examples.

```sql
drivers      -- drivers with ratings, cities, vehicle types
riders       -- registered passengers
trips        -- completed and active rides with geolocation
payments     -- payment records per trip
reviews      -- two-way driver and rider reviews
driver_earnings -- earnings breakdown per trip
```

By Day 10 you will have written queries that:
- Find the top-rated drivers in each city using window functions
- Detect payment fraud using correlated subqueries
- Analyze surge pricing patterns using CTEs
- Diagnose a slow query on 10 million trip records using EXPLAIN ANALYZE
- Design a Bronze/Silver/Gold data warehouse layer on top of the raw data

The full schema, seed data, and day-by-day practice queries are in [`real-world-project/`](real-world-project/).

---

## Study Kit

This bootcamp includes 12 purpose-built study tools:

| # | Component | What It Does |
|---|-----------|--------------|
| 01 | [Topic Mastery Tracker](study-kit/01-topic-mastery-tracker.md) | Rate yourself 0-3 on 60+ topics after each session |
| 02 | [8-Week Sprint Calendar](study-kit/02-sprint-calendar.md) | Extends beyond 10 days into interview prep and advanced topics |
| 03 | [Structured Study Guide](study-kit/03-structured-study-guide.md) | The science behind spaced repetition and active recall |
| 04 | [Active Recall Questions](study-kit/04-active-recall-questions.md) | 120+ questions organized by day with answer hints |
| 05 | [Logic Flow Diagrams](study-kit/05-logic-flow-diagrams.md) | ASCII diagrams for B-Tree, joins, MVCC, DWH layers |
| 06 | [Technical Cheat Sheet](study-kit/06-technical-cheat-sheet.md) | Dense 2-page SQL reference card |
| 07 | [Comparison Tables](study-kit/07-comparison-tables.md) | Side-by-side comparisons of joins, indexes, CTEs, and more |
| 08 | [Acronym and Glossary](study-kit/08-acronym-glossary.md) | 80+ terms with definitions and real-world context |
| 09 | [Mock Exam Repository](study-kit/09-mock-exam-repository.md) | 3 full timed exams (60 questions total) with answer keys |
| 10 | [The Error Log](study-kit/10-error-log.md) | Track mistakes, patterns, and your path to mastery |
| 11 | [Flash Drill Cards](study-kit/11-flash-drill-cards.md) | 100 Q&A cards plus 20 rapid-fire speed round cards |
| 12 | [Case Study Workbook](study-kit/12-case-study-workbook.md) | 10 production debugging case studies with full solutions |

---

## AI Mentor Integration

This is the first SQL bootcamp with a built-in AI mentor system.

The [`00-setup/ai-mentor-prompts.md`](00-setup/ai-mentor-prompts.md) file contains:

- **Master System Prompt** - activates your AI as "Coach", a strict PostgreSQL senior engineer
- **10 Daily Morning Prompts** - one per day, pre-loaded with that day's topics and pressure scenario
- **Transition Prompts** - paste when moving between session blocks
- **Special Situation Prompts** - "I don't understand this", "quiz me", "run the pressure sim now"
- **End of Plan Prompts** - performance review, gap analysis, interview readiness check

Works with Claude (recommended), ChatGPT, and Gemini.

```
Morning routine:
1. Open AI chat
2. Paste Master System Prompt
3. Paste Day X Morning Prompt
4. Coach is activated - follow the blocks
5. End of session: "Give me my score"
```

---

## What's Inside

```
sql-mastery-bootcamp/
|
+-- README.md
+-- LICENSE
+-- CONTRIBUTING.md
+-- .gitattributes
|
+-- 00-setup/
|   +-- getting-started.md         Complete onboarding guide
|   +-- ai-mentor-prompts.md       All AI mentor prompts (master + 10 daily)
|   +-- db-fiddle-setup.sql        Paste this into DB Fiddle to get started
|   +-- calendar/
|       +-- sql_mastery_10day.ics  Import into Google Calendar or Outlook
|
+-- daily-guides/
|   +-- day-01-sql-foundations.md
|   +-- day-02-ddl-dml-filtering.md
|   +-- day-03-joins.md
|   +-- day-04-functions-null-case.md
|   +-- day-05-aggregates-window-functions.md
|   +-- day-06-subqueries-cte.md
|   +-- day-07-views-procedures-triggers.md
|   +-- day-08-indexes-execution-plans.md
|   +-- day-09-partitions-performance.md
|   +-- day-10-projects-dwh-eda.md
|
+-- study-kit/
|   +-- 01-topic-mastery-tracker.md
|   +-- 02-sprint-calendar.md
|   +-- 03-structured-study-guide.md
|   +-- 04-active-recall-questions.md
|   +-- 05-logic-flow-diagrams.md
|   +-- 06-technical-cheat-sheet.md
|   +-- 07-comparison-tables.md
|   +-- 08-acronym-glossary.md
|   +-- 09-mock-exam-repository.md
|   +-- 10-error-log.md
|   +-- 11-flash-drill-cards.md
|   +-- 12-case-study-workbook.md
|
+-- real-world-project/
|   +-- README.md                  Database documentation and data dictionary
|   +-- schema.sql                 Full PostgreSQL schema with indexes
|   +-- seed-data.sql              Realistic sample data (50+ trips, 20 riders)
|   +-- practice-queries.sql       Day-by-day practice queries
|
+-- .github/
    +-- ISSUE_TEMPLATE/
        +-- bug_report.md
        +-- feature_request.md
```

---

## Video Resource and Credits

This bootcamp is a structured learning framework built around an outstanding free video course.

**Full credit and thanks to the original creator:**

| | |
|---|---|
| **Video** | SQL Full Course for Beginners (30 Hours) - From Zero to Hero |
| **Creator** | [Data with Baraa](https://www.youtube.com/@DataWithBaraa) |
| **Watch Free** | [youtube.com/watch?v=SSKVgrwhzus](https://www.youtube.com/watch?v=SSKVgrwhzus) |

> This repo adds structure, lab exercises, a real-world database, AI mentor prompts, and a full study kit on top of Baraa's teaching. All video content and core instruction belong to **Data with Baraa**. Please watch, like, and subscribe to support the original creator.

Each daily guide includes the exact video timestamp range so you know precisely where to start and stop each day.

---

## Contributing

Contributions make this bootcamp better for everyone.

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

**Ways to contribute:**
- Add new lab exercises for any day
- Improve explanations or fix errors
- Add translations to other languages
- Share your pressure scenario solutions
- Suggest new case studies

---

## License

MIT License - 2026 Mokhali

Free to use, modify, and distribute for any purpose. See [LICENSE](LICENSE) for details.

---

<div align="center">

**Built by [Mokhali](https://github.com/DesmondMokhali) - because SQL is too important to be boring.**

If this helped you, please star the repo. It helps others find it. ⭐

[Start Learning Now](00-setup/getting-started.md)

</div>
