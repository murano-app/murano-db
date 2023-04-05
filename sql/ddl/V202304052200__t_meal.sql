ALTER TABLE t_meal
    ADD COLUMN default_name varchar(100) NOT NULL default '';

ALTER TABLE t_meal
    ADD COLUMN default_description varchar(300);

UPDATE t_meal
SET default_name        = detail.name,
    default_description = detail.description
FROM (SELECT tmd.name, tmd.description, tmd.meal_id
      FROM t_meal_details tmd
      JOIN t_meal tm on tm.id = tmd.meal_id
      JOIN t_restaurant tr on tm.restaurant_id = tr.id
      WHERE tr.default_localization = tmd.localization) as detail
where detail.meal_id = t_meal.id;

ALTER TABLE t_meal ALTER COLUMN default_name DROP DEFAULT;
