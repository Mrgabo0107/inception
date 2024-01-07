FROM    debian:bullseye

RUN		apt-get update && apt-get install -y \
		php7.4 \
		php7.4-fpm \
		php7.4-cgi \
		php7.4-common \
		php7.4-mysql \
		php7.4-gd \
		php7.4-xml \
		php7.4-mbstring \
		wget \
        curl \
		default-mysql-server \
		mariadb-client \
		&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY    ./conf/www.conf /etc/php/7.4/fpm/pool.d/

COPY    ./tools/init_wordpress.sh /bin/

RUN     curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
        chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && \
        mkdir -p /run/php/ && \
        mkdir -p /var/www/html && \
        chown -R www-data:www-data /var/www/* && \
        chmod -R 755 /var/www/* && \
        chmod +x /bin/init_wordpress.sh

ENTRYPOINT  [ "init_wordpress.sh" ]
