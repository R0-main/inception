#!/bin/sh

# Only substitute the DOMAIN_NAME variable, leave nginx variables alone
envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/nginx.conf > /etc/nginx/sites-enabled/default

# Test nginx configuration
nginx -t

# Start nginx
exec nginx -g 'daemon off;'
