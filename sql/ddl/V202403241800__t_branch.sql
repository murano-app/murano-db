--rename columns
ALTER TABLE t_restaurant
    RENAME COLUMN restaurant_uuid TO uuid;

--drop FK constraints in child tables
ALTER TABLE t_table
    DROP CONSTRAINT fk_table_restaurant_id;
ALTER TABLE t_branch_item
    DROP CONSTRAINT fk_restaurant_meal_restaurant_id;

--rename the table
ALTER TABLE t_restaurant
    RENAME TO t_branch;

--recreate FK constraints in child tables
ALTER TABLE t_table
    ADD CONSTRAINT fk_table_branch_id
        FOREIGN KEY (branch_id)
            REFERENCES t_branch (id);
ALTER TABLE t_branch_item
    ADD CONSTRAINT fk_branch_item_branch_id
        FOREIGN KEY (branch_id)
            REFERENCES t_branch (id);
