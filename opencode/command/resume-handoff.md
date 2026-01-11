---
description: Resume work from a handoff document
---

# Resume Handoff

You are tasked with resuming work from a handoff document. These documents contain critical context, learnings, and next steps from previous sessions.

## Initial Response

When this command is invoked:

1. **If a handoff document path was provided**:
   - Read the handoff document FULLY
   - Read any referenced plan or research documents
   - Begin the analysis process
   - Propose a course of action and confirm with user

2. **If no path provided**:
   ```
   I'll help you resume work from a handoff document.

   Please provide the path to the handoff file.

   Tip: You can invoke this command directly: `/resume-handoff path/to/handoff.md`
   ```

## Process Steps

### Step 1: Read and Analyze Handoff

1. **Read handoff document completely** and extract:
   - Task(s) and their statuses
   - Recent changes
   - Learnings
   - Artifacts
   - Action items and next steps
   - Other notes

2. **Use @explore to verify current state**:
   - Check that referenced files still exist
   - Verify recent changes are still present
   - Look for any new changes since handoff

3. **Read critical files identified** in the handoff

### Step 2: Synthesize and Present Analysis

Present comprehensive analysis:

```
I've analyzed the handoff from [date]. Here's the current situation:

**Original Tasks:**
- [Task 1]: [Status from handoff] → [Current verification]
- [Task 2]: [Status from handoff] → [Current verification]

**Key Learnings Validated:**
- [Learning with file:line reference] - [Still valid/Changed]

**Recent Changes Status:**
- [Change 1] - [Verified present/Missing/Modified]

**Artifacts Reviewed:**
- [Document 1]: [Key takeaway]

**Recommended Next Actions:**
1. [Most logical next step]
2. [Second priority action]

**Potential Issues Identified:**
- [Any conflicts or regressions found]

Shall I proceed with [recommended action 1], or would you like to adjust the approach?
```

### Step 3: Create Action Plan

1. **Use TodoWrite to create task list**:
   - Convert action items from handoff into todos
   - Add any new tasks discovered during analysis
   - Prioritize based on dependencies

2. **Get confirmation** before beginning implementation

### Step 4: Begin Implementation

1. **Start with the first approved task**
2. **Reference learnings from handoff** throughout
3. **Apply patterns and approaches** documented in handoff
4. **Update progress** as tasks are completed

## Guidelines

1. **Be Thorough in Analysis**:
   - Read the entire handoff document first
   - Verify ALL mentioned changes still exist
   - Check for any regressions or conflicts

2. **Be Interactive**:
   - Present findings before starting work
   - Get buy-in on the approach
   - Allow for course corrections

3. **Leverage Handoff Wisdom**:
   - Pay special attention to "Learnings" section
   - Apply documented patterns
   - Avoid repeating mentioned mistakes

4. **Track Continuity**:
   - Use TodoWrite to maintain task continuity
   - Document any deviations from original plan
   - Consider creating a new handoff when done

5. **Validate Before Acting**:
   - Never assume handoff state matches current state
   - Verify all file references still exist
   - Check for breaking changes since handoff
