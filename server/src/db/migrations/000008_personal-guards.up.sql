BEGIN;

CREATE TYPE personal_guard_types AS ENUM ('AGENCY', 'INDIVIDUAL');

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS personal_guards (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    support_id UUID NOT NULL,
    profession VARCHAR NOT NULL,
    city VARCHAR NOT NULL,
    vendor_id UUID,
    type personal_guard_types NOT NULL DEFAULT 'AGENCY',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (support_id) REFERENCES supports(id),
    FOREIGN KEY (vendor_id) REFERENCES personal_guard_vendors(id)
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
    AFTER UPDATE ON personal_guards
    FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();

COMMIT;