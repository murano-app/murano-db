--rename columns
ALTER TABLE t_table
    RENAME COLUMN table_nr TO number;
ALTER TABLE t_table
    RENAME COLUMN restaurant_id TO branch_id;
ALTER TABLE t_table
    RENAME COLUMN table_uuid TO uuid;

--remove legacy Telagram bot columns
ALTER TABLE t_table
    DROP COLUMN group_chat_id;
ALTER TABLE t_table
    DROP COLUMN waiter_chat_id;
ALTER TABLE t_table
    DROP COLUMN pending;
ALTER TABLE t_table
    DROP COLUMN last_message_id;
