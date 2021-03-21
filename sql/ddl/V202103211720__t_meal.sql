CREATE TYPE unit AS ENUM ('G', 'KG', 'MG', 'L', 'ML', 'PI');

ALTER TABLE t_meal
    ADD COLUMN weight1 numeric(7, 3);
ALTER TABLE t_meal
    ADD COLUMN unit1 unit;

ALTER TABLE t_meal
    ADD COLUMN weight2 numeric(7, 3);
ALTER TABLE t_meal
    ADD COLUMN unit2 unit;

ALTER TABLE t_meal
    ADD COLUMN weight3 numeric(7, 3);
ALTER TABLE t_meal
    ADD COLUMN unit3 unit;

ALTER TABLE t_meal
    ADD COLUMN weight4 numeric(7, 3);
ALTER TABLE t_meal
    ADD COLUMN unit4 unit;

ALTER TABLE t_meal
    ADD COLUMN weight5 numeric(7, 3);
ALTER TABLE t_meal
    ADD COLUMN unit5 unit;
