#!/bin/bash

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F
