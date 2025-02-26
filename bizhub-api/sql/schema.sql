CREATE SEQUENCE IF NOT EXISTS backups_id_seq;

CREATE TABLE backups (
	id INT NOT NULL DEFAULT nextval('backups_id_seq') PRIMARY KEY,
    file_path VARCHAR(255) NOT NULL,
    uncompressed_file_size_in_bytes BIGINT NOT NULL,
    file_extension VARCHAR(7) NOT NULL,
    user_id VARCHAR(255) NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS user_friend_lists_id_seq;
CREATE SEQUENCE IF NOT EXISTS user_friends_id_seq;
CREATE SEQUENCE IF NOT EXISTS events_id_seq;

CREATE TABLE user_friend_lists (
	id INT NOT NULL DEFAULT nextval('user_friend_lists_id_seq') PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    created_date_time_in_utc TIMESTAMPTZ NOT NULL
);

CREATE TABLE user_friends (
    id INT NOT NULL DEFAULT nextval('user_friends_id_seq') PRIMARY KEY,
    user_friend_list_id INT NOT NULL,
    friend_user_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_friend_list_id) REFERENCES user_friend_lists (id)
);

CREATE TABLE events (
	id INT NOT NULL DEFAULT nextval('events_id_seq') PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    start_date_time_in_utc TIMESTAMPTZ NOT NULL,
    end_date_time_in_utc TIMESTAMPTZ NOT NULL,
    created_date_time_in_utc TIMESTAMPTZ NOT NULL,
    modified_date_time_in_utc TIMESTAMPTZ NOT NULL
);
