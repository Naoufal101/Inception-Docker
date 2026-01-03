FROM debian:bookworm-slim

# Install Nginx and curl (for health check)
RUN     apt-get update && apt-get install -y --no-install-recommends \
        nginx \
        openssl \
        curl \
        && rm -rf /var/lib/apt/lists/*

COPY	./tools/docker-entrypoint.sh /usr/bin/

RUN		chmod 744 /usr/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]