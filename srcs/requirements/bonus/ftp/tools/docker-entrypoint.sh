#!/bin/sh
echo "Starting vsftpd FTP server..."
exec vsftpd /etc/vsftpd.conf -foreground
