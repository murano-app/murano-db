ALTER TABLE t_payment
    ADD CONSTRAINT fk_payment_acknowledged_by
        FOREIGN KEY (acknowledged_by)
            REFERENCES t_user (id);