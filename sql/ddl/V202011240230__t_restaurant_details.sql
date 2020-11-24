CREATE TABLE t_restaurant_details
(
    restaurant_id bigint  NOT NULL,
    localization  varchar(2) NOT NULL,
    greeting      varchar(1000),

    PRIMARY KEY (restaurant_id, localization),
    CONSTRAINT fk_restaurant_details_restaurant_id
        FOREIGN KEY (restaurant_id)
            REFERENCES t_restaurant (id)
)