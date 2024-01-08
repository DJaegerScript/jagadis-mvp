package config

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/limiter"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"jagadis/src/core/middleware"
	"jagadis/src/modules/auth"
	"os"
	"time"
)

func (s *Server) SetupRouter() {
	authenticator := middleware.New(s.DB)

	s.Router.Use(middleware.Logger())

	s.Router.Use(recover.New())

	if os.Getenv("ENVIRONMENT") == "prod" {
		redisStorage := InitRedis()
		s.Router.Use(limiter.New(limiter.Config{
			Storage:    redisStorage,
			Max:        10,
			Expiration: 1 * time.Minute,
		}))
	}

	s.Router.Use(cors.New(cors.Config{
		AllowOrigins: os.Getenv("WHITELIST_DOMAIN"),
	}))

	s.Router.Get("/", func(ctx *fiber.Ctx) error {
		return ctx.Status(fiber.StatusOK).JSON(fiber.Map{
			"isSuccess":  true,
			"statusCode": fiber.StatusOK,
			"message":    "Hello World",
			"content":    nil,
		})
	})

	s.Router.Mount("/auth", s.AuthRouter(authenticator))
}

func (s *Server) AuthRouter(authenticator *middleware.Authenticator) *fiber.App {
	authHandler := auth.NewHandler(s.DB)

	authRouter := fiber.New()

	authRouter.Post("/registration", authHandler.Registration)
	authRouter.Post("/login", authHandler.Login)
	authRouter.Post("/logout", authenticator.TokenAuthenticator, authHandler.Logout)

	return authRouter
}
