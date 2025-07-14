#!/bin/bash

# wp core install
# wp user create --allow-root rguigneb rguigneb@example.com --user_pass=admin --role=administrator
wp user create --allow-root riad riad@example.com --user_pass=riadlebg --role=subscriber
wp core install --allow-root --url=rguigneb.42.fr --title=42 --admin_user=rguigneb --admin_password=admin --admin_email=rguigneb@gmail.com

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F
