--rename columns
ALTER TABLE t_branch
    DROP COLUMN default_greeting;

ALTER TABLE t_branch
    DROP COLUMN restaurant_key;
