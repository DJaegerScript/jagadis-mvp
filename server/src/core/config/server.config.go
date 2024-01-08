package config

import (
	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v4/pgxpool"
	"jagadis/src/core/middleware"
)

type Server struct {
	Router *fiber.App
	DB     *pgxpool.Pool
}

func MakeServer() Server {
	middleware.NewLogger()

	r := fiber.New()
	db := InitDatabase()
	server := Server{
		Router: r,
		DB:     db,
	}

	server.SetupRouter()

	return server
}
