package sos

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v4/pgxpool"
	"jagadis/src/modules/common"
)

type Handler interface {
	GuardianRegistration(ctx *fiber.Ctx) error
}

type HandlerStruct struct {
	Service  Service
	Validate *validator.Validate
}

func NewHandler(db *pgxpool.Pool) *HandlerStruct {
	service, err := NewService(db)
	if err != nil {
		panic(err)
	}
	return &HandlerStruct{
		Service:  service,
		Validate: validator.New(),
	}
}

func (h *HandlerStruct) GuardianRegistration(ctx *fiber.Ctx) error {
	userId, err := common.GetSession(ctx)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	if !common.GetRequestAuthenticity(ctx, userId) {
		return common.HandleException(ctx, fiber.StatusForbidden, "Compromised request")
	}

	err, requestBody := common.ParseBody(ctx, h.Validate, new(GuardianRegistrationRequestDTO))
	if err != nil {
		return common.HandleException(ctx, fiber.StatusBadRequest, "Invalid request body")
	}

	err, statusCode, message := h.Service.RegisterGuardian(requestBody.ContactNumbers, userId)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusCreated

	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    "Guardian successfully registered!",
		"content":    nil,
	})
}
