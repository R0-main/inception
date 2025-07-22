FROM debian:bullseye

RUN apt update && apt-get -y install sudo curl vsftpd

RUN mkdir -p /home/ftp/wordpress
RUN chown ftp:ftp /home/ftp/wordpress

COPY ./tools/docker-entrypoint.sh /home/ftp/docker-entrypoint.sh
RUN chmod +x /home/ftp/docker-entrypoint.sh

COPY ./conf/ftp.conf /etc/vsftpd.conf

WORKDIR /home/ftp

USER ftp
EXPOSE 5678

CMD ["vsftpd", "/etc/vsftpd.conf"]

