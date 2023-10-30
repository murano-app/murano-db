CREATE TYPE staff_role AS ENUM ('MANAGER', 'WAITER');
CREATE CAST (character varying as staff_role) WITH INOUT AS IMPLICIT;

TRUNCATE TABLE t_order, t_user_table, t_control_panel_user RESTART IDENTITY CASCADE;

ALTER TABLE t_control_panel_user
    RENAME TO t_staff_user;

ALTER TABLE t_staff_user
    ADD COLUMN user_uuid  uuid unique default uuid_generate_v4() NOT NULL,
    ADD COLUMN role       staff_role                             NOT NULL DEFAULT 'WAITER',
    ADD COLUMN created_at TIMESTAMP                              NOT NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE t_order
    DROP CONSTRAINT fk_order_user_id;
ALTER TABLE t_order
    ADD CONSTRAINT fk_order_staff_user_id FOREIGN KEY (status_changed_by) REFERENCES t_staff_user (id);

ALTER TABLE t_user_table
    DROP CONSTRAINT fk_user_table_user_id;
ALTER TABLE t_user_table
    ADD CONSTRAINT fk_staff_user_table_user_id FOREIGN KEY (user_id) REFERENCES t_staff_user (id);

DROP TABLE t_user, t_bot CASCADE;
