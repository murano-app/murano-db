CREATE TABLE t_client
(
    id                   bigserial PRIMARY KEY,
    email                varchar(100) NOT NULL UNIQUE,
    name                 varchar(100) NOT NULL,
    default_localization varchar(2)   NOT NULL DEFAULT ('en'),
    currency             varchar(3)   NOT NULL
);

-- RESTAURANT CHANGES

-- migrate data FROM t_restaurant
INSERT INTO t_client (email, name, default_localization, currency)
SELECT replace(r.name, ' ', '') || '@example.com', r.name, r.default_localization, r.currency
FROM t_restaurant r;

--add reference to t_client
ALTER TABLE t_restaurant
    ADD COLUMN client_id bigint REFERENCES t_client (id);
UPDATE t_restaurant
SET client_id = (SELECT cl.id FROM t_client cl WHERE cl.name = t_restaurant.name)
WHERE true;
ALTER TABLE t_restaurant
    ALTER COLUMN client_id SET NOT NULL;

--DROP migrated columns
ALTER TABLE t_restaurant
    DROP COLUMN currency;
ALTER TABLE t_restaurant
    DROP COLUMN default_localization;


-- CATEGORY CHANGES
ALTER TABLE t_category
    ADD COLUMN client_id bigint REFERENCES t_client (id);

UPDATE t_category
SET client_id = (SELECT cl.id
                 FROM t_client cl
                          JOIN t_restaurant r ON r.client_id = cl.id
                 WHERE r.id = t_category.restaurant_id)
WHERE true;

ALTER TABLE t_category
    ALTER COLUMN client_id SET NOT NULL;

ALTER TABLE t_category
    DROP COLUMN restaurant_id;
