# 🤝 Contributing to SQL Mastery Bootcamp

Thank you for considering contributing to this bootcamp! This project exists to make SQL education accessible, practical, and engineering-focused. Your contributions help us achieve that goal.

---

## 🎯 Types of Contributions Welcome

We actively welcome all of the following:

### 1. **New Exercises & Solutions**
- Additional practice problems for any day
- More complex, real-world scenarios
- Solutions with detailed explanations
- Edge cases and "gotcha" examples

### 2. **Bug Fixes & Clarifications**
- Typos, grammar, clarity improvements
- Factual errors in explanations
- Broken links or references
- Outdated PostgreSQL syntax

### 3. **Translations**
- Translate guides to other languages
- Translate exercises and solutions
- Translate AI mentor prompts
- Create new translations in language-specific folders

### 4. **Additional Day Guides or Supplements**
- Advanced topics (e.g., "Day 10.5: Replication & High Availability")
- Supplementary materials for struggling learners
- Interview prep guides
- Real-world case studies

### 5. **Improved Diagrams & Visuals**
- Visual explanations of JOIN algorithms
- Query plan visualizations
- Architecture diagrams
- Data modeling examples

### 6. **Better Resources & References**
- Links to PostgreSQL documentation
- Recommended reading lists
- Video recommendations
- Tool recommendations (with rationale)

### 7. **Feedback & Ideas**
- Tell us what's working (we love hearing this!)
- Tell us what's broken
- Suggest new topics or restructuring
- Share your learning experience

---

## 🚀 How to Contribute

### Step 1: Fork the Repository
```bash
# Click "Fork" on GitHub
# Then clone your fork
git clone https://github.com/YOUR-USERNAME/sql-mastery-bootcamp.git
cd sql-mastery-bootcamp
```

### Step 2: Create a Branch
```bash
# Use a descriptive branch name
git checkout -b add/day-3-join-exercises
# or
git checkout -b fix/day-1-typo
# or
git checkout -b enhance/ai-mentor-prompts
```

### Step 3: Make Your Changes

Follow the style guides below based on what you're contributing.

### Step 4: Commit with Clear Messages
```bash
git add .
git commit -m "Add 3 advanced JOIN exercises for Day 3"
# Good commit messages explain WHAT and WHY, not just WHAT
```

### Step 5: Push and Open a Pull Request
```bash
git push origin your-branch-name
# Then go to GitHub and open a PR
```

### Step 6: Respond to Feedback
We'll review your PR and might ask for changes. That's normal and collaborative!

---

## 📝 Style Guides

### SQL Style Guide

**Keywords:** Use UPPERCASE for SQL keywords
```sql
-- ✅ Good
SELECT user_id, created_at
FROM users
WHERE status = 'active'
ORDER BY created_at DESC;

-- ❌ Bad
select user_id, created_at from users where status = 'active' order by created_at desc;
```

**Indentation:** Use 2 spaces for indentation
```sql
-- ✅ Good
SELECT
  u.user_id,
  u.email,
  r.ride_count
FROM users u
LEFT JOIN rides r ON u.user_id = r.user_id
WHERE u.status = 'active';

-- ❌ Bad
SELECT u.user_id, u.email, r.ride_count FROM users u LEFT JOIN rides r ON u.user_id = r.user_id WHERE u.status = 'active';
```

**Comments:** Comment non-obvious logic
```sql
-- ✅ Good
SELECT
  user_id,
  -- Calculate days since last login; NULLs means never logged in
  CURRENT_DATE - last_login_date AS days_inactive
FROM users;

-- ❌ Bad
SELECT user_id, CURRENT_DATE - last_login_date FROM users;
```

**Naming:** Use snake_case, be descriptive
```sql
-- ✅ Good
SELECT
  ride_id,
  passenger_user_id,
  total_cost_cents
FROM rides;

-- ❌ Bad
SELECT id, uid, cost FROM r;
```

**Formatting:** Use meaningful line breaks
```sql
-- ✅ Good: Each clause is clear
SELECT u.user_id, COUNT(r.ride_id) AS ride_count
FROM users u
LEFT JOIN rides r ON u.user_id = r.user_id
WHERE u.status = 'active'
  AND u.created_at > CURRENT_DATE - INTERVAL '1 year'
GROUP BY u.user_id
HAVING COUNT(r.ride_id) > 10
ORDER BY ride_count DESC;
```

---

### Markdown Style Guide

**Headings:** Use `#` for H1, `##` for H2, etc. (not underlines)
```markdown
# Main Title
## Section
### Subsection
```

**Code Blocks:** Use triple backticks with language specified
````markdown
```sql
SELECT * FROM users;
```
````

**Tables:** Use pipes and dashes
```markdown
| Day | Topic | Duration |
|-----|-------|----------|
| 1   | SELECT | 1h 30min |
```

**Lists:** Use `-` for unordered, numbers for ordered
```markdown
- Item 1
- Item 2

1. First
2. Second
```

**Emphasis:** Use `**bold**` and `*italic*`, not `__bold__` or `_italic_`

**Links:** Use `[text](url)` format

**Emojis:** Use sparingly and meaningfully
```markdown
✅ Good
❌ Bad
🚀 Important
⏱️ Time-based
📚 Learning
```

---

### Exercise & Solution Format

When adding exercises, follow this format:

```markdown
## Exercise 5: [Clear Title]

**Difficulty:** Intermediate
**Time:** 15-20 minutes
**Topics:** JOINs, aggregates, window functions

**Scenario:**
[1-2 sentences describing the business problem]

**Data Context:**
[If not using the standard schema, describe the tables/columns needed]

**Your Task:**
[1-3 bullet points describing what to write]

**Hints (Optional):**
- [Hint 1]
- [Hint 2]

---

**Solution:**

```sql
[Annotated solution with comments explaining the "why"]
```

**Explanation:**
[1-2 paragraphs explaining the approach, why it works, performance considerations]

**Follow-Up Questions:**
1. How would this query perform with 100M rows?
2. What index would help this query?
3. Can you rewrite this without a subquery?
```

---

### AI Mentor Prompt Format

When adding new prompts, follow this format:

````markdown
### [Situation Name]

```
[Clear, conversational prompt for the AI]
[Explain the context: what's happening, what does the student need]
[Include any specific PostgreSQL version or configuration context]
```

**Rationale:** Why this prompt is useful, what problem it solves.
````

---

## 📋 Code of Conduct

### Our Commitment

This bootcamp is built on respect and inclusion. We are committed to providing a safe learning environment for everyone, regardless of:
- Experience level or background
- Identity, experience, or perspective
- Age, race, gender, sexual orientation, disability, religion, or any other characteristic

### Expected Behavior

- **Be respectful** — Treat everyone with kindness, even in disagreement
- **Be inclusive** — Welcome questions from beginners without judgment
- **Be constructive** — Feedback should help, not hurt
- **Be honest** — If you made a mistake, acknowledge it and fix it
- **Be patient** — Teaching takes time; learning takes time

### Unacceptable Behavior

- Harassment, discrimination, or intimidation
- Personal attacks or insults
- Unsolicited advice on someone's appearance or identity
- Publishing private information without permission
- Behavior that creates an unsafe learning environment

### Reporting Issues

If you witness or experience unacceptable behavior, please report it to the maintainers. All reports will be handled with confidentiality and care.

---

## 🔍 PR Review Process

### What We Look For

1. **Clarity** — Is the contribution clear and well-explained?
2. **Correctness** — Is the SQL correct? Are explanations accurate?
3. **Alignment** — Does it fit the bootcamp's goals and structure?
4. **Quality** — Does it meet the style guides above?
5. **Completeness** — For exercises: is there a solution? For fixes: is it thorough?

### What Happens Next

1. We review your PR within 7 days (usually faster)
2. We might ask questions or request changes
3. We'll discuss the best approach if there are multiple options
4. Once approved, we'll merge and credit you
5. Your contribution goes live in the next bootcamp cycle

---

## 💡 Examples of Strong Contributions

### Example 1: New Exercise
```
Title: "Add 3 advanced window function exercises for Day 5"
Description: "These exercises cover LAG/LEAD with PARTITION BY, 
which students often struggle with. Includes a real-world scenario 
(calculating ride duration percentiles)."
Files: day-05-aggregates-window/exercises.sql, solutions.sql
```

### Example 2: Bug Fix
```
Title: "Fix typo in Day 3 guide and clarify LEFT JOIN behavior"
Description: "Found 'Lef Join' (should be 'LEFT JOIN'). Also clarified 
that LEFT JOIN returns NULL for unmatched right table rows, with an example."
Files: day-03-joins/guide.md
```

### Example 3: New Feature
```
Title: "Add PostgreSQL 16 performance tips supplement"
Description: "New file covering MERGE statement and other PostgreSQL 16 
improvements relevant to the bootcamp. Includes migration path for PG 15."
Files: docs/postgres-16-supplement.md
```

---

## ❓ Questions?

- **How do I report a bug?** Open an issue (use the bug template)
- **Can I add a whole new day?** Probably! Open an issue first to discuss scope
- **Can I translate the bootcamp?** Yes! We love translations. Coordinate in an issue first
- **I want to improve the pedagogy** — Great! Open an issue to discuss approach before investing time
- **Can I use this for my own course?** Yes! The MIT license allows it. Just credit the original (as required by the license)

---

## 🙏 Thank You

Whether you fix a typo or contribute a new section, you're helping future learners. Every contribution matters. We appreciate you!

**Welcome to the community. Let's make SQL education better together.** ❤️

---

## 📖 Additional Resources

- [GitHub Forking Guide](https://guides.github.com/activities/forking/)
- [How to Write Good Commit Messages](https://www.freecodecamp.org/news/how-to-write-good-commit-messages-with-commitizen/)
- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [Markdown Guide](https://www.markdownguide.org/)

---

**Ready to contribute? Pick an issue, make a branch, and submit a PR. We're excited to see what you create!** 🚀
