FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx

COPY ./conf/nginx.conf /etc/nginx/conf.d

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]