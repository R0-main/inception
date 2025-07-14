FROM debian:12.11

RUN apt update && apt-get -y install sudo
RUN sudo apt install -y mariadb-server

RUN sudo systemctl enable mariadb

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

CMD ["mysqld"]
