CREATE TABLE t_category
(
    id            bigserial PRIMARY KEY,
    restaurant_id bigint NOT NULL,
    priority      int NOT NULL ,

    CONSTRAINT uq_t_category_restaurant_id_priority
        UNIQUE (restaurant_id, priority),
    CONSTRAINT fk_category_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id)
)

