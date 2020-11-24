CREATE TABLE t_meal_details
(
    meal_id      bigint  NOT NULL,
    localization varchar(2) NOT NULL,
    name         varchar(100),
    description  varchar(300),
    category     varchar(50),

    PRIMARY KEY (meal_id, localization),
    CONSTRAINT fk_meal_details_meal_id
        FOREIGN KEY (meal_id)
            REFERENCES t_meal (id)
)