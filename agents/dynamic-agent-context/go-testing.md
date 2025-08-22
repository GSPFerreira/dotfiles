# Go Testing Context

## Go Testing Framework
- Use built-in `testing` package
- Test files should end with `_test.go`
- Test functions must start with `Test` and take `*testing.T`
- Benchmark functions start with `Benchmark` and take `*testing.B`

## Testing Best Practices
- Use table-driven tests for multiple test cases
- Test both happy path and error conditions
- Use `testify/assert` or `testify/require` for assertions if available
- Mock external dependencies using interfaces
- Use `t.Helper()` for test helper functions

## Common Testing Patterns
```go
func TestFunction(t *testing.T) {
    tests := []struct {
        name     string
        input    interface{}
        expected interface{}
        wantErr  bool
    }{
        // test cases
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // test logic
        })
    }
}
```

## Testing Commands
- `go test ./...` - Run all tests
- `go test -v` - Verbose output
- `go test -cover` - Show coverage
- `go test -race` - Race condition detection