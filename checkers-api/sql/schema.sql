CREATE SEQUENCE IF NOT EXISTS backups_id_seq;

CREATE TABLE backups (
	id INT NOT NULL DEFAULT nextval('backups_id_seq') PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    is_compressed BOOLEAN NOT NULL,
    user_id VARCHAR(255) NOT NULL
);
