CREATE TEMP TABLE aggregated_categories AS
select distinct on (tmd.category) tm.restaurant_id as restaurant_id,
                              tm.id            as meal_id,
                              tm.priority,
                              tmd.localization,
                              tmd.category
from t_meal_details tmd
         join t_meal tm on tm.id = tmd.meal_id;

do
$$
    DECLARE
        r record;
    begin
        for r IN select distinct on (meal_id) restaurant_id, meal_id, priority
                  from aggregated_categories
            loop
                INSERT INTO t_category (restaurant_id, priority)
                VALUES (r.restaurant_id, r.priority);

                INSERT INTO t_category_details(category_id, localization, name)
                SELECT currval('t_category_id_seq'), localization, category
                FROM aggregated_categories
                WHERE meal_id = r.meal_id;
            end loop;
    end;
$$;

DROP TABLE aggregated_categories;
