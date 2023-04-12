CREATE TABLE t_restaurant_meal
(
    restaurant_id bigint not null,
    meal_id       bigint not null,
    available     boolean default false,

        PRIMARY KEY (restaurant_id, meal_id),
    CONSTRAINT fk_restaurant_meal_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id),
    CONSTRAINT fk_restaurant_meal_meal_id
        FOREIGN KEY (meal_id)
            REFERENCES t_meal (id)
);


-- migrate data FROM t_meal
INSERT INTO t_restaurant_meal
SELECT ml.restaurant_id, ml.id, true
FROM t_meal ml;


ALTER TABLE t_meal
    DROP COLUMN restaurant_id;
