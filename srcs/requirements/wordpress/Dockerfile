FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    curl \
    unzip \
    sudo \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's/;listen.owner = www-data/listen.owner = www-data/' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's/;listen.group = www-data/listen.group = www-data/' /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html

# # Download and extract WordPress
# RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
#     tar -xzf wordpress.tar.gz --strip-components=1 && \
#     rm wordpress.tar.gz


RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

RUN mkdir -p /run/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

RUN wp cli update --allow-root
RUN wp core download --allow-root

COPY ./conf/wp-config.php /var/www/html/wp-config.php
COPY ./tools/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]

