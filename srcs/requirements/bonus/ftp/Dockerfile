FROM debian:bullseye

RUN apt update && apt-get -y install sudo curl vsftpd

RUN useradd -m -s /bin/bash ftp

COPY ./tools/docker-entrypoint.sh /home/ftp/docker-entrypoint.sh
RUN chmod +x /home/ftp/docker-entrypoint.sh

WORKDIR /home/ftp

USER ftp
EXPOSE 5678

ENTRYPOINT ["/home/ftp/docker-entrypoint.sh"]
