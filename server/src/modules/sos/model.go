package sos

import (
	"github.com/gofrs/uuid"
	"time"
)

type Guardians struct {
	ID            uuid.UUID `json:"id"`
	UserID        uuid.UUID `json:"user_id"`
	ContactNumber string    `json:"contact_number"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}
