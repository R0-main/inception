#!/bin/sh

envsubst < /etc/nginx/templates/nginx.conf > /etc/nginx/sites-available/default

nginx -t

exec nginx -g 'daemon off;'
