# Makefile for building and running the backend API

# Variables
APP_NAME := backend
DOCKER_IMAGE := backend-api:latest
DOCKERFILE := Dockerfile

# Build the Go binary
build:
	@echo "Building the Go binary..."
	GOOS=linux GOARCH=amd64 go build -o $(APP_NAME) ./cmd/server/main.go

# Build the Docker image
docker-build:
	@echo "Building the Docker image..."
	podman build --format=docker --platform=linux/amd64 -t $(DOCKER_IMAGE) -f $(DOCKERFILE) .

# Run the Docker container
docker-run:
	@echo "Running the Docker container..."
	docker run -p 8080:8080 --rm $(DOCKER_IMAGE)

# Clean up build artifacts
clean:
	@echo "Cleaning up build artifacts..."
	rm -f $(APP_NAME)

# Run tests
test:
	@echo "Running tests..."
	go test ./... -v

.PHONY: build docker-build docker-run clean test
