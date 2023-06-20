TRUNCATE t_order, t_order_meal;

CREATE TABLE t_table_session
(
    id                 bigserial PRIMARY KEY,
    table_id           bigint                                 NOT NULL,
    closed_at          TIMESTAMP   DEFAULT NULL,
    table_session_uuid uuid unique default uuid_generate_v4() NOT NULL,


    CONSTRAINT fk_table_session_table_id
        FOREIGN KEY (table_id)
            REFERENCES t_table (id)
);
