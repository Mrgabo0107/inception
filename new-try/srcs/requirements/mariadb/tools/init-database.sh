#!/bin/bash

echo "Checking if \`$DB_NAME\` database exists"
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then

    if ! service mariadb status > /dev/null; then
        echo "MariaDB service is not running, starting it"
        service mariadb start
        sleep 2
    else
        echo "MariaDB service is already running."
    fi

    echo "MariaDB server started. Setting up user: ${DB_USER}"
    run_cmd="mysql -u root -p${GNRL_ROOT_PASSWORD} -e"

    echo "Create db if it doesn't exist"
    $run_cmd "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"

    echo "Create user if it doesn't exist"
    $run_cmd "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';"

    echo "Grant all privileges on ${DB_NAME} to ${DB_USER}"
    $run_cmd "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%';"

    echo "Flush privileges"
    $run_cmd "FLUSH PRIVILEGES;"

    mysqladmin -u root -p${GNRL_ROOT_PASSWORD} shutdown

    echo "MariaDB database and user were created successfully! "

    if [ -f /var/run/mysqld/mysqld.pid ]; then
        echo "=> Shutting down MariaDB..."
        service mariadb stop
        sleep 2
    fi

else
    echo "=> \`$DB_NAME\` database exists!"
fi

exec mysqld