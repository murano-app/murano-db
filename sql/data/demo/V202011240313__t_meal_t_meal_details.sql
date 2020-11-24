-- Bratwürstchen Restaurant
INSERT INTO t_meal (restaurant_id, price)
SELECT r.id, '19.99'
FROM t_restaurant r
WHERE r.name = 'Bratwürstchen Restaurant';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'de', 'Wurst mit Pommes', '150g/100g', 'Warme Speisen'),
       (currval('t_meal_id_seq'), 'en', 'Sausage with fries', '150g/100g', 'Warm food');


INSERT INTO t_meal (restaurant_id, price)
SELECT r.id, '14.99'
FROM t_restaurant r
WHERE r.name = 'Bratwürstchen Restaurant';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'de', 'Kartoffelsalat', '200g', 'Vorspeisen'),
       (currval('t_meal_id_seq'), 'en', 'Potato salad', '200g', 'Appetizers');


INSERT INTO t_meal (restaurant_id, price)
SELECT r.id, '1.49'
FROM t_restaurant r
WHERE r.name = 'Bratwürstchen Restaurant';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'de', 'Cola', '330ml', 'Getränke'),
       (currval('t_meal_id_seq'), 'en', 'Cola', '330ml', 'Drinks');


-- Murano Restaurant
INSERT INTO t_meal (restaurant_id, price)
SELECT r.id, '150'
FROM t_restaurant r
WHERE r.name = 'Murano Restaurant';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'en', 'Steak with Sauce', 'Pork steak with delicious onion sauce', 'Steaks'),
       (currval('t_meal_id_seq'), 'ro', 'Friptura de porc', 'Friptură de porc cu sos delicios de ceapă', 'Fripturi');


INSERT INTO t_meal (restaurant_id, price)
SELECT r.id, '120'
FROM t_restaurant r
WHERE r.name = 'Murano Restaurant';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'en', 'Long island', 'Buy it to your girlfriend and sex is guaranteed',
        'Alcohol drinks'),
       (currval('t_meal_id_seq'), 'ro', 'Long island', 'Cumpărați-o prietenei dvs. și sexul este garantat',
        'Băuturi alcoolice');


INSERT INTO t_meal (restaurant_id, price)
SELECT r.id, '120'
FROM t_restaurant r
WHERE r.name = 'Murano Restaurant';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'en', 'Pina colada', 'Feel yourself like in Hawaii', 'Alcohol drinks'),
       (currval('t_meal_id_seq'), 'ro', 'Pina colada', 'Simțiți-vă ca în Hawaii', 'Băuturi alcoolice');


INSERT INTO t_meal (restaurant_id, price)
SELECT r.id, '70'
FROM t_restaurant r
WHERE r.name = 'Murano Restaurant';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'en', 'Limonade', 'Extremely overpriced', 'Non alcoholic drinks'),
       (currval('t_meal_id_seq'), 'ro', 'Limonadă', 'Extrem de scump', 'Băuturi nealcoolice');
