package auth

import (
	"github.com/gofrs/uuid"
	"time"
)

type RegistrationRequestDTO struct {
	PhoneNumber          string `json:"phoneNumber" validate:"required,e164"`
	Email                string `json:"email" validate:"required,email"`
	Password             string `json:"password" validate:"required"`
	ConfirmationPassword string `json:"confirmationPassword" validate:"required,eqfield=Password"`
}

type LoginRequestDTO struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required"`
}

type UserDTO struct {
	ID          uuid.UUID
	Name        string
	Email       string
	PhoneNumber string
	Gender      string
	City        string
	Birthdate   time.Time
}

type LoginResponseDTO struct {
	Token string
	User  *UserDTO
}
