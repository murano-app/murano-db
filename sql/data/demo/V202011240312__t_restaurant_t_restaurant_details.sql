INSERT INTO t_restaurant (name)
VALUES ('Bratwürstchen Restaurant');

INSERT INTO t_restaurant_details (restaurant_id, localization, greeting)
VALUES (currval('t_restaurant_id_seq'), 'en', 'Tipical german restaurant, nothing special. You are welcome'),
       (currval('t_restaurant_id_seq'), 'de', 'Typisches duetsches Restaurant, nichts besonderes');


INSERT INTO t_restaurant (name, default_localization, currency)
VALUES ('Murano Restaurant', 'ro', 'MDL');

INSERT INTO t_restaurant_details (restaurant_id, localization, greeting)
VALUES (currval('t_restaurant_id_seq'), 'ro', 'Artiom a lucrat aici'),
       (currval('t_restaurant_id_seq'), 'en', 'This restaurant is a piece of shit, but our friend used to work here, ' ||
                                              'so we decided to use it''s name for test data. ' ||
                                              '...and as our project''s name');

--attach existing bot to murano restaurant
UPDATE t_bot
SET restaurant_id = currval('t_restaurant_id_seq')
WHERE name = 'MuranoBot';