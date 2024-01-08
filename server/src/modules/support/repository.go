package support

import (
	"context"

	sq "github.com/Masterminds/squirrel"
	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
)

type Repo interface {
	GetAllPersonalGuard() (err error, statusCode int, data []*Support, message string)
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

func (r *RepoStruct) GetAllPersonalGuard() (statusCode int, data []*SupportDTO, message string, err error) {
	query, args, err := r.psql.
		Select(
			"s.id",
			"s.name",
			"s.image_url",
			"s.gender",
			"s.year_of_experience",
			"s.fee",
			"pg.profession",
			"pg.city",
			"pg.type",
			"pgv.name",
			"pgv.address",
			"pgv.contact",
		).From(
		"supports s",
	).Join(
		"personal_guards pg ON pg.support_id = s.id",
	).Join(
		"personal_guard_vendors pgv ON pgv.id = pg.vendor_id",
	).ToSql()

	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return fiber.StatusInternalServerError, nil, "Oops! Something went wrong", err
	}

	ctx := context.Background()

	rows, err := r.DB.Query(ctx, query, args...)
	if err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		return fiber.StatusInternalServerError, nil, "Oops! Something went wrong", err
	}
	defer rows.Close()

	for rows.Next() {
		var support Support
		var personalGuardDTO PersonalGuardDTO
		var vendorDTO VendorDTO

		err := rows.Scan(
			&support.ID,
			&support.Name,
			&support.ImageURL,
			&support.Gender,
			&support.YearOfExperience,
			&support.Fee,
			&personalGuardDTO.Profession,
			&personalGuardDTO.Domicile,
			&personalGuardDTO.EmployerType,
			&vendorDTO.Name,
			&vendorDTO.Address,
			&vendorDTO.Contact,
		)
		if err != nil {
			zap.L().Error("Error scanning rows", zap.Error(err))
			return fiber.StatusInternalServerError, nil, "Oops! Something went wrong", err
		}

		supportDTO := &SupportDTO{
			ID:               support.ID,
			Name:             support.Name,
			ImageURL:         support.ImageURL,
			Gender:           support.Gender,
			YearOfExperience: support.YearOfExperience,
			Fee:              support.Fee,
			PersonalGuard:    &personalGuardDTO,
			Vendor:           &vendorDTO,
		}

		data = append(data, supportDTO)
	}

	return fiber.StatusOK, data, "", nil
}
