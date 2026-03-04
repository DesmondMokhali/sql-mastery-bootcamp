# 📖 How to Use This Bootcamp
**The Science of Learning SQL the Right Way**

---

## 🧠 Why This Bootcamp Works

This bootcamp is designed around **three core learning principles:**

### 1. Spaced Repetition
**Concept:** Review material at increasing intervals to move it to long-term memory.

- Day 1: Learn SELECT
- Day 2: Use SELECT in JOINs (repeat)
- Day 3: Use SELECT in GROUP BY queries (repeat)
- Day 10: Use SELECT in DWH design (repeat)

**Result:** By Day 10, SELECT is deeply embedded. You won't forget it.

### 2. Active Recall
**Concept:** Force your brain to retrieve information, not just read it.

- **Bad:** Reading the guide passively
- **Good:** Reading guide, closing it, writing query from memory

**Lab exercises force active recall.** You can't pass them without thinking.

### 3. Deliberate Practice
**Concept:** Practice at the edge of your ability, get immediate feedback.

- Day 1 labs: Easy (comfort zone)
- Day 5 labs: Hard (edge of ability)
- Day 10 labs: Production scenario (stretch)

**Pressure scenarios** simulate real-world debugging. This builds confidence.

---

## 📚 How to Use Each Daily Session

### The Session Structure (8 hours / day)

#### Morning Block (09:00-12:00) - Learn & Understand

**09:00-09:45** Topic 1 Deep Dive
- Read the guide
- Understand the *why*, not just the *how*
- **Active recall check:** Close guide, explain to imaginary colleague

**09:45-10:30** Topic 2 Deep Dive
- Repeat process

**10:30-11:15** Topic 3 Deep Dive

**11:15-12:00** Synthesis
- Connect all 3 topics
- Real-world example from Uber schema
- Ask: "When would I use this?"

**Checkpoint:** You can explain each topic in your own words

---

#### Midday Break (12:00-13:00)
**Step away.** Lunch, walk, let brain consolidate. Don't study during lunch.

---

#### Afternoon Block (13:00-15:15) - Practice & Master

**13:00-13:45** Deep Dive Section
- Study the ASCII diagrams
- Understand execution trees, optimization barriers
- **Why?** You'll see this in EXPLAIN output. Recognize patterns.

**13:45-14:30** Lab Exercises 1-3
- **DO NOT LOOK AT SOLUTIONS**
- Spend 5 min per lab max
- If stuck > 5 min, mark as "tricky" and move on
- You'll come back to it

**14:30-15:15** Lab Exercises 4-5 + Pressure Scenario
- Lab 4 & 5 are harder
- Pressure scenario: Real production bug, you debug it
- This builds problem-solving muscle

**Checkpoint:** You can build queries without the guide

---

#### Evening Review (15:15-15:35) - Consolidate & Plan

**15:15-15:25** Recap Checklist
- Mark which items you can do confidently
- Mark which items are shaky

**15:25-15:35** Watch Video Segment
- Reinforce learning with different teaching style
- Catch nuances you missed reading

**15:35-16:00** Planning (optional)
- Plan tomorrow's weak topics
- Note gotchas in a personal notebook

**Checkpoint:** You can check off 80%+ of recap checklist

---

## 📝 Note-Taking Strategy

**Effective notes ≠ transcription of guide.**

### The Cornell Method (Modified for SQL)

```
┌─────────────────────────────────────────┐
│ TOPIC: Window Functions                 │
├──────────────┬──────────────────────────┤
│ Questions    │ Notes                    │
│              │                          │
│ What's the   │ ROW_NUMBER(): Assigns   │
│ difference   │ sequential number to    │
│ between      │ rows in partition.      │
│ ROW_NUMBER   │ Useful for "top N per   │
│ and RANK?    │ group"                  │
│              │                          │
│              │ RANK(): Assigns same    │
│              │ rank to tied values,    │
│              │ skips next rank         │
│              │                          │
│ When use     │ Example:                │
│ RANK vs      │ SELECT ROW_NUMBER()     │
│ DENSE_RANK?  │ OVER (PARTITION BY...)  │
└──────────────┴──────────────────────────┘
```

