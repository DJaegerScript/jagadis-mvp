BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR,
    email VARCHAR NOT NULL UNIQUE ,
    phone_number VARCHAR NOT NULL UNIQUE,
    password TEXT NOT NULL,
    gender VARCHAR,
    city VARCHAR,
    birthdate DATE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
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

CREATE TRIGGER set_users_updated_at
    AFTER UPDATE ON users
    FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();

COMMIT;