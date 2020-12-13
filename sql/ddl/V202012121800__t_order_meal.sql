CREATE TABLE t_order_meal
(
    id            bigserial PRIMARY KEY,
    pending       boolean DEFAULT false,
    meal_id       bigint NOT NULL,
    meal_amount   int    NOT NULL,
    table_id      bigint    NOT NULL,

    CONSTRAINT fk_order_meal_table_id
        FOREIGN KEY (table_id)
            REFERENCES t_table (id),

    CONSTRAINT fk_order_meal_meal_id
        FOREIGN KEY (meal_id)
            REFERENCES t_meal (id)
)