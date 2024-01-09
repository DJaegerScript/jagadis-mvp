package user

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
)

type Repo interface {
	SaveUser(email string, phoneNumber string, password string) (err error, statusCode int, message string)
	UpdateUser(user UpdateProfileRequestDTO, userId uuid.UUID) (err error, statusCode int, message string)
	FindUserById(userId uuid.UUID) (err error, statusCode int, user Users, message string)
	FindUserByEmail(email string) (err error, statusCode int, user Users, message string)
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

func (r *RepoStruct) SaveUser(email string, phoneNumber string, password string) (err error, statusCode int, message string) {
	queryStatement := r.psql.Insert("users").Columns("phone_number", "email", "password")

	queryStatement = queryStatement.Values(
		phoneNumber,
		strings.ToLower(email),
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

func (r *RepoStruct) UpdateUser(user UpdateProfileRequestDTO, userId uuid.UUID) (err error, statusCode int, message string) {
	query, args, err := r.psql.Update("users").
		Where(sq.Eq{
			"id": userId,
		}).
		SetMap(map[string]interface{}{
			"name":         user.Name,
			"email":        user.Email,
			"phone_number": user.PhoneNumber,
			"gender":       user.Gender,
			"city":         user.City,
			"birthdate":    user.BirthDate,
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

func (r *RepoStruct) FindUserById(userId uuid.UUID) (err error, statusCode int, user Users, message string) {
	query, args, err := r.psql.Select("*").From("users").Where(sq.Eq{
		"id": userId,
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

func (r *RepoStruct) FindUserByEmail(email string) (err error, statusCode int, user Users, message string) {
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
