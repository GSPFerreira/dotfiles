# Go Development Guidelines

## Quick Reference

- Build: `make build`
- Test: `make test`
- Lint: `make lint`
- Run: `make run`

## Context Loading Instructions

**IMPORTANT**: Only load the following reference files when needed for the current task.

### Available References

[project-structure](./go/project-structure.md) - Directory layout and package organization
[commands ](../go/commands.md) - Full command reference for build, test, deploy
[code-style](../go/code-style.md) - Go conventions, patterns, and best practices
[testing](../go/testing.md) - Testing strategies, patterns, and requirements
[database](./go/database.md) - Database patterns, migrations, and conventions
[api](./go/api.md) - API design, REST/gRPC guidelines
[dependencies](./go/dependencies.md) - Approved libraries and dependency management
[git-workflow](./go/git-workflow.md) - Git conventions and PR process
[troubleshooting](./go/troubleshooting.md) - Common issues and gotchas


### Task-Specific Loading

- For writing new code: Load @code-style and @project-structure
- For testing: Load @testing and @commands
- For API work: Load @api and @code-style
- For database changes: Load @database and @testing
- For debugging: Load @troubleshooting and @project-structure

## Critical Rules (Always Active)

1. Never use global variables
2. Always handle errors explicitly  
3. Use context.Context for cancellation
4. Close all resources (files, connections)
7. Run `make lint` before committing
