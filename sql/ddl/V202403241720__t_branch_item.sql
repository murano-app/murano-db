--rename columns
ALTER TABLE t_restaurant_meal
    RENAME COLUMN meal_id TO item_id;
ALTER TABLE t_restaurant_meal
    RENAME COLUMN restaurant_id TO branch_id;

--rename table
ALTER TABLE t_restaurant_meal
    RENAME TO t_branch_item;



--replace old "available" column with a custom typed column

--add custom type for availability
CREATE TYPE item_availability AS ENUM ('AVAILABLE', 'HIDDEN', 'NOT_AVAILABLE');

--add new custom typed column
ALTER TABLE t_branch_item
    ADD COLUMN availability item_availability;

--set values in the new column based on values from the old "available" column
UPDATE t_branch_item
SET availability = CASE
                       WHEN available IS TRUE THEN 'AVAILABLE'::item_availability
                       ELSE 'HIDDEN'::item_availability
    END;

--make the new column not nullable
ALTER TABLE t_branch_item
    ALTER COLUMN availability SET NOT NULL;

--drop the old "available" column
ALTER TABLE  t_branch_item
    DROP COLUMN available;
