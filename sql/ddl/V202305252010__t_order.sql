TRUNCATE t_order_meal;

CREATE TYPE order_status AS ENUM ('PENDING', 'ACCEPTED', 'DECLINED');

CREATE TABLE t_order
(
    id                bigserial PRIMARY KEY,
    status            order_status default 'PENDING'          NOT NULL,
    table_id          bigint                                  NOT NULL,
    order_uuid        uuid unique  default uuid_generate_v4() NOT NULL,
    created_at        TIMESTAMP                               NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_changed_at TIMESTAMP    default NULL,
    status_changed_by bigint       default NULL,
    order_comment     varchar(256) default NULL,

    CONSTRAINT fk_order_table_id
        FOREIGN KEY (table_id)
            REFERENCES t_table (id),

    CONSTRAINT fk_order_user_id
        FOREIGN KEY (status_changed_by)
            REFERENCES t_user (id)
);

CREATE CAST (character varying as order_status) WITH INOUT AS IMPLICIT;
