FROM debian:bookworm-slim

# Install Nginx and curl (for health check)
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    curl \
    && rm -rf /var/lib/apt/lists/*
    # ca-certificates \

# # Create necessary directories
# RUN mkdir -p /var/log/nginx && \
#     mkdir -p /var/cache/nginx && \
#     mkdir -p /etc/nginx/conf.d && \
#     mkdir -p /etc/nginx/ssl && \
#     chown -R nginx:nginx /var/log/nginx && \
#     chown -R nginx:nginx /var/cache/nginx

# # Copy custom Nginx configuration
# COPY nginx.conf /etc/nginx/nginx.conf

# Copy entrypoint script
# COPY docker-entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# # Health check
# HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    # CMD curl -f http://localhost/health || exit 1
COPY	./tools/docker-entrypoint.sh /usr/bin/

RUN		chmod 744 /usr/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]