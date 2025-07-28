#!/bin/sh

export DB_MYSQLDB_USER=$(sed -n '1p' /run/secrets/n8n_db_credentials)
export DB_MYSQLDB_PASSWORD=$(sed -n '2p' /run/secrets/n8n_db_credentials)
export N8N_ENCRYPTION_KEY=$(cat /run/secrets/n8n_encryption_key)

# if we have enterprise things
# n8n user:create --email "$N8N_EMAIL" --password "$N8N_PASSWORD" --first-name "Default" --last-name "Owner"
# n8n import:credentials --input=/home/n8n/discord_workflow_credentials.json

n8n import:workflow --input=/home/n8n/discord_workflow.json

exec n8n
