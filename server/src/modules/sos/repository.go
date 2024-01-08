package sos

import (
	"context"
	sq "github.com/Masterminds/squirrel"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgconn"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
)

type Repo interface {
	Save(phoneNumber string, uuid uuid.UUID) (err error, statusCode int, message string)
	FindAllByUserId(userId uuid.UUID) (err error, statusCode int, guardians []Guardians, message string)
	DeleteById(guardianId uuid.UUID, userId uuid.UUID) (err error, statusCode int, message string)
	DeleteByUserId(userId uuid.UUID) (err error, statusCode int, message string)
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

func (r *RepoStruct) Save(phoneNumber string, userId uuid.UUID) (err error, statusCode int, message string) {
	query, args, err := r.psql.Insert("guardians").
		Columns("user_id", "contact_number").
		Values(
			userId,
			phoneNumber,
		).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	ctx := context.Background()

	if _, err = r.DB.Exec(ctx, query, args...); err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		if pge, pgok := err.(*pgconn.PgError); pgok {
			if pge.Code == "23505" {
				return err, fiber.StatusConflict, "Contact number already registered!"
			}
		}
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	return nil, fiber.StatusCreated, ""
}

func (r *RepoStruct) FindAllByUserId(userId uuid.UUID) (err error, statusCode int, guardians []Guardians, message string) {
	query, args, err := r.psql.Select("id", "contact_number").From("guardians").
		Where(sq.Eq{
			"user_id": userId,
		},
		).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, guardians, "Oops! Something went wrong"
	}

	ctx := context.Background()

	rows, err := r.DB.Query(ctx, query, args...)
	if err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		statusCode = fiber.StatusInternalServerError
		return err, fiber.StatusInternalServerError, guardians, "Oops! Something went wrong"
	}

	for rows.Next() {
		var guardian Guardians

		err = rows.Scan(
			&guardian.ID,
			&guardian.ContactNumber,
		)
		if err != nil {
			zap.L().Error("Error scanning row data", zap.Error(err))
			return
		}

		guardians = append(guardians, guardian)
	}

	return nil, fiber.StatusOK, guardians, ""
}

func (r *RepoStruct) DeleteById(guardianId uuid.UUID, userId uuid.UUID) (err error, statusCode int, message string) {
	query, args, err := r.psql.Delete("guardians").
		Where(sq.Eq{
			"id":      guardianId,
			"user_id": userId,
		},
		).ToSql()
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

func (r *RepoStruct) DeleteByUserId(userId uuid.UUID) (err error, statusCode int, message string) {
	query, args, err := r.psql.Delete("guardians").
		Where(sq.Eq{
			"user_id": userId,
		},
		).ToSql()
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
