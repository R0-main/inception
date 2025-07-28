FROM debian:bullseye

ARG NGINX_PORT
ENV NGINX_PORT=${NGINX_PORT}

RUN apt update && apt-get -y install sudo
RUN sudo apt install -y nginx openssl gettext-base
RUN mkdir -p /var/www/html

COPY ./certs/selfsigned.crt /etc/ssl/certs/
COPY ./certs/selfsigned.key /etc/ssl/private/
COPY ./conf/nginx.conf /etc/nginx/templates/nginx.conf

COPY ./tools/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE ${NGINX_PORT}

ENTRYPOINT ["/docker-entrypoint.sh"]
