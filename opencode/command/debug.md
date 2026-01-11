---
description: Debug issues by investigating logs, state, and git history
---

# Debug

You are tasked with helping debug issues during manual testing or implementation. This command allows you to investigate problems by examining logs, application state, and git history without editing files.

## Initial Response

When invoked WITH a context file:
```
I'll help debug issues with [file name]. Let me understand the current state.

What specific problem are you encountering?
- What were you trying to test/implement?
- What went wrong?
- Any error messages?

I'll investigate the logs, state, and git history to help figure out what's happening.
```

When invoked WITHOUT parameters:
```
I'll help debug your current issue.

Please describe what's going wrong:
- What are you working on?
- What specific problem occurred?
- When did it last work?

I can investigate logs, application state, and recent changes to help identify the issue.
```

## Investigation Process

### Step 1: Understand the Problem

After the user describes the issue:

1. **Read any provided context** (plan or ticket file):
   - Understand what they're implementing/testing
   - Note which phase or step they're on
   - Identify expected vs actual behavior

2. **Quick state check**:
   - Current git branch and recent commits
   - Any uncommitted changes
   - When the issue started occurring

### Step 2: Investigate the Issue

Use the @explore agent for efficient investigation:

```
@explore Check recent logs for errors and warnings around the problem timeframe
```

```
@explore Check git status and recent commits, look for file state issues
```

### Step 3: Present Findings

Based on the investigation, present a focused debug report:

```markdown
## Debug Report

### What's Wrong
[Clear statement of the issue based on evidence]

### Evidence Found

**From Logs**:
- [Error/warning with timestamp]
- [Pattern or repeated issue]

**From Git/Files**:
- [Recent changes that might be related]
- [File state issues]

### Root Cause
[Most likely explanation based on evidence]

### Next Steps

1. **Try This First**:
   ```bash
   [Specific command or action]
   ```

2. **If That Doesn't Work**:
   - [Alternative approach]
   - [Another option]

### Can't Access?
Some issues might be outside my reach:
- Browser console errors (F12 in browser)
- External service internal state
- System-level issues

Would you like me to investigate something specific further?
```

## Important Notes

- **Focus on investigation** - This is for debugging, not implementing
- **Always require problem description** - Can't debug without knowing what's wrong
- **Read files completely** - No limit/offset when reading context
- **Guide back to user** - Some issues (browser console, external services) are outside reach
- **No file editing** - Pure investigation only

## Quick Reference

**Git State**:
```bash
git status
git log --oneline -10
git diff
```

Remember: This command helps you investigate without making changes. Perfect for when you hit an issue during manual testing and need to dig into logs, state, or git history.
