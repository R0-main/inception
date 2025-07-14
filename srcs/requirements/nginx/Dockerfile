FROM debian:12.11

RUN apt update && apt-get -y install sudo
RUN sudo apt install -y nginx openssl gettext-base
RUN mkdir -p /var/www/html

COPY ./certs/selfsigned.crt /etc/ssl/certs/
COPY ./certs/selfsigned.key /etc/ssl/private/
COPY ./conf/nginx.conf /etc/nginx/templates/nginx.conf

# COPY ./tools/index.html /var/www/html/index.html

COPY ./tools/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/docker-entrypoint.sh"]
