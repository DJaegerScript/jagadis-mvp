package sos

import (
	"database/sql"
	"encoding/json"
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

type Alerts struct {
	ID              uuid.UUID       `json:"id"`
	UserId          uuid.UUID       `json:"user_id"`
	Status          string          `json:"status"`
	LatestLongitude float64         `json:"latest_longitude"`
	LatestLatitude  float64         `json:"latest_latitude"`
	Guardians       json.RawMessage `json:"guardians"`
	StandByAt       time.Time       `json:"standby_at"`
	ActivatedAt     sql.NullTime    `json:"activated_at"`
	TurnedOffAt     sql.NullTime    `json:"turned_off_at"`
}
