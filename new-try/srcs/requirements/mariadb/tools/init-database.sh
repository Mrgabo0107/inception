#!/bin/bash

#   Check if the wordpress database is already created
echo "=> Checking if \`$DB_NAME\` database exists . . ."
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then

    #   Check if MariaDB is already running
    if ! service mariadb status > /dev/null; then
        echo "=> MariaDB service is not running, starting it . . ."
        service mariadb start
        sleep 2
    else
        echo "=> MariaDB service is already running."
    fi

    echo "=> creating \`$DB_NAME\` database . . ."
    # CREATE WORDPRESS DATABASE
    mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

    # CREATE USER
    echo "=> creating user . . ."
    mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';"

    # PRIVILEGES USER FOR ALL IP ADRESSES
    mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';"

    mysql -e "FLUSH PRIVILEGES;"

    # FORCE AUTHENTIFICATION WITH PASSWORD FOR ROOT
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$GNRL_ROOT_PASSWORD';"

    mysqladmin -u root -p${GNRL_ROOT_PASSWORD} shutdown

    echo "=> MariaDB database and user were created successfully! "

    # Shutdown MariaDB gracefully if it was started in this script
    if [ -f /var/run/mysqld/mysqld.pid ]; then
        echo "=> Shutting down MariaDB..."
        service mariadb stop
        # kill $(cat /var/run/mysqld/mysqld.pid)
        sleep 2
    fi

else
    echo "=> \`$DB_NAME\` database exists!"
fi

exec mysqld
