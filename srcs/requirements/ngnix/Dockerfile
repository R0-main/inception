FROM debian:12.11

# ARG DOMAIN_NAME

RUN apt update && apt-get -y install sudo
RUN sudo apt install -y nginx openssl

EXPOSE 80

# COPY ./conf/nginx.conf /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]
