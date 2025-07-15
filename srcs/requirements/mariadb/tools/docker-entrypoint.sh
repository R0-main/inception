#!/bin/bash

# Use envsubst to substitute environment variables in the SQL template
envsubst < /tmp/init.sql.template > /tmp/init.sql

# Start MariaDB with the generated init file
exec mysqld --user=mysql --init-file=/tmp/init.sql
