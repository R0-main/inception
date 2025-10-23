# Inception

Inception is a containerized infrastructure for hosting a self-managed WordPress site and a handful of supporting services.  It is built as part of the 42 **Inception** curriculum and demonstrates how to orchestrate a multi-service stack with Docker, Docker Compose, and Make.

## Features

- **Reverse proxy & TLS termination** with Nginx serving WordPress, Adminer, n8n, and a static site over HTTPS.
- **WordPress** configured automatically with WP-CLI, Redis caching, and pre-created admin/subscriber accounts.
- **MariaDB** relational database seeded on first boot using Docker secrets for credentials.
- **Redis** cache available to WordPress via the `redis-cache` plugin.
- **Adminer** web UI for inspecting MariaDB.
- **Static website** served alongside WordPress to demonstrate multi-site routing.
- **FTP** server exposing the WordPress volume for legacy file transfers.
- **n8n** automation platform backed by the MariaDB instance.
- Shared user-defined bridge network and bind-mounted volumes for persistent data.

## Repository layout

```
.
├── Makefile                 # Helper targets for provisioning, starting, and cleaning the stack
├── srcs/
│   ├── docker-compose.yml   # Orchestration for core and bonus services
│   ├── .env                 # Default environment variables consumed by docker-compose
│   ├── requirements/        # Mandatory services (nginx, wordpress, mariadb)
│   └── bonus/               # Additional services (redis, adminer, ftp, static-website, n8n)
└── secrets/                 # Docker secret files (credentials, encryption keys)
```

Each service directory contains its own `Dockerfile`, configuration templates, and entrypoint scripts tailored to the service.  Persistent data for MariaDB and WordPress is mounted from host directories defined in the `.env` file.

## Prerequisites

- Docker Engine 24+
- Docker Compose plugin (`docker compose`)
- GNU Make
- Ability to run commands with `sudo` (used by the Makefile when fixing permissions and editing `/etc/hosts`).

## Configuration

1. **Environment variables** – Copy `srcs/.env` to `srcs/.env.local` (or override via shell) and adjust the values as needed:

   ```bash
   cp srcs/.env srcs/.env.local
   export $(grep -v '^#' srcs/.env.local | xargs)
   ```

   Key variables include `DOMAIN_NAME`, service ports, and bind-mounted volume paths (`VOLUME_WORDPRESS_PATH`, `VOLUME_MARIADB_PATH`, `VOLUME_STATIC_PATH`).

2. **Secrets** – Populate the files in `secrets/` with your own credentials.  Each secret is a plain-text file where lines are parsed in the entrypoint scripts.  For example, the WordPress admin credentials file expects three lines:

   ```text
   <admin username>
   <admin email>
   <admin password>
   ```

   The MariaDB and n8n users are seeded from their respective secret files during container initialization.

## Usage

### Bootstrapping the stack

The provided Makefile wraps the Docker Compose commands and prepares the host environment.  From the repository root run:

```bash
make up
```

This target will:

1. Create persistent data folders under `/home/<user>/data`.
2. Append the development domain to `/etc/hosts` if it is missing.
3. Build all images and start the containers in detached mode.
4. Fix the ownership and permissions on the WordPress volume so the web server can write to it.

To stop or remove the deployment, use:

```bash
make down      # stop containers
make clean     # stop containers and remove data directories
make fclean    # full Docker cleanup (containers, images, volumes, networks, cache)
```

### Inspecting services

A few helpful Docker commands while the stack is running:

```bash
# Tail the WordPress/PHP-FPM logs
docker compose -f srcs/docker-compose.yml logs -f wordpress

# Open a shell inside the MariaDB container to run SQL commands
docker compose -f srcs/docker-compose.yml exec mariadb mysql -u root -p

# Trigger a rebuild for a single service (e.g., nginx)
docker compose -f srcs/docker-compose.yml up -d --build nginx
```

### Accessing the applications

| Service          | URL (default)                         | Notes                                 |
| ---------------- | ------------------------------------- | -------------------------------------- |
| WordPress        | `https://rguigneb.42.fr`              | Admin credentials sourced from secrets |
| Adminer          | `https://rguigneb.42.fr:1557`         | Connect to `mariadb:3306`              |
| Static website   | `https://rguigneb.42.fr:1558`         | Simple Hugo-based site served by Nginx |
| n8n              | `https://rguigneb.42.fr/n8n/`         | Basic auth controlled via `.env`       |
| FTP              | `ftp://rguigneb.42.fr:21`             | Passive range `40000-40010`            |

Adjust the hostnames and ports to match your customized `.env` file.

## Development tips

- Service-specific configuration templates live under `conf/` directories and are rendered at container startup (e.g., `nginx.conf` uses environment variables via `envsubst`).
- MariaDB initialization takes place through `/tmp/init.sql`, generated from `conf/init.sql` with credentials injected by `envsubst`.
- WordPress bootstrapping happens in `requirements/wordpress/tools/docker-entrypoint.sh`, which handles `wp-config.php`, core installation, user creation, and Redis integration.
- Bonus services can be disabled by commenting them out in `docker-compose.yml` if you prefer a leaner stack.

## Cleanup

If you need to reset everything, `make fclean` removes all Docker state (containers, images, volumes, networks, build cache) and deletes the host data directories defined in the `.env` file.  Use this with caution because it affects **all** Docker resources on the machine.

## Further reading

- [Docker documentation](https://docs.docker.com/)
- [WP-CLI command reference](https://developer.wordpress.org/cli/commands/)
- [n8n workflow automation](https://docs.n8n.io/)

