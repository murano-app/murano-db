CREATE TABLE t_control_panel_user
(
    id       bigserial PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL

);
