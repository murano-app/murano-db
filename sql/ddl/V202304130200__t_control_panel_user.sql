DROP TABLE t_restaurant_control_panel_user;

TRUNCATE t_control_panel_user;

ALTER TABLE t_control_panel_user
ADD COLUMN client_id bigint REFERENCES t_client(id) NOT NULL;