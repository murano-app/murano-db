ALTER TABLE t_bot
DROP COLUMN type;

ALTER TABLE t_bot
ADD CONSTRAINT t_bot_unq_name_const UNIQUE (name);

