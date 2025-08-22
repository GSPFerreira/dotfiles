# OCI Image Development Context

## Dockerfile Best Practices
- Use multi-stage builds to reduce image size
- Use specific base image tags, avoid `latest`
- Run as non-root user for security
- Use `.dockerignore` to exclude unnecessary files
- Layer caching optimization (copy dependencies first)
- Use `COPY` instead of `ADD` when possible

## Security Considerations
- Scan images for vulnerabilities (trivy, snyk)
- Use minimal base images (alpine, distroless)
- Don't store secrets in images
- Use security policies and admission controllers
- Regular base image updates

## Multi-stage Build Example
```dockerfile
# Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Runtime stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
USER 1000
CMD ["./main"]
```

## Build Commands
- `docker build -t image:tag .`
- `docker buildx build --platform linux/amd64,linux/arm64`
- `buildah bud -t image:tag .`
- `podman build -t image:tag .`

## Image Optimization
- Use Alpine or distroless base images
- Remove package managers after installation
- Combine RUN commands to reduce layers
- Use .dockerignore effectively