CREATE TABLE t_meal
(
    id            bigserial PRIMARY KEY,
    restaurant_id bigserial     NOT NULL,
    price         decimal(9, 2) NOT NULL,

    CONSTRAINT fk_meal_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id)
)