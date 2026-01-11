---
description: Generate comprehensive PR descriptions
---

# Generate PR Description

You are tasked with generating a comprehensive pull request description.

## Steps to follow:

1. **Identify the PR to describe:**
   - Check if the current branch has an associated PR: `gh pr view --json url,number,title,state 2>/dev/null`
   - If no PR exists for the current branch, or if on main/master, list open PRs: `gh pr list --limit 10 --json number,title,headRefName,author`
   - Ask the user which PR they want to describe

2. **Gather comprehensive PR information:**
   - Get the full PR diff: `gh pr diff {number}`
   - If you get an error about no default remote repository, instruct the user to run `gh repo set-default` and select the appropriate repository
   - Get commit history: `gh pr view {number} --json commits`
   - Review the base branch: `gh pr view {number} --json baseRefName`
   - Get PR metadata: `gh pr view {number} --json url,title,number,state`

3. **Analyze the changes thoroughly:**
   - Read through the entire diff carefully
   - For context, read any files that are referenced but not shown in the diff
   - Understand the purpose and impact of each change
   - Identify user-facing changes vs internal implementation details
   - Look for breaking changes or migration requirements

4. **Handle verification requirements:**
   - For each verification step:
     - If it's a command you can run (like `make check test`, `npm test`, etc.), run it
     - If it passes, mark the checkbox as checked: `- [x]`
     - If it fails, keep it unchecked and note what failed: `- [ ]` with explanation
     - If it requires manual testing (UI interactions, external services), leave unchecked and note for user
   - Document any verification steps you couldn't complete

5. **Generate the description using this template:**

```md
## What problem(s) was I solving?

[Describe the problem or feature request]

## What user-facing changes did I ship?

[List user-visible changes]

## How I implemented it

[Technical implementation details]

## How to verify it

### Automated Testing
- [ ] Tests pass: `[test command]`
- [ ] Linting passes: `[lint command]`

### Manual Testing
- [ ] [Manual verification step]
```

6. **Update the PR:**
   - Save the description to a temp file
   - Update the PR description directly: `gh pr edit {number} --body-file /tmp/pr_description.md`
   - Confirm the update was successful
   - If any verification steps remain unchecked, remind the user to complete them before merging

## Important notes:
- Be thorough but concise - descriptions should be scannable
- Focus on the "why" as much as the "what"
- Include any breaking changes or migration notes prominently
- If the PR touches multiple components, organize the description accordingly
- Always attempt to run verification commands when possible
- Clearly communicate which verification steps need manual testing
