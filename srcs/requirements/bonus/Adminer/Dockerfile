# 1. Base Image (Debian Bullseye)
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    php \
    php-mysqli \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O index.php

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]