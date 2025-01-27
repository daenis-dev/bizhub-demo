CREATE SEQUENCE IF NOT EXISTS artifacts_id_seq;

CREATE TABLE artifacts (
    id INT NOT NULL DEFAULT nextval('artifacts_id_seq') PRIMARY KEY,
    name VARCHAR(255),
    file_path VARCHAR(255),
    hash BYTEA,
    user_id VARCHAR(255) NOT NULL
);