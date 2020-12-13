do
$$
    begin
        for counter in 1..10
            loop
                INSERT INTO t_table (table_nr, restaurant_id, group_chat_id)
                SELECT counter, r.id, -431483020
                FROM t_restaurant r
                WHERE r.name = 'Bratwürstchen Restaurant';
            end loop;
    end;
$$;

do
$$
    begin
        for counter in 1..15
            loop
                INSERT INTO t_table (table_nr, restaurant_id, group_chat_id)
                SELECT counter, r.id, -459406579
                FROM t_restaurant r
                WHERE r.name = 'Murano Restaurant';
            end loop;
    end;
$$