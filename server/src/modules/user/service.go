package user

import (
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Service interface {
	GetProfile(userId uuid.UUID) (err error, statusCode int, getProfileResponseDTO *GetProfileResponseDTO, message string)
	UpdateProfile(dto UpdateProfileRequestDTO, userId uuid.UUID) (err error, statusCode int, message string)
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

func (s *ServiceStruct) GetProfile(userId uuid.UUID) (err error, statusCode int, getProfileResponseDTO *GetProfileResponseDTO, message string) {
	err, statusCode, profile, message := s.Repo.FindUserById(userId)
	if err != nil {
		return err, statusCode, nil, message
	}

	response := &GetProfileResponseDTO{
		User: UpdateProfileRequestDTO{
			ID:          profile.ID,
			Email:       profile.Email,
			PhoneNumber: profile.PhoneNumber,
			Name:        profile.Name.String,
			City:        profile.City.String,
			Gender:      profile.Gender.String,
			BirthDate:   profile.BirthDate.Time,
		},
	}

	return err, statusCode, response, ""
}

func (s *ServiceStruct) UpdateProfile(dto UpdateProfileRequestDTO, userId uuid.UUID) (err error, statusCode int, message string) {
	return s.Repo.UpdateUser(dto, userId)
}
