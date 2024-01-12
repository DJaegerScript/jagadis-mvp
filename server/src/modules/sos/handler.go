package sos

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
	"jagadis/src/modules/common"
)

type Handler interface {
	GuardianRegistration(ctx *fiber.Ctx) error
	GetAllGuardians(ctx *fiber.Ctx) error
	RemoveGuardian(ctx *fiber.Ctx) error
	ResetGuardian(ctx *fiber.Ctx) error
	EnterStandbyMode(ctx *fiber.Ctx) error
	UpdateAlert(ctx *fiber.Ctx) error
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

func (h *HandlerStruct) GetAllGuardians(ctx *fiber.Ctx) error {
	userId, err := common.GetSession(ctx)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	if !common.GetRequestAuthenticity(ctx, userId) {
		return common.HandleException(ctx, fiber.StatusForbidden, "Compromised request")
	}

	err, statusCode, guardians, message := h.Service.GetAllGuardians(userId)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusOK

	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    "Guardians successfully retrieved!",
		"content": fiber.Map{
			"guardians": guardians,
		},
	})
}

func (h *HandlerStruct) RemoveGuardian(ctx *fiber.Ctx) error {
	userId, err := common.GetSession(ctx)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	if !common.GetRequestAuthenticity(ctx, userId) {
		return common.HandleException(ctx, fiber.StatusForbidden, "Compromised request")
	}

	guardianId := uuid.FromStringOrNil(ctx.Params("guardianId"))

	err, statusCode, message := h.Service.RemoveGuardian(guardianId, userId)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusOK

	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    "Guardian successfully removed!",
		"content":    nil,
	})
}

func (h *HandlerStruct) ResetGuardian(ctx *fiber.Ctx) error {
	userId, err := common.GetSession(ctx)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	if !common.GetRequestAuthenticity(ctx, userId) {
		return common.HandleException(ctx, fiber.StatusForbidden, "Compromised request")
	}

	err, statusCode, message := h.Service.ResetGuardian(userId)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusOK

	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    "Guardian successfully reset!",
		"content":    nil,
	})
}

func (h *HandlerStruct) EnterStandbyMode(ctx *fiber.Ctx) error {
	userId, err := common.GetSession(ctx)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	if !common.GetRequestAuthenticity(ctx, userId) {
		return common.HandleException(ctx, fiber.StatusForbidden, "Compromised request")
	}

	err, requestBody := common.ParseBody(ctx, h.Validate, new(AlertRequestDTO))
	if err != nil {
		return common.HandleException(ctx, fiber.StatusBadRequest, "Invalid request body")
	}

	err, statusCode, message := h.Service.EnterStandbyMode(requestBody, userId)
	if err != nil || statusCode == fiber.StatusNotFound || statusCode == fiber.StatusConflict {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusCreated

	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    "Successfully entering standby mode!",
		"content":    nil,
	})
}

/*
 * TODO:
 * - Should create update for long/lat
 */
func (h *HandlerStruct) UpdateAlert(ctx *fiber.Ctx) error {
	userId, err := common.GetSession(ctx)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	if !common.GetRequestAuthenticity(ctx, userId) {
		return common.HandleException(ctx, fiber.StatusForbidden, "Compromised request")
	}

	err, requestBody := common.ParseBody(ctx, h.Validate, new(AlertRequestDTO))
	if err != nil {
		return common.HandleException(ctx, fiber.StatusBadRequest, "Invalid request body")
	}

	action := ctx.Query("action")

	err, statusCode, message := h.Service.UpdateAlert(action, requestBody, userId)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusOK

	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    "Alert updated successfully!",
		"content":    nil,
	})

}
