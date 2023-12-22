# Penultimate version of debian
FROM    debian:bullseye

RUN 	apt-get update && apt-get install -y \
		# PHP version 7.4
		php7.4 \
		# PHP FastCGI Process Manager
		php7.4-fpm \
		# PHP CGI
		php7.4-cgi \
		# PHP common files
		php7.4-common \
		# PHP MySQL module
		php7.4-mysql \
		# PHP GD graphics library
		php7.4-gd \
		# PHP XML module
		php7.4-xml \
		# PHP multibyte string module
		php7.4-mbstring \
		wget \
#		unzip \
		default-mysql-server \
		mariadb-client \
		iputils-ping \
		apt-get clean && rm -rf /var/lib/apt/lists/*

RUN		mkdir -p /var/www/html/ && mkdir -p /run/php && \
		chown -R www-data:www-data /var/www/html && \
        chmod -R 755 /var/www/html

RUN		wget https://wordpress.org/latest.tar.gz && \
		tar -xvzf latest.tar.gz && \
		mv wordpress/* /var/www/html/ && \
		rmdir wordpress && \
		rm latest.tar.gz

RUN		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		&& chmod +x wp-cli.phar	&& mv wp-cli.phar /usr/local/bin/wp

COPY	./tools/init-wordpress.sh  /bin/

RUN		chmod +x /bin/init-wordpress.sh

EXPOSE  9000

CMD ["start-wordpress.sh"]