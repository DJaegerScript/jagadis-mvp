package support

import (
	"context"

	sq "github.com/Masterminds/squirrel"
	"github.com/gofiber/fiber/v2"
	"github.com/gofrs/uuid"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
	"go.uber.org/zap"
)

type Repo interface {
	GetAllPersonalGuard() (statusCode int, personalGuards []*PersonalGuard, message string, err error)
	GetAllTherapist() (statusCode int, therapists []*Therapist, message string, err error)
	GetSupportByID(supportId uuid.UUID) (statusCode int, support *Support, message string, err error)
	GetPersonalGuardVendorByID(vendorId uuid.UUID) (statusCode int, vendor *PersonalGuardVendor, message string, err error)
	GetTherapistVendorByID(vendorId uuid.UUID) (statusCode int, vendor *TherapistVendor, message string, err error)
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

func (r *RepoStruct) GetSupportByID(supportId uuid.UUID) (statusCode int, support *Support, message string, err error) {
	query, args, err := r.psql.Select("id", "support_type_id", "name", "image_url", "year_of_experience", "gender", "fee").From("supports").Where(sq.Eq{"id": supportId}).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return fiber.StatusInternalServerError, support, "Oops! Something went wrong", err
	}

	ctx := context.Background()

	err = r.DB.QueryRow(ctx, query, args...).Scan(
		&support.ID,
		&support.SupportTypeID,
		&support.Name,
		&support.ImageURL,
		&support.YearOfExperience,
		&support.Gender,
		&support.Fee,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			zap.L().Error("Support not found", zap.Error(err))
			return fiber.StatusNotFound, support, "Support not found!", err
		}
		zap.L().Error("Error executing query", zap.Error(err))
		statusCode = fiber.StatusInternalServerError
		return fiber.StatusInternalServerError, support, "Oops! Something went wrong", err
	}

	return fiber.StatusOK, support, "Success", nil
}

func (r *RepoStruct) GetAllPersonalGuard() (statusCode int, personalGuards []*PersonalGuard, message string, err error) {
	query, args, err := r.psql.Select("id", "support_id", "profession", "city", "vendor_id", "type").From("personal_guards").ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return fiber.StatusInternalServerError, personalGuards, "Oops! Something went wrong", err
	}

	ctx := context.Background()

	rows, err := r.DB.Query(ctx, query, args...)
	if err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		statusCode = fiber.StatusInternalServerError
		return fiber.StatusInternalServerError, personalGuards, "Oops! Something went wrong", err
	}

	for rows.Next() {
		var personalGuard PersonalGuard

		err = rows.Scan(&personalGuard.ID, &personalGuard.SupportID, &personalGuard.Profession, &personalGuard.City, &personalGuard.VendorID, &personalGuard.Type)

		if err != nil {
			zap.L().Error("Error scanning row data", zap.Error(err))
			return
		}

		personalGuards = append(personalGuards, &personalGuard)
	}

	return fiber.StatusOK, personalGuards, "Success", nil
}

func (r *RepoStruct) GetPersonalGuardVendorByID(vendorId uuid.UUID) (statusCode int, vendor *PersonalGuardVendor, message string, err error) {
	query, args, err := r.psql.Select("id", "name", "address", "contact").From("personal_guard_vendors").Where(sq.Eq{"id": vendorId}).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return fiber.StatusInternalServerError, vendor, "Oops! Something went wrong", err
	}

	ctx := context.Background()

	err = r.DB.QueryRow(ctx, query, args...).Scan(
		&vendor.ID,
		&vendor.Name,
		&vendor.Address,
		&vendor.Contact,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			zap.L().Error("Vendor not found", zap.Error(err))
			return fiber.StatusNotFound, vendor, "Vendor not found!", err
		}
		zap.L().Error("Error executing query", zap.Error(err))
		statusCode = fiber.StatusInternalServerError
		return fiber.StatusInternalServerError, vendor, "Oops! Something went wrong", err
	}

	return fiber.StatusOK, vendor, "Success", nil
}

func (r *RepoStruct) GetAllTherapist() (statusCode int, therapists []*Therapist, message string, err error) {
	query, args, err := r.psql.Select("id", "support_id", "speciality", "education", "vendor_id").From("therapists").ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return fiber.StatusInternalServerError, therapists, "Oops! Something went wrong", err
	}

	ctx := context.Background()

	rows, err := r.DB.Query(ctx, query, args...)
	if err != nil {
		zap.L().Error("Error executing query", zap.Error(err))
		statusCode = fiber.StatusInternalServerError
		return fiber.StatusInternalServerError, therapists, "Oops! Something went wrong", err
	}

	for rows.Next() {
		var therapist Therapist

		err = rows.Scan(&therapist.ID, &therapist.SupportID, &therapist.Speciality, &therapist.Education, &therapist.VendorID)

		if err != nil {
			zap.L().Error("Error scanning row data", zap.Error(err))
			return
		}

		therapists = append(therapists, &therapist)
	}

	return fiber.StatusOK, therapists, "Success", nil
}

func (r *RepoStruct) GetTherapistVendorByID(vendorId uuid.UUID) (statusCode int, vendor *TherapistVendor, message string, err error) {
	query, args, err := r.psql.Select("id", "name", "address", "contact").From("therapist_vendors").Where(sq.Eq{"id": vendorId}).ToSql()
	if err != nil {
		zap.L().Error("Error building query", zap.Error(err))
		return fiber.StatusInternalServerError, vendor, "Oops! Something went wrong", err
	}

	ctx := context.Background()

	err = r.DB.QueryRow(ctx, query, args...).Scan(
		&vendor.ID,
		&vendor.Name,
		&vendor.Address,
		&vendor.Contact,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			zap.L().Error("Vendor not found", zap.Error(err))
			return fiber.StatusNotFound, vendor, "Vendor not found!", err
		}
		zap.L().Error("Error executing query", zap.Error(err))
		statusCode = fiber.StatusInternalServerError
		return fiber.StatusInternalServerError, vendor, "Oops! Something went wrong", err
	}

	return fiber.StatusOK, vendor, "Success", nil
}
