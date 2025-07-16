#!/bin/sh
echo "Starting Adminer server..."

echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf
a2enconf servername
a2enconf adminer.conf

service apache2 reload

exec apache2ctl -D FOREGROUND
