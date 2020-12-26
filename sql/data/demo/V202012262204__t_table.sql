do
$$
    begin
        for counter in 1..10
            loop
                INSERT INTO t_table (table_nr, restaurant_id, group_chat_id)
                SELECT counter, r.id, -1001208502622
                FROM t_restaurant r
                WHERE r.name = 'Bratwursthaus';
            end loop;
    end;
$$;

do
$$
    begin
        for counter in 1..15
            loop
                INSERT INTO t_table (table_nr, restaurant_id, group_chat_id)
                SELECT counter, r.id, -1001194244713
                FROM t_restaurant r
                WHERE r.name = 'La Mamaliga';
            end loop;
    end;
$$