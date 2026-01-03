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
  wp db create --path=/var/www/wordpress --allow-root
  wp core install --path=/var/www/wordpress --url=$WP_SITE_URL --title="$WP_SITE_TITLE" --admin_user=$WP_ADMIN_USER --admin_password=$(cat /run/secrets/wp_admin_password) --admin_email=$WP_ADMIN_EMAIL --allow-root
  wp user create $WP_DEFAULT_USER $WP_DEFAULT_USER_EMAIL --role=$WP_DEFAULT_USER_ROLE --path=/var/www/wordpress --allow-root
  wp theme activate $WP_DEFAULT_THEME --allow-root --path=/var/www/wordpress

    # Configure Connection Details
  wp config set WP_REDIS_HOST $WP_REDIS_HOST --allow-root --path=/var/www/wordpress
  wp config set WP_REDIS_PORT $WP_REDIS_PORT --raw --allow-root --path=/var/www/wordpress

  #  Install and Activate the Plugin
  wp plugin install redis-cache --activate --allow-root  --path=/var/www/wordpress

  # Enable the Redis Object Cache
  # This creates the necessary 'object-cache.php' file.
  wp redis enable --allow-root  --path=/var/www/wordpress

  echo "WordPress installation done"
fi

#Start php-fpm in foreground as PID 1
exec php-fpm8.2 -F