FROM debian:bullseye

RUN apt update && apt-get -y install\
    sudo\
    mariadb-server\
    gettext-base

RUN mkdir -p /run/mysqld
RUN chown mysql:mysql /run/mysqld

RUN sudo mysql_install_db

COPY ./conf/init.sql /tmp/init.sql.template

COPY ./conf/mariadb.conf /etc/mysql/mariadb.conf.d/99-custom.cnf.template

ARG MARIADB_PORT
ENV MARIADB_PORT=${MARIADB_PORT}

RUN envsubst '${MARIADB_PORT}' < /etc/mysql/mariadb.conf.d/99-custom.cnf.template > /etc/mysql/mariadb.conf.d/99-custom.cnf

COPY ./tools/docker-entrypoint.sh /docker-entrypoint.sh

RUN chown mysql:mysql /etc/mysql/mariadb.conf.d/99-custom.cnf
RUN chmod 644 /etc/mysql/mariadb.conf.d/99-custom.cnf
RUN chmod +x /docker-entrypoint.sh

USER mysql

EXPOSE ${MARIADB_PORT}

ENTRYPOINT ["/docker-entrypoint.sh"]
