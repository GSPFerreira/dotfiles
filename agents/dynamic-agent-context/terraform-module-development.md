# Terraform Module Development Context

## Terraform Module Structure
```

module/
|-- 000-env.tf              # Provider configuration
├── 001-main.tf             # Primary resources
├── 002-variables.tf        # Input variables
├── 004-locals.tf           # Local variables
├── 006-data.tf             # Data sources
├── 999-outputs.tf          # Output values
├── moduleDefinition.json   # Terradocs module definition
├── .docs-footer.md         # Terradocs footer
├── .docs-header.md         # Terradocs header
└── DoD.md                  # Documentation for module intended functionality and usage
```

## Best Practices

- Use semantic versioning for module releases
- Define clear variable descriptions and types
- Use consistent naming conventions (snake_case)
- Use data sources instead of hardcoded values

## Development Workflow

1. Contextualize on the module purpose by reading the DoD.md, and fail the process if the file is not available.
2. Based on the provided context create the files moduleDefinition.json, .docs-footer.md, .docs-header.md.
3. Define base module structure, env.tf, main.tf, variables.tf, outputs.tf
4. Implement resources in main.tf
5. Add comprehensive examples
6. Use `terraform fmt` for formatting
7. Validate with `terraform validate`
8. Test with real infrastructure
