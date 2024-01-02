FROM	debian:bullseye

RUN		apt-get update && apt-get install -y \
		mariadb-server \
		mariadb-client \
		iputils-ping \
		&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY	./tools/init-database.sh /bin/

RUN		chmod +x /bin/init-database.sh && \
		chown -R mysql:mysql /var/log/mysql && \
		chmod -R 755 /var/log/mysql

RUN	mkdir -p /run/mysqld && chown -R mysql:root /run/mysqld

COPY	./conf/50-server.cnf /etc/mysql/

EXPOSE	3306

CMD		["init-database.sh"]

# FROM debian:bullseye

# RUN apt-get update && apt-get install -y \
#     mariadb-server \
#     iputils-ping \
#     && apt-get clean && rm -rf /var/lib/apt/lists/*

# # Copiar el script de inicialización
# COPY ./tools/init-database.sh /bin/
# RUN chmod +x /bin/init-database.sh

# # Copiar la configuración personalizada de MariaDB
# COPY ./conf/50-server.cnf /etc/mysql/

# # Exponer el puerto 3306 para MariaDB
# EXPOSE 3306

# # Establecer el script de inicialización como el comando predeterminado
# CMD ["init-database.sh"]
