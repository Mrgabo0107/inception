#!/bin/sh

wait_for_db() {
    echo "Waiting for Mariadb"
    until mysqladmin ping -h"mariadb" --silent; do
        echo "Waiting for Mariadb"
        sleep 2
    done
    echo "Mariadb up and running"
}

wait_for_db
sleep 10

cd $WP_PATH_DIR

echo "Checking for wp-config.php"
if [ ! -f "wp-config.php" ]; then
    echo "Downloading WordPress"
    su -s /bin/sh -c "wp core download --allow-root" www-data
    wp_downloaded=true

    echo "Creating config file"
    su -s /bin/sh -c "wp config create --dbname=${DB_NAME} \
                    --dbuser=${DB_USER} \
                    --dbpass=${DB_USER_PASSWORD} \
                    --dbhost=mariadb \
                    --path=${WP_PATH_DIR}" www-data
    echo "wp-config.php is ready"
else
    echo "wp-config.php is ready"
fi

if ! su -s /bin/sh -c "wp core is-installed" www-data; then
    if [ ! "$wp_downloaded" = false ]; then
        echo "Downloading WordPress"
        su -s /bin/sh -c "wp core download --allow-root" www-data
    fi
    echo "Installing WordPress"
    su -s /bin/sh -c "wp core install --url=${DOMAIN_NAME} \
                    --title=gamoreno-inception \
                    --admin_user=${WP_ADMIN_USER} \
                    --admin_password=${WP_ADMIN_PASSWORD} \
                    --admin_email=${GNRL_EMAIL} \
                    --skip-email" www-data
    echo "WordPress is installed"

    echo "Creating new user ($WP_USER)"
    su -s /bin/sh -c "wp user create ${WP_USER} ${GNRL_EMAIL} \
                    --user_pass=${WP_USER_PASSWORD} \
                    --role=author" www-data
    echo "User created"

    echo "=> Activating WordPress theme . . ."
    su -s /bin/sh -c "wp theme activate twentytwentytwo" www-data
else
    echo "=> WordPress already installed and configured!"
fi

php-fpm7.4 -F -R
