--rename columns
ALTER TABLE t_staff_user
    RENAME COLUMN user_uuid TO uuid;

--drop FK constraints in child tables
ALTER TABLE t_order
    DROP CONSTRAINT fk_order_staff_user_id;
ALTER TABLE t_user_table
    DROP CONSTRAINT fk_staff_user_table_user_id;

--rename the table
ALTER TABLE t_staff_user
    RENAME TO t_user;

--recreate FK constraints in child tables
ALTER TABLE t_order
    ADD CONSTRAINT fk_order_user_id
        FOREIGN KEY (status_changed_by)
            REFERENCES t_user (id);
ALTER TABLE t_user_table
    ADD CONSTRAINT fk_user_table_user_id
        FOREIGN KEY (user_id)
            REFERENCES t_user (id);
