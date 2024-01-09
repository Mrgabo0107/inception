FROM	debian:bullseye

RUN	apt-get update -y && apt-get install -y \
	nginx \
	openssl \
	curl \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /var/www/html \
	&& chmod -R 755 /var/www/html \
	&& chown -R www-data:www-data /var/www/html

RUN	openssl req -newkey rsa:2048 \
	#autosigned
	-x509 \
	#for one year
	-days 365 \
	#private key not incripted (not password required)
	-nodes \
	#location
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	#certificate info
	-subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=42gamoreno/CN=gamoreno/"


COPY	./conf/nginx.conf /etc/nginx/conf.d

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]