CREATE TABLE t_waiter_table
(
    id         bigserial PRIMARY KEY,
    waiter_id  bigint    NOT NULL,
    table_id   bigint    NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP          default NULL,

    CONSTRAINT waiter_table_waiter_id_table_id_deleted_at_key UNIQUE (waiter_id, table_id, deleted_at),

    CONSTRAINT fk_waiter_table_waiter_id
        FOREIGN KEY (waiter_id)
            REFERENCES t_waiter_user (id),

    CONSTRAINT fk_waiter_table_table_id
        FOREIGN KEY (table_id)
            REFERENCES t_table (id)
);
