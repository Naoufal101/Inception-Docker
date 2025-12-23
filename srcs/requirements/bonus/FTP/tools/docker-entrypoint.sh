#!/usr/bin/env bash

# 1. Create the FTP user if it doesn't exist
# We point the home directory (-d) to the folder where WordPress is stored
if ! id "$FTP_USER" &>/dev/null; then
    useradd -d /var/www/html $FTP_USER
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

# 2. Fix Permissions
# Ensure the FTP user owns the folder so they can write to it
chown -R $FTP_USER:$FTP_USER /var/www/html

# 3. Add the FTP user to the 'vsftpd.userlist' (Allow login)
echo $FTP_USER > /etc/vsftpd.userlist

# 4. Start the FTP server
echo "Starting FTP Server..."
/usr/sbin/vsftpd /etc/vsftpd.conf