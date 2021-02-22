ALTER TABLE t_meal
    ADD COLUMN category_id bigint;

--add fk
ALTER TABLE t_meal
    ADD CONSTRAINT fk_meal_category_id
        FOREIGN KEY (category_id)
            REFERENCES t_category (id);

--populate category_id with according data
UPDATE t_meal
SET category_id = subquery.category_id
FROM (SELECT distinct on (tm.id) tc.id AS category_id, tmd.meal_id
      FROM t_category tc
               JOIN t_category_details tcd on tc.id = tcd.category_id
               JOIN t_meal_details tmd on tcd.name = tmd.category
               JOIN t_meal tm ON tm.id = tmd.meal_id) AS subquery
WHERE subquery.meal_id = id;

--add not null constraint
ALTER TABLE t_meal
    ALTER COLUMN category_id SET NOT NULL;