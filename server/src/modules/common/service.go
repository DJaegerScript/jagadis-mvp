package common

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"go.uber.org/zap"
)

type Service interface {
	ParseBody(ctx *fiber.Ctx, validator *validator.Validate, dto *struct{})
}

func ParseBody[T any](ctx *fiber.Ctx, validator *validator.Validate, dto *T) (error, *T) {
	if err := ctx.BodyParser(dto); err != nil {
		zap.L().Error("Body parser error", zap.Error(err))
		return err, nil
	}

	if err := validator.Struct(dto); err != nil {
		zap.L().Error("Body validation error", zap.Error(err))
		return err, nil
	}

	return nil, dto
}

func HandleException(ctx *fiber.Ctx, statusCode int, message string) error {
	return ctx.Status(statusCode).JSON(fiber.Map{
		"isSuccess":  false,
		"statusCode": statusCode,
		"message":    message,
		"content":    nil,
	})
}
