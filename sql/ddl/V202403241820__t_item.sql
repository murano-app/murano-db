--rename columns
ALTER TABLE t_meal
    RENAME COLUMN priority TO sequence;
ALTER TABLE t_meal
    RENAME COLUMN meal_uuid TO uuid;
ALTER TABLE t_meal
    RENAME COLUMN weight1 TO quantity1;
ALTER TABLE t_meal
    RENAME COLUMN weight2 TO quantity2;
ALTER TABLE t_meal
    RENAME COLUMN weight3 TO quantity3;
ALTER TABLE t_meal
    RENAME COLUMN weight4 TO quantity4;
ALTER TABLE t_meal
    RENAME COLUMN weight5 TO quantity5;

--drop FK constraints in child tables
ALTER TABLE t_item_localization
    DROP CONSTRAINT fk_meal_details_meal_id;
ALTER TABLE t_branch_item
    DROP CONSTRAINT fk_restaurant_meal_meal_id;
ALTER TABLE t_order_item
    DROP CONSTRAINT fk_order_meal_meal_id;

--rename the table
ALTER TABLE t_meal
    RENAME TO t_item;

--recreate FK constraints in child tables
ALTER TABLE t_item_localization
    ADD CONSTRAINT fk_item_localization_item_id
        FOREIGN KEY (item_id)
            REFERENCES t_item (id);
ALTER TABLE t_branch_item
    ADD CONSTRAINT fk_branch_item_item_id
        FOREIGN KEY (item_id)
            REFERENCES t_item (id);
ALTER TABLE t_order_item
    ADD CONSTRAINT fk_order_item_item_id
        FOREIGN KEY (item_id)
            REFERENCES t_item (id);

