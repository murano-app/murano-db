CREATE TABLE t_waiter_user
(
    id            bigserial PRIMARY KEY,
    username      VARCHAR(100) NOT NULL,
    password      VARCHAR(100) NOT NULL,
    restaurant_id bigint       NOT NULL,
    waiter_uuid   uuid unique           default uuid_generate_v4() NOT NULL,
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT waiter_user_username_restaurant_id_key UNIQUE (username, restaurant_id),

    CONSTRAINT fk_waiter_user_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id)
);
