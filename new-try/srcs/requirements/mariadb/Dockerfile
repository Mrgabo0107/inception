FROM	debian:bullseye

RUN	apt-get update && apt-get install -y \
mariadb-server mariadb-client -y

RUN	mkdir -p /run/mysqld && chown -R mysql:root /run/mysqld

COPY	./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY    ./tools/init-database.sh /bin/

RUN	chmod +x /bin/init-database.sh

ENTRYPOINT	[ "init-database.sh" ]

# FROM	debian:bullseye

# RUN		apt-get update && apt-get install -y \
# 		mariadb-server \
# 		mariadb-client \
# 		iputils-ping \
# 		&& apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN     mkdir -p /run/mysqld && chown -R mysql:root /run/mysqld

# COPY	./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# COPY	./tools/init-database.sh /bin/

# RUN		chmod +x /bin/init-database.sh \
# 		# chown -R mysql:mysql /var/log/mysql && \
# 		# chmod -R 755 /var/log/mysql

# # EXPOSE	3306

# CMD		["init-database.sh"]