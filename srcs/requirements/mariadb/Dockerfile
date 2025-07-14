FROM debian:12.11

RUN apt update && apt-get -y install sudo
RUN sudo apt install -y mariadb-server

# Create the directory for the MySQL socket
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

# Switch to mysql user
USER mysql

CMD ["mysqld", "--user=mysql"]
