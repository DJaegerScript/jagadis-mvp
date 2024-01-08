package auth

import (
	"crypto/rand"
	"encoding/base64"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
	"golang.org/x/crypto/bcrypt"
	"time"
)

type Service interface {
	Register(registrationBody *RegistrationRequestDTO) (err error, statusCode int, message string)
	Login(loginBody *LoginRequestDTO) (err error, statusCode int, loginResponseDTO *LoginResponseDTO, message string)
	Logout(userId uuid.UUID) (err error, statusCode int, message string)
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

func (s *ServiceStruct) Register(registrationBody *RegistrationRequestDTO) (err error, statusCode int, message string) {

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(registrationBody.Password), 10)
	if err != nil {
		zap.L().Error("Error generating password hash", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	err, statusCode, message = s.Repo.Save(registrationBody, string(hashedPassword))
	if err != nil {
		return err, statusCode, message
	}

	return err, statusCode, message
}

func (s *ServiceStruct) Login(loginBody *LoginRequestDTO) (err error, statusCode int, loginResponseData *LoginResponseDTO, message string) {
	err, statusCode, user, message := s.Repo.FindByEmail(loginBody.Email)
	if err != nil {
		return err, statusCode, nil, message
	}

	if err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(loginBody.Password)); err != nil {
		zap.L().Error("Error generating password hash", zap.Error(err))
		return err, fiber.StatusForbidden, nil, "Email or password didn't match!"
	}

	token, err, statusCode, message := s.generateToken()
	if err != nil {
		return err, statusCode, nil, message
	}

	expiredAt := time.Now().Add(7 * 24 * time.Hour)
	if err, statusCode, message = s.Repo.SaveToken(user.ID, token, expiredAt); err != nil {
		return err, statusCode, nil, message
	}

	response := &LoginResponseDTO{
		Token: token,
		User: &UserDTO{
			ID:          user.ID,
			Email:       user.Email,
			PhoneNumber: user.PhoneNumber,
			Name:        user.Name.String,
			City:        user.City.String,
			Gender:      user.Gender.String,
			Birthdate:   user.BirthDate.Time,
		},
	}

	return err, statusCode, response, ""
}

func (s *ServiceStruct) Logout(userId uuid.UUID) (err error, statusCode int, message string) {
	err, statusCode, message = s.Repo.InvalidateAllToken(userId)

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
