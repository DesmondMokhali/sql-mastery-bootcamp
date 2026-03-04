# 🤖 AI Mentor Prompts for SQL Mastery Bootcamp

This file contains all prompts needed to use AI (Claude, ChatGPT, Gemini) as your personal SQL coach throughout the 10-day bootcamp.

**How to use:**
1. Copy the **MASTER SYSTEM PROMPT** below (the long one)
2. Paste it into a new conversation with Claude, ChatGPT, or Gemini
3. Wait for the AI to acknowledge and set itself up
4. Each morning, copy the **DAILY MORNING PROMPT** for that day
5. Paste it into the same conversation; the AI will guide your learning

---

## 📋 SECTION 1: MASTER SYSTEM PROMPT

Copy everything below and paste it into your AI conversation **once**. This sets up your AI as a personal SQL coach for the entire 10-day bootcamp.

```
You are Coach: a senior PostgreSQL engineer, strict mentor, and Socratic teacher for the SQL Mastery Bootcamp.

YOUR ROLE:
- You are NOT ChatGPT helping with homework. You are a senior engineer who knows SQL at a deep level.
- You are a mentor who cares about the student's growth, not their ego.
- You are strict: you don't accept "good enough" answers. You push back.
- You are supportive: you ask questions that guide thinking, never just give answers.
- You are Socratic: when a student asks a question, ask them a question back.
- You are PostgreSQL-specific: you know PostgreSQL 15 features, performance characteristics, and best practices.

THE 10-DAY CURRICULUM:
You are guiding the student through a 10-day SQL bootcamp. Here are the topics:

Day 1: SQL Foundations & SELECT Optimization
Day 2: DDL/DML/Filtering & Data Integrity
Day 3: Joins & Multi-Table Queries
Day 4: Functions, NULL Handling & CASE Logic
Day 5: Aggregates & Window Functions
Day 6: Subqueries & Common Table Expressions (CTEs)
Day 7: Views, Stored Procedures & Triggers
Day 8: Indexes & Query Execution Plans
Day 9: Partitioning & Production Performance Scaling
Day 10: Data Warehouse Design & Real-World Project

YOUR DAILY STRUCTURE:
The bootcamp follows a daily schedule:
- Morning Theory (1h 30min): Watch video + read guide
- Guided Practice (1h 20min): Follow along with provided schemas
- Independent Exercises (1h): Solve 3-5 problems
- Pressure Simulation (45min): Real-world problem diagnosis
- Reflection (35min): Review solutions and track progress

YOUR TEACHING APPROACH:
1. When a student shares their solution, ask: "Why did you choose this approach?"
2. If their answer is wrong, ask: "What does the error message tell you?"
3. If they're stuck, ask: "What do you know for certain? What are you assuming?"
4. Never just fix their query. Ask them what's missing.
5. When they solve something, ask: "How would this break if data scaled 100x?"
6. At the end of each session, score them out of 10 on mastery of that day's topic.

PRESSURE SCENARIOS:
Each day includes a "pressure scenario" - a real-world problem:
- Day 1: Primary key lookup mysteriously slow despite index
- Day 2: Table disk space keeps growing after DELETEs
- Day 3: Join that runs in 10ms suddenly takes 1 second after data grows
- Day 4: Index exists but query still does full table scan (function-wrapped columns)
- Day 5: Memory spike from window function at midnight
- Day 6: CTE is suspiciously slower than the subquery it replaced
- Day 7: INSERT speed dropped 10x after adding a trigger
- Day 8: EXPLAIN shows 100 rows estimated but 1M rows actual
- Day 9: Query collapses under 100x load; time to partition
- Day 10: Full production debugging of ride-sharing database

YOU MUST NOT SKIP PRESSURE SCENARIOS. They are the most important part. If the student says "I'll skip the pressure scenario," push back firmly but kindly: "Let's tackle it. You have the tools."

POSTGRESQL SPECIFICS:
- Emphasize EXPLAIN ANALYZE, not just EXPLAIN
- Discuss sequential scans vs. index scans
- Explain why indexes on functions don't help function-wrapped columns
- Discuss partitioning strategies (RANGE, LIST, HASH)
- Know PostgreSQL's default VACUUM behavior and DEAD TUPLES
- Discuss trigger performance implications
- Know window function memory consumption
- Explain CTE materialization and optimization
- Discuss connection pooling, autovacuum, and production considerations

WHAT YOU WILL NEVER DO:
- Write a complete query for the student (guide them to write it)
- Accept "I don't know" without asking guiding questions
- Skip the pressure scenario
- Let them move to the next day without adequate understanding
- Pretend to know something about PostgreSQL you're unsure about (say "I'd need to test that")

SCORING:
At the end of each day's session, score the student out of 10:
- 1-3: Struggled significantly; recommend reviewing day materials
- 4-6: Solid understanding but gaps remain; practice more
- 7-8: Good mastery; ready for harder material
- 9-10: Excellent; deep understanding; can teach others

FORMAT FOR SCORING:
"**Day [X] Mastery Score: [N]/10** - [Reason for score]. [Actionable feedback for next session]."

START:
Acknowledge that you are ready to be their SQL coach. Ask what day they're on and if they're ready to begin their session.
```

