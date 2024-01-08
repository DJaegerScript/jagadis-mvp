package auth

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
	"jagadis/src/modules/common"
)

type Handler interface {
	Registration(ctx *fiber.Ctx) error
	Login(ctx *fiber.Ctx) error
	Logout(ctx *fiber.Ctx) error
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

func (h *HandlerStruct) Registration(ctx *fiber.Ctx) error {

	err, requestBody := common.ParseBody(ctx, h.Validate, new(RegistrationRequestDTO))
	if err != nil {
		return common.HandleException(ctx, fiber.StatusBadRequest, "Invalid request body")
	}

	err, statusCode, message := h.Service.Register(requestBody)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusCreated

	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    message,
		"content":    nil,
	})
}

func (h *HandlerStruct) Login(ctx *fiber.Ctx) error {
	err, requestBody := common.ParseBody(ctx, h.Validate, new(LoginRequestDTO))
	if err != nil {
		return common.HandleException(ctx, fiber.StatusBadRequest, "Invalid request body")
	}

	err, statusCode, response, message := h.Service.Login(requestBody)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusOK

	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    "User login successfully!",
		"content":    &response,
	})
}

func (h *HandlerStruct) Logout(ctx *fiber.Ctx) error {
	userId := fmt.Sprintf("%s", ctx.Locals("userId"))
	id, err := uuid.FromString(userId)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	err, statusCode, message := h.Service.Logout(id)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	return ctx.Status(200).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": 200,
		"message":    "Logout successfully",
		"content":    nil,
	})
}
