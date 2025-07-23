FROM debian:bullseye

# Installer les paquets nécessaires
RUN apt update && apt-get -y install sudo curl vsftpd

# RUN mkdir -p /var/run/vsftpd/empty
# RUN chmod 755 /var/run/vsftpd/empty
RUN sudo mkdir -p /var/run/vsftpd/empty
RUN sudo chown root:root /var/run/vsftpd/empty
RUN sudo chmod 755 /var/run/vsftpd/empty



# Créer l'utilisateur avec un home directory
RUN useradd -m -d /home/ftpuser -s /usr/sbin/nologin ftpuser

# Définir le mot de passe (IMPORTANT: utiliser chpasswd correctement)
RUN echo "ftpuser:test" | chpasswd

# Créer la structure de répertoires FTP
RUN mkdir -p /home/ftpuser/ftp/upload
RUN chown ftpuser:ftpuser /home/ftpuser
RUN chown root:root /home/ftpuser/ftp
RUN chown ftpuser:ftpuser /home/ftpuser/ftp/upload
RUN chmod 755 /home/ftpuser/ftp

# Configurer PAM pour vsftpd (CRITIQUE)
RUN echo "auth required pam_unix.so nullok" > /etc/pam.d/vsftpd
RUN echo "account required pam_unix.so" >> /etc/pam.d/vsftpd
RUN echo "session optional pam_unix.so" >> /etc/pam.d/vsftpd

# Permettre à l'utilisateur de se connecter même avec nologin
RUN echo "/usr/sbin/nologin" >> /etc/shells

COPY ./conf/ftp.conf /etc/vsftpd.conf
COPY ./conf/vsftpd.userlist /etc/vsftpd.userlist

COPY ./certs/vsftpd.pem /etc/ssl/private/vsftpd.pem

EXPOSE 21 40000-40010

# USER root

# CMD ["sleep", "10000000"]
CMD ["vsftpd", "/etc/vsftpd.conf"]
