# ClickHouse Keeper Example

An example of running a local `ClickHouse` cluster using `clickhouse-keeper` for replication.

Config examples accompanying the [blog post](https://mrkaran.dev/posts/clickhouse-replication/).

## Generate Config

```bash
make gen-clickhouse-config
```

## Run Containers

```
make up
```

## Setup Cluster Schema

```
docker-compose exec clickhouse-blue-1 clickhouse-client  
```

Run all the commands present inside [schema.sql](./schema.sql).

### Query all shards/replicas

```sql
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
```

Replace the private IPs with the `host_address` you find inside your cluster:

```sql
SELECT
    host_name,
    host_address
FROM system.clusters
```
