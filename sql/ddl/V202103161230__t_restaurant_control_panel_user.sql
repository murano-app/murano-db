CREATE TABLE t_restaurant_control_panel_user (
    restaurant_id bigint,
    control_panel_user_id bigint,

    CONSTRAINT fk_restaurant_control_panel_user_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id),

    CONSTRAINT fk_restaurant_control_panel_user_control_panel_user_id
        FOREIGN KEY (control_panel_user_id)
            REFERENCES t_control_panel_user (id),

    CONSTRAINT pk_restaurant_control_panel_user PRIMARY KEY (restaurant_id, control_panel_user_id)
);
