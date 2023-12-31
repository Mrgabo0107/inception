# penultimate version of debian
FROM	debian:bullseye

# install stuff and clean
RUN		apt-get update -y && apt-get install -y \
		nginx \
		openssl \
		curl \
		iputils-ping &&\
		apt-get clean && rm -rf /var/lib/apt/lists/*

#create 2048 bits key
RUN		openssl req -newkey rsa:2048 \
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

RUN chmod 600 /etc/ssl/certs/nginx-selfsigned.crt /etc/ssl/private/nginx-selfsigned.key

# assure that html directory is created, with good permissions, group and owner
RUN		mkdir -p /var/www/html && \
		chmod -R 755 /var/www/html && \
		chown -R www-data:www-data /var/www/html

COPY	./conf/nginx.conf /etc/nginx/

# RUN		chmod -R 755 /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]