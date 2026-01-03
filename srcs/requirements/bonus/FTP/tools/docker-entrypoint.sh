#!/usr/bin/env bash

# We point the home directory (-d) to the folder where WordPress is stored
if ! id "$FTP_USER" &>/dev/null; then
    useradd -d /var/www/html $FTP_USER
    echo "$FTP_USER:$(cat /run/secrets/ftp_password)" | chpasswd
fi

# Ensure the FTP user owns the folder so they can write to it
chown -R $FTP_USER:$FTP_USER /var/www/html

# Add the FTP user to the 'vsftpd.userlist' (Allow login)
echo $FTP_USER > /etc/vsftpd.userlist

echo "Starting FTP Server..."
/usr/sbin/vsftpd /etc/my_vsftpd.conf