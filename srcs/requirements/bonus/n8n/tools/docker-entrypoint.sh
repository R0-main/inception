#!/bin/sh

# Start Redis server
echo "Starting Redis server..."

exec redis-server --protected-mode no --bind 0.0.0.0 --port 6379 --daemonize no
