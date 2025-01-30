CREATE SEQUENCE IF NOT EXISTS artifacts_id_seq;

CREATE TABLE artifacts (
    id INT NOT NULL DEFAULT nextval('artifacts_id_seq') PRIMARY KEY,
    name VARCHAR(255),
    file_path VARCHAR(255),
    hash BYTEA,
    user_id VARCHAR(255) NOT NULL
);

INSERT INTO artifacts (name, file_path, hash, user_id) VALUES ('Task One', '/Windows/Scheduled/task1.json', decode('1234567890abcde1', 'hex'), '783254cd-3a14-452a-b6ac-33c0938f53d8');
INSERT INTO artifacts (name, file_path, hash, user_id) VALUES ('Task Two', '/Windows/Scheduled/task2.json', decode('1234567890abcde2', 'hex'), '783254cd-3a14-452a-b6ac-33c0938f53d8');
INSERT INTO artifacts (name, file_path, hash, user_id) VALUES ('Sys Config', '/Windows/System32/conf.json', decode('1234567890abcde3', 'hex'), '783254cd-3a14-452a-b6ac-33c0938f53d8');
INSERT INTO artifacts (name, file_path, hash, user_id) VALUES ('Sys Requirements', '/Windows/System32/usr/bin/requirements.txt', decode('1234567890abcde4', 'hex'), '783254cd-3a14-452a-b6ac-33c0938f53d8');
INSERT INTO artifacts (name, file_path, hash, user_id) VALUES ('Test File', '/Windows/test.txt', decode('1234567890abcde5', 'hex'), '783254cd-3a14-452a-b6ac-33c0938f53d8');
