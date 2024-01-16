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
	Longitude float64 `json:"longitude,omitempty" validate:"required"`
	Latitude  float64 `json:"latitude,omitempty" validate:"required"`
}

type AlertedGuardianDTO struct {
	ContactNumber string `json:"contact_number"`
	Name          string `json:"name"`
}

type GetAllActivatedAlertResponseDTO struct {
	ID uuid.UUID `json:"id"`
	// TODO: init this
	UserID      uuid.UUID `json:"user_id,omitempty"`
	Name        string    `json:"name,omitempty"`
	PhoneNumber string    `json:"phone_number,omitempty"`
	ActivatedAt time.Time `json:"activated_at,omitempty"`
}

type AlertDTO struct {
	Alerts
	Name        sql.NullString `json:"name"`
	PhoneNumber string         `json:"phone_number"`
}

type TrackAlertResponseDTO struct {
	Location AlertRequestDTO                 `json:"location"`
	User     GetAllActivatedAlertResponseDTO `json:"user"`
}
