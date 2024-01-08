package auth

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

type Tokens struct {
	ID        uuid.UUID `json:"id"`
	UserId    uuid.UUID `json:"user_id"`
	Content   string    `json:"content"`
	IsExpired bool      `json:"is_expired"`
	ExpiredAt time.Time `json:"expired_at"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}
