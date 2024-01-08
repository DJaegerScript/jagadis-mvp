BEGIN;

CREATE TYPE service_payment_statuses AS ENUM ('NOT_PAID', 'PENDING', 'SUCCESS');

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS service_payments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    service_session_id UUID NOT NULL,
    virtual_account_number VARCHAR NOT NULL,
    status service_payment_statuses NOT NULL DEFAULT 'NOT_PAID',
    payment_method VARCHAR NOT NULL,
    total_amount INT NOT NULL,
    payload INT NOT NULL,
    expired_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (service_session_id) REFERENCES service_sessions(id)
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

CREATE TRIGGER set_service_payments_updated_at
    AFTER UPDATE ON service_payments
    FOR EACH ROW
EXECUTE PROCEDURE set_updated_at();

COMMIT;