FROM debian:12.11

ARG DOMAIN_NAME

RUN apt update && apt-get -y install sudo
RUN sudo apt install -y nginx openssl

RUN mkdir -p /var/www/html
RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=${DOMAIN_NAME}"

RUN echo "<h1>Hello from ${DOMAIN_NAME}</h1>" > /var/www/html/index.html

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN nginx -t

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
