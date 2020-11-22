CREATE TABLE t_bot (
    id                  bigserial PRIMARY KEY,
    restaurant_id       bigserial NOT NULL,
    name                VARCHAR(100) NOT NULL,
    token               VARCHAR(46) NOT NULL,
    type                VARCHAR(6) NOT NULL CHECK(type IN ('ASSIGN', 'TRCKNG'))
)