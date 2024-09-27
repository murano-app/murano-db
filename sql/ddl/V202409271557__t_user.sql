ALTER TABLE t_user
    ADD COLUMN email VARCHAR(100) UNIQUE;

UPDATE t_user
SET email = CONCAT(username, '@changeme.com')
WHERE email IS NULL;

ALTER TABLE t_user
    ALTER COLUMN email SET NOT NULL;
