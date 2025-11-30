FROM	debian:bookworm-slim

WORKDIR /var/www

RUN 	apt-get update && apt-get install -y curl

RUN		cd /tmp && curl -O https://wordpress.org/latest.tar.gz \
		&& tar -xf latest.tar.gz && rm -rf latest.tar.gz


RUN     curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN		apt-get install -y --no-install-recommends php8.2-fpm \
		php8.2-mysql \
		libfcgi-bin \
		&& rm -rf /var/lib/apt/lists/*

COPY    ./conf/z_cgi.conf /etc/php/8.2/fpm/pool.d/

COPY	./tools/docker-entrypoint.sh /usr/bin/

RUN		chmod 744 /usr/bin/docker-entrypoint.sh


ENTRYPOINT [ "docker-entrypoint.sh" ]