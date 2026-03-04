---
name: Feature Request
about: Suggest an idea to improve SQL Mastery Bootcamp
title: "[FEATURE] "
labels: enhancement
assignees: ''

---

## 💡 Feature Description

**What would you like to see?**
[Describe the feature or improvement you're suggesting]

---

## 🎯 Type of Feature

- [ ] **New exercises** - additional practice problems
- [ ] **New content** - additional day guide or supplementary material
- [ ] **Improved explanation** - better way to teach existing concept
- [ ] **New tool/resource** - tool, template, or resource to help learning
- [ ] **Translation** - translate existing content to another language
- [ ] **Enhancement** - improve existing feature (e.g., better formatting, more examples)
- [ ] **Supplementary material** - interview prep, glossary entries, video recommendations, etc.
- [ ] **Other:** _______________

---

## 🔍 Which Day(s) Does This Affect?

- [ ] General (README, setup, overall structure)
- [ ] Day 1: SQL Foundations & SELECT
- [ ] Day 2: DDL/DML/Filtering
- [ ] Day 3: Joins
- [ ] Day 4: Functions, NULL, CASE
- [ ] Day 5: Aggregates & Window Functions
- [ ] Day 6: Subqueries & CTEs
- [ ] Day 7: Views, Procedures, Triggers
- [ ] Day 8: Indexes & Execution Plans
- [ ] Day 9: Partitions & Performance
- [ ] Day 10: DWH Design & Project
- [ ] Multiple days (specify): _______________

---

## 📚 Problem Statement

**What problem does this solve?**
[Describe the problem a learner faces that this feature would address]

**Example:** "Students struggle with understanding join algorithms. A visual diagram would help explain NESTED LOOP vs. HASH JOIN."

---

## 💬 Proposed Solution

**How should this feature work?**
[Describe your idea in detail]

**Example:**
```
Add a new subsection "Join Algorithms Visualized" to Day 3 guide with:
- Diagram showing NESTED LOOP algorithm (nested iterations)
- Diagram showing HASH JOIN algorithm (hash table lookup)
- Diagram showing MERGE JOIN algorithm (sorted merge)
- Performance comparison table
```

---

## 📋 Implementation Details

**If you have suggestions on how to implement this:**

- **Format:** [e.g., markdown guide, SQL file, diagram, video, etc.]
- **Location:** [e.g., which file or folder]
- **Effort:** [Rough estimate: small, medium, large]
- **Dependencies:** [Does this require other changes first?]

---

## 🎓 Learning Impact

**How would this help learners?**
- [ ] Clarifies a confusing concept
- [ ] Provides more practice on a topic
- [ ] Makes content more engaging
- [ ] Covers a gap in the curriculum
- [ ] Prepares better for interviews
- [ ] Applies to real-world work
- [ ] Other: _______________

**Estimated impact:** [Small, Medium, Large]

---

## 🚀 Example or Mock-Up

[If possible, provide an example or mock-up of what this would look like]

**Example:**
```sql
-- Exercise: Calculate the 95th percentile of ride duration by city
-- This would test understanding of window functions + percentile functions
SELECT
  city,
  PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY duration_minutes) AS p95_duration
FROM rides
GROUP BY city;
```

---

## 🔗 Related Issues or Resources

[Link to related issues, documentation, or resources that might be helpful]

**Example:**
- Related to #42 (request for window function exercises)
- PostgreSQL docs: https://www.postgresql.org/docs/15/functions-window.html
- Student feedback: "I'd like more complex practice"

---

## 👥 Who Would Benefit?

- [ ] Beginners (no SQL experience)
- [ ] Intermediate learners (some SQL, learning engineering concepts)
- [ ] Advanced learners (preparing for interviews or advanced topics)
- [ ] Instructors (using the bootcamp to teach others)
- [ ] All learners

---

## ⏱️ Priority

**How important is this feature?**
- [ ] **Nice to have** - Would improve experience but not critical
- [ ] **Important** - Significant improvement; should be prioritized
- [ ] **Critical** - Addresses a major gap or issue; should be done ASAP

---

## 📝 Additional Context

[Any other information that would help evaluate this feature request?]

**Examples:**
- Student feedback you've received
- Real-world relevance
- How this compares to other SQL learning resources
- Your experience with this topic

---

## 🤝 Can You Contribute?

Would you be interested in helping implement this feature?

- [ ] Yes, I can write the content
- [ ] Yes, I can create diagrams/visuals
- [ ] Yes, I can write SQL examples
- [ ] Yes, I can help in another way: _______________
- [ ] No, but I'd love to see someone else work on it

---

## 📧 Contact

[If you'd like us to reach out with questions or updates, provide your contact info]

- Discord: [optional]
- Email: [optional]
- Twitter: [optional]

---

**Thank you for helping improve SQL Mastery Bootcamp!** ❤️

We review feature requests regularly and prioritize based on learning impact, community interest, and available resources.
