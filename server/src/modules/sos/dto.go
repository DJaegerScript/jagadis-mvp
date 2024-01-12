package sos

import (
	"database/sql"
	"github.com/gofrs/uuid"
	"time"
)

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

type GetAllActivatedAlertResponseDTO struct {
	ID          uuid.UUID `json:"id"`
	Name        string    `json:"name,omitempty"`
	PhoneNumber string    `json:"phone_number"`
	ActivatedAt time.Time `json:"activated_at"`
}

type AlertDTO struct {
	Alerts
	Name        sql.NullString `json:"name"`
	PhoneNumber string         `json:"phone_number"`
}
