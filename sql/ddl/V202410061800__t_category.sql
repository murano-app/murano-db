ALTER TABLE t_category
    ADD COLUMN deleted_at timestamp;

ALTER TABLE t_category
    DROP CONSTRAINT uq_t_category_restaurant_id_priority;

--required for the next statement
CREATE EXTENSION IF NOT EXISTS btree_gist;

--replace the dropped unique constraint with a partial unique constraint
--with the new constraint the deleted categories should not be taken into consideration
-- it is important for the new constraint to still be deferrable (we want to validate against it on commit, not upon execution of the statement)
-- This is necessary because we want to be able to switch sequences
-- For example in the same transaction we execute 2 updates
--  first update changes sequence of category A from 1 to 2
--  second update changes sequence of category B from 2 to 1
-- if the constraint is not deferrable it will fail on the first update.
--
-- since postgres neither supports partial unique constraints nor deferrable unique indexes, we have to use EXCLUDE.
-- inspiration: https://www.postgresql.org/message-id/41ED3F5450C90F4D8381BC4D8DF6BBDC7A4F39D6%40EXCHANGESERVER.ikoffice.de
ALTER TABLE t_category
    ADD CONSTRAINT uq_t_category_client_sequence
        EXCLUDE USING gist (sequence WITH =, client_id WITH =)
        WHERE (deleted_at IS NULL)
        DEFERRABLE INITIALLY DEFERRED;
