CREATE OR REPLACE FUNCTION pg_temp.unit_string_to_enum(meal_unit text)
    RETURNS unit
    LANGUAGE plpgsql
AS
$$
DECLARE
    result unit;
begin
    case meal_unit
        when ('g')
            then result = 'G';
        when ('ml')
            then result = 'ML';
        when ('kg')
            then result = 'KG';
        when ('l')
            then result = 'L';
        else result = 'PI';
        end case;
    return result;
end;
$$;

do
$$
    DECLARE
        r              record;
        current_weight text;
    begin
        for r IN SELECT tm.id, tm.weight FROM t_meal tm
            loop
                SELECT split_part(r.weight, '/', 1)
                INTO current_weight;
                if (current_weight <> '') then
                    UPDATE t_meal
                    SET weight1 = regexp_replace(current_weight, '\D', '', 'g') :: DECIMAL
                    WHERE id = r.id;
                    UPDATE t_meal
                    SET unit1 = pg_temp.unit_string_to_enum(
                            regexp_replace(current_weight, '\d', '', 'g'))
                    WHERE id = r.id;
                end if;

                SELECT split_part(r.weight, '/', 2)
                INTO current_weight;
                if (current_weight <> '') then
                    UPDATE t_meal
                    SET weight2 = regexp_replace(current_weight, '\D', '', 'g') :: DECIMAL
                    WHERE id = r.id;
                    UPDATE t_meal
                    SET unit2 = pg_temp.unit_string_to_enum(
                            regexp_replace(current_weight, '\d', '', 'g'))
                    WHERE id = r.id;
                end if;

                SELECT split_part(r.weight, '/', 3)
                INTO current_weight;
                if (current_weight <> '') then
                    UPDATE t_meal
                    SET weight3 = regexp_replace(current_weight, '\D', '', 'g') :: DECIMAL
                    WHERE id = r.id;
                    UPDATE t_meal
                    SET unit3 = pg_temp.unit_string_to_enum(
                            regexp_replace(current_weight, '\d', '', 'g'))
                    WHERE id = r.id;
                end if;

                SELECT split_part(r.weight, '/', 4)
                INTO current_weight;
                if (current_weight <> '') then
                    UPDATE t_meal
                    SET weight4 = regexp_replace(current_weight, '\D', '', 'g') :: DECIMAL
                    WHERE id = r.id;
                    UPDATE t_meal
                    SET unit4 = pg_temp.unit_string_to_enum(
                            regexp_replace(current_weight, '\d', '', 'g'))
                    WHERE id = r.id;
                end if;

                SELECT split_part(r.weight, '/', 5)
                INTO current_weight;
                if (current_weight <> '') then
                    UPDATE t_meal
                    SET weight5 = regexp_replace(current_weight, '\D', '', 'g') :: DECIMAL
                    WHERE id = r.id;
                    UPDATE t_meal
                    SET unit5 = pg_temp.unit_string_to_enum(
                            regexp_replace(current_weight, '\d', '', 'g'))
                    WHERE id = r.id;
                end if;

            end loop;
    end ;
$$;
