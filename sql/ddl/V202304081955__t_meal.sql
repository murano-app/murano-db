ALTER TABLE t_meal
ADD COLUMN meal_uuid uuid unique default uuid_generate_v4() NOT NULL;

CREATE INDEX idx_meal_uuid ON t_table (meal_uuid)