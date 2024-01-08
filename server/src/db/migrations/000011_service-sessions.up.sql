BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS service_sessions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL,
    support_id UUID NOT NULL,
    location VARCHAR NOT NULL,
    started_at TIMESTAMP NOT NULL ,
    finished_at TIMESTAMP NOT NULL ,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (support_id) REFERENCES supports(id)
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

CREATE TRIGGER set_service_sessions_updated_at
    AFTER UPDATE ON service_sessions
    FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();

COMMIT;