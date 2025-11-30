#!/bin/sh

set -e

#get password
DB_PASSWORD=$(cat /run/secrets/my_other_secret)

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
    
    # mv wordpress/ to /var/www/, if it doesn't exist
    mv /tmp/wordpress/* /var/www/wordpress

    # Ensure proper permissions on mounted volume
    chown -R www-data:www-data /var/www/wordpress

    # rename wordpress config file
    mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

    # set dataBase credentials in wordpress config file
    sed -i "s/database_name_here/$MYSQL_DATABASE/" /var/www/wordpress/wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" /var/www/wordpress/wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/" /var/www/wordpress/wp-config.php
    sed -i "s/localhost/mariadb:3306/" /var/www/wordpress/wp-config.php

fi

#Start php-fpm in foreground as PID 1
exec php-fpm8.2 -F