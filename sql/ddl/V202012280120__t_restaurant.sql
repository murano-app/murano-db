CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

ALTER TABLE t_restaurant
    ADD COLUMN restaurant_uuid uuid unique default uuid_generate_v4() NOT NULL;

CREATE INDEX idx_restaurant_uuid ON t_restaurant (restaurant_uuid);