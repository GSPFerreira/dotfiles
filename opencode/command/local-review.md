---
description: Set up local environment for reviewing a colleague's branch
---

# Local Review

You are tasked with setting up a local review environment for a colleague's branch.

## Process

When invoked with a parameter like `gh_username:branchName`:

1. **Parse the input**:
   - Extract GitHub username and branch name from the format `username:branchname`
   - If no parameter provided, ask for it in the format: `gh_username:branchName`

2. **Extract reference information**:
   - Look for ticket numbers in the branch name (e.g., `issue-123`, `feat-456`)
   - Use this to create a descriptive local branch name
   - If no ticket found, use a sanitized version of the branch name

3. **Set up the remote and fetch the branch**:
   - Check if the remote already exists using `git remote -v`
   - If not, add it: `git remote add USERNAME https://github.com/USERNAME/REPO`
   - Fetch from the remote: `git fetch USERNAME`
   - Create local branch: `git checkout -b review/BRANCHNAME USERNAME/BRANCHNAME`

4. **Prepare the environment**:
   - Run any setup commands (install dependencies, etc.)
   - Note any setup failures but continue

5. **Provide review context**:
   - Show the recent commits on this branch
   - Show the diff from main/master
   - Suggest review focus areas

## Error Handling

- If branch already exists locally, inform the user they may need to delete it first
- If remote fetch fails, check if the username/repo exists
- If setup fails, provide the error but continue

## Example Usage

```
/local-review colleague:feature/new-login-flow
```

This will:
- Add 'colleague' as a remote (if needed)
- Fetch and create local branch `review/feature-new-login-flow`
- Set up the environment
- Show diff and commits for review context
