CREATE TYPE payment_type AS ENUM ('CASH', 'CARD');

CREATE TABLE t_payment
(
    id               bigserial PRIMARY KEY,
    table_session_id bigint       NOT NULL,
    type             payment_type NOT NULL,
    created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payment_table_session_id
        FOREIGN KEY (table_session_id)
            REFERENCES t_table_session (id)
);

CREATE CAST (character varying as payment_type) WITH INOUT AS IMPLICIT;
