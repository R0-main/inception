# Inception (Bonus Stack)

The **bonus** branch packages an end-to-end WordPress environment that mirrors the 42 _Inception_ project requirements while leaving plenty of room for experimentation. Everything runs on self-built Docker images orchestrated with Docker Compose: an HTTPS-terminating Nginx proxy, a PHP-FPM WordPress container bootstrapped with WP-CLI, and a MariaDB database seeded from secrets. The Makefile automates the full lifecycle so you can focus on extending the stack with your own services.

---

## Table of Contents
- [Architecture](#architecture)
- [Stack Overview](#stack-overview)
- [Repository Layout](#repository-layout)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [.env variables](#env-variables)
  - [Secrets](#secrets)
- [Managing the Stack](#managing-the-stack)
  - [Using the Makefile](#using-the-makefile)
  - [Running raw Docker commands](#running-raw-docker-commands)
- [Data & TLS Assets](#data--tls-assets)
- [Customization Recipes](#customization-recipes)
- [Troubleshooting](#troubleshooting)
- [Bonus Extensions](#bonus-extensions)

---

## Architecture

```
┌─────────────┐       ┌─────────────┐       ┌───────────────┐
│   Browser   │ 443 → │    Nginx    │ ───→  │  WordPress    │
└─────────────┘       └─────────────┘       └───────────────┘
                                         ┌────────────────┐
                                         │    MariaDB     │
                                         └────────────────┘
```

- **TLS termination** happens inside `nginx`, which serves static assets and forwards PHP requests to the WordPress FastCGI socket.
- **Application logic** lives in `wordpress`, configured via WP-CLI to remain idempotent on restarts.
- **Persistence** is handled by MariaDB and bind-mounted volumes stored under `/home/<user>/data/` by default.

## Stack Overview

| Service   | Container Name | Port(s) | Responsibilities |
|-----------|----------------|---------|------------------|
| nginx     | `nginx`        | 443     | Serves HTTPS, proxies PHP requests, delivers static files |
| wordpress | `wordpress`    | internal (FastCGI) | Runs PHP-FPM, installs core, themes, and users with WP-CLI |
| mariadb   | `mariadb`      | internal | Stores WordPress content and credentials |

All containers share the `inception-network` bridge network defined in [`srcs/docker-compose.yml`](srcs/docker-compose.yml).

## Repository Layout

```
.
├── Makefile                  # Shortcuts for setup, run, teardown, cleanup
├── README.md                 # This guide
├── secrets/wordpress/        # Secret files consumed by Docker secrets
├── srcs/
│   ├── .env                  # Central environment configuration
│   ├── docker-compose.yml    # Service, network, volume, and secret definitions
│   └── requirements/
│       ├── nginx/            # Custom Nginx Docker context (certs, config, entrypoint)
│       ├── wordpress/        # WordPress Docker context (WP-CLI bootstrap)
│       └── mariadb/          # MariaDB Docker context (init SQL, config, entrypoint)
└── ...
```

## Prerequisites

- Docker Engine **20.10+** with the Docker Compose V2 plugin (`docker compose` command).
- GNU Make (used for the helper targets).
- Permissions to edit `/etc/hosts` so you can map the development domain to `127.0.0.1`.

## Quick Start

```bash
# Clone and switch to the bonus branch
$ git clone https://github.com/<you>/inception.git
$ cd inception
$ git checkout bonus

# Populate secrets (see below) and adjust srcs/.env to your liking
$ make setup           # creates volumes directories and seeds /etc/hosts
$ make up              # builds images and starts the stack in detached mode

# Visit the site (accept the self-signed certificate warning)
$ open https://rguigneb.42.fr
```

Stop the environment with `make down`, or nuke everything (including bind-mounted data) with `make clean-data`.

## Configuration

### .env variables

The `.env` file under `srcs/` is the source of truth for Compose. Adjust ports, domain, or volume locations as needed:

```dotenv
# srcs/.env
DOMAIN_NAME=example.local
NGINX_PORT=443
WP_PORT=9000
MARIADB_PORT=3306
VOLUME_WORDPRESS_PATH=/home/$USER/data/wordpress
VOLUME_MARIADB_PATH=/home/$USER/data/mariadb
WP_DATABASE=wordpress
WP_USER=wordpress
```

### Secrets

Credentials live in Docker secrets for safety. Each file stores a single value per line:

```bash
$ cat secrets/wordpress/db_password.txt
ChangeMeSuperSecure!

$ cat secrets/wordpress/wp_admin_user_credentials.txt
admin
admin@example.local
Tr0ub4dor&3

$ cat secrets/wordpress/wp_sub_user_credentials.txt
subscriber
subscriber@example.local
SubPass123!
```

> :information_source: The entrypoint scripts read these secrets and configure both MariaDB and WordPress accordingly. Update them before first launch to avoid reinitializing data.

## Managing the Stack

### Using the Makefile

```bash
make setup       # Prepare host directories, ensure correct permissions, update /etc/hosts
make up          # Build images and start containers (detached)
make down        # Stop and remove containers while keeping volumes intact
make clean       # Stop containers and prune images/networks created by the stack
make clean-data  # Remove bind-mounted data under /home/<user>/data
make re          # Equivalent to clean + up (fresh rebuild)
```

### Running raw Docker commands

If you prefer direct Compose calls, the Make targets wrap the following commands:

```bash
# Build and run
$ docker compose -f srcs/docker-compose.yml up -d --build

# Inspect logs
$ docker compose -f srcs/docker-compose.yml logs -f nginx

# Tear down
$ docker compose -f srcs/docker-compose.yml down
```

## Data & TLS Assets

- WordPress and MariaDB data persist to the host paths specified in `.env` (`VOLUME_WORDPRESS_PATH`, `VOLUME_MARIADB_PATH`). Back them up to preserve site content.
- The bundled TLS certificate/key live in `srcs/requirements/nginx/certs/`. Replace `selfsigned.crt` and `selfsigned.key` with your own files to remove browser warnings.
- File permissions are normalized to UID/GID `33` (`www-data`) during `make up` to keep the PHP-FPM process happy.

## Customization Recipes

- **Serve the stack on a new domain and port**:
  ```bash
  # srcs/.env
  DOMAIN_NAME=blog.local
  NGINX_PORT=8443
  ```
  Update `/etc/hosts` with `127.0.0.1 blog.local` and restart via `make re`.

- **Bundle additional WordPress plugins/themes at build time**:
  ```dockerfile
  # srcs/requirements/wordpress/Dockerfile
  RUN wp plugin install redis-cache --activate --allow-root \
      && wp theme install twentytwentythree --activate --allow-root
  ```

- **Expose MariaDB for GUI clients**:
  ```yaml
  # srcs/docker-compose.yml
  services:
    mariadb:
      ports:
        - "3306:3306"
  ```
  Remember to secure remote access with strong passwords and firewalls.

- **Customize Nginx routing**: tweak `srcs/requirements/nginx/conf/nginx.conf` to add redirects, additional locations, or HTTP/2 support.

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| WordPress installer re-runs on every boot | Host volume not writable by `www-data` | `sudo chown -R 33:33 $VOLUME_WORDPRESS_PATH` then `make re` |
| Browser warns about invalid certificate | Included cert is self-signed | Replace `certs/selfsigned.crt` and `certs/selfsigned.key` with trusted files |
| `Error establishing a database connection` | Secret credentials mismatch or MariaDB volume corruption | Verify secret files, delete the MariaDB volume directory, and run `make re` |
| Services exit immediately | Missing secrets or `.env` values | Double-check that every required file exists and contains the expected values |

## Bonus Extensions

The bonus branch is a great playground for extra services. A few ideas:

- **Add Redis caching**: create `srcs/requirements/redis/` with a Dockerfile, add a `redis` service in `docker-compose.yml`, and install a Redis plugin in WordPress.
- **Serve static assets from a CDN container**: build an `alpine`-based `static` service that mounts `wordpress/wp-content/uploads` read-only.
- **Deploy an Adminer or phpMyAdmin container**: extend Compose with a `phpmyadmin` service connected to `inception-network` for quick database inspections.

Each addition should follow the repository pattern—build from scratch, define secrets via bind-mounted files, and hook into the shared network. Have fun experimenting!
