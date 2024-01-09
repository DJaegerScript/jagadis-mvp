package support

import (
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Service interface {
	GetAllPersonalGuardSupports() (err error, statusCode int, supportDTOs []SupportDTO, message string)
	GetAllTherapistSupports() (err error, statusCode int, supportDTOs []SupportDTO, message string)
	GetSupportDetail(supportId uuid.UUID) (err error, statusCode int, supportDTO SupportDTO, message string)
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

func (s *ServiceStruct) GetSupportDetail(supportId uuid.UUID) (err error, statusCode int, supportDTO SupportDTO, message string) {
	statusCode, support, message, err := s.Repo.GetSupportByID(supportId)
	if err != nil {
		return err, statusCode, supportDTO, message
	}

	statusCode, supportType, message, err := s.Repo.GetSupportTypeByID(support.SupportTypeID)
	if err != nil {
		return err, statusCode, supportDTO, message
	}

	switch supportType.Name {
	case "PERSONAL_GUARD":
		statusCode, personalGuard, message, err := s.Repo.GetPersonalGuardBySupportID(supportId)
		if err != nil {
			return err, statusCode, supportDTO, message
		}

		if personalGuard.VendorID != nil {
			statusCode, vendor, message, err := s.Repo.GetPersonalGuardVendorByID(personalGuard.VendorID)
			if err != nil {
				return err, statusCode, supportDTO, message
			}

			return err, statusCode, SupportDTO{
				ID:               support.ID,
				Name:             support.Name,
				ImageURL:         support.ImageURL,
				Gender:           support.Gender,
				YearOfExperience: support.YearOfExperience,
				Fee:              support.Fee,
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
			}, message
		} else {
			return err, statusCode, SupportDTO{
				ID:               support.ID,
				Name:             support.Name,
				ImageURL:         support.ImageURL,
				Gender:           support.Gender,
				YearOfExperience: support.YearOfExperience,
				Fee:              support.Fee,
				PersonalGuard: &PersonalGuardDTO{
					Profession:   personalGuard.Profession,
					Domicile:     personalGuard.City,
					EmployerType: personalGuard.Type,
				},
			}, message
		}
	case "THERAPIST":
		statusCode, therapist, message, err := s.Repo.GetTherapistBySupportID(supportId)
		if err != nil {
			return err, statusCode, supportDTO, message
		}

		statusCode, vendor, message, err := s.Repo.GetTherapistVendorByID(therapist.VendorID)
		if err != nil {
			return err, statusCode, supportDTO, message
		}

		return err, statusCode, SupportDTO{
			ID:               support.ID,
			Name:             support.Name,
			ImageURL:         support.ImageURL,
			Gender:           support.Gender,
			YearOfExperience: support.YearOfExperience,
			Fee:              support.Fee,
			Therapist: &TherapistDTO{
				Specialty: therapist.Specialty,
				Education: therapist.Education,
			},
			Vendor: &VendorDTO{
				Name:    vendor.Name,
				Address: vendor.Address,
				Contact: vendor.Contact,
			},
		}, message
	default:
		return err, statusCode, supportDTO, message
	}
}

func (s *ServiceStruct) GetAllPersonalGuardSupports() (err error, statusCode int, supportDTOs []SupportDTO, message string) {
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

		statusCode, supportType, message, err := s.Repo.GetSupportTypeByID(support.SupportTypeID)
		if err != nil {
			return err, statusCode, supportDTOs, message
		}

		supportDTOs = append(supportDTOs, SupportDTO{
			ID:               support.ID,
			Type:             supportType.Name,
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

func (s *ServiceStruct) GetAllTherapistSupports() (err error, statusCode int, supportDTOs []SupportDTO, message string) {
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

		statusCode, supportType, message, err := s.Repo.GetSupportTypeByID(support.SupportTypeID)
		if err != nil {
			return err, statusCode, supportDTOs, message
		}

		supportDTOs = append(supportDTOs, SupportDTO{
			ID:               support.ID,
			Type:             supportType.Name,
			Name:             support.Name,
			ImageURL:         support.ImageURL,
			YearOfExperience: support.YearOfExperience,
			Fee:              support.Fee,
			Gender:           support.Gender,
			Therapist: &TherapistDTO{
				Specialty: therapist.Specialty,
				Education: therapist.Education,
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
