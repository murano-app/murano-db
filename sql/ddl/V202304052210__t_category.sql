ALTER TABLE t_category
    ADD COLUMN default_name varchar(50) NOT NULL default '';

UPDATE t_category
SET default_name        = detail.name
FROM (SELECT tcd.name, tcd.category_id
      FROM t_category_details tcd
      JOIN t_category tc on tc.id = tcd.category_id
      JOIN t_restaurant tr on tc.restaurant_id = tr.id
      WHERE tr.default_localization = tcd.localization) as detail
where detail.category_id = t_category.id;

ALTER TABLE t_category ALTER COLUMN default_name DROP DEFAULT;