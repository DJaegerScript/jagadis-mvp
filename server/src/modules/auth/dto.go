package auth

import "jagadis/src/modules/user"

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

type LoginResponseDTO struct {
	Token string                       `json:"token"`
	User  user.UpdateProfileRequestDTO `json:"user"`
}
