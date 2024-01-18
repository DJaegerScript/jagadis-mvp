# Use the official Golang image as the base image
FROM golang:latest

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum to download dependencies
COPY go.mod .
COPY go.sum .

# Download dependencies
RUN go mod download

# Copy the entire application source code into the container
COPY . .

# # Change directory to ./src/db and run go run migrate.go
# WORKDIR /app/src/db
# RUN go run migrate.go

# Change back to the root project directory
WORKDIR /app

# Build the Golang application
RUN go build -o bin/main main.go

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["./bin/main"]