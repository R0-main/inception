#!/bin/sh
# Start Redis server
echo "Starting Adminer server..."

exec a2enconf adminer.conf

service apache2 reload

