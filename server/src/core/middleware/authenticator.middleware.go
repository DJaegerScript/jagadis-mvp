package middleware

import (
	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v4/pgxpool"
	"jagadis/src/modules/auth"
	"jagadis/src/modules/common"
	"strings"
	"time"
)

type Authenticator struct {
	Repo auth.Repo
}

func New(db *pgxpool.Pool) *Authenticator {
	repo := auth.NewRepo(db)

	return &Authenticator{
		Repo: repo,
	}
}

func (a *Authenticator) TokenAuthenticator(ctx *fiber.Ctx) error {
	authorization := ctx.Get("Authorization")
	token := strings.Split(authorization, " ")[1]

	err, statusCode, session, message := a.Repo.FindTokenByContent(token)
	if err != nil {
		return common.HandleException(ctx, statusCode, message)
	}

	if time.Now().After(session.ExpiredAt) {
		err, statusCode, message = a.Repo.UpdateTokenExpiry(session.ID)
		return common.HandleException(ctx, statusCode, message)
	}

	ctx.Locals("userId", session.UserId)

	return ctx.Next()
}
