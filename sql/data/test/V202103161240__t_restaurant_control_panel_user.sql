INSERT INTO t_restaurant_control_panel_user(restaurant_id, control_panel_user_id)
SELECT r.id, cpu.id
FROM t_restaurant r
         CROSS JOIN t_control_panel_user cpu
WHERE cpu.username = 'superUser' AND r.name IN ('Bratwursthaus', 'La Mamaliga')
   OR cpu.username = 'mamaligaUser' AND r.name = 'La Mamaliga'
   OR cpu.username = 'bratwurstUser' AND r.name = 'Bratwursthaus';