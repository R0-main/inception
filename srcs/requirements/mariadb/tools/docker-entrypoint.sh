#!/bin/bash

export WP_PASSWORD=$(cat /run/secrets/wp_db_password)

envsubst < /tmp/init.sql.template > /tmp/init.sql

exec mysqld --user=mysql --init-file=/tmp/init.sql
