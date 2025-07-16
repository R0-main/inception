FROM debian:bullseye

RUN apt update && apt-get -y install sudo
RUN apt-get -y install adminer

WORKDIR /usr/share/adminer/

RUN ./compile.php

RUN mv adminer-*.php adminer.php
RUN echo "Alias /adminer.php /usr/share/adminer/adminer.php" | tee /etc/apache2/conf-available/adminer.conf
RUN sudo echo "Alias /adminer.php /usr/share/adminer/adminer.php" | sudo tee /etc/apache2/conf-available/adminer.conf

COPY ./tools/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
