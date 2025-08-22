# Terraform Module Testing Context

## Testing Approaches
1. **Static Analysis**: `terraform validate`, `terraform plan`
2. **Unit Testing**: Terratest, terraform-compliance
3. **Integration Testing**: Deploy to test environment
4. **Policy Testing**: Open Policy Agent (OPA) with Conftest

## Terratest Framework
```go
func TestTerraformModule(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../examples/complete",
        Vars: map[string]interface{}{
            "name": "test-" + strings.ToLower(random.UniqueId()),
        },
    }
    
    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)
    
    // Test outputs
    output := terraform.Output(t, terraformOptions, "id")
    assert.NotEmpty(t, output)
}
```

## Testing Commands
- `terraform fmt -check` - Check formatting
- `terraform validate` - Validate syntax
- `terraform plan` - Preview changes
- `tflint` - Linting (if available)
- `checkov` - Security scanning (if available)

## Test Structure
```
tests/
├── terraform_test.go
├── go.mod
└── go.sum
examples/
├── complete/
│   ├── main.tf
│   └── variables.tf
└── simple/
    ├── main.tf
    └── variables.tf
```