ALTER TABLE t_order_meal
    DROP CONSTRAINT fk_order_meal_table_id;

ALTER TABLE t_order_meal
    DROP COLUMN order_comment;

ALTER TABLE t_order_meal
    RENAME COLUMN table_id TO order_id;

ALTER TABLE t_order_meal
    ADD CONSTRAINT fk_order_meal_order_id FOREIGN KEY (order_id) REFERENCES t_order (id);
