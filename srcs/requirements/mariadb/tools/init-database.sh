#!/bin/bash

# echo "Starting MariaDB server"

# #Start mysql in the background and save the pid 
# mysqld_safe &
# mariadb_pid=$!

# # waiting to start
# while ! mysqladmin ping --silent; do
# 	sleep 2
# done

# echo "Server started. Setting up database values:"
# run_cmd="mysql -u root -p${GNRL_ROOT_PASSWORD} -e"

# # Create database
# echo "Create data base if it doesn't exist"
# $run_cmd "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"

# # Create user
# echo "Create user if it doesn't exist"
# $run_cmd "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# # Grant privileges to user
# echo "Grant all privileges on ${DB_NAME} to ${MYSQL_USER}"
# $run_cmd "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${MYSQL_USER}\`@'%';"

# # Flush privileges to reload the permissions and avoid to restart the database
# echo "Flush privileges"
# $run_cmd "FLUSH PRIVILEGES;"

# echo "Setup finished."

# # Wait for the background MariaDB server to finish and stop
# # wait $mariadb_pid

# # echo "Waiting for MariaDB server to finish..."
# # while ps -p $mariadb_pid > /dev/null; do
# #     sleep 1
# # done
# # echo "Waiting for MariaDB server to finish..."
# # while pgrep -x mysqld_safe > /dev/null; do
# #     sleep 1
# # done

# # echo "Launching Database as the main process."

# # # Replace the current shell with mysqld_safe as the main process
# # exec mysqld_safe

# # echo "Setup finished. Stopping MySQL server started by the script."

# # Detener el servidor MySQL iniciado por el script
# mysqladmin shutdown

# echo "MySQL server stopped. Starting MySQL as the main process."

# # Iniciar el servidor MySQL como proceso principal
# exec mysqld_safe



# echo "Starting MariaDB server"

# # Start mysql in the background
# mysqld_safe &

# # Wait for MariaDB to start
# while ! mysqladmin ping --silent; do
#     sleep 2
# done

# echo "Server started. Setting up database values:"
# run_cmd="mysql -u root -p${GNRL_ROOT_PASSWORD} -e"

# # Create database
# echo "Create database if it doesn't exist"
# $run_cmd "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"

# # Create user
# echo "Create user if it doesn't exist"
# $run_cmd "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# # Grant privileges to user
# echo "Grant all privileges on ${DB_NAME} to ${MYSQL_USER}"
# $run_cmd "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${MYSQL_USER}\`@'%';"

# # Flush privileges to reload the permissions
# echo "Flush privileges"
# $run_cmd "FLUSH PRIVILEGES;"

# echo "Setup finished. MariaDB is now ready."

# # Detener el servidor MySQL iniciado por el script
# mysqladmin shutdown

# echo "MySQL server stopped. Setup finished."


#   Check if the wordpress database is already created

# set -x
# echo "=> Checking if \`$DB_NAME\` database exists . . ."
# if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then

#     #   Check if MariaDB is already running
#     if ! service mariadb status > /dev/null; then
#         echo "=> MariaDB service is not running, starting it . . ."
#         service mariadb start
#         sleep 2
#     else
#         echo "=> MariaDB service is already running."
#     fi

#     echo "=> creating \`$DB_NAME\` database . . ."
#     # CREATE WORDPRESS DATABASE
#     mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

#     # CREATE USER
#     echo "=> creating user . . ."
#     mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

#     # PRIVILEGES USER FOR ALL IP ADRESSES
#     mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

#     mysql -e "FLUSH PRIVILEGES;"

#     # FORCE AUTHENTIFICATION WITH PASSWORD FOR ROOT
#     mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$GNRL_ROOT_PASSWORD';"

#     mysqladmin -u root -p${GNRL_ROOT_PASSWORD} shutdown

#     echo "=> MariaDB database and user were created successfully! "

#     # Shutdown MariaDB gracefully if it was started in this script
#     if [ -f /var/run/mysqld/mysqld.pid ]; then
#         echo "=> Shutting down MariaDB..."
#         service mariadb stop
#         # kill $(cat /var/run/mysqld/mysqld.pid)
#         sleep 2
#     fi

# else
#     echo "=> \`$DB_NAME\` database exists!"
# fi

# exec mysqld