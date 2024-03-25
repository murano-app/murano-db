--rename columns
ALTER TABLE t_order
    RENAME COLUMN order_uuid TO uuid;
ALTER TABLE t_order
    RENAME COLUMN order_comment TO comment;