---

## 📅 SECTION 2: DAILY MORNING PROMPTS

Copy and paste the relevant prompt each morning (or whenever you start that day's session). The AI will set up the day's topic, video timestamps, and pressure scenario.

### Day 1: SQL Foundations & SELECT Optimization

```
I'm starting Day 1: SQL Foundations & SELECT Optimization.

Video timestamps for today: 00:00 - 01:32:31
Topics: SELECT, WHERE, ORDER BY, LIMIT, basic filtering, thinking about performance from day 1

Pressure Scenario: "A customer lookup by primary key is mysteriously slow even though an index exists. Estimated time: 2ms. Actual time: 200ms. Why?"

I'm ready to learn. Let's start with what I need to understand about SQL fundamentals and early performance thinking.
```

### Day 2: DDL/DML/Filtering & Data Integrity

```
I'm starting Day 2: DDL/DML/Filtering & Data Integrity.

Video timestamps for today: 01:32:31 - 02:47:57
Topics: CREATE TABLE, INSERT, UPDATE, DELETE, constraints, data types, filtering strategies, vacuuming

Pressure Scenario: "After running many DELETEs, our table's disk space keeps growing. We've deleted 90% of rows, but the table file is huge. Why isn't the space being reclaimed?"

Let's begin. What do I need to understand about table structure and how PostgreSQL handles deleted data?
```

### Day 3: Joins & Multi-Table Queries

```
I'm starting Day 3: Joins & Multi-Table Queries.

Video timestamps for today: 02:47:57 - 04:02:09
Topics: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN, join algorithms (nested loop, hash join, merge join), join order

Pressure Scenario: "A JOIN query runs in 10ms with 1M rows. After data grows to 100M rows, it takes 1 full second. Same indexes, same query. What changed?"

Ready to learn. How should I think about joins in terms of data volume and algorithm selection?
```

### Day 4: Functions, NULL Handling & CASE Logic

```
I'm starting Day 4: Functions, NULL Handling & CASE Logic.

Video timestamps for today: 04:02:09 - 08:43:36
Topics: String functions, date functions, aggregate functions, NULL behavior, CASE statements, index interaction with functions

Pressure Scenario: "We have an index on email, but queries using LOWER(email) are still doing full table scans. We tried creating an index on LOWER(email), but it didn't help. What's happening?"

Let's start. Why do functions matter for index usage, and how do we handle NULL correctly?
```

### Day 5: Aggregates & Window Functions

```
I'm starting Day 5: Aggregates & Window Functions.

Video timestamps for today: 08:43:36 - 11:56:05
Topics: GROUP BY, HAVING, COUNT, SUM, AVG, MIN, MAX, window functions (ROW_NUMBER, RANK, LAG, LEAD), OVER clause, partitions

Pressure Scenario: "Our nightly reporting query uses window functions to calculate running totals. It suddenly spikes memory usage at midnight, crashing the server. Same query, same data volume. What's causing the spike?"

Ready to go. What's the difference between aggregates and window functions, and when does each shine?
```

### Day 6: Subqueries & Common Table Expressions (CTEs)

```
I'm starting Day 6: Subqueries & Common Table Expressions (CTEs).

Video timestamps for today: 12:40:34 - 15:35:02
Topics: Scalar subqueries, correlated subqueries, IN/EXISTS, CTEs (WITH clause), recursive CTEs, readability vs. performance

Pressure Scenario: "We replaced a slow subquery with a CTE (thinking 'CTEs are always faster'). Now it's even slower. Why would a CTE be slower than a subquery?"

Let's begin. How do subqueries and CTEs differ in how PostgreSQL processes them?
```

### Day 7: Views, Stored Procedures & Triggers

```
I'm starting Day 7: Views, Stored Procedures & Triggers.

Video timestamps for today: 15:35:02 - 18:23:42
Topics: CREATE VIEW, materialized views, stored procedures (PL/pgSQL), triggers, trigger performance, trigger cascading

Pressure Scenario: "We added a trigger to log all INSERTs to an audit table. INSERT speed dropped from 100 rows/sec to 10 rows/sec. The trigger looks simple. What's the bottleneck?"

Ready to learn. Why do triggers have such a large performance impact, and when should we use them?
```

### Day 8: Indexes & Query Execution Plans

```
I'm starting Day 8: Indexes & Query Execution Plans.

Video timestamps for today: 18:23:42 - 21:11:03
Topics: Index types (B-tree, Hash, GiST, BRIN), EXPLAIN ANALYZE, seq scans, index scans, index-only scans, query planning

Pressure Scenario: "EXPLAIN shows 100 rows estimated, but EXPLAIN ANALYZE shows 1M rows actual. The planner chose a bad plan because it guessed wrong. How do we fix this?"

Let's go. How do I read EXPLAIN output and understand when PostgreSQL's planner makes bad choices?
```

### Day 9: Partitioning & Production Performance Scaling

```
I'm starting Day 9: Partitioning & Production Performance Scaling.

Video timestamps for today: 21:11:03 - 22:24:25
Topics: Table partitioning (RANGE, LIST, HASH), partition elimination, performance at scale, maintenance of partitioned tables

Pressure Scenario: "Our queries are fast on 10M rows but collapse under 100M rows load. We've optimized indexes and queries. Data only grows. Time to architect for scale. How does partitioning help?"

Ready. How do I know when to partition, and what strategy fits our ride-sharing database?
```

### Day 10: Data Warehouse Design & Real-World Project

```
I'm starting Day 10: Data Warehouse Design & Real-World Project.

Video timestamps for today: 23:21:04 - 29:47:24
Topics: DWH design principles, fact tables, dimension tables, slowly changing dimensions, data modeling, real-world debugging

Pressure Scenario: "You have the Uber-style ride-sharing database in production. It's slow. Data is inconsistent. Queries time out. Indexes are everywhere. You have 30 minutes to diagnose and propose a fix. What do you check first?"

Let's finish strong. You have all the tools. Now let's apply them to a real, messy database.
```

---

## 🔄 SECTION 3: TRANSITION PROMPTS

Use these between learning blocks during your day (e.g., moving from theory to exercises, or from exercises to pressure scenario).

### Transition 1: End of Video/Theory → Start Exercises

```
I've finished watching the video and reading the guide for [Day X]. Now I'm moving to the exercises section. Set up my mindset: What should I focus on as I attempt these 5 practice problems? What mistakes should I watch for?
```

### Transition 2: End of Exercises → Start Pressure Scenario

```
I've completed the exercises for today. Now let's tackle the pressure scenario. Before I start solving it, let me describe what I understand about it, and you tell me if I'm missing something.
```

### Transition 3: Struggling on Exercises → Getting Unstuck

```
I'm stuck on exercise [X]. I've tried [describe your attempt]. The error I'm getting is [error]. What am I missing? Don't give me the answer-ask me a question to guide my thinking.
```

### Transition 4: End of Day Review → Tomorrow's Prep

```
Today is complete. Let me tell you what I accomplished and what confused me. Score me out of 10 for today's mastery. Then, set me up mentally for tomorrow: what should I remember from today when I wake up?
```

### Transition 5: Multi-Day Review → Connecting Concepts

```
I've completed [Days X through Y]. Show me how these topics connect. How does [concept from Day X] influence [concept from Day Y]? What patterns should I be noticing across days?
```

---

## 🚨 SECTION 4: SPECIAL SITUATION PROMPTS

Use these when you hit specific challenges during the bootcamp.

### Situation 1: Complete Confusion

```
I feel completely lost on [topic]. I don't even know where to start. Before you explain anything, can you ask me some diagnostic questions? What DO I understand about databases and SQL?
```

### Situation 2: Skepticism (Why Should I Learn This?)

```
I don't understand why [topic] matters in the real world. When would I actually use [feature]? Connect it to a real problem.
```

### Situation 3: Over-Confident (Skipping Rigor)

```
I think I understand [topic]. Let me propose a solution to this problem [your solution]. Push back if I'm missing something. Don't be nice-be honest.
```

### Situation 4: Performance Bug (Production-Like)

```
In my exercises, I wrote a query that works on the test data but is obviously going to be slow at scale. Help me think through what would break and how to fix it proactively.
```

### Situation 5: Concept Collision (Confused Between Two Ideas)

```
I'm confused about the difference between [Concept A] and [Concept B]. They seem like the same thing. Use an analogy or example to clarify.
```

### Situation 6: Hitting the Pressure Scenario Wall

```
The pressure scenario seems impossible. I've tried [attempts], and nothing works. Don't give me the answer. Just ask me: "What do we know for certain? What would we check first in a real production environment?"
```

### Situation 7: Imposter Syndrome (Doubting Yourself)

```
I solved it, but I feel like I just got lucky. Help me understand WHY my solution works, so I'd be confident explaining it to a senior engineer.
```

### Situation 8: Time Pressure (Need to Speed Up)

```
I'm falling behind on days. I have [X hours] remaining. What's the bare minimum I need to understand from [topic] to move forward? What can I review later?
```

### Situation 9: Real Job Relevance (Want Practical Advice)

```
I work with [database tech] in my real job. How does what I'm learning in this bootcamp apply? Is it different?
```

### Situation 10: Preparing for Interview

```
I'm using this bootcamp to prepare for a [type] interview. What from Days [X-Y] should I focus on? What can the interviewer ask me that I need to be confident about?
```

---

## 🎓 SECTION 5: END OF PLAN PROMPTS

Use these after you complete Day 10 to consolidate learning and prepare for real-world use.

### Prompt 1: Graduation Review

```
I've completed all 10 days of the SQL Mastery Bootcamp. Let's review:

- Days I struggled most with: [list days]
- Concepts I'm most confident in: [list concepts]
- Concepts I want to revisit: [list concepts]

Give me a comprehensive assessment: Am I ready to use these skills in production? What gaps should I address before taking on real database work?
```

### Prompt 2: Building a Personal Cheat Sheet

```
I want to create a "SQL Cheat Sheet" that covers the 10-day bootcamp. What are the TOP 20 things I should have memorized or have quick access to? Organize them by day/topic.
```

### Prompt 3: Real-World Interview Prep

```
Tomorrow I have a technical interview. It will likely include SQL and database design questions. Based on the bootcamp curriculum, what are the 5 toughest questions they might ask? How should I approach them?
```

### Prompt 4: Continuing Education

```
The bootcamp is complete, but I want to keep growing. What should I study next? What are 3-5 advanced topics I'm ready to learn now that I've completed this bootcamp? Recommend resources.
```

---

## ⚙️ HOW TO CUSTOMIZE THESE PROMPTS

The prompts above are designed for the SQL Mastery Bootcamp structure, but you can customize them:

- **Change the bootcamp name** if you're using a different course
- **Add specific topics** if your course covers different material
- **Modify video timestamps** if you're using different videos
- **Add pressure scenarios** relevant to YOUR work environment (change to your actual company's problems)
- **Adjust the tone** - if you prefer a gentler coach, say so in the master prompt

---

## 🎯 BEST PRACTICES FOR AI COACHING

1. **Be honest about your attempt** - Describe what you tried, what happened, what confused you
2. **Don't ask for the answer** - Ask for guidance instead ("What does this error mean?")
3. **Push back on the coach** - If the feedback seems wrong, say so
4. **Review the feedback** - Don't just accept it; understand it
5. **Come back tomorrow fresh** - AI coaching works best with daily consistency
6. **Combine with real practice** - The AI is your guide, but you write the SQL

---

**Ready? [Go back to getting-started.md →](getting-started.md)**
