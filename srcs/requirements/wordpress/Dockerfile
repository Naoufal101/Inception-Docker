FROM		debian:bookworm-slim

RUN 		apt-get update && apt-get install -y curl

RUN			cd /tmp && curl -O https://wordpress.org/latest.tar.gz \
			&& tar -xf latest.tar.gz && rm -rf latest.tar.gz

RUN			apt-get install -y --no-install-recommends php8.2-fpm  php8.2-mysql && \
			rm -rf /var/lib/apt/lists/*

COPY		./tools/docker-entrypoint.sh /usr/bin/

RUN			chmod 744 /usr/bin/docker-entrypoint.sh

WORKDIR 	/var/www

ENTRYPOINT [ "docker-entrypoint.sh" ]