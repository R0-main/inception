#!/bin/sh

envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/nginx.conf > /etc/nginx/sites-enabled/default

nginx -t

exec nginx -g 'daemon off;'
