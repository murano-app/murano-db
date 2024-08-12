ALTER TABLE t_branch
    ADD COLUMN address_line1 VARCHAR(255),
    ADD COLUMN address_line2 VARCHAR(255),
    ADD COLUMN city VARCHAR(50),
    ADD COLUMN postal_code VARCHAR(20),
    ADD COLUMN country_code VARCHAR(3);

UPDATE t_branch
SET address_line1 = 'Dummy Street Address',
    country_code = 'MDA'
WHERE address_line1 IS NULL;

ALTER TABLE t_branch
    ALTER COLUMN address_line1 SET NOT NULL,
    ALTER COLUMN country_code SET NOT NULL;
