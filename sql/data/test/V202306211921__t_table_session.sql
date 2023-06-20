INSERT INTO t_table_session (table_id, closed_at)
SELECT t.id, null
FROM t_table t
