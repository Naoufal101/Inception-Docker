#!/bin/sh

set -e

#get password
DB_PASSWORD=$(cat /run/secrets/my_other_secret)

# entrypoint.sh
if wp core is-installed --allow-root --path=/var/www/wordpress 2>/dev/null; then
  echo "WordPress already installed — skipping setup"
else
  echo "Installing WordPress..."
  wp core download --path=/var/www/wordpress --allow-root
  wp config create --path=/var/www/wordpress --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$(cat /run/secrets/my_other_secret) --dbhost=mariadb:3306 --skip-check --allow-root
  wp core install --path=/var/www/wordpress --url=localhost --title="The Inception" --admin_user=molxi --admin_password=molxi123 --admin_email=molxi@gmail.com --allow-root
  echo "WordPress installation done"
fi

#Start php-fpm in foreground as PID 1
exec php-fpm8.2 -F