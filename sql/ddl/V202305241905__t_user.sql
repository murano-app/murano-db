CREATE TABLE t_user
(
    id            bigserial PRIMARY KEY,
    username      VARCHAR(100) NOT NULL,
    password      VARCHAR(100) NOT NULL,
    restaurant_id bigint       NOT NULL,
    user_uuid     uuid unique           default uuid_generate_v4() NOT NULL,
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT user_username_restaurant_id_key UNIQUE (username, restaurant_id),

    CONSTRAINT fk_user_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id)
);
