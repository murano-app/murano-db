ALTER TABLE t_client
    ADD COLUMN uuid uuid unique default uuid_generate_v4() NOT NULL;
