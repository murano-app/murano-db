CREATE TABLE t_waiter_user
(
    id            bigserial PRIMARY KEY,
    username      VARCHAR(100) NOT NULL,
    password      VARCHAR(100) NOT NULL,
    restaurant_id bigint       NOT NULL,

    CONSTRAINT fk_waiter_user_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id)
);
