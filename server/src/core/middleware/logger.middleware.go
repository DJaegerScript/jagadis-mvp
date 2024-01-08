package middleware

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"io"
	"log"
	"os"
	"time"
)

var (
	HttpLoger *zap.Logger
)

func createDirectory() {
	path, _ := os.Getwd()

	if _, err := os.Stat(fmt.Sprintf("%s/logs", path)); os.IsNotExist(err) {
		os.Mkdir("logs", os.ModePerm)
	}
}

func getLogWritter() zapcore.WriteSyncer {
	path, err := os.Getwd()
	if err != nil {
		log.Panic("get os wd", err.Error())
	}

	if os.Getenv("ENVIRONMENT") == "dev" {
		createDirectory()
		file, err := os.OpenFile(path+"/logs/logs.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
		if err != nil {
			log.Panic("open file path", err.Error())
		}
		mw := io.MultiWriter(os.Stdout, file)
		return zapcore.AddSync(mw)

	}
	return zapcore.AddSync(os.Stdout)

}

func NewLogger() {
	ws := getLogWritter()
	conf := zap.NewProductionEncoderConfig()
	conf.EncodeTime = zapcore.RFC3339TimeEncoder
	conf.TimeKey = "timestamp"
	enc := zapcore.NewJSONEncoder(conf)

	core := zapcore.NewCore(enc, ws, zapcore.DebugLevel)
	logger := zap.New(core, zap.AddCaller(), zap.AddStacktrace(zap.ErrorLevel))
	zap.ReplaceGlobals(logger)

	conf.MessageKey = zapcore.OmitKey
	conf.CallerKey = zapcore.OmitKey

	enc = zapcore.NewJSONEncoder(conf)
	core = zapcore.NewCore(enc, ws, zapcore.DebugLevel)
	HttpLoger = zap.New(core)

}

func Logger() func(c *fiber.Ctx) error {
	return func(c *fiber.Ctx) error {

		t := time.Now()
		defer func() {
			HttpLoger.Info("request",
				zap.String("method", c.Method()),
				zap.String("path", string(c.Request().URI().RequestURI())),
				zap.String("duration", time.Since(t).String()),
				zap.Int("status", c.Response().StatusCode()),
				zap.Any("ip addresses", c.IPs()),
			)
		}()

		return c.Next()
	}
}
