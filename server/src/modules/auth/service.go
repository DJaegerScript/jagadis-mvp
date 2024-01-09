package auth

import (
	"crypto/rand"
	"encoding/base64"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
	"golang.org/x/crypto/bcrypt"
	"jagadis/src/modules/user"
	"time"
)

type Service interface {
	Register(registrationBody *RegistrationRequestDTO) (err error, statusCode int, message string)
	Login(loginBody *LoginRequestDTO) (err error, statusCode int, loginResponseDTO *LoginResponseDTO, message string)
	Logout(userId uuid.UUID) (err error, statusCode int, message string)
}

type ServiceStruct struct {
	AuthRepo Repo
	UserRepo user.Repo
}

func NewService(db *pgxpool.Pool) (svc *ServiceStruct, err error) {
	authRepo := NewRepo(db)
	userRepo := user.NewRepo(db)

	svc = &ServiceStruct{
		AuthRepo: authRepo,
		UserRepo: userRepo,
	}

	return svc, err
}

func (s *ServiceStruct) Register(registrationBody *RegistrationRequestDTO) (err error, statusCode int, message string) {

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(registrationBody.Password), 10)
	if err != nil {
		zap.L().Error("Error generating password hash", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	err, statusCode, message = s.UserRepo.SaveUser(registrationBody.Email, registrationBody.PhoneNumber, string(hashedPassword))
	if err != nil {
		return err, statusCode, message
	}

	return err, statusCode, message
}

func (s *ServiceStruct) Login(loginBody *LoginRequestDTO) (err error, statusCode int, loginResponseData *LoginResponseDTO, message string) {
	err, statusCode, existingUser, message := s.UserRepo.FindUserByEmail(loginBody.Email)
	if err != nil {
		return err, statusCode, nil, message
	}

	if err = bcrypt.CompareHashAndPassword([]byte(existingUser.Password), []byte(loginBody.Password)); err != nil {
		zap.L().Error("Error generating password hash", zap.Error(err))
		return err, fiber.StatusForbidden, nil, "Email or password didn't match!"
	}

	err, statusCode, message = s.AuthRepo.InvalidateAllSession(existingUser.ID)
	if err != nil {
		return err, statusCode, nil, message
	}

	token, err, statusCode, message := s.generateToken()
	if err != nil {
		return err, statusCode, nil, message
	}

	expiredAt := time.Now().Add(7 * 24 * time.Hour)
	if err, statusCode, message = s.AuthRepo.SaveSession(existingUser.ID, token, expiredAt); err != nil {
		return err, statusCode, nil, message
	}

	response := &LoginResponseDTO{
		Token: token,
		User: user.UpdateProfileRequestDTO{
			ID:          existingUser.ID,
			Email:       existingUser.Email,
			PhoneNumber: existingUser.PhoneNumber,
			Name:        existingUser.Name.String,
			City:        existingUser.City.String,
			Gender:      existingUser.Gender.String,
			BirthDate:   existingUser.BirthDate.Time,
		},
	}

	return err, statusCode, response, ""
}

func (s *ServiceStruct) Logout(userId uuid.UUID) (err error, statusCode int, message string) {
	err, statusCode, message = s.AuthRepo.InvalidateAllSession(userId)

	return err, statusCode, message
}

func (s *ServiceStruct) generateToken() (token string, err error, statusCode int, message string) {
	tokenBytes := make([]byte, 32)
	_, err = rand.Read(tokenBytes)
	if err != nil {
		return "", err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	token = base64.StdEncoding.EncodeToString(tokenBytes)
	return token, err, fiber.StatusOK, ""
}
