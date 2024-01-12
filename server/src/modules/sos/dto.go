package sos

import "github.com/gofrs/uuid"

type GuardianRegistrationRequestDTO struct {
	ContactNumbers string `json:"contactNumbers" validate:"required,e164"`
}

type GetAllGuardiansResponseDTO struct {
	ID            uuid.UUID `json:"id,omitempty"`
	ContactNumber string    `json:"contact_number,omitempty"`
	Name          string    `json:"name,omitempty"`
}

type AlertRequestDTO struct {
	Longitude float64 `json:"longitude" validate:"required"`
	Latitude  float64 `json:"latitude" validate:"required"`
}

type AlertedGuardianDTO struct {
	ContactNumber string `json:"contact_number"`
	Name          string `json:"name"`
}