**Key principle:** Write questions on left, answers on right.
- Questions = active recall cues
- Answers = minimal (1-2 lines)
- Examples = always include

### What to Note

✅ **DO note:**
- Gotchas ("NULL in NOT IN returns no rows")
- Performance implications ("Index only scan = fast")
- Personal confusion ("HAVING vs WHERE takes me forever")
- Real examples from labs ("That query timed out, fixed by...")

❌ **DON'T note:**
- Entire guide verbatim
- Syntax (consult guide when needed)
- Things you understand deeply (don't help with recall)

---

## 🔬 How to Run Pressure Simulations

**Pressure scenarios are the most important part.** They train your debugging muscle.

### The Simulation Flow

**Step 1: Read Scenario (5 min)**
- Understand the problem statement
- Don't look at solution yet

**Step 2: Investigate (15 min)**
- Write SQL queries to diagnose
- Run EXPLAIN ANALYZE
- Check system views (pg_stats, etc.)
- **Goal:** Find root cause, not fix yet

**Step 3: Hypothesize (5 min)**
- What's causing the problem?
- Write your hypothesis in English
- **Example:** "CTE is materializing all 100M rows instead of filtering early"

**Step 4: Solve (10 min)**
- Write optimized SQL
- Explain why it's faster
- **Estimate:** How much faster? (2x, 10x, 100x)

**Step 5: Review Solution (5 min)**
- Compare your solution to provided solution
- **Celebrate:** Did you get it right?
- **Learn:** What different approach did they use?

**Total time:** 40 min per pressure scenario.

---

## 📊 Weekly Review Protocol

**Every Friday evening (15 min):**

### 1. Mastery Tracker Update (5 min)

```
Update your mastery tracker:
- Mark each topic 0-3
- Be honest (this is for you, not grades)
- Identify 3 weak topics for next week
```

### 2. Weak Spots Deep Dive (10 min)

```
For your 3 weakest topics:
- What confused you?
- What would help? (rewatch video, different example, etc.)
- When will you practice it? (schedule time)
```

**Example:**
```
Weak topic: Correlated subqueries
Why weak: Hard to understand N+1 execution
Help needed: More examples from different angles
Practice time: Monday 14:00, do 3 old labs again
```

### 3. Celebrate Progress

```
Write 1 thing you accomplished this week:
"I went from not understanding CTEs to writing multi-CTE queries!"

Write 1 insight you had:
"Window functions are just CTEs with row context"
```

---

## 🎯 Resource Guide

### Official Documentation (Bookmark These)

- **PostgreSQL Manual:** https://www.postgresql.org/docs/
  - Use for: Syntax reference, system views, performance tuning
  - Best for: Quick lookups, deep dives

- **Use The Index, Luke!** https://use-the-index-luke.com/
  - Use for: Understanding indexes, execution plans
  - Best for: Index performance deep dives

### Books

- **SQL Performance Explained** by Markus Winand
  - 200 pages, index-focused
  - Best: Fast read, practical

- **PostgreSQL 13 in 100 Steps** by Tobias Petik
  - 300 pages, practical
  - Best: Beginner-friendly, hands-on

### Videos (Beyond Bootcamp)

- **PostgreSQL Tutorial Playlist** (YouTube, PostgreSQL Official)
- **SQL Performance Tuning** (Udemy, various instructors)
- **Data Warehouse Design** (LinkedIn Learning)

### Practice Platforms

- **LeetCode SQL** (leetcode.com)
  - 400+ SQL problems, discuss forums
  - Best: Interview prep, variety

- **HackerRank SQL** (hackerrank.com)
  - Structured, good explanations
  - Best: Learning new concepts

- **Mode Analytics SQL Tutorial** (mode.com/sql-tutorial)
  - Free, clear explanations
  - Best: Supplementary learning

---

## 💪 Mindset for Success

### Embrace Struggle

```
Struggle = Learning

When a lab takes 30 min and you're frustrated:
  ✓ Your brain is growing
  ✓ You're building problem-solving skills
  ✓ This will feel easy in a week

DON'T:
  ✗ Give up after 5 min
  ✗ Look at solution immediately
  ✗ Rush through just to finish

DO:
  ✓ Spend 15+ min struggling (it's productive)
  ✓ Write partial solutions even if wrong
  ✓ Learn from mistakes (this is where growth happens)
```

### The Growth Curve

```
Day 1:  ███░░░░░░  30% confident
Day 3:  ████░░░░░  40% confident (dip: feeling overwhelmed)
Day 5:  ██████░░░  60% confident (breakthrough!)
Day 8:  ████████░  80% confident
Day 10: ██████████ 100% confident (in fundamentals)
```

**Days 3-4 are hard.** This is normal. Push through.

---

## 🎓 Study Tips & Hacks

### Pomodoro Technique (Modified)

```
Standard: 25 min work, 5 min break
SQL version: 45 min work, 15 min break

Why 45?
- SQL requires deep focus
- 25 is too short to get into flow
- 45 = 1 guide section or 2 lab exercises
```

### The Feynman Technique (Great for SQL)

```
1. Pick a concept (e.g., window functions)
2. Explain it in simple English as if teaching a 5-year-old
3. Identify gaps (where you get stuck)
4. Refine (look up only those gaps)
5. Simplify (remove jargon, use analogies)

Example:
"Window functions are like: you have a list of trips,
and for EACH trip, you also show the average fare
of all trips by that driver. But you still return
all original trips. It's like adding a column that
repeats per group."
```

### Build Muscle Memory

```
For complex syntax (CTEs, window functions):
- Type it 5 times without looking at guide
- Typos OK, rough syntax OK
- Goal: Your fingers remember the pattern
- Result: No mental load during interviews
```

### Teach Someone (Even Rubber Duck)

```
The rubber duck method:
1. Have a rubber duck (or any object) in front of you
2. Explain your SQL query to it line-by-line
3. Often, you'll realize your mistake mid-explanation
4. Works because: Explaining forces precision

Alternative: Explain to a friend (they don't need to understand)
```

---

## ⚠️ Common Pitfalls to Avoid

| Pitfall | Why Bad | Fix |
|---------|---------|-----|
| **Reading only, not coding** | SQL is skill, not knowledge | Code every exercise |
| **Looking at solutions too fast** | Robs you of learning | 15+ min before peeking |
| **Skipping pressure scenarios** | These build real skills | Always complete them |
| **Not using mastery tracker** | Can't see progress | Update after each day |
| **Memorizing syntax** | Won't work for unfamiliar queries | Understand patterns instead |
| **Studying all 10 days then reviewing** | Spacing = better retention | Review weekly, not at end |
| **Not using EXPLAIN ANALYZE** | Can't diagnose real problems | Use on every optimization lab |
| **Passive video watching** | Doesn't stick | Code along or pause to think |

---

## 🚀 Accelerated Path (If Time-Constrained)

**Can't do full 10 days?** Prioritize:

| Days | Focus | Skip |
|------|-------|------|
| 1-3 | SELECT, JOIN, GROUP BY (fundamentals) | None |
| 5 | Window functions (used everywhere) | Days 4 partially OK to skim |
| 6 | CTEs (essential for real SQL) | None |
| 8 | EXPLAIN ANALYZE (must understand optimization) | Detailed B-Tree theory OK to skip |
| 10 | Star schema (data warehouse pattern) | Fact/dimension OK to understand shallowly |

**Minimum viable bootcamp:** Days 1-3, 5, 6, 8, 10 = 6 days (fundamentals + real-world)

---

## ✅ Final Success Checklist

By end of bootcamp, you should be able to:

- [ ] Write 5-table JOIN without reference materials
- [ ] Explain window functions to a non-technical friend
- [ ] Read EXPLAIN output and suggest optimization
- [ ] Design a star schema for unknown business
- [ ] Debug slow query end-to-end
- [ ] Write CTE without syntax errors
- [ ] Explain NULL handling edge cases
- [ ] Discuss trade-offs (index cost vs query speed)
- [ ] Build complete data warehouse (Bronze → Gold)
- [ ] Teach someone else SQL concepts

**If you can do 8/10, you're ready for interviews.**

---

*Last updated: 13 March 2026 | Remember: Struggle is progress!*
