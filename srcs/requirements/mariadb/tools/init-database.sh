#!/bin/bash

echo "Starting MariaDB server"

#Start mysql in the background and save the pid 
mysqld_safe &
mariadb_pid=$!

# waiting to start
while ! mysqladmin ping --silent; do
	sleep 2
done

echo "Server started. Setting up database values:"
run_cmd="mysql -u root -p${MYSQL_ROOT_PASSWORD} -e"

# Create database
echo "Create data base if it doesn't exist"
$run_cmd "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"

# Create user
echo "Create user if it doesn't exist"
$run_cmd "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Grant privileges to user
echo "Grant all privileges on ${DB_NAME} to ${MYSQL_USER}"
$run_cmd "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${MYSQL_USER}\`@'%';"

# Flush privileges to reload the permissions and avoid to restart the database
echo "Flush privileges"
$run_cmd "FLUSH PRIVILEGES;"

echo "Setup finished."

# Wait for the background MariaDB server to finish and stop
# wait $mariadb_pid

# echo "Waiting for MariaDB server to finish..."
# while ps -p $mariadb_pid > /dev/null; do
#     sleep 1
# done
echo "Waiting for MariaDB server to finish..."
while pgrep -x mysqld_safe > /dev/null; do
    sleep 1
done

echo "Launching Database as the main process."

# Replace the current shell with mysqld_safe as the main process
exec mysqld_safe
