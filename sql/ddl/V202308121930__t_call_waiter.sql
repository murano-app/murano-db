ALTER TABLE t_call_waiter
    ADD COLUMN acknowledged_at timestamp;

ALTER TABLE t_call_waiter
    ADD COLUMN acknowledged_by bigint REFERENCES t_user(id);
