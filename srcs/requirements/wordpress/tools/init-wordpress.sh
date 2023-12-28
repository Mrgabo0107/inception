#!/bin/bash

# set -x
cd ${WP_PATH}
# Function to check if MariaDB is ready
wait_for_db() {
	echo "($?)" "Waiting for MariaDB..."
	until mysqladmin ping -h"mariadb" --silent; do
		echo "($?)" "Waiting for MariaDB..."
		sleep 2
	done
	echo "MariaDB up and running"
}

# Wait for MariaDB to be ready
wait_for_db
sleep 10

# Check if wp-config.php exists and create the file
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
	echo "Creating wp-config.php..."
	su -s /bin/sh -c "wp config create --dbname=${DB_NAME} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=mariadb:3306 --path=${WP_PATH}" www-data
	chmod 644 ${WP_PATH}/wp-config.php
fi

# Set ownership so wordpress can add content
chown -R www-data:www-data /var/www/html/*

# Check if WordPress is installed and install
if ! $(su -s /bin/sh -c "wp core is-installed --path=${WP_PATH}" www-data); then
	# Install WordPress
	su -s /bin/sh -c "wp core install --url=${DOMAIN_NAME} --title="Gamoreno-website" --admin_user="Symply-God" --admin_password=${MYSQL_ROOT_PASSWORD} --admin_email="gamoreno@student.42.fr" --path=${WP_PATH}" www-data
	# Create a second user
	su -s /bin/sh -c "wp user create gabo gabo@${DOMAIN_NAME} --role=author --user_pass=${MYSQL_PASSWORD} --path=${WP_PATH}" www-data
fi

# Start php-fpm in the foreground
echo "Starting FPM"
exec php-fpm7.4 -F
