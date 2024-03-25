ALTER TABLE t_call_waiter
    ADD CONSTRAINT fk_call_waiter_acknowledged_by
        FOREIGN KEY (acknowledged_by)
            REFERENCES t_user (id);
