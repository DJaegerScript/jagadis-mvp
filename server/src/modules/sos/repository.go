package sos

import (
	"context"
	"encoding/json"
	"errors"
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
	SaveAlert(location *AlertRequestDTO, userId uuid.UUID, alertedGuardians []byte) (err error, statusCode int, message string)
	FindAlertByUserId(userId uuid.UUID, action string) (err error, statusCode int, alerts []Alerts, message string)
	UpdateAlert(action string, location *AlertRequestDTO, alertId uuid.UUID) (err error, statusCode int, message string)
	FindAlertByGuardian(status string, phoneNumber string) (err error, statusCode int, alerts []AlertDTO, message string)
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

	res, err := r.DB.Exec(ctx, query, args...)
	if err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		return err, fiber.StatusInternalServerError, "Oops! Something went wrong"
	}

	if res.RowsAffected() <= 0 {
		zap.L().Error("No guardian record found", zap.Error(err))
		return errors.New("record not found"), fiber.StatusNotFound, "Penerima sinyal tidak ditemukan!"
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

func (r *RepoStruct) SaveAlert(location *AlertRequestDTO, userId uuid.UUID, alertedGuardians []byte) (err error, statusCode int, message string) {
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

func (r *RepoStruct) FindAlertByUserId(userId uuid.UUID, action string) (err error, statusCode int, alerts []Alerts, message string) {
	var conditions map[string]interface{}

	if action != "" {
		conditions = sq.Eq{
			"user_id": userId,
			"status":  action,
		}
	} else {
		conditions = sq.Eq{
			"user_id": userId,
		}
	}

	query, args, err := r.psql.Select("*").From("alerts").
		Where(conditions).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, alerts, "Oops! Something went wrong"
	}

	ctx := context.Background()

	rows, err := r.DB.Query(ctx, query, args...)
	if err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
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

func (r *RepoStruct) UpdateAlert(action string, location *AlertRequestDTO, alertId uuid.UUID) (err error, statusCode int, message string) {
	queryStatement := r.psql.Update("alerts").
		Where(sq.Eq{
			"id": alertId,
		})

	if action == "ACTIVATED" {
		queryStatement = queryStatement.
			SetMap(map[string]interface{}{
				"status":           action,
				"activated_at":     time.Now(),
				"latest_latitude":  location.Latitude,
				"latest_longitude": location.Longitude,
			})
	} else if action == "TURNED_OFF" {
		queryStatement = queryStatement.
			SetMap(map[string]interface{}{
				"status":           action,
				"turned_off_at":    time.Now(),
				"latest_latitude":  location.Latitude,
				"latest_longitude": location.Longitude,
			})
	} else {
		queryStatement = queryStatement.
			SetMap(map[string]interface{}{
				"latest_latitude":  location.Latitude,
				"latest_longitude": location.Longitude,
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

func (r *RepoStruct) FindAlertByGuardian(status string, phoneNumber string) (err error, statusCode int, alerts []AlertDTO, message string) {

	query, args, err := r.psql.Select("alerts.*, u.name, u.phone_number").
		From("alerts").
		Join("public.users u ON alerts.user_id = u.id").
		Where(sq.Eq{"status": status}).
		ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return err, fiber.StatusInternalServerError, alerts, "Oops! Something went wrong"
	}

	ctx := context.Background()

	rows, err := r.DB.Query(ctx, query, args...)
	if err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		return err, fiber.StatusInternalServerError, alerts, "Oops! Something went wrong"
	}

	for rows.Next() {
		var alert AlertDTO

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
			&alert.Name,
			&alert.PhoneNumber,
		)
		if err != nil {
			zap.L().Error("Error scanning row data", zap.Error(err))
			return err, fiber.StatusInternalServerError, alerts, "Oops! Something went wrong"
		}

		var alertedGuardians []AlertedGuardianDTO
		err = json.Unmarshal(alert.Guardians, &alertedGuardians)
		if err != nil {
			zap.L().Error("Error unmarshalling guardian", zap.Error(err))
			return err, fiber.StatusInternalServerError, nil, "Oops! Something went wrong"
		}

		for _, guardian := range alertedGuardians {
			if guardian.ContactNumber == phoneNumber {
				alerts = append(alerts, alert)
			}
		}

	}

	return nil, fiber.StatusOK, alerts, ""
}
