#!/bin/bash

export WORDPRESS_DB_PASSWORD=$(cat /run/secrets/wp_db_password)

export WP_ADMIN_USER=$(sed -n '1p' /run/secrets/wp_admin_user_credentials)
export WP_ADMIN_EMAIL=$(sed -n '2p' /run/secrets/wp_admin_user_credentials)
export WP_ADMIN_PASSWORD=$(sed -n '3p' /run/secrets/wp_admin_user_credentials)

export WP_SUB_USER=$(sed -n '1p' /run/secrets/wp_sub_user_credentials)
export WP_SUB_EMAIL=$(sed -n '2p' /run/secrets/wp_sub_user_credentials)
export WP_SUB_PASSWORD=$(sed -n '3p' /run/secrets/wp_sub_user_credentials)

# Create wp-config.php if it doesn't exist
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create --allow-root \
        --dbname=${WORDPRESS_DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${WORDPRESS_DB_HOST} \
        --dbcharset=utf8mb4 \
        --dbcollate=''
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root ; then
    echo "Installing WordPress..."
    wp core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title="42" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    wp user create --allow-root \
        ${WP_SUB_USER} \
        ${WP_SUB_EMAIL} \
        --user_pass=${WP_SUB_PASSWORD} \
        --role=subscriber

	wp plugin install redis-cache --activate --allow-root
    wp config set WP_REDIS_HOST "${REDIS_HOST:-redis}" --allow-root
    wp config set WP_REDIS_PORT "${REDIS_PORT:-6379}" --raw --allow-root
	wp redis enable --allow-root
fi

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
