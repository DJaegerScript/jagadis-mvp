package sos

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
	"jagadis/src/modules/auth"
)

type Service interface {
	RegisterGuardian(contactNumbers string, userId uuid.UUID) (err error, statusCode int, message string)
	GetAllGuardians(userId uuid.UUID) (err error, statusCode int, guardians []GetAllGuardiansResponseDTO, message string)
}

type ServiceStruct struct {
	GuardianRepo Repo
	UserRepo     auth.Repo
}

func NewService(db *pgxpool.Pool) (svc *ServiceStruct, err error) {
	guardianRepo := NewRepo(db)
	userRepo := auth.NewRepo(db)

	svc = &ServiceStruct{
		GuardianRepo: guardianRepo,
		UserRepo:     userRepo,
	}

	return svc, err
}

func (s *ServiceStruct) RegisterGuardian(contactNumbers string, userId uuid.UUID) (err error, statusCode int, message string) {

	err, statusCode, guardianId, message := s.UserRepo.FindUserByPhoneNumber(contactNumbers)
	if err != nil || !guardianId.Valid {
		return err, statusCode, message
	}

	if userId == guardianId.UUID {
		return err, fiber.StatusForbidden, "Must insert another user phone number!"
	}

	err, statusCode, message = s.GuardianRepo.Save(contactNumbers, userId)
	if err != nil {
		return err, statusCode, message
	}

	return err, statusCode, message
}

func (s *ServiceStruct) GetAllGuardians(userId uuid.UUID) (err error, statusCode int, guardians []GetAllGuardiansResponseDTO, message string) {
	err, statusCode, results, message := s.GuardianRepo.FindAllByUserId(userId)
	if err != nil {
		return err, statusCode, guardians, message
	}

	for _, result := range results {
		guardians = append(guardians, GetAllGuardiansResponseDTO{
			ID:            result.ID,
			ContactNumber: result.ContactNumber,
		})
	}

	return err, statusCode, guardians, message
}
