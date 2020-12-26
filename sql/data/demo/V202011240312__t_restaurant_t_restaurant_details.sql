INSERT INTO t_restaurant (name)
VALUES ('Bratwursthaus');

INSERT INTO t_restaurant_details (restaurant_id, localization, greeting)
VALUES (currval('t_restaurant_id_seq'), 'en', 'Typical German restaurant, nothing special. You are welcome.'),
       (currval('t_restaurant_id_seq'), 'de', 'Typisches duetsches Restaurant, nichts besonderes');


INSERT INTO t_restaurant (name, default_localization, currency)
VALUES ('La Mamaliga', 'ro', 'MDL');

INSERT INTO t_restaurant_details (restaurant_id, localization, greeting)
VALUES (currval('t_restaurant_id_seq'), 'ro', 'Restaurant tipic moldovenesc, nimic special. Bine ati venit.'),
       (currval('t_restaurant_id_seq'), 'en', 'Typical Moldovan restaurant, nothing special. You are welcome');
