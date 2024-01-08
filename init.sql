CREATE EXTENSION pgcrypto;

DROP TABLE IF EXISTS app_user;

CREATE TABLE app_user (
  id serial,
  username text NOT NULL UNIQUE,
  password_hash text NOT NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS monitor;

CREATE TYPE types AS ENUM ('solo', 'dual');

CREATE TABLE monitor (
  id serial,
  endpoint_key text UNIQUE NOT NULL,
  name text,
  schedule text NOT NULL,
  command text,
  active boolean NOT NULL DEFAULT true,
  failing boolean NOT NULL DEFAULT false,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  tolerable_runtime int NOT NULL DEFAULT 25,
  grace_period int NOT NULL DEFAULT 5,
  type types NOT NULL DEFAULT 'solo',
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS run;

CREATE TYPE states AS ENUM ('started', 'completed', 'failed', 'unresolved', 'no_start', 'solo_completed', 'missed', 'solo_missed');

CREATE TABLE run (
  id serial,
  monitor_id integer NOT NULL,
  run_token text,
  time timestamp NOT NULL,
  duration interval,
  state states NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (monitor_id) REFERENCES monitor(id) ON DELETE CASCADE
);

CREATE TABLE api_key (
  id serial, 
  api_key_hash text NOT NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  name text DEFAULT 'server_api_key',
  prefix text NOT NULL,
  PRIMARY KEY (id)
);

CREATE PROCEDURE rotate_runs()
LANGUAGE SQL
BEGIN ATOMIC
  WITH selection AS (
      SELECT id, monitor_id, run_row_id
      FROM (
          SELECT id, monitor_id, ROW_NUMBER() OVER (PARTITION BY monitor_id ORDER BY id) as run_row_id
          FROM run
          GROUP BY monitor_id, id
      ) AS general
      WHERE monitor_id IN (SELECT monitor_id FROM run GROUP BY monitor_id HAVING COUNT(*) > 150) AND
      run_row_id < (SELECT COUNT(*) - 100 FROM run WHERE monitor_id = general.monitor_id)
      GROUP BY monitor_id, id, run_row_id
  )

  DELETE FROM run
  WHERE id IN (SELECT id FROM selection);

END;

