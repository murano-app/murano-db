ALTER TABLE t_order
    DROP CONSTRAINT fk_order_table_id;

ALTER TABLE t_order
    RENAME COLUMN table_id TO table_session_id;

ALTER TABLE t_order
    ADD CONSTRAINT fk_order_table_session_id
        FOREIGN KEY (table_session_id)
            REFERENCES t_table_session (id);
