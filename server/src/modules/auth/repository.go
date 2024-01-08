package auth

import (
	"context"
	sq "github.com/Masterminds/squirrel"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgconn"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
	"strings"
	"time"
)

type Repo interface {
	Save(data *RegistrationRequestDTO, password string) (err error, statusCode int, message string)
	FindByEmail(email string) (err error, statusCode int, user Users, message string)
	SaveSession(userId uuid.UUID, token string, expiredAt time.Time) (err error, statusCode int, message string)
	FindSessionByToken(token string) (err error, statusCode int, session Sessions, message string)
	UpdateSessionExpiry(tokenId uuid.UUID) (err error, statusCode int, message string)
	InvalidateAllSession(userId uuid.UUID) (err error, statusCode int, message string)
	FindUserByPhoneNumber(phoneNumber string) (err error, statusCode int, user Users, message string)
}

type RepoStruct struct {
	DB   *pgxpool.Pool
	psql sq.StatementBuilderType
}

func NewRepo(db *pgxpool.Pool) *RepoStruct {
	return &RepoStruct{
		DB:   db,
		psql: sq.StatementBuilder.PlaceholderFormat(sq.Dollar),
	}
}

func (r *RepoStruct) Save(data *RegistrationRequestDTO, password string) (err error, statusCode int, message string) {
	queryStatement := r.psql.Insert("users").Columns("phone_number", "email", "password")

	queryStatement = queryStatement.Values(
		data.PhoneNumber,
		strings.ToLower(data.Email),
		password,
	)

	query, args, err := queryStatement.ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	ctx := context.Background()

	if _, err = r.DB.Exec(ctx, query, args...); err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		if pge, pgok := err.(*pgconn.PgError); pgok {
			if pge.Code == "23505" {
				if pge.ConstraintName == "users_phone_number_key" {
					message = "Phone number already registered!"
				} else if pge.ConstraintName == "users_email_key" {
					message = "Email number already registered!"
				}

				return err, fiber.StatusConflict, message
			}
		}

		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	return nil, fiber.StatusCreated, ""
}

func (r *RepoStruct) FindByEmail(email string) (err error, statusCode int, user Users, message string) {
	query, args, err := r.psql.Select("*").From("users").Where(sq.Eq{
		"email": strings.ToLower(email),
	}).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, user, "Oops! Something went wrong"
	}

	ctx := context.Background()

	err = r.DB.QueryRow(ctx, query, args...).Scan(
		&user.ID,
		&user.Name,
		&user.Email,
		&user.PhoneNumber,
		&user.Password,
		&user.Gender,
		&user.City,
		&user.BirthDate,
		&user.CreatedAt,
		&user.UpdatedAt,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			zap.L().Error("User not found", zap.Error(err))
			return err, fiber.StatusNotFound, user, "User not found!"
		}
		zap.L().Error("Error executing query", zap.Error(err))
		statusCode = fiber.StatusInternalServerError
		return err, fiber.StatusInternalServerError, user, "Oops! Something went wrong"
	}

	return nil, fiber.StatusOK, user, ""
}

func (r *RepoStruct) SaveSession(userId uuid.UUID, token string, expiredAt time.Time) (err error, statusCode int, message string) {
	queryStatement := r.psql.Insert("sessions").Columns("user_id", "token", "expired_at")

	queryStatement = queryStatement.Values(
		userId,
		token,
		expiredAt,
	)

	query, args, err := queryStatement.ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	ctx := context.Background()

	if _, err = r.DB.Exec(ctx, query, args...); err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	return nil, fiber.StatusCreated, ""
}

func (r *RepoStruct) FindUserByPhoneNumber(phoneNumber string) (err error, statusCode int, user Users, message string) {
	query, args, err := r.psql.Select("*").From("users").Where(sq.Eq{
		"phone_number": phoneNumber,
	}).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, user, "Oops! Something went wrong"
	}

	ctx := context.Background()

	err = r.DB.QueryRow(ctx, query, args...).Scan(
		&user.ID,
		&user.Name,
		&user.Email,
		&user.PhoneNumber,
		&user.Password,
		&user.Gender,
		&user.City,
		&user.BirthDate,
		&user.CreatedAt,
		&user.UpdatedAt,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			zap.L().Error("User not found", zap.Error(err))
			return err, fiber.StatusNotFound, user, "User not found!"
		}
		zap.L().Error("Error executing query", zap.Error(err))
		statusCode = fiber.StatusInternalServerError
		return err, fiber.StatusInternalServerError, user, "Oops! Something went wrong"
	}

	return nil, fiber.StatusOK, user, ""
}

func (r *RepoStruct) FindSessionByToken(token string) (err error, statusCode int, session Sessions, message string) {
	query, args, err := r.psql.
		Select("id", "user_id", "is_expired", "expired_at").
		From("sessions").
		Where(sq.Eq{
			"token":      token,
			"is_expired": false,
		}).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, session, "Oops! Something went wrong"
	}

	ctx := context.Background()

	err = r.DB.QueryRow(ctx, query, args...).Scan(
		&session.ID,
		&session.UserId,
		&session.IsExpired,
		&session.ExpiredAt,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			zap.L().Error("Session not found", zap.Error(err))
			return err, fiber.StatusForbidden, session, "No active session"
		}
		zap.L().Error("Error executing query", zap.Error(err))
		statusCode = fiber.StatusInternalServerError
		return err, fiber.StatusInternalServerError, session, "Oops! Something went wrong"
	}

	return nil, fiber.StatusOK, session, ""
}

func (r *RepoStruct) UpdateSessionExpiry(tokenId uuid.UUID) (err error, statusCode int, message string) {
	query, args, err := r.psql.Update("sessions").Where(sq.Eq{
		"id": tokenId,
	}).SetMap(map[string]interface{}{
		"is_expired": true,
	}).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	ctx := context.Background()

	if _, err = r.DB.Exec(ctx, query, args...); err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	return nil, fiber.StatusUnauthorized, "Session expired!"
}

func (r *RepoStruct) InvalidateAllSession(userId uuid.UUID) (err error, statusCode int, message string) {
	query, args, err := r.psql.Update("sessions").Where(sq.Eq{
		"user_id":    userId,
		"is_expired": false,
	}).SetMap(map[string]interface{}{
		"is_expired": true,
	}).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	ctx := context.Background()

	if _, err = r.DB.Exec(ctx, query, args...); err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	return nil, fiber.StatusOK, ""
}
