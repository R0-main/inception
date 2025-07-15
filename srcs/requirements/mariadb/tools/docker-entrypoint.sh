#!/bin/bash

envsubst < /tmp/init.sql.template > /tmp/init.sql

exec mysqld --user=mysql --init-file=/tmp/init.sql
