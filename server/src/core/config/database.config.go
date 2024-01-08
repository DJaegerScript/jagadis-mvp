package config

import (
	"context"
	"github.com/gofiber/storage/redis/v3"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
	"os"
)

func InitDatabase() (db *pgxpool.Pool) {
	dbUrl := os.Getenv("DATABASE_URL")

	ctx := context.Background()
	db, err := pgxpool.Connect(ctx, dbUrl)
	if err != nil {
		zap.L().Fatal("DB Connection", zap.Error(err))
	}

	return db
}

func InitRedis() (redisStorage *redis.Storage) {
	redisStorage = redis.New(redis.Config{
		URL:   os.Getenv("REDIS_URL"),
		Reset: false,
	})
	return redisStorage
}
