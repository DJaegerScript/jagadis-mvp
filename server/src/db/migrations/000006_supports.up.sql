BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS supports (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    support_type_id UUID NOT NULL,
    name VARCHAR NOT NULL,
    image_url VARCHAR NOT NULL,
    year_of_experience INT NOT NULL DEFAULT 0,
    gender VARCHAR NOT NULL,
    fee INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (support_type_id) REFERENCES support_types(id)
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

CREATE TRIGGER set_supports_updated_at
    AFTER UPDATE ON supports
    FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();

COMMIT;