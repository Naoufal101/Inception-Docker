FROM	debian:bookworm-slim

RUN		apt-get update && \
		apt-get install -y --no-install-recommends mariadb-server && \
		rm -rf /var/lib/apt/lists/*

COPY	./conf/.my.cnf /root/

COPY	tools/docker-entrypoint.sh /usr/bin/

RUN		chmod 744 /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
