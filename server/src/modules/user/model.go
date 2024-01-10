package user

import (
	"database/sql"
	"github.com/gofrs/uuid"
	"time"
)

type Users struct {
	ID          uuid.UUID      `json:"id"`
	Name        sql.NullString `json:"name"`
	Email       string         `json:"email"`
	PhoneNumber string         `json:"phone_number"`
	Password    string         `json:"password"`
	Gender      sql.NullString `json:"gender"`
	City        sql.NullString `json:"city"`
	BirthDate   sql.NullTime   `json:"birthdate"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
}
