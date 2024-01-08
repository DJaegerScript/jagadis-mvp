BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS therapists (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    support_id UUID NOT NULL,
    specialty VARCHAR NOT NULL,
    education VARCHAR NOT NULL,
    vendor_id UUID,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (support_id) REFERENCES supports(id),
    FOREIGN KEY (vendor_id) REFERENCES therapist_vendors(id)
);

CREATE OR REPLACE FUNCTION set_updated_at()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE TRIGGER set_personal_guards_updated_at
    AFTER UPDATE ON therapists
    FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();

COMMIT;