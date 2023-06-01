ALTER TABLE t_restaurant
    ADD COLUMN restaurant_key varchar(100) UNIQUE;

UPDATE t_restaurant
SET restaurant_key = name;

ALTER TABLE t_restaurant
    ADD CONSTRAINT uq_t_restaurant_restaurant_key UNIQUE (restaurant_key);

