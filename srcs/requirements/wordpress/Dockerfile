FROM	debian:bookworm-slim

RUN 	apt-get update && apt-get install -y curl

RUN     curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		&& chmod +x wp-cli.phar \
		&& mv wp-cli.phar /usr/bin/wp

RUN		apt-get install -y --no-install-recommends php8.2-fpm \
		php8.2-mysql \
		libfcgi-bin \
		&& rm -rf /var/lib/apt/lists/*

COPY    ./conf/z_cgi.conf /etc/php/8.2/fpm/pool.d/

COPY	./tools/docker-entrypoint.sh /usr/bin/

RUN		chmod 744 /usr/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]