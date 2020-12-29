ALTER TABLE t_table
    ADD CONSTRAINT fk_table_waiter_chat_id
        FOREIGN KEY (waiter_chat_id)
            REFERENCES t_telegram_user (id)
