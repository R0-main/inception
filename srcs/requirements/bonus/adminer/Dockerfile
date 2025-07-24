FROM debian:bullseye

RUN apt update && apt-get -y install sudo
RUN apt-get -y install adminer

WORKDIR /usr/share/adminer/

ARG ADMINER_PORT
ENV ADMINER_PORT=${ADMINER_PORT}

RUN ./compile.php

RUN mv adminer-*.php adminer.php
RUN echo "Alias /adminer.php /usr/share/adminer/adminer.php" | tee /etc/apache2/conf-available/adminer.conf
RUN sudo echo "Alias /adminer.php /usr/share/adminer/adminer.php" | sudo tee /etc/apache2/conf-available/adminer.conf

EXPOSE ${ADMINER_PORT}

CMD php -S 0.0.0.0:${ADMINER_PORT} adminer.php
