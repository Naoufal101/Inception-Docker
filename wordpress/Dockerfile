FROM		debian:bookworm-slim

WORKDIR		/var/www/

RUN			wget https://wordpress.org/latest.tar.gz \
			&& tar -xvf latest.tar.gz && rm -rf latest.tar.gz \
			&& apt-get update && apt-get install php php-fpm

COPY		./tools/entry_point.sh /usr/bin/

RUN			 chmod 744 /usr/bin/entry_point.sh

ENTRYPOINT [ "entry_point.sh" ]