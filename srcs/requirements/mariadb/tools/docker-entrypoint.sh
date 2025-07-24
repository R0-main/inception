#!/bin/bash

export WP_PASSWORD=$(cat /run/secrets/wp_db_password)
export N8N_DB_USER=$(sed -n '1p' /run/secrets/n8n_db_credentials)
export N8N_DB_PASSWORD=$(sed -n '2p' /run/secrets/n8n_db_credentials)

envsubst < /tmp/init.sql.template > /tmp/init.sql

exec mysqld --user=mysql --init-file=/tmp/init.sql
