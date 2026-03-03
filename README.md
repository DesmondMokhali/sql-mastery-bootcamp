# 🗄️ SQL Mastery Bootcamp

### Engineering-Level SQL in 10 Days — Free & Open Source

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Days](https://img.shields.io/badge/Duration-10%20Days-blue)
![Level](https://img.shields.io/badge/Level-Engineering-red)
![Database](https://img.shields.io/badge/Database-PostgreSQL-336791)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

---

## 💡 The Promise

**Go from SQL beginner to thinking like a database engineer — in 10 structured days. Free forever.**

SQL Mastery Bootcamp is an intensive, hands-on engineering program designed to take you from foundational SQL knowledge to production-grade database design and optimization. Built on real-world scenarios, pressure testing, and progressive complexity, this bootcamp prepares you for both technical interviews and actual engineering work.

---

## 🎯 What You'll Learn

- **SQL Foundations & SELECT Optimization** — master query writing and understand why certain queries perform better
- **DDL/DML Operations & Data Filtering** — safely create, modify, and manipulate tables with precision
- **Advanced JOIN Strategies** — understand join algorithms and write performant multi-table queries
- **Functions, NULL Handling & CASE Logic** — write defensive SQL that handles edge cases gracefully
- **Aggregates & Window Functions** — perform complex analytical queries without exploding your server memory
- **Subqueries & CTEs** — structure complex logic into readable, maintainable SQL
- **Views, Stored Procedures & Triggers** — abstract logic and enforce business rules at the database layer
- **Indexes & Query Execution Plans** — read EXPLAIN output and transform 100-second queries into milliseconds
- **Partitioning & Production Performance** — design tables that scale to billions of rows
- **Data Warehouse Design & Real-World Project** — architect an Uber-style ride-sharing database from scratch

---

## 👥 Who This Is For

- **Backend engineers** building APIs that touch databases
- **Data analysts** querying and transforming data at scale
- **Full-stack developers** wanting SQL expertise beyond ORM queries
- **Technical interview candidates** preparing for system design & database questions
- **Database enthusiasts** who want to think like a DBA, not just use SQL

**No prerequisites required.** Just a browser and 10 days of commitment. ⏰

---

## 📅 The 10-Day Plan

| Day | Dates | Topic | Pressure Scenario |
|-----|-------|-------|-------------------|
| 1 | Tue 3 Mar | SQL Foundations & SELECT | Primary key lookup mysteriously slow despite index |
| 2 | Wed 4 Mar | DDL/DML/Filtering | Table disk space keeps growing after DELETEs |
| 3 | Thu 5 Mar | Joins | Join that runs in 10ms suddenly takes 1 second after data grows |
| 4 | Fri 6 Mar | Functions, NULL, CASE | Index exists but query still does full table scan |
| 5 | Mon 9 Mar | Aggregates & Window Functions | Memory spike from window function at midnight |
| 6 | Tue 10 Mar | Subqueries & CTEs | CTE is suspiciously slower than the subquery it replaced |
| 7 | Wed 11 Mar | Views, Procedures, Triggers | INSERT speed dropped 10x after adding a trigger |
| 8 | Thu 12 Mar | Indexes & Execution Plans | EXPLAIN shows 100 rows estimated but 1M rows actual |
| 9 | Fri 13 Mar | Partitions & Performance | Query collapses under 100x load; time to partition |
| 10 | Mon 16 Mar | DWH Design & Real Project | Build and debug an Uber-style ride-sharing database |

---

## ⏱️ Daily Schedule

Each day follows a structured 5 hours 10 minutes of learning:

| Block | Duration | Activity |
|-------|----------|----------|
| **Morning Theory** | 1h 30min | Watch video lecture + read guide |
| **Guided Practice** | 1h 20min | Follow along in DB Fiddle with provided schemas |
| **Independent Exercises** | 1h 00min | Solve 3-5 problems; test your understanding |
| **Pressure Simulation** | 0h 45min | Real-world scenario: diagnose & fix the problem |
| **Reflection & Notes** | 0h 35min | Review your solutions, take notes, update tracker |

**Daily commitment:** Start fresh each morning. No prerequisites from previous days (though cumulative mastery helps).

---

## 📂 What's Inside

```
sql-mastery-bootcamp/
├── README.md                          # This file
├── LICENSE                            # MIT License
├── CONTRIBUTING.md                    # How to contribute
├── 00-setup/
│   ├── getting-started.md            # Comprehensive onboarding guide
│   ├── ai-mentor-prompts.md          # Prompts for AI coaching
│   └── db-fiddle-setup.sql           # PostgreSQL schema for DB Fiddle
├── day-01-foundations/
│   ├── guide.md                      # Day 1 learning guide
│   ├── exercises.sql                 # 5 practice exercises
│   ├── solutions.sql                 # Annotated solutions
│   └── pressure-scenario.md          # Real-world problem to solve
├── day-02-ddl-dml/
├── day-03-joins/
├── day-04-functions/
├── day-05-aggregates-window/
├── day-06-subqueries-cte/
├── day-07-views-procedures/
├── day-08-indexes-explain/
├── day-09-partitions-performance/
├── day-10-dwh-project/
├── .github/
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md             # Bug report template
│       └── feature_request.md        # Feature request template
└── docs/
    ├── glossary.md                   # SQL & database terminology
    └── postgres-reference.md         # PostgreSQL specific features
```

---

## 🚀 Quick Start

### Step 1: Clone This Repository
```bash
git clone https://github.com/mokhali/sql-mastery-bootcamp.git
cd sql-mastery-bootcamp
```

### Step 2: Open the Setup Guide
Read `00-setup/getting-started.md` — it takes 10 minutes and explains everything.

### Step 3: Start Day 1
Open `day-01-foundations/guide.md` and begin your journey.

**That's it.** No installation, no setup. Just open DB Fiddle in your browser. ✨

---

## 🚕 Real-World Project

The bootcamp uses a running case study: an **Uber-style ride-sharing database**. By Day 10, you'll have designed and debugged:

- Drivers and passengers (with complex statuses)
- Ride requests (matching algorithms)
- Pricing logic (surge multipliers, tips)
- Performance at scale (10M+ rides, partitioning, indexing)

This isn't a toy database. It's a real problem space where SQL knowledge directly impacts user experience.

---

## 📚 Study Kit (12 Components)

1. **Daily Guides** — 10 markdown guides (one per day) with video timestamps and learning outcomes
2. **Video Lectures** — Full 30-hour video course (links provided in each day guide)
3. **Exercise Sets** — 50+ hands-on SQL exercises with progressive difficulty
4. **Annotated Solutions** — Every exercise solution with detailed comments explaining the "why"
5. **Pressure Scenarios** — 10 real-world problems (query slowdown, data integrity, scale issues)
6. **DB Fiddle Schemas** — Pre-built PostgreSQL schemas ready to paste into DB Fiddle
7. **AI Mentor Prompts** — 50+ prompts to use with Claude, ChatGPT, or Gemini as your personal coach
8. **Glossary** — SQL & database terminology (terms linked in guides)
9. **PostgreSQL Reference** — Version-specific features and best practices
10. **Mastery Tracker** — Self-assessment template to track your progress
11. **Issue Templates** — How to report bugs or suggest improvements
12. **Contributing Guide** — How to improve this bootcamp for others

---

## 🤖 AI Mentor Integration

Don't learn alone. Use the **AI Mentor Prompts** to get personalized coaching:

1. Copy the **Master System Prompt** from `00-setup/ai-mentor-prompts.md`
2. Paste it into Claude, ChatGPT, or Gemini
3. Use the **Daily Morning Prompt** at the start of each session
4. Describe your solution or problem; the AI coach gives Socratic feedback
5. The AI simulates the pressure scenario and scores you out of 10

This transforms a solo bootcamp into a guided learning experience. The AI knows the curriculum, knows PostgreSQL, and won't let you skip the hard parts.

---

## 🎬 Video Resource

Full video course (30 hours): https://www.youtube.com/watch?v=SSKVgrwhzus

Each day guide includes exact timestamps where the video covers that day's topic. Watch the video, follow the guide, then practice.

---

## 🤝 Contributing

See `CONTRIBUTING.md` for detailed guidelines.

**We welcome:**
- New exercises and solutions
- Bug fixes and clarifications
- PostgreSQL optimizations
- Translations
- Additional day guides or supplements

---

## 📄 License

MIT License © 2026 Mokhali

You are free to use, modify, and distribute this bootcamp for any purpose (personal, commercial, etc.). See `LICENSE` for details.

---

## ❤️ Made with Love

This bootcamp exists because SQL is too important to be boring. Written by **Mokhali**, a database engineer who believes practical, hands-on learning beats passive courses every time.

**Questions?** Open an issue. **Ideas?** Submit a PR. **Loving it?** Star the repo. ⭐

---

**Ready to master SQL? [Start here →](00-setup/getting-started.md)**
