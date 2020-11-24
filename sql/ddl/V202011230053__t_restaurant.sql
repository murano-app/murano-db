CREATE TABLE t_restaurant
(
    id                   bigserial PRIMARY KEY,
    name                 varchar(100) NOT NULL,
    default_localization varchar(2)   NOT NULL DEFAULT ('en'),
    currency             varchar(3)   NOT NULL DEFAULT ('EUR')

)