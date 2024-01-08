package main

import (
	"github.com/joho/godotenv"
	"go.uber.org/zap"
	"jagadis/src/core/config"
	"math/rand"
	"os"
	"time"
)

func main() {
	rand.New(rand.NewSource(time.Now().UTC().UnixNano()))
	err := godotenv.Load()
	if err != nil {
		zap.L().Fatal("Failed to get env var", zap.Error(err))
	}

	s := config.MakeServer()
	defer func() {
		s.DB.Close()
	}()

	port := os.Getenv("PORT")
	err = s.Router.Listen(":" + port)
	if err != nil {
		zap.L().Fatal("Failed to listen port "+port, zap.Error(err))
	}
}
