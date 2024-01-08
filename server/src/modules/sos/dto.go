package sos

type GuardianRegistrationRequestDTO struct {
	ContactNumbers string `json:"contactNumbers" validate:"required,e164"`
}
