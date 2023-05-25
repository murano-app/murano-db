CREATE TABLE t_order
(
    id         bigserial PRIMARY KEY,
    accepted   boolean            default NULL,
    table_id   bigint    NOT NULL,
    order_uuid uuid unique        default uuid_generate_v4() NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_waiter_table_table_id
        FOREIGN KEY (table_id)
            REFERENCES t_table (id)
);
