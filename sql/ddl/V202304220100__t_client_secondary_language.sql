CREATE TABLE t_client_secondary_language
(
    client_id    bigint,
    localization varchar(2),

    PRIMARY KEY (client_id, localization),
    CONSTRAINT fk_client_secondary_language_client_id
        FOREIGN KEY (client_id)
            REFERENCES t_client (id)
);

--migrate data from t_restaurant_details
INSERT INTO t_client_secondary_language
SELECT DISTINCT ON (tc.id, trd.localization) tc.id, trd.localization
FROM t_restaurant_details trd
         JOIN t_restaurant tr ON tr.id = trd.restaurant_id
         JOIN t_client tc ON tr.client_id = tc.id;
