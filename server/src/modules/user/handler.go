package user

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v4/pgxpool"
	"jagadis/src/modules/common"
)

type Handler interface {
	GetProfile(ctx *fiber.Ctx) error
	UpdateProfile(ctx *fiber.Ctx) error
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

func (h *HandlerStruct) GetProfile(ctx *fiber.Ctx) error {
	userId, err := common.GetSession(ctx)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	if !common.GetRequestAuthenticity(ctx, userId) {
		return common.HandleException(ctx, fiber.StatusForbidden, "Compromised request")
	}

	err, statusCode, profile, message := h.Service.GetProfile(userId)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusOK

	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    "Profile successfully retrieved!",
		"content":    profile,
	})
}

func (h *HandlerStruct) UpdateProfile(ctx *fiber.Ctx) error {
	userId, err := common.GetSession(ctx)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	if !common.GetRequestAuthenticity(ctx, userId) {
		return common.HandleException(ctx, fiber.StatusForbidden, "Compromised request")
	}

	err, requestBody := common.ParseBody(ctx, h.Validate, new(UpdateProfileRequestDTO))
	if err != nil {
		return common.HandleException(ctx, fiber.StatusBadRequest, "Invalid request body")
	}

	err, statusCode, message := h.Service.UpdateProfile(*requestBody, userId)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusOK

	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    "Profile successfully updated!",
		"content":    nil,
	})
}
