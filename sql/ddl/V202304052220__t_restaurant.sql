ALTER TABLE t_restaurant
    ADD COLUMN default_greeting varchar(1000);

UPDATE t_restaurant
SET default_greeting = detail.greeting
FROM (SELECT trd.greeting, trd.restaurant_id
      FROM t_restaurant_details trd
      JOIN t_restaurant tr on trd.restaurant_id = tr.id
      WHERE tr.default_localization = trd.localization) as detail
WHERE t_restaurant.id = detail.restaurant_id;
