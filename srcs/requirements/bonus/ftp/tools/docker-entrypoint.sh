#!/bin/sh

export FTP_USERNAME=$(sed -n '1p' /run/secrets/ftp_user_credentials)
export FTP_USER_PASSWORD=$(sed -n '2p' /run/secrets/ftp_user_credentials)

echo $FTP_USERNAME > /etc/vsftpd.userlist

useradd -m -d /ftp/wordpress -s /usr/sbin/nologin $FTP_USERNAME
echo $FTP_USERNAME:$FTP_USER_PASSWORD | chpasswd
usermod -a -G www-data $FTP_USER

exec vsftpd /etc/vsftpd.conf
