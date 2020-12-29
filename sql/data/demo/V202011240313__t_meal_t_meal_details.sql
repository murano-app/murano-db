-- Bratwürstchen Restaurant
INSERT INTO t_meal (restaurant_id, price, weight, priority)
SELECT r.id, '19.99', '150g/100g' ,1
FROM t_restaurant r
WHERE r.name = 'Bratwursthaus';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'de', 'Wurst mit Pommes', 'Wird mit einer tomatenhaltigen Sauce und Currypulver oder mit einem Curry-Ketchup serviert', 'Warme Speisen'),
       (currval('t_meal_id_seq'), 'en', 'Sausage with fries', 'Served with a tomato-based sauce and curry powder or with a curry ketchup', 'Warm food');


INSERT INTO t_meal (restaurant_id, price, weight, priority)
SELECT r.id, '14.99', '200g', 2
FROM t_restaurant r
WHERE r.name = 'Bratwursthaus';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'de', 'Kartoffelsalat', 'The boiled potatoes are cut into slices and mixed with the other ingredients. Both so-called boiled potatoes (cooked without peel) and jacket potatoes boiled with peel can be used.', 'Vorspeisen'),
       (currval('t_meal_id_seq'), 'en', 'Potato salad', 'Die gekochten Kartoffeln werden in Scheiben geschnitten und mit den weiteren Zutaten vermischt. Es können sowohl sogenannte Salzkartoffeln (ohne Schale gekocht) als auch die mit Schale gekochten Pellkartoffeln verwendet werden.', 'Appetizers');


INSERT INTO t_meal (restaurant_id, price, weight, priority)
SELECT r.id, '1.49', '330ml', 3
FROM t_restaurant r
WHERE r.name = 'Bratwursthaus';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'de', 'Cola', null, 'Getränke'),
       (currval('t_meal_id_seq'), 'en', 'Cola', null, 'Drinks');


-- Murano Restaurant
INSERT INTO t_meal (restaurant_id, price, weight, priority)
SELECT r.id, '150', '200g/50ml', 1
FROM t_restaurant r
WHERE r.name = 'La Mamaliga';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'en', 'Steak with Sauce', 'Pork steak with delicious onion sauce', 'Steaks'),
       (currval('t_meal_id_seq'), 'ro', 'Friptura de porc', 'Friptură de porc cu sos delicios de ceapă', 'Fripturi');


INSERT INTO t_meal (restaurant_id, price, weight, priority)
SELECT r.id, '120', '400ml', 3
FROM t_restaurant r
WHERE r.name = 'La Mamaliga';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'en', 'Long island', 'Buy it to your girlfriend and sex is guaranteed',
        'Alcohol drinks'),
       (currval('t_meal_id_seq'), 'ro', 'Long island', 'Cumpărați-o prietenei dvs. și sexul este garantat',
        'Băuturi alcoolice');


INSERT INTO t_meal (restaurant_id, price, priority)
SELECT r.id, '120', 4
FROM t_restaurant r
WHERE r.name = 'La Mamaliga';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'en', 'Pina colada', 'Feel yourself like in Hawaii', 'Alcohol drinks'),
       (currval('t_meal_id_seq'), 'ro', 'Pina colada', 'Simțiți-vă ca în Hawaii', 'Băuturi alcoolice');


INSERT INTO t_meal (restaurant_id, price, priority)
SELECT r.id, '70', 5
FROM t_restaurant r
WHERE r.name = 'La Mamaliga';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'en', 'Limonade', 'Extremely overpriced', 'Non alcoholic drinks'),
       (currval('t_meal_id_seq'), 'ro', 'Limonadă', 'Extrem de scump', 'Băuturi nealcoolice');


INSERT INTO t_meal (restaurant_id, price, weight, priority)
SELECT r.id, '80', '300g/50g/10g', 2
FROM t_restaurant r
WHERE r.name = 'La Mamaliga';

INSERT INTO t_meal_details
VALUES (currval('t_meal_id_seq'), 'en', 'Mamaliga', 'Yellow moldovan thing', 'National dishes'),
       (currval('t_meal_id_seq'), 'ro', 'Mamaliga', 'Tu stii si asta', 'Mâncăruri naționale');