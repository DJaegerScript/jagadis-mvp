package support

import (
	"time"

	"github.com/gofrs/uuid"
)

type Support struct {
	ID               uuid.UUID `json:"id"`
	SupportTypeID    uuid.UUID `json:"support_type_id"`
	Name             string    `json:"name"`
	ImageURL         string    `json:"image_url"`
	YearOfExperience int       `json:"year_of_experience"`
	Gender           string    `json:"gender"`
	Fee              int       `json:"fee"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
}

type SupportType struct {
	ID        uuid.UUID `json:"id"`
	Name      string    `json:"name"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type PersonalGuard struct {
	ID         uuid.UUID `json:"id"`
	SupportID  uuid.UUID `json:"support_id"`
	Profession string    `json:"profession"`
	City       string    `json:"city"`
	VendorID   uuid.UUID `json:"vendor_id"`
	Type       string    `json:"type"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
}

type PersonalGuardVendor struct {
	ID        uuid.UUID `json:"id"`
	Name      string    `json:"name"`
	Address   string    `json:"address"`
	Contact   string    `json:"contact"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type Therapist struct {
	ID         uuid.UUID `json:"id"`
	SupportID  uuid.UUID `json:"support_id"`
	Speciality string    `json:"speciality"`
	Education  string    `json:"education"`
	VendorID   uuid.UUID `json:"vendor_id"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
}

type TherapistVendor struct {
	ID        uuid.UUID `json:"id"`
	Name      string    `json:"name"`
	Address   string    `json:"address"`
	Contact   string    `json:"contact"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}
