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
	EnterStandbyMode(location *AlertRequestDTO, userId uuid.UUID) (err error, statusCode int, alertId uuid.UUID, message string)
	UpdateAlert(action string, location *AlertRequestDTO, userId uuid.UUID) (err error, statusCode int, message string)
	GetAllActivatedAlert(userId uuid.UUID) (err error, statusCode int, dto []GetAllActivatedAlertResponseDTO, message string)
	TrackAlert(userId uuid.UUID, alertId uuid.UUID) (err error, statusCode int, dto TrackAlertResponseDTO, message string)
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
		return nil, fiber.StatusForbidden, "Harus memasukkan nomor pengguna lain!"
	}

	err, statusCode, message = s.SOSRepo.Save(contactNumbers, userId, guardian.Name.String)
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
				Name:          result.Name.String,
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

func (s *ServiceStruct) EnterStandbyMode(location *AlertRequestDTO, userId uuid.UUID) (err error, statusCode int, alertId uuid.UUID, message string) {
	// TODO: Uncomment this when migrating flutter to kotlin
	//err, statusCode, alerts, message := s.SOSRepo.FindAlertByUserId(userId, "STANDBY")
	err, statusCode, alerts, message := s.SOSRepo.FindAlertByUserId(userId, "ACTIVATED")
	if err != nil {
		return err, statusCode, alertId, message
	}

	//if len(alerts) > 0 {
	//	return err, fiber.StatusConflict, "SOS sudah berada di mode standby!"
	//}
	if len(alerts) > 0 {
		return err, fiber.StatusConflict, alertId, "SOS sudah active!"
	}

	err, statusCode, guardians, message := s.SOSRepo.FindAllByUserId(userId)
	if err != nil {
		return err, statusCode, alertId, message
	}

	if guardians == nil {
		return err, fiber.StatusNotFound, alertId, "Masukan kontak yang dipercaya terlebih dahulu!"
	}

	var alertedGuardians []AlertedGuardianDTO
	for _, guardian := range guardians {
		alertedGuardians = append(alertedGuardians, AlertedGuardianDTO{
			ContactNumber: guardian.ContactNumber,
			Name:          guardian.Name.String,
		})
	}

	alertedGuardianPayload, err := json.Marshal(alertedGuardians)
	if err != nil {
		zap.L().Error("Error marshaling guardian dto", zap.Error(err))
		return err, fiber.StatusInternalServerError, alertId, "Oops! Terjadi kesalahan"
	}

	err, statusCode, alertId, message = s.SOSRepo.SaveAlert(location, userId, alertedGuardianPayload)
	if err != nil {
		return err, statusCode, alertId, message
	}

	return err, statusCode, alertId, message
}

func (s *ServiceStruct) UpdateAlert(action string, location *AlertRequestDTO, userId uuid.UUID) (err error, statusCode int, message string) {
	err, statusCode, alerts, message := s.SOSRepo.FindAlertByUserId(userId, "ACTIVATED")
	if err != nil {
		return err, statusCode, message
	}

	if len(alerts) <= 0 {
		return err, fiber.StatusNotFound, "Tidak ada sos yang menyala!"
	}

	return s.SOSRepo.UpdateAlert(action, location, alerts[0].ID)
}

func (s *ServiceStruct) GetAllActivatedAlert(userId uuid.UUID) (err error, statusCode int, dto []GetAllActivatedAlertResponseDTO, message string) {
	err, statusCode, guardian, message := s.UserRepo.FindUserById(userId)
	if err != nil {
		return err, statusCode, nil, message
	}

	err, statusCode, alerts, message := s.SOSRepo.FindAlertByGuardian("ACTIVATED", guardian.PhoneNumber)
	if err != nil {
		return err, statusCode, nil, message
	}

	if len(alerts) <= 0 {
		dto = make([]GetAllActivatedAlertResponseDTO, 0)
	} else {
		for _, alert := range alerts {
			dto = append(dto, GetAllActivatedAlertResponseDTO{
				ID:          alert.ID,
				UserID:      alert.UserId,
				ActivatedAt: alert.ActivatedAt.Time,
				Name:        alert.Name.String,
				PhoneNumber: alert.PhoneNumber,
			})
		}
	}

	return nil, fiber.StatusOK, dto, "Activated alert retrieved successfully!"
}

func (s *ServiceStruct) TrackAlert(userId uuid.UUID, alertId uuid.UUID) (err error, statusCode int, dto TrackAlertResponseDTO, message string) {

	err, statusCode, alert, message := s.SOSRepo.FindAlertById(alertId)
	if err != nil {
		return err, statusCode, dto, message
	}

	dto = TrackAlertResponseDTO{
		User: GetAllActivatedAlertResponseDTO{
			ID:          alert.ID,
			UserID:      userId,
			Name:        alert.Name.String,
			PhoneNumber: alert.PhoneNumber,
			ActivatedAt: alert.ActivatedAt.Time,
		},
		Location: AlertRequestDTO{
			Longitude: alert.LatestLongitude,
			Latitude:  alert.LatestLatitude,
		},
	}

	return nil, fiber.StatusOK, dto, "!"
}
