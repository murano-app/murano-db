INSERT INTO t_bot (restaurant_id, name, token)
SELECT r.id, 'LaMamaligaMDADemoBot', '1445042440:AAElS0TH2JP4zQZr_68VnQZTAl5s-uRw0uA'
FROM t_restaurant r
WHERE r.name = 'La Mamaliga';

INSERT INTO t_bot (restaurant_id, name, token)
SELECT r.id, 'BratwursthausGERDemoBot', '1250206679:AAEiTVnQbekyfTuKUeI6KZQFPfF-Ol0EAHE'
FROM t_restaurant r
WHERE r.name = 'Bratwursthaus';