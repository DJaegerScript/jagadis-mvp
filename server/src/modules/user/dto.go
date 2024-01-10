package user

import (
	"github.com/gofrs/uuid"
	"time"
)

type UpdateProfileRequestDTO struct {
	ID          uuid.UUID `json:"id"`
	Name        string    `json:"name" validate:"required"`
	Email       string    `json:"email" validate:"required,email"`
	PhoneNumber string    `json:"phoneNumber" validate:"required,e164"`
	Gender      string    `json:"gender" validate:"required"`
	City        string    `json:"city" validate:"required"`
	BirthDate   time.Time `json:"birthdate" validate:"required"`
}

type GetProfileResponseDTO struct {
	User UpdateProfileRequestDTO `json:"user"`
}
