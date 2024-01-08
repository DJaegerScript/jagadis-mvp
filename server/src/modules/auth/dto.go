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
	ID          uuid.UUID `json:"id"`
	Name        string    `json:"name"`
	Email       string    `json:"email"`
	PhoneNumber string    `json:"phoneNumber"`
	Gender      string    `json:"gender"`
	City        string    `json:"city"`
	BirthDate   time.Time `json:"birthdate"`
}

type LoginResponseDTO struct {
	Token string   `json:"token"`
	User  *UserDTO `json:"user"`
}
