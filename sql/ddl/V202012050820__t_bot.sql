ALTER TABLE t_bot
ADD COLUMN group_chat_id bigint unique;

UPDATE t_bot
SET group_chat_id = -459406579
WHERE TRUE;

ALTER TABLE t_bot
ALTER COLUMN  group_chat_id
SET NOT NULL;