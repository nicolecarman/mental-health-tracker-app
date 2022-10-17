-- Use this file to initialize the PostGreSQL database only once, before starting the server for the first time.

-- Create the database
CREATE DATABASE "feelsifyDB"
    WITH
    OWNER = postgres
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE "feelsifyDB"
    IS 'The database for the Feelsify Mental healt tracker app';

-- Connect to the newly created database as current user
\c feelsifyDB

-- Grant full permissions on the database

GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA public to postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public to postgres;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public to postgres;

-- create the tables
-- some column names have table name in front of them to prevent using SQL keywords
-- For a list of SQL keywords see: https://www.postgresql.org/docs/current/sql-keywords-appendix.html
-- UUIDs are generated by the server, not in PSQL.
CREATE TABLE IF NOT EXISTS users(
    user_id         UUID PRIMARY KEY NOT NULL,
    username        VARCHAR(25) UNIQUE NOT NULL,
    email           VARCHAR(50) UNIQUE NOT NULL,
    user_password   CHAR(60) NOT NULL,
    full_name       VARCHAR(35) NOT NULL,
    age             SMALLINT NOT NULL,
    last_login_date DATE NOT NULL,
    account_creation_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS entries(
    entry_id        UUID PRIMARY KEY NOT NULL,
    user_id         UUID REFERENCES users(user_id),
    entry_date      DATE NOT NULL,
    entry_type      VARCHAR(10) NOT NULL,
    entry_level     SMALLINT NOT NULL,
    note            TEXT
);

CREATE TABLE IF NOT EXISTS entry_events(
    event_id        UUID PRIMARY KEY NOT NULL,
    entry_id        UUID REFERENCES entries(entry_id),
    entry_event     VARCHAR(12) NOT NULL
);

-- create a test user
-- unhashed password = test
INSERT INTO users(user_id, username, email, user_password, full_name, age, last_login_date, account_creation_date)
VALUES (
    uuid('dd4089df-8989-4c8c-aee0-2e5c7ccd4f5a'),
    'test123',
    'test123@example.com',
    '$2b$10$VzQhCKrOjYr.KSLQYfLB0.CnP3.SkCd/eN37xyvtdJmaTHalK.Bi6',
    'Test User',
    18,
    TO_DATE('2022-10-16', 'YYYY-MM-DD'),
    TO_DATE('2022-10-9', 'YYYY-MM-DD')
);

-- create entries for the test user
INSERT INTO entries(entry_id, user_id, entry_date, entry_type, entry_level, note)
VALUES (
    uuid('3f336097-52f7-4520-8dd9-5d34b0a8c2ea'),
    uuid('dd4089df-8989-4c8c-aee0-2e5c7ccd4f5a'),
    TO_DATE('2022-10-10', 'YYYY-MM-DD'),
    'depression',
    6,
    'I am sick of always being a test user.'
);

INSERT INTO entry_events(event_id, entry_id, entry_event)
VALUES (
    uuid('27a4e808-1a57-4e3b-b1ae-e12fa4e398b4'),
    uuid('3f336097-52f7-4520-8dd9-5d34b0a8c2ea'),
    'trauma'
);

INSERT INTO entries(entry_id, user_id, entry_date, entry_type, entry_level, note)
VALUES (
    uuid('edc677aa-47ad-4d90-8655-231c30dba523'),
    uuid('dd4089df-8989-4c8c-aee0-2e5c7ccd4f5a'),
    TO_DATE('2022-10-11', 'YYYY-MM-DD'),
    'stress',
    9,
    'Another day, another test.'
);

INSERT INTO entry_events(event_id, entry_id, entry_event)
VALUES (
    uuid('8c0a488b-a07a-459c-84b0-1af2334127d9'),
    uuid('edc677aa-47ad-4d90-8655-231c30dba523'),
    'significant'
);

INSERT INTO entries(entry_id, user_id, entry_date, entry_type, entry_level, note)
VALUES (
    uuid('834fe32e-f41a-463e-854f-16cda173961c'),
    uuid('dd4089df-8989-4c8c-aee0-2e5c7ccd4f5a'),
    TO_DATE('2022-10-12', 'YYYY-MM-DD'),
    'anxiety',
    2,
    'I hope this test goes well.'
);

INSERT INTO entry_events(event_id, entry_id, entry_event)
VALUES (
    uuid('d8b6392e-76e1-4e96-8fc9-8beeb2bd995b'),
    uuid('834fe32e-f41a-463e-854f-16cda173961c'),
    'work'
);

INSERT INTO entry_events(event_id, entry_id, entry_event)
VALUES (
    uuid('8c30af73-f5b3-4acc-8e30-cdb4952e44d5'),
    uuid('834fe32e-f41a-463e-854f-16cda173961c'),
    'significant'
);

SELECT *
FROM users;

SELECT *
FROM entries;

SELECT *
FROM entry_events;
