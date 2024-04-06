CREATE TABLE t_user_branch
(
    user_id       bigint NOT NULL,
    branch_id     bigint NOT NULL,
    PRIMARY KEY(user_id, branch_id),

    CONSTRAINT fk_user_branch_user_id
        FOREIGN KEY (user_id)
            REFERENCES t_user (id),

    CONSTRAINT fk_user_branch_branch_id
        FOREIGN KEY (branch_id)
            REFERENCES t_branch (id)
);

-- populate table
INSERT INTO t_user_branch
    SELECT u.id, b.id
    FROM t_client cl
    JOIN t_user u on cl.id = u.client_id
    JOIN t_branch b on cl.id = b.client_id;

