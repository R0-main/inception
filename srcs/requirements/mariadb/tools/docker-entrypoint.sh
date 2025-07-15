#!/bin/bash

export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
envsubst < /tmp/init.sql.template > /tmp/init.sql

exec mysqld --user=mysql --init-file=/tmp/init.sql
