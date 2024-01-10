package sos

import (
	"encoding/json"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
	"jagadis/src/modules/user"
)

type Service interface {
	RegisterGuardian(contactNumbers string, userId uuid.UUID) (err error, statusCode int, message string)
	GetAllGuardians(userId uuid.UUID) (err error, statusCode int, guardians []GetAllGuardiansResponseDTO, message string)
	RemoveGuardian(guardianId uuid.UUID, userId uuid.UUID) (err error, statusCode int, message string)
	ResetGuardian(userId uuid.UUID) (err error, statusCode int, message string)
	EnterStandbyMode(location *EnterStandByModeRequestDTO, userId uuid.UUID) (err error, statusCode int, message string)
	UpdateAlert(action string, alertId uuid.UUID, userId uuid.UUID) (err error, statusCode int, message string)
}

type ServiceStruct struct {
	SOSRepo  Repo
	UserRepo user.Repo
}

func NewService(db *pgxpool.Pool) (svc *ServiceStruct, err error) {
	guardianRepo := NewRepo(db)
	userRepo := user.NewRepo(db)

	svc = &ServiceStruct{
		SOSRepo:  guardianRepo,
		UserRepo: userRepo,
	}

	return svc, err
}

func (s *ServiceStruct) RegisterGuardian(contactNumbers string, userId uuid.UUID) (err error, statusCode int, message string) {

	err, statusCode, guardian, message := s.UserRepo.FindUserByPhoneNumber(contactNumbers)
	if err != nil {
		return err, statusCode, message
	}

	if userId == guardian.ID {
		return err, fiber.StatusForbidden, "Must insert another user phone number!"
	}

	err, statusCode, message = s.SOSRepo.Save(contactNumbers, userId)
	if err != nil {
		return err, statusCode, message
	}

	return err, statusCode, message
}

func (s *ServiceStruct) GetAllGuardians(userId uuid.UUID) (err error, statusCode int, guardians []GetAllGuardiansResponseDTO, message string) {
	err, statusCode, results, message := s.SOSRepo.FindAllByUserId(userId)
	if err != nil {
		return err, statusCode, guardians, message
	}

	if len(results) <= 0 {
		guardians = make([]GetAllGuardiansResponseDTO, 0)
	} else {

		for _, result := range results {
			guardians = append(guardians, GetAllGuardiansResponseDTO{
				ID:            result.ID,
				ContactNumber: result.ContactNumber,
			})
		}
	}

	return err, statusCode, guardians, message
}

func (s *ServiceStruct) RemoveGuardian(guardianId uuid.UUID, userId uuid.UUID) (err error, statusCode int, message string) {
	return s.SOSRepo.DeleteById(guardianId, userId)
}

func (s *ServiceStruct) ResetGuardian(userId uuid.UUID) (err error, statusCode int, message string) {
	return s.SOSRepo.DeleteByUserId(userId)
}

func (s *ServiceStruct) EnterStandbyMode(location *EnterStandByModeRequestDTO, userId uuid.UUID) (err error, statusCode int, message string) {
	err, statusCode, alerts, message := s.SOSRepo.FindAlertByUserId(userId)
	if err != nil {
		return err, statusCode, message
	}

	if len(alerts) > 0 {
		return err, fiber.StatusConflict, "Alert already in standby mode!"
	}

	err, statusCode, guardians, message := s.SOSRepo.FindAllByUserId(userId)
	if err != nil {
		return err, statusCode, message
	}

	if guardians == nil {
		return err, fiber.StatusNotFound, "Insert guardians first!"
	}

	var alertedGuardians []AlertedGuardianDTO
	for _, guardian := range guardians {
		_, _, guardianDetail, _ := s.UserRepo.FindUserByPhoneNumber(guardian.ContactNumber)

		alertedGuardians = append(alertedGuardians, AlertedGuardianDTO{
			ContactNumber: guardian.ContactNumber,
			Name:          guardianDetail.Name.String,
		})
	}

	alertedGuardianPayload, err := json.Marshal(alertedGuardians)
	if err != nil {
		zap.L().Error("Error marshaling guardian dto", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	err, statusCode, message = s.SOSRepo.SaveAlert(location, userId, alertedGuardianPayload)
	if err != nil {
		return err, statusCode, message
	}

	return err, statusCode, message
}

func (s *ServiceStruct) UpdateAlert(action string, alertId uuid.UUID, userId uuid.UUID) (err error, statusCode int, message string) {
	return s.SOSRepo.UpdateAlert(action, userId, alertId)
}
