#!/bin/sh

n8n &

# PID du process lancé
N8N_PID=$!

# Attendre que la table "user" soit créée
until mysql -h mariadb -u n8n_user -pn8n_password -e "USE n8n; SHOW TABLES LIKE 'user';" | grep user; do
  echo "Waiting for table 'user' to be ready..."
  sleep 5
done

# Une fois prêt, on injecte les données
echo "Running SQL init script..."
mysql -h mariadb -u n8n_user -pn8n_password n8n < /home/n8n/init.sql

# Attendre que n8n (en arrière-plan) se termine (ça le garde en premier plan)
wait $N8N_PID
