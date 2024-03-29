package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/joho/godotenv"
)

var action string

func init() {
	flag.StringVar(&action, "action", "up", "migration action (up/down)")
	flag.Parse()
}

func main() {
	err := godotenv.Load("../../.env")
	if err != nil {
		fmt.Println(err.Error())
	}

	dbUrl := os.Getenv("DATABASE_MIGRATION_URL")

	m, err := migrate.New(
		"file://migrations/",
		dbUrl,
	)
	if err != nil {
		fmt.Println(err.Error())
	}

	if action == "up" {
		if err := m.Up(); err != nil {
			fmt.Println(err.Error())
		}
	} else if action == "down" {
		if err := m.Down(); err != nil {
			fmt.Println(err.Error())
		}
	} else {
		fmt.Println("invalid action")
	}
}
