ALTER TABLE t_category
    DROP CONSTRAINT uq_t_category_restaurant_id_priority;

ALTER TABLE t_category
    ADD CONSTRAINT uq_t_category_restaurant_id_priority UNIQUE (priority, restaurant_id) DEFERRABLE INITIALLY DEFERRED;