# Use the official Golang image as the base image
FROM golang:1.24 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./
COPY vendor vendor
COPY cmd cmd
COPY internal internal
COPY Makefile Makefile

# Download dependencies
#RUN go mod download

# Copy the source code into the container
#COPY . .
RUN ls -l
# Build the Go binary
#RUN go build -o backend ./cmd/server/main.go
RUN make build
RUN ls -l


# Use a minimal base image for the final container
FROM alpine:latest
# Install glibc
RUN apk add --no-cache libc6-compat
# Set the working directory inside the container
WORKDIR /

# Copy the Go binary from the builder stage
COPY --from=builder /app/backend /backend
RUN ldd /backend

# Expose the port the application runs on
EXPOSE 8080

# Command to run the application
CMD ["./backend"]