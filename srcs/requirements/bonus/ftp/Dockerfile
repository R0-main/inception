FROM debian:bullseye

RUN apt update && apt-get -y install sudo curl vsftpd gettext-base

ARG FTP_PORT
ARG FTP_MIN_PORT
ARG FTP_MAX_PORT

ENV FTP_PORT=${FTP_PORT}
ENV FTP_MIN_PORT=${FTP_MIN_PORT}
ENV FTP_MAX_PORT=${FTP_MAX_PORT}

RUN sudo mkdir -p /var/run/vsftpd/empty
RUN sudo chown root:root /var/run/vsftpd/empty
RUN sudo chmod 755 /var/run/vsftpd/empty

RUN useradd -m -d /home/ftpuser -s /usr/sbin/nologin ftpuser

RUN echo "ftpuser:test" | chpasswd

RUN echo "/usr/sbin/nologin" >> /etc/shells

COPY ./conf/ftp.conf /etc/vsftpd.conf.template
RUN envsubst '${FTP_PORT} ${FTP_MIN_PORT} ${FTP_MAX_PORT}' < /etc/vsftpd.conf.template > /etc/vsftpd.conf

COPY ./conf/vsftpd.userlist /etc/vsftpd.userlist
COPY ./certs/vsftpd.pem /etc/ssl/private/vsftpd.pem

EXPOSE ${FTP_PORT} ${FTP_MIN_PORT}-${FTP_MAX_PORT}

CMD ["vsftpd", "/etc/vsftpd.conf"]
