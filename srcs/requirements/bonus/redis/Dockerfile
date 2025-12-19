# 1. Use Debian Bullseye (Stable and reliable)
FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y redis-server && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i "s/bind 127.0.0.1/#bind 127.0.0.1/" /etc/redis/redis.conf

RUN sed -i "s/protected-mode yes/protected-mode no/" /etc/redis/redis.conf

RUN sed -i "s/daemonize yes/daemonize no/" /etc/redis/redis.conf

CMD ["redis-server", "/etc/redis/redis.conf"]