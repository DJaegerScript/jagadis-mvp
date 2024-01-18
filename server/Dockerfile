# Use the official Golang image as the base image
FROM golang:latest

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum to download dependencies
COPY ./server/go.mod .
COPY ./server/go.sum .

# Download dependencies
RUN go mod download

# Copy the entire application source code into the container
COPY ./server .

# Change back to the root project directory
WORKDIR /app

# Build the Golang application
RUN go build -o bin/main main.go

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["./bin/main"]