package sos

import "github.com/gofrs/uuid"

type GuardianRegistrationRequestDTO struct {
	ContactNumbers string `json:"contactNumbers" validate:"required,e164"`
}

type GetAllGuardiansResponseDTO struct {
	ID            uuid.UUID `json:"id"`
	ContactNumber string    `json:"contact_number"`
}
