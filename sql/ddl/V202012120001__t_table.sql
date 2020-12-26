CREATE TABLE t_table
(
    id              bigserial PRIMARY KEY,
    table_nr        int,
    restaurant_id   bigint NOT NULL,
    group_chat_id   bigint NOT NULL,
    waiter_chat_id  bigint,
    pending         boolean DEFAULT true,
    last_message_id int,

    CONSTRAINT unq_table_restaurant_id_table_nr
        UNIQUE (table_nr, restaurant_id, waiter_chat_id),
    CONSTRAINT unq_table_group_chat_id_last_message_id
        UNIQUE (group_chat_id, last_message_id),
    CONSTRAINT fk_table_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id)
)