package config

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/limiter"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"jagadis/src/core/middleware"
	"jagadis/src/modules/auth"
	"jagadis/src/modules/sos"
	"jagadis/src/modules/user"
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
	s.Router.Mount("/user", s.UserRouter(authenticator))
	s.Router.Mount("/sos", s.SOSRouter(authenticator))
}

func (s *Server) AuthRouter(authenticator *middleware.Authenticator) *fiber.App {
	authHandler := auth.NewHandler(s.DB)

	authRouter := fiber.New()

	authRouter.Post("/registration", authHandler.Registration)
	authRouter.Post("/login", authHandler.Login)
	authRouter.Post("/logout", authenticator.TokenAuthenticator, authHandler.Logout)

	return authRouter
}

func (s *Server) UserRouter(authenticator *middleware.Authenticator) *fiber.App {
	userHandler := user.NewHandler(s.DB)

	userRouter := fiber.New()

	userRouter.Get("/:userId/profile", authenticator.TokenAuthenticator, userHandler.GetProfile)
	userRouter.Put("/:userId/profile", authenticator.TokenAuthenticator, userHandler.UpdateProfile)

	return userRouter
}

func (s *Server) SOSRouter(authenticator *middleware.Authenticator) *fiber.App {
	sosHandler := sos.NewHandler(s.DB)

	sosRouter := fiber.New()

	sosRouter.Get("/:userId/guardian", authenticator.TokenAuthenticator, sosHandler.GetAllGuardians)
	sosRouter.Post("/:userId/guardian", authenticator.TokenAuthenticator, sosHandler.GuardianRegistration)
	sosRouter.Delete("/:userId/guardian/:guardianId", authenticator.TokenAuthenticator, sosHandler.RemoveGuardian)
	sosRouter.Delete("/:userId/guardian", authenticator.TokenAuthenticator, sosHandler.ResetGuardian)

	sosRouter.Post("/:userId/alert", authenticator.TokenAuthenticator, sosHandler.EnterStandbyMode)
	sosRouter.Put("/:userId/alert/:alertId", authenticator.TokenAuthenticator, sosHandler.UpdateAlert)

	return sosRouter
}
