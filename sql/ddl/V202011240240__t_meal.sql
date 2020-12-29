CREATE TABLE t_meal
(
    id            bigserial PRIMARY KEY,
    restaurant_id bigserial     NOT NULL,
    price         decimal(9, 2) NOT NULL,
    weight        varchar(50),
    priority      integer       NOT NULL,

    CONSTRAINT uq_t_meal_restaurant_id_priority
        UNIQUE (restaurant_id, priority),
    CONSTRAINT fk_meal_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id)
)