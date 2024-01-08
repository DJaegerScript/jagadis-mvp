install:
	go mod tidy

build:
	go build -o bin/main main.go

run-build:
	./bin/main

run:
	go run main.go

dev:
	air

migration:
	migrate create -seq -ext sql -dir ./src/db/migrations $(filter-out $@,$(MAKECMDGOALS))

migrate:
	cd ./src/db && go run migrate.go

migrate-rollback:
	cd ./src/db && go run migrate.go -action down