# 🚀 Getting Started with SQL Mastery Bootcamp

Welcome! This guide walks you through everything you need to know to succeed in the bootcamp. Read this once (takes ~10 minutes), then refer back as needed.

---

## ✅ Prerequisites

**You need:**
- A web browser (Chrome, Firefox, Safari, Edge - anything modern)
- 5-10 hours per day for 10 days
- A willingness to struggle through hard problems (struggle = learning)

**You do NOT need:**
- Any existing SQL knowledge
- A local PostgreSQL installation
- Any fancy tools or paid subscriptions
- A specific operating system

Everything is browser-based. You'll use **DB Fiddle**, a free online SQL editor. That's it.

---

## 📖 How to Use This Bootcamp

### The Daily Workflow

Each morning, follow this routine (takes ~5 hours 10 minutes total):

1. **Open your calendar** - check which day you're on
2. **Open the day guide** - e.g., `day-01-foundations/guide.md`
3. **Activate your AI mentor** - paste the day's prompt (see below)
4. **Watch the video** - follow timestamps in the guide
5. **Read the guide** - it explains concepts and teaches you how to think
6. **Do the exercises** - use DB Fiddle to write SQL
7. **Face the pressure scenario** - solve a real-world problem
8. **Reflect** - review your solutions, update your mastery tracker

### Time Breakdown

- **Morning Theory** (1h 30min) - Watch video + read guide
- **Guided Practice** (1h 20min) - Follow along with provided schemas
- **Independent Exercises** (1h 00min) - Solve 3-5 problems from the exercise file
- **Pressure Simulation** (0h 45min) - Diagnose and fix the scenario
- **Reflection** (0h 35min) - Review, take notes, track progress

---

## 🌐 How to Use DB Fiddle

DB Fiddle is a free online SQL editor where you run SQL against a live PostgreSQL database. No installation needed.

### Setup (one time, takes 2 minutes)

1. Go to **https://www.db-fiddle.com/**
2. In the **Database Version** dropdown (top left), select **PostgreSQL 15**
3. In the left panel, paste the schema from `00-setup/db-fiddle-setup.sql`
4. Click **Run** - you'll see the schema created
5. In the right panel, paste your SQL query
6. Click **Run** - you'll see your results

### Daily Workflow in DB Fiddle

- **Left panel (Schema):** Stays the same all day (don't touch it)
- **Right panel (Query):** Where you write and test your SQL
- **Results:** Shows rows returned, execution time, and any errors
- **Copy/Paste:** Use this for all exercises and pressure scenarios

### Pro Tips

- The database resets every time you refresh the page
- Save your solutions locally (copy/paste into a text editor)
- If you mess up the schema, just refresh the page and paste again
- You can't hurt anything in DB Fiddle - experiment freely!

---

## 🤖 How to Use AI as Your Mentor

The bootcamp includes **AI Mentor Prompts** - detailed instructions for Claude, ChatGPT, Gemini, or any capable AI to act as your personal SQL coach.

### Setup (one time, takes 3 minutes)

1. Open `00-setup/ai-mentor-prompts.md`
2. Copy the **MASTER SYSTEM PROMPT** section (the big one)
3. Go to your AI of choice (Claude.ai, ChatGPT, or Gemini)
4. Start a new conversation
5. Paste the master prompt - this sets up the AI as your coach
6. Hit Enter and wait for the AI to acknowledge

### Daily Use (takes 2 minutes)

1. At the start of each day, copy the **DAILY MORNING PROMPT** for that day
2. Paste it into the same conversation with your AI mentor
3. The AI will set up the day's topic, video timestamps, and pressure scenario
4. Describe your solution or problem; the AI gives Socratic feedback
5. At the end, the AI scores you out of 10 on mastery

### Why This Works

- **Socratic Method** - The AI asks you questions instead of giving answers, forcing you to think
- **Real-Time Feedback** - No waiting for a forum post; you get instant coaching
- **Pressure Simulation** - The AI won't let you skip the hard parts; it enforces the pressure scenario
- **Personalized Pace** - You can ask clarifying questions; the AI adapts to your understanding
- **Motivation** - A daily score (out of 10) creates healthy accountability

### What NOT to Do

- Don't just ask the AI for answers (defeats the purpose)
- Don't skip the pressure scenario because it's hard
- Don't use the AI before attempting exercises yourself
- Don't treat it as a replacement for actually writing SQL

---

## 📚 How to Use the Study Kit

The bootcamp provides 12 components. Here's what each does:

1. **Daily Guides** - Read at the start of each day (explains concepts, builds intuition)
2. **Video Lectures** - Watch alongside the guide (see timestamps in each guide)
3. **Exercise Sets** - Do these to practice (3-5 exercises per day)
4. **Annotated Solutions** - Review after you attempt the exercises (explains the "why")
5. **Pressure Scenarios** - Real-world problems to diagnose and fix
6. **DB Fiddle Schemas** - Pre-built tables ready to paste
7. **AI Mentor Prompts** - Use these with Claude/ChatGPT/Gemini
8. **Glossary** - Look up unfamiliar terms (linked in guides)
9. **PostgreSQL Reference** - Version-specific features and best practices
10. **Mastery Tracker** - Self-assessment template (see section below)
11. **Issue Templates** - How to report bugs or request features
12. **Contributing Guide** - How to improve the bootcamp

---

## 📊 Mastery Tracker

Use this to track your progress through the bootcamp. Copy this into a text file or spreadsheet and update it daily.

```
MASTERY TRACKER - SQL Bootcamp (10 Days)

Day 1: SQL Foundations & SELECT
  ☐ Watched video (1h 30min)
  ☐ Understood SELECT, WHERE, ORDER BY
  ☐ Completed exercises 1-5
  ☐ Solved pressure scenario
  ☐ Self-score: __/10
  ☐ Notes: _____________________________________

Day 2: DDL/DML/Filtering
  ☐ Watched video
  ☐ Understood CREATE TABLE, INSERT, UPDATE, DELETE
  ☐ Completed exercises 1-5
  ☐ Solved pressure scenario
  ☐ Self-score: __/10
  ☐ Notes: _____________________________________

[Continue for all 10 days]

FINAL REVIEW (after Day 10):
  ☐ Completed ride-sharing database project
  ☐ Can explain execution plans
  ☐ Understand indexes and partitioning
  ☐ Ready for SQL interviews
  ☐ Overall mastery: __/100
```

---

## 📋 Daily Routine (Sample: Day 1)

Here's what an ideal day looks like:

### 8:00 AM - Start Fresh
- Open your browser
- Open `day-01-foundations/guide.md`
- Open `00-setup/ai-mentor-prompts.md`

### 8:10 AM - Activate Your AI Coach
- Go to Claude/ChatGPT/Gemini
- Paste the **MASTER SYSTEM PROMPT**
- Wait for acknowledgment (~2 min)
- Paste the **Day 1 Morning Prompt**
- Tell the AI: "I'm starting Day 1. Let's begin."

### 8:15 AM - Watch & Read (1h 30min)
- Watch the video (00:00-01:32:31)
- Follow along with the guide
- Take notes on key concepts
- Pause and re-watch confusing parts

### 9:45 AM - Guided Practice (1h 20min)
- Go to DB Fiddle
- Paste the Day 1 schema
- Follow the "Guided Practice" section in the guide
- Write SQL alongside the guide
- Run queries and see results

### 11:05 AM - Independent Exercises (1h)
- Look at exercises 1-5 in `day-01-foundations/exercises.sql`
- Write your own SQL without looking at solutions
- Test each one in DB Fiddle
- If stuck, ask your AI mentor (don't jump to solutions)

### 12:05 PM - Lunch Break (or break)
- Step away for 30 min
- Clear your head

### 12:35 PM - Pressure Scenario (45 min)
- Read `day-01-foundations/pressure-scenario.md`
- This describes a real-world problem (e.g., slow primary key lookup)
- Use your new SQL knowledge to diagnose and fix it
- Describe your solution to your AI mentor
- Let the AI score you out of 10

### 1:20 PM - Reflect (35 min)
- Review your exercises and solutions
- Read the annotated solutions in `day-01-foundations/solutions.sql`
- Update your mastery tracker
- Write down 1-2 insights you gained
- Note any concepts to review tomorrow

### 1:55 PM - Done ✅
- You're finished for the day
- Rest, exercise, spend time with family
- Come back tomorrow ready to learn

---

## 💪 Tips for Success

### 1. Struggle is Good
If an exercise takes 30 minutes, that's **not** a problem - that's learning. Struggle builds memory and intuition. Embrace it.

### 2. Don't Skip the Pressure Scenario
The pressure scenario is the most important part. It's where you apply what you learned to a real problem. Do it every day.

### 3. Use Your AI Mentor Wisely
- **Good:** "I tried this query but got 0 rows. What am I missing?"
- **Bad:** "Can you write the query for me?"

The AI is there to guide your thinking, not do the thinking for you.

### 4. Read the Solutions (After Attempting)
Don't jump to solutions. Attempt each exercise first. Then read the annotated solution to understand the "why."

### 5. Take Detailed Notes
SQL is a language. You wouldn't learn Spanish by passively watching videos. Take notes. Write examples. Build a personal reference.

### 6. Relate to Real Work
Every concept in this bootcamp applies to real databases you'll work with. Ask yourself: "When would I use this? What problem does this solve?"

---

## ❌ What to Do If You Miss a Day

Life happens. You might miss a day (or several). Here's how to handle it:

### Option 1: Catch Up the Next Day
- Do the missed day + the current day (takes 10 hours)
- Not ideal but doable if you have flexibility

### Option 2: Skip the Missed Day
- Move forward with the current day
- Most days are independent (you don't need Day 3 to do Day 4)
- Some days build on each other (e.g., Day 8 builds on Days 1-7)
- Check the guide to see dependencies

### Option 3: Extend the Bootcamp
- Spend 14-15 days instead of 10
- Give yourself grace and catch up at your own pace
- Better to learn thoroughly than rush

### Option 4: Review Later
- Do the bootcamp quickly without pressure scenarios
- Circle back after a few weeks for pressure scenarios
- Less ideal, but better than abandoning it

**Our recommendation:** Don't miss days, but if you do, keep moving forward. Momentum > perfection.

---

## 📈 How to Track Progress

### Daily Self-Assessment
At the end of each day, ask yourself:
- Can I write a SELECT query with WHERE and ORDER BY?
- Can I explain why this index helps that query?
- Can I solve the pressure scenario?
- What did I learn today?

### Weekly Checkpoints
- After Day 5: Can you write JOIN queries and basic aggregates?
- After Day 10: Can you architect a database and optimize queries?

### Final Project Review
- By Day 10, you'll have designed an Uber-style ride-sharing database
- Can you explain every table, index, and query?
- Can you handle the production debugging scenario?

### Are You Ready for Real Work?
After Day 10, you should be able to:
- Write complex SQL without hesitation
- Read and understand EXPLAIN output
- Design tables and indexes for performance
- Know when to use a subquery vs. a CTE
- Troubleshoot production database issues

---

## 🆘 Troubleshooting

### "I'm stuck on an exercise"
- Read the guide again (key insight might be there)
- Ask your AI mentor Socratically: "What does this error mean?"
- Look at a similar solved exercise
- Skip it and come back tomorrow (fresh eyes help)

### "DB Fiddle isn't working"
- Refresh the page
- Clear your browser cache
- Try a different browser
- Check your PostgreSQL syntax (maybe you have a typo)

### "The pressure scenario seems impossible"
- It's not. You have all the tools you need
- Start by stating what you know
- Ask your AI mentor: "What am I missing?"
- Sometimes the answer is "this database design is bad" - that's a valid insight

### "I'm falling behind"
- It's okay. This isn't a race
- You can complete the bootcamp at your own pace
- Some days take 7 hours; some take 12
- Extend the 10 days to 14-15 if needed

### "I'm not understanding concept X"
- Watch the video again (different explanation might click)
- Read the glossary
- Ask your AI mentor to explain it differently
- Search PostgreSQL official docs
- Sometimes you just need to sleep on it

---

## 🎯 Your First Steps (Right Now)

1. ✅ You're reading this guide (good job!)
2. ⏭️ **Next:** Go to DB Fiddle and test it out (2 min)
3. ⏭️ **Then:** Read `day-01-foundations/guide.md` to understand Day 1
4. ⏭️ **Then:** Set up your AI mentor (3 min)
5. ⏭️ **Then:** Tomorrow morning, start Day 1 for real

---

## 📞 Need Help?

- **Stuck on a concept?** Read the glossary or ask your AI mentor
- **Found a bug in the materials?** Open an issue on GitHub
- **Have an idea for improvement?** Submit a PR (see CONTRIBUTING.md)
- **Want to contribute?** See CONTRIBUTING.md

---

**Ready? [Start Day 1 →](../day-01-foundations/guide.md)**
