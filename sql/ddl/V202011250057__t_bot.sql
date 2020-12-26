CREATE TABLE t_bot
(
    id            bigserial PRIMARY KEY,
    restaurant_id bigint    NOT NULL,
    name          VARCHAR(100) NOT NULL UNIQUE,
    token         VARCHAR(46)  NOT NULL,

    CONSTRAINT fk_bot_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id)
);