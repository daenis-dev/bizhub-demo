CREATE SEQUENCE IF NOT EXISTS backups_id_seq;
CREATE TABLE backups (
	id INT NOT NULL DEFAULT nextval('backups_id_seq') PRIMARY KEY,
    file_path VARCHAR(255) NOT NULL,
    uncompressed_file_size_in_bytes BIGINT NOT NULL,
    file_extension VARCHAR(7) NOT NULL,
    user_id VARCHAR(255) NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS events_id_seq;
CREATE TABLE events (
	id INT NOT NULL DEFAULT nextval('events_id_seq') PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    start_date_time_in_utc TIMESTAMPTZ NOT NULL,
    end_date_time_in_utc TIMESTAMPTZ NOT NULL,
    created_date_time_in_utc TIMESTAMPTZ NOT NULL,
    modified_date_time_in_utc TIMESTAMPTZ NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS schedule_keys_id_seq;
CREATE TABLE schedule_keys (
	id INT NOT NULL DEFAULT nextval('schedule_keys_id_seq') PRIMARY KEY,
	user_id VARCHAR(255) NOT NULL,
    token VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    created_date_time_in_utc TIMESTAMPTZ NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS booking_request_statuses_id_seq;
CREATE TABLE booking_request_statuses (
    id INT NOT NULL DEFAULT nextval('booking_request_statuses_id_seq') PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    request_is_pending_approval BOOLEAN NOT NULL DEFAULT TRUE,
    request_is_active BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO booking_request_statuses (name, request_is_pending_approval) VALUES ('pending approval', TRUE);
INSERT INTO booking_request_statuses (name, request_is_pending_approval) VALUES ('accepted', FALSE);
INSERT INTO booking_request_statuses (name, request_is_pending_approval) VALUES ('denied', FALSE);
INSERT INTO booking_request_statuses (name, request_is_pending_approval) VALUES ('canceled', FALSE);

CREATE SEQUENCE IF NOT EXISTS booking_requests_id_seq;
CREATE TABLE booking_requests (
	id INT NOT NULL DEFAULT nextval('booking_requests_id_seq') PRIMARY KEY,
	requestee_user_id VARCHAR(255) NOT NULL,
    requester_email_address VARCHAR (255) NOT NULL,
    status_id INT NOT NULL,
    start_date_time_in_utc TIMESTAMPTZ NOT NULL,
    end_date_time_in_utc TIMESTAMPTZ NOT NULL,
    event_name VARCHAR(255) NOT NULL,
    created_date_time_in_utc TIMESTAMPTZ NOT NULL,
    modified_date_time_in_utc TIMESTAMPTZ NOT NULL,
    FOREIGN KEY (status_id) REFERENCES booking_request_statuses (id)
);
