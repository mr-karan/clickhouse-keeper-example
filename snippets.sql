---local:
CREATE DATABASE app;
CREATE TABLE app.events_local (
    time DateTime,
    event_id  Int32,
    type LowCardinality(String)
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{cluster}/{shard}/table', '{replica}')
PARTITION BY toYYYYMM(time)
ORDER BY (event_id);

---random_data:
CREATE TABLE generate_engine_table (name String, value UInt32) ENGINE = GenerateRandom(1, 5, 3);
SELECT now(),* FROM generate_engine_table LIMIT 1000;

---insert_events_data:
INSERT INTO app.events_main VALUES
    (now(), rand(1), generateUUIDv4());

---query_shards:
SELECT * FROM
(
    SELECT hostName(), *
    FROM remote('172.20.0.2', 'app', 'events_local')
    UNION ALL
    SELECT hostName(), *
    FROM remote('172.20.0.3', 'app', 'events_local')
    UNION ALL
    SELECT hostName(), *
    FROM remote('172.20.0.4', 'app', 'events_local')
    UNION ALL
    SELECT hostName(), *
    FROM remote('172.20.0.5', 'app', 'events_local')
    UNION ALL
    SELECT hostName(), *
    FROM remote('172.20.0.6', 'app', 'events_local')
    UNION ALL
    SELECT hostName(), *
    FROM remote('172.20.0.7', 'app', 'events_local')
);
