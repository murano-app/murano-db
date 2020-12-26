INSERT INTO t_bot (restaurant_id, name, token)
SELECT r.id, 'LaMamaligaMDAQABot', '1437937035:AAFQW0RHStK8hsCzVoXpeLn60d5_BWdwM3w'
FROM t_restaurant r
WHERE r.name = 'La Mamaliga';

INSERT INTO t_bot (restaurant_id, name, token)
SELECT r.id, 'BratwursthausGERQABot', '1491727755:AAEW1x5iNGcKh0E_bITuWEpwIPfAjPH72kY'
FROM t_restaurant r
WHERE r.name = 'Bratwursthaus';