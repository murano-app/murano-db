ALTER TABLE t_branch
    ADD COLUMN street_address VARCHAR(255),
    ADD COLUMN address_line2 VARCHAR(255),
    ADD COLUMN city VARCHAR(50),
    ADD COLUMN postal_code VARCHAR(20),
    ADD COLUMN country_code VARCHAR(3);

UPDATE t_branch
SET street_address = 'Dummy Street Address',
    country_code = 'MDA'
WHERE street_address IS NULL;

ALTER TABLE t_branch
    ALTER COLUMN street_address SET NOT NULL,
    ALTER COLUMN country_code SET NOT NULL;
