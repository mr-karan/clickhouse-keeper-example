CREATE DATABASE app ON CLUSTER 'events';

CREATE TABLE app.events_local ON CLUSTER '{cluster}' (
    time DateTime,
    event_id  Int32,
    uuid UUID
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{cluster}/{shard}/table', '{replica}')
PARTITION BY toYYYYMM(time)
ORDER BY (event_id);

CREATE TABLE app.events_main ON CLUSTER '{cluster}' AS app.events_local
ENGINE = Distributed('{cluster}', app, events_local, rand());

/* Repeat several times */
INSERT INTO app.events_main VALUES
   (now(), rand(1), generateUUIDv4());
