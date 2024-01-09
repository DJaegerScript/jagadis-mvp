package auth

import (
	"github.com/gofrs/uuid"
	"time"
)

type Sessions struct {
	ID        uuid.UUID `json:"id"`
	UserId    uuid.UUID `json:"user_id"`
	Content   string    `json:"content"`
	IsExpired bool      `json:"is_expired"`
	ExpiredAt time.Time `json:"expired_at"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}
