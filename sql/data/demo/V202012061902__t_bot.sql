INSERT INTO t_bot (restaurant_id, name, token, group_chat_id)
SELECT r.id, 'GermanRestaurantGalleryBot', '1374675625:AAEQBk6iUCPberhBhmhXYU1FRpfdSD9qj-w', -431483020
FROM t_restaurant r
WHERE r.name = 'Bratwürstchen Restaurant';

