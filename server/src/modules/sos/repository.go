package sos

import (
	"context"
	sq "github.com/Masterminds/squirrel"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgconn"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
	"time"
)

type Repo interface {
	Save(phoneNumber string, uuid uuid.UUID, name string) (err error, statusCode int, message string)
	FindAllByUserId(userId uuid.UUID) (err error, statusCode int, guardians []Guardians, message string)
	DeleteById(guardianId uuid.UUID, userId uuid.UUID) (err error, statusCode int, message string)
	DeleteByUserId(userId uuid.UUID) (err error, statusCode int, message string)
	SaveAlert(location *EnterStandByModeRequestDTO, userId uuid.UUID, alertedGuardians []byte) (err error, statusCode int, message string)
	FindAlertByUserId(userId uuid.UUID) (err error, statusCode int, alerts []Alerts, message string)
	UpdateAlert(action string, userId uuid.UUID, alertId uuid.UUID) (err error, statusCode int, message string)
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

func (r *RepoStruct) Save(phoneNumber string, userId uuid.UUID, name string) (err error, statusCode int, message string) {
	query, args, err := r.psql.Insert("guardians").
		Columns("user_id", "contact_number", "name").
		Values(
			userId,
			phoneNumber,
			name,
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
	query, args, err := r.psql.Select("id", "contact_number", "name").From("guardians").
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
			&guardian.Name,
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

func (r *RepoStruct) SaveAlert(location *EnterStandByModeRequestDTO, userId uuid.UUID, alertedGuardians []byte) (err error, statusCode int, message string) {
	query, args, err := r.psql.Insert("alerts").
		Columns("user_id", "latest_longitude", "latest_latitude", "guardians", "standby_at").
		Values(
			userId,
			&location.Longitude,
			&location.Latitude,
			alertedGuardians,
			time.Now(),
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

	return nil, fiber.StatusCreated, ""
}

func (r *RepoStruct) FindAlertByUserId(userId uuid.UUID) (err error, statusCode int, alerts []Alerts, message string) {
	query, args, err := r.psql.Select("*").From("alerts").
		Where(sq.Eq{
			"user_id": userId,
		},
		).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, alerts, "Oops! Something went wrong"
	}

	ctx := context.Background()

	rows, err := r.DB.Query(ctx, query, args...)
	if err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		statusCode = fiber.StatusInternalServerError
		return err, fiber.StatusInternalServerError, alerts, "Oops! Something went wrong"
	}

	for rows.Next() {
		var alert Alerts

		err = rows.Scan(
			&alert.ID,
			&alert.UserId,
			&alert.Status,
			&alert.LatestLongitude,
			&alert.LatestLatitude,
			&alert.Guardians,
			&alert.StandByAt,
			&alert.ActivatedAt,
			&alert.TurnedOffAt,
		)
		if err != nil {
			zap.L().Error("Error scanning row data", zap.Error(err))
			return
		}

		alerts = append(alerts, alert)
	}

	return nil, fiber.StatusOK, alerts, ""
}

func (r *RepoStruct) UpdateAlert(action string, userId uuid.UUID, alertId uuid.UUID) (err error, statusCode int, message string) {
	queryStatement := r.psql.Update("alerts").
		Where(sq.Eq{
			"id":      alertId,
			"user_id": userId,
		})

	if action == "ACTIVATED" {
		queryStatement = queryStatement.
			SetMap(map[string]interface{}{
				"status":       action,
				"activated_at": time.Now(),
			})
	} else {
		queryStatement = queryStatement.
			SetMap(map[string]interface{}{
				"status":        action,
				"turned_off_at": time.Now(),
			})
	}

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

	return nil, fiber.StatusOK, ""
}
