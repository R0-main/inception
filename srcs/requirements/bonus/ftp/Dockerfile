FROM debian:bullseye

RUN apt update && apt-get -y install sudo curl vsftpd

RUN sudo mkdir -p /var/run/vsftpd/empty
RUN sudo chown root:root /var/run/vsftpd/empty
RUN sudo chmod 755 /var/run/vsftpd/empty

RUN useradd -m -d /home/ftpuser -s /usr/sbin/nologin ftpuser

RUN echo "ftpuser:test" | chpasswd

RUN echo "/usr/sbin/nologin" >> /etc/shells

COPY ./conf/ftp.conf /etc/vsftpd.conf
COPY ./conf/vsftpd.userlist /etc/vsftpd.userlist
COPY ./certs/vsftpd.pem /etc/ssl/private/vsftpd.pem

EXPOSE 21 40000-40010

CMD ["vsftpd", "/etc/vsftpd.conf"]
