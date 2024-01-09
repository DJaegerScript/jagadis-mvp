package support

import (
	"github.com/jackc/pgx/v4/pgxpool"
)

type Service interface {
	GetAllPersonalGuardSupports() (err error, statusCode int, supportDTOs []*SupportDTO, message string)
	GetAllTherapistSupports() (err error, statusCode int, supportDTOs []*SupportDTO, message string)
}

type ServiceStruct struct {
	Repo Repo
}

func NewService(db *pgxpool.Pool) (svc *ServiceStruct, err error) {
	repo := NewRepo(db)

	svc = &ServiceStruct{
		Repo: repo,
	}

	return svc, err
}

func (s *ServiceStruct) GetAllPersonalGuardSupports() (err error, statusCode int, supportDTOs []*SupportDTO, message string) {
	statusCode, personalGuards, message, err := s.Repo.GetAllPersonalGuard()
	if err != nil {
		return err, statusCode, supportDTOs, message
	}

	for _, personalGuard := range personalGuards {
		statusCode, support, message, err := s.Repo.GetSupportByID(personalGuard.SupportID)
		if err != nil {
			return err, statusCode, supportDTOs, message
		}

		statusCode, vendor, message, err := s.Repo.GetPersonalGuardVendorByID(personalGuard.VendorID)
		if err != nil {
			return err, statusCode, supportDTOs, message
		}

		supportDTOs = append(supportDTOs, &SupportDTO{
			ID:               support.ID,
			Type:             support.SupportTypeID.String(),
			Name:             support.Name,
			ImageURL:         support.ImageURL,
			YearOfExperience: support.YearOfExperience,
			Fee:              support.Fee,
			Gender:           support.Gender,
			PersonalGuard: &PersonalGuardDTO{
				Profession:   personalGuard.Profession,
				Domicile:     personalGuard.City,
				EmployerType: personalGuard.Type,
			},
			Vendor: &VendorDTO{
				Name:    vendor.Name,
				Address: vendor.Address,
				Contact: vendor.Contact,
			},
		})
	}

	return err, statusCode, supportDTOs, message
}

func (s *ServiceStruct) GetAllTherapistSupports() (err error, statusCode int, supportDTOs []*SupportDTO, message string) {
	statusCode, therapists, message, err := s.Repo.GetAllTherapist()
	if err != nil {
		return err, statusCode, supportDTOs, message
	}

	for _, therapist := range therapists {
		statusCode, support, message, err := s.Repo.GetSupportByID(therapist.SupportID)
		if err != nil {
			return err, statusCode, supportDTOs, message
		}

		statusCode, vendor, message, err := s.Repo.GetTherapistVendorByID(therapist.VendorID)
		if err != nil {
			return err, statusCode, supportDTOs, message
		}

		supportDTOs = append(supportDTOs, &SupportDTO{
			ID:               support.ID,
			Type:             support.SupportTypeID.String(),
			Name:             support.Name,
			ImageURL:         support.ImageURL,
			YearOfExperience: support.YearOfExperience,
			Fee:              support.Fee,
			Gender:           support.Gender,
			Therapist: &TherapistDTO{
				Speciality: therapist.Speciality,
				Education:  therapist.Education,
			},
			Vendor: &VendorDTO{
				Name:    vendor.Name,
				Address: vendor.Address,
				Contact: vendor.Contact,
			},
		})
	}

	return err, statusCode, supportDTOs, message
}
