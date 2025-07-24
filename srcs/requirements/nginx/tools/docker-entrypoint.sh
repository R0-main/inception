#!/bin/sh

envsubst '${DOMAIN_NAME} ${WP_PORT} ${ADMINER_PORT} ${STATIC_WEBSITE_PORT} ${N8N_PORT}' < /etc/nginx/templates/nginx.conf > /etc/nginx/sites-enabled/default

nginx -t

exec nginx -g 'daemon off;'
