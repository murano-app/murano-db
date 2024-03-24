--rename columns
ALTER TABLE t_order_meal
    RENAME COLUMN meal_id TO item_id;
ALTER TABLE t_order_meal
    RENAME COLUMN meal_amount TO item_count;

--rename table
ALTER TABLE t_order_meal RENAME TO t_order_item;