CREATE TABLE t_user_table
(
    id               bigserial PRIMARY KEY,
    user_id          bigint    NOT NULL,
    table_id         bigint    NOT NULL,
    started_watching_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    stopped_watching_at TIMESTAMP          default NULL,

    CONSTRAINT user_table_user_id_table_id_deleted_at_key UNIQUE (user_id, table_id, stopped_watching_at),

    CONSTRAINT fk_user_table_user_id
        FOREIGN KEY (user_id)
            REFERENCES t_user (id),

    CONSTRAINT fk_user_table_table_id
        FOREIGN KEY (table_id)
            REFERENCES t_table (id)
);
