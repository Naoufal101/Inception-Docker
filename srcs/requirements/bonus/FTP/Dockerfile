FROM debian:bookworm-slim

# Install vsftpd
RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

# Create the empty folder required by secure_chroot_dir
RUN mkdir -p /var/run/vsftpd/empty

# Copy our config and script
COPY conf/vsftpd.conf /etc/my_vsftpd.conf
COPY tools/docker-entrypoint.sh /usr/bin/

# Make script executable
RUN chmod +x /usr/bin/docker-entrypoint.sh

# Run the setup script
ENTRYPOINT ["docker-entrypoint.sh"]