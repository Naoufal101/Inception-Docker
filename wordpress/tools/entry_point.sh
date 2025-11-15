#!/bin/sh
DB_PASSWORD=$(cat /run/secrets/db_password)

#rename wordpress config file
mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

#set dataBase credentials in wordpress config file
sed -i "s/MyDatabaseName/$DB_Name/" /var/www/html/wp-config.php
sed -i "s/MyUserName/$DB_UserName/" /var/www/html/wp-config.php
sed -i "s/DB_PASSWORD/$DB_PASSWORD/" /var/www/html/wp-config.php
sed -i "s/MyDatabaseHost/mariadb:3306/" /var/www/html/wp-config.php


exec php-fpm
