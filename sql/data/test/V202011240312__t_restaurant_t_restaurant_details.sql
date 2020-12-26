INSERT INTO t_restaurant (name)
VALUES ('Bratwursthaus');

INSERT INTO t_restaurant_details (restaurant_id, localization, greeting)
VALUES (currval('t_restaurant_id_seq'), 'en', 'Typical German restaurant, nothing special. You are welcome.'),
       (currval('t_restaurant_id_seq'), 'de', 'Typisches duetsches Restaurant, nichts besonderes');


INSERT INTO t_restaurant (name, default_localization, currency)
VALUES ('La Mamaliga', 'ro', 'MDL');

INSERT INTO t_restaurant_details (restaurant_id, localization, greeting)
VALUES (currval('t_restaurant_id_seq'), 'ro', 'Restaurant tipic moldovenesc, nimic special. Bine ati venit.'),
       (currval('t_restaurant_id_seq'), 'en', 'Vivamus ultricies urna ut enim volutpat congue. Proin accumsan tellus eu interdum pellentesque. Donec blandit malesuada ante, ac consequat velit ullamcorper a. In sagittis sem ac mattis vehicula. Phasellus efficitur faucibus nisi. Ut volutpat mi nisl, in suscipit neque ornare in. Maecenas pulvinar nisl tincidunt justo rutrum, hendrerit hendrerit tellus convallis. Vestibulum sed erat in libero tristique auctor nec et diam. Aenean eget tellus nulla. Nam pulvinar, lectus ac maximus tincidunt, purus diam consectetur erat, eget placerat elit ante in eros. In vitae nulla sollicitudin, tempus sem id, pharetra nulla. Donec imperdiet pellentesque dui.');
