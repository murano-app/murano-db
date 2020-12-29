ALTER TABLE t_table
ADD COLUMN table_uuid uuid unique default uuid_generate_v4() NOT NULL;

CREATE INDEX idx_table_uuid ON t_table (table_uuid);