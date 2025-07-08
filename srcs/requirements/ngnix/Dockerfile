FROM debian:12.11

RUN apt update && apt-get -y install sudo
RUN sudo apt install -y nginx openssl

COPY ./certs/selfsigned.crt /etc/ssl/certs/
COPY ./certs/selfsigned.key /etc/ssl/private/
COPY ./conf/nginx.conf /etc/nginx/sites-available/default
COPY ./tools/index.html /var/www/html/index.html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
