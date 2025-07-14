FROM debian:12.11

RUN apt update && apt-get -y install\
    sudo\
    mariadb-server

RUN mkdir -p /run/mysqld
RUN chown mysql:mysql /run/mysqld

RUN sudo mysql_install_db --user=mysql --datadir=/var/lib/mysql

COPY ./conf/init.sql /tmp/init.sql
COPY ./conf/mariadb.conf /etc/mysql/mariadb.conf.d/99-custom.cnf

RUN chown mysql:mysql /etc/mysql/mariadb.conf.d/99-custom.cnf
RUN chmod 644 /etc/mysql/mariadb.conf.d/99-custom.cnf

CMD ["mysqld", "--user=mysql", "--init-file=/tmp/init.sql"]
