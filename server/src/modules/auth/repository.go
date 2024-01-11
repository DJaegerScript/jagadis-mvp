package auth

import (
	"context"
	sq "github.com/Masterminds/squirrel"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
	"time"
)

type Repo interface {
	SaveSession(userId uuid.UUID, token string, expiredAt time.Time) (err error, statusCode int, message string)
	FindSessionByToken(token string) (err error, statusCode int, session Sessions, message string)
	UpdateSessionExpiry(tokenId uuid.UUID) (err error, statusCode int, message string)
	InvalidateAllSession(userId uuid.UUID) (err error, statusCode int, message string)
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
			return err, fiber.StatusUnauthorized, session, "No active session"
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
