ALTER TABLE t_meal
    DROP CONSTRAINT uq_t_meal_restaurant_id_priority;

ALTER TABLE t_meal
    ADD CONSTRAINT uq_t_meal_category_id_priority UNIQUE (priority, category_id);
