# Plan Command

You are about to start working on a task, but first you need to create a comprehensive planning document to gather all necessary information from the user.

## Task Description

The user wants to work on the following task:

```
{{ARGS}}
```

## Your Workflow

### Phase 1: Generate Planning Document

1. Analyze the task description to identify key decision points, uncertainties, and architectural choices
2. Create a planning document at `.claude/plan.md` with the following structure:

```markdown
# Planning Document: [Brief Task Title]

**Task:** [Restate the task description]

**Created:** [Current date]

---

## 🎯 Objective Clarification

> What is the primary goal of this task? What problem does it solve?

**Answer:** [FILL IN]

---

## 🏗️ Architecture & Design Decisions

### Question 1: [Specific architecture question]
> Context: [Why this matters]

**Options:**
- Option A: [Description]
- Option B: [Description]
- Other: [User can describe alternative]

**Preferred Approach:** [FILL IN]

**Rationale:** [FILL IN]

[Add more architecture questions as needed]

---

## 🛠️ Technical Stack & Dependencies

### Question: What technologies/libraries should be used?

**Required Technologies:**
- [Technology 1]: [FILL IN - version, specific library, etc.]
- [Technology 2]: [FILL IN]

**New Dependencies (if any):**
- [Dependency name]: [FILL IN - why needed, alternative considered]

---

## 📁 File Structure & Organization

### Question: Where should new files/modules be located?

**Proposed Structure:**
```
[FILL IN - directory structure]
```

**Rationale:** [FILL IN]

---

## 🔌 Integration Points

### Question: What existing systems/modules will this integrate with?

**Integration Points:**
1. [System/Module 1]: [FILL IN - how it integrates]
2. [System/Module 2]: [FILL IN - how it integrates]

**Potential Conflicts:** [FILL IN]

---

## 📊 Data Model & Schema

[Include this section only if relevant]

### Question: What data structures/models are needed?

**Schema:**
```
[FILL IN - data model, database schema, type definitions, etc.]
```

**Migrations Needed:** [FILL IN - yes/no, details]

---

## 🎨 User Interface & Experience

[Include this section only if UI is involved]

### Question: What should the user interface look like?

**UI Components:**
- [Component 1]: [FILL IN - description, behavior]
- [Component 2]: [FILL IN]

**User Flow:**
1. [FILL IN - step by step user interaction]

**Design Constraints:** [FILL IN - style guide, existing patterns to follow]

---

## ✅ Testing Strategy

### Question: How should this be tested?

**Testing Approach:**
- Unit tests: [FILL IN - what to test]
- Integration tests: [FILL IN - what to test]
- Manual testing: [FILL IN - what to verify]

**Edge Cases to Consider:**
1. [FILL IN]
2. [FILL IN]

---

## 🚀 Deployment & Rollout

[Include only if deployment is part of the task]

### Question: How should this be deployed?

**Deployment Strategy:** [FILL IN]

**Rollback Plan:** [FILL IN]

---

## 🎯 Success Criteria

### Question: How do we know this task is complete?

**Completion Checklist:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

**Performance Goals:** [FILL IN - if applicable]

---

## ❓ Open Questions & Concerns

**Uncertainties:**
1. [Question 1]: [FILL IN]
2. [Question 2]: [FILL IN]

**Risks & Mitigation:**
- Risk: [Description] → Mitigation: [FILL IN]

---

## 📝 Additional Notes

[Any other context, preferences, or considerations]

[FILL IN]

---

**Instructions:** Please fill in all `[FILL IN]` sections above. Remove any sections that are not relevant to this task. Add any additional questions or sections you think are important. When you're done, save this file and let me know so I can proceed with implementation.
```

3. **Customize the planning document** based on the specific task:
   - Add task-specific questions
   - Include relevant sections (remove UI section for backend tasks, etc.)
   - Add specific technical decision points based on the task complexity
   - Include any ambiguities or assumptions that need clarification

4. **Create the file** at `.claude/plan.md`

### Phase 2: Wait for User Input

After creating the planning document:

1. Tell the user:
   - Where the planning document is located (`.claude/plan.md`)
   - What they need to do (fill in all `[FILL IN]` sections)
   - How to let you know when they're done (just say "done" or "ready" or "I've filled it in")

2. **IMPORTANT:** Do NOT proceed with any implementation until the user confirms they've edited the file

3. Do NOT use the TodoWrite tool yet - we're still in the planning phase

### Phase 3: Read Plan and Execute

Once the user confirms they've edited the planning document:

1. Read the `.claude/plan.md` file
2. Verify all sections are filled in
3. If anything is missing or unclear, ask for clarification
4. Once you have a complete plan:
   - Use TodoWrite to create a comprehensive todo list based on the plan
   - Start implementation following the decisions made in the planning document
   - Reference the plan document throughout implementation to ensure alignment

## Important Guidelines

- **Be thorough but concise** - Don't create a 100-question document, focus on key decisions
- **Task-specific questions** - Tailor questions to the actual task, don't use generic templates blindly
- **Remove irrelevant sections** - If the task doesn't involve UI, don't ask UI questions
- **Identify ambiguities** - Pay special attention to areas where multiple valid approaches exist
- **Architecture over implementation** - Focus on high-level decisions, not minor details
- **User preferences** - Ask about preferences when multiple good options exist

## Example Questions to Consider

**For new features:**
- What's the primary use case?
- Who are the users?
- What existing patterns should we follow?
- What libraries/frameworks to use?
- Where does this fit in the codebase?

**For refactoring:**
- What are the current pain points?
- What's the desired end state?
- Can we do this incrementally?
- What's the backwards compatibility strategy?

**For bug fixes:**
- What's the expected behavior?
- What's the current behavior?
- Are there related bugs to fix?
- How to prevent regression?

**For optimization:**
- What are the performance goals?
- What are we optimizing for (speed, memory, size)?
- What's the acceptable trade-off?
- How to measure improvement?

---

Remember: The goal is to have a complete, unambiguous plan before writing any code. This prevents rework and ensures the implementation matches user expectations.
