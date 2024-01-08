BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS guardians (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL,
    contact_number TEXT NOT NULL ,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE (user_id, contact_number)
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

CREATE TRIGGER set_guardians_updated_at
    AFTER UPDATE ON guardians
    FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();

COMMIT;