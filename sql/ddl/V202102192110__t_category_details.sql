CREATE TABLE t_category_details
(
    category_id  bigint,
    localization varchar(2),
    name         varchar(50) NOT NULL,

    PRIMARY KEY (category_id, localization),
    CONSTRAINT fk_meal_details_meal_id
        FOREIGN KEY (category_id)
            REFERENCES t_category (id)
)
