package support

import (
	"github.com/gofrs/uuid"
)

type SupportDTO struct {
	ID               uuid.UUID         `json:"id"`
	Name             string            `json:"name"`
	ImageURL         string            `json:"imageURL"`
	Gender           string            `json:"gender"`
	YearOfExperience int               `json:"yearOfExperience"`
	Type             string            `json:"type"`
	Fee              int               `json:"fee"`
	PersonalGuard    *PersonalGuardDTO `json:"personalGuard,omitempty"`
	Therapist        *TherapistDTO     `json:"therapist,omitempty"`
	Vendor           *VendorDTO        `json:"vendor"`
}

type PersonalGuardDTO struct {
	Profession   string `json:"profession"`
	Domicile     string `json:"domicile"`
	EmployerType string `json:"employerType"`
}

type TherapistDTO struct {
	Speciality string `json:"speciality"`
	Education  string `json:"education"`
}

type VendorDTO struct {
	Name    string `json:"name"`
	Address string `json:"address"`
	Contact string `json:"contact"`
}
