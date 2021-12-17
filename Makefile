BASE_CONFIG_DIR := ./configs
GEN_CONFIG_DIR := ${BASE_CONFIG_DIR}/gen

.PHONY: gen-clickhouse-config
gen-clickhouse-config:
	rm -rf ${GEN_CONFIG_DIR} ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-blue-1 ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-blue-2 ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-green-1 ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-green-2 ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-orange-1 ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-orange-2

	SERVER_ID=1 envsubst < ${BASE_CONFIG_DIR}/enable_keeper.xml > ${GEN_CONFIG_DIR}/clickhouse-blue-1/enable_keeper.xml
	REPLICA=r1 SHARD=blue envsubst < ${BASE_CONFIG_DIR}/macros.xml > ${GEN_CONFIG_DIR}/clickhouse-blue-1/macros.xml
	cp -t ${GEN_CONFIG_DIR}/clickhouse-blue-1/ ${BASE_CONFIG_DIR}/remote_servers.xml ${BASE_CONFIG_DIR}/use_keeper.xml ${BASE_CONFIG_DIR}/docker_related_config.xml 

	SERVER_ID=2 envsubst < ${BASE_CONFIG_DIR}/enable_keeper.xml > ${GEN_CONFIG_DIR}/clickhouse-blue-2/enable_keeper.xml
	REPLICA=r2 SHARD=blue envsubst < ${BASE_CONFIG_DIR}/macros.xml > ${GEN_CONFIG_DIR}/clickhouse-blue-2/macros.xml
	cp -t ${GEN_CONFIG_DIR}/clickhouse-blue-2/ ${BASE_CONFIG_DIR}/remote_servers.xml ${BASE_CONFIG_DIR}/use_keeper.xml ${BASE_CONFIG_DIR}/docker_related_config.xml 

	SERVER_ID=3 envsubst < ${BASE_CONFIG_DIR}/enable_keeper.xml > ${GEN_CONFIG_DIR}/clickhouse-green-1/enable_keeper.xml
	REPLICA=r1 SHARD=green envsubst < ${BASE_CONFIG_DIR}/macros.xml > ${GEN_CONFIG_DIR}/clickhouse-green-1/macros.xml
	cp -t ${GEN_CONFIG_DIR}/clickhouse-green-1/ ${BASE_CONFIG_DIR}/remote_servers.xml ${BASE_CONFIG_DIR}/use_keeper.xml ${BASE_CONFIG_DIR}/docker_related_config.xml 

	REPLICA=r2 SHARD=green envsubst < ${BASE_CONFIG_DIR}/macros.xml > ${GEN_CONFIG_DIR}/clickhouse-green-2/macros.xml
	cp -t ${GEN_CONFIG_DIR}/clickhouse-green-2/ ${BASE_CONFIG_DIR}/remote_servers.xml ${BASE_CONFIG_DIR}/use_keeper.xml ${BASE_CONFIG_DIR}/docker_related_config.xml 

	REPLICA=r1 SHARD=orange envsubst < ${BASE_CONFIG_DIR}/macros.xml > ${GEN_CONFIG_DIR}/clickhouse-orange-1/macros.xml
	cp -t ${GEN_CONFIG_DIR}/clickhouse-orange-1/ ${BASE_CONFIG_DIR}/remote_servers.xml ${BASE_CONFIG_DIR}/use_keeper.xml ${BASE_CONFIG_DIR}/docker_related_config.xml 

	REPLICA=r2 SHARD=orange envsubst < ${BASE_CONFIG_DIR}/macros.xml > ${GEN_CONFIG_DIR}/clickhouse-orange-2/macros.xml
	cp -t ${GEN_CONFIG_DIR}/clickhouse-orange-2/ ${BASE_CONFIG_DIR}/remote_servers.xml ${BASE_CONFIG_DIR}/use_keeper.xml ${BASE_CONFIG_DIR}/docker_related_config.xml 

.PHONY: up
up:
	docker-compose up

.PHONY: keeper-check
keeper-check:
	echo ruok | nc 127.0.0.1 9181
