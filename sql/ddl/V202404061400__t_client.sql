--move restaurant_key to client
ALTER TABLE t_client
    ADD COLUMN key varchar(100);

UPDATE t_client cl
SET key = (SELECT br.restaurant_key
           FROM t_branch br
                    JOIN t_client on cl.id = br.client_id
           LIMIT 1) -- currently only single branched clients in the DB
WHERE true;

ALTER TABLE t_client
    ADD CONSTRAINT uq_t_client_key UNIQUE (key);
