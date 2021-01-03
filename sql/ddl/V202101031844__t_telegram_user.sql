-- add restaurant id column
ALTER TABLE t_telegram_user
ADD COLUMN restaurant_id bigint;

ALTER TABLE t_telegram_user
    ADD CONSTRAINT fk_telegram_user_restaurant_id
    FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id);

UPDATE t_telegram_user SET restaurant_id =
    (SELECT id FROM t_restaurant LIMIT 1)
WHERE TRUE;

-- modify PK
ALTER TABLE t_telegram_user DROP CONSTRAINT t_telegram_user_pkey;

ALTER TABLE t_telegram_user RENAME COLUMN id TO user_id;

ALTER TABLE t_telegram_user ADD PRIMARY KEY (user_id, restaurant_id);

