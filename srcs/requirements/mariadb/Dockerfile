FROM debian:12.11

RUN apt update && apt-get -y install sudo
RUN sudo apt install -y mariadb-server

# Create the directory for the MySQL socket
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

RUN sudo mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

COPY ./conf/init.sql /tmp/init.sql
COPY ./conf/mariadb.conf /etc/mysql/mariadb.conf.d/99-custom.cnf

# Set proper permissions
RUN chown mysql:mysql /etc/mysql/mariadb.conf.d/99-custom.cnf && \
    chmod 644 /etc/mysql/mariadb.conf.d/99-custom.cnf


CMD ["sudo", "mysqld", "--user=mysql", "--init-file=/tmp/init.sql"]
