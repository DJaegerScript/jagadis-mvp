package support

import (
	"jagadis/src/modules/common"

	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Handler interface {
	GetAllSupportDTO(ctx *fiber.Ctx) error
	GetSupportDetail(ctx *fiber.Ctx) error
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

func (h *HandlerStruct) GetSupportDetail(ctx *fiber.Ctx) error {
	_, err := common.GetSession(ctx)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	supportId := uuid.FromStringOrNil(ctx.Params("supportId"))

	err, statusCode, supportDTO, message := h.Service.GetSupportDetail(supportId)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusOK

	return ctx.Status(fiber.StatusOK).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    message,
		"content":    supportDTO,
	})
}

func (h *HandlerStruct) GetAllSupportDTO(ctx *fiber.Ctx) error {
	_, err := common.GetSession(ctx)
	if err != nil {
		return common.HandleException(ctx, fiber.StatusInternalServerError, "Oops! Something went wrong")
	}

	supportType := ctx.Query("type")

	if supportType != "PERSONAL_GUARD" && supportType != "THERAPIST" {
		return common.HandleException(ctx, fiber.StatusBadRequest, "Invalid support type")
	}

	var (
		getAllFunc  func() (error, int, []SupportDTO, string)
		supportDTOs []SupportDTO
		message     string
		statusCode  int
	)

	switch supportType {
	case "PERSONAL_GUARD":
		getAllFunc = h.Service.GetAllPersonalGuardSupports
	case "THERAPIST":
		getAllFunc = h.Service.GetAllTherapistSupports
	default:
		return common.HandleException(ctx, fiber.StatusBadRequest, "Invalid support type")
	}

	err, statusCode, supportDTOs, message = getAllFunc()
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	statusCode = fiber.StatusOK

	return ctx.Status(fiber.StatusOK).JSON(fiber.Map{
		"isSuccess":  true,
		"statusCode": statusCode,
		"message":    message,
		"content": fiber.Map{
			"supports": supportDTOs,
		},
	})
}
