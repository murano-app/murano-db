CREATE TABLE t_call_waiter
(
    id               bigserial PRIMARY KEY,
    table_session_id bigint    NOT NULL,
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_call_waiter_table_session_id
        FOREIGN KEY (table_session_id)
            REFERENCES t_table_session (id)
);
