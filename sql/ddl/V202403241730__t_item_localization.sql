--rename columns
ALTER TABLE t_meal_details
    RENAME COLUMN meal_id TO item_id;

--rename table
ALTER TABLE t_meal_details RENAME TO t_item_localization;