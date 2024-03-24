--rename columns
ALTER TABLE t_category
    RENAME COLUMN priority TO sequence;
