---
description: Create handoff document for transferring work to another session
---

# Create Handoff

You are tasked with writing a handoff document to transfer your work context to another session. Create a thorough but **concise** document that captures key details without losing important context.

## Process

### 1. Gather Context

Before writing the handoff:
- Review what was accomplished in this session
- Run `git status` and `git log --oneline -5` to understand current state
- Identify any in-progress work
- Note important learnings and discoveries

### 2. Create the Handoff Document

Write the document to a location the user specifies, or suggest:
- `.handoffs/YYYY-MM-DD_HH-MM_description.md`

Use this template:

```markdown
---
date: [Current date and time]
branch: [Current branch name]
commit: [Current commit hash]
---

# Handoff: [Brief description]

## Task(s)
[Description of the task(s) with status of each: completed, in progress, or planned]

## Critical References
[2-3 most important file paths or documents that must be followed]

## Recent Changes
[List recent changes made in file:line format]

## Learnings
[Important discoveries - patterns, root causes, things someone picking up this work should know]

## Artifacts
[Exhaustive list of files produced or updated as file paths]

## Action Items & Next Steps
[List of what needs to be done next]

## Other Notes
[Additional context, references, or useful information]
```

### 3. Guidelines

- **More information, not less** - This template is a minimum
- **Be thorough and precise** - Include both high-level objectives and implementation details
- **Avoid excessive code snippets** - Prefer `path/to/file.ext:line` references
- **Focus on "why"** - Explain reasoning behind decisions

## Response

After creating the handoff, respond with:

```
Handoff created! You can resume from this handoff in a new session with:

/resume-handoff path/to/handoff.md
```
