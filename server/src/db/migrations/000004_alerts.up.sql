BEGIN;

CREATE TYPE alert_statuses AS ENUM ('STANDBY', 'ACTIVATED', 'TURNED_OFF');

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS alerts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL,
    status alert_statuses DEFAULT 'STANDBY',
    latest_longitude FLOAT NOT NULL,
    latest_latitude FLOAT NOT NULL,
    guardians json,
    standby_at TIMESTAMP,
    activated_at TIMESTAMP,
    turned_off_at TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

COMMIT;