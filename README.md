# Inception

A production-style WordPress stack built as part of the 42 _Inception_ project. The goal is to compose a secure, reproducible infrastructure entirely from self-managed containers using Docker Compose, without relying on pre-built images. This repository provides a ready-to-run environment with a TLS-terminated Nginx reverse proxy, a PHP-FPM powered WordPress instance, and a MariaDB database initialized via secrets.

## Architecture

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│   Client    │ 443 → │    Nginx    │ ───→  │  WordPress  │
└─────────────┘       └─────────────┘       └─────────────┘
                                         ┌─────────────┐
                                         │   MariaDB   │
                                         └─────────────┘
```

- **Nginx** terminates HTTPS with a self-signed certificate and forwards PHP requests to WordPress via FastCGI. Templates are rendered with environment variables at container start-up for easy customization.
- **WordPress** runs on PHP-FPM 7.4 and is provisioned with WP-CLI. Secrets supply admin and subscriber credentials, and the entrypoint ensures idempotent installation.
- **MariaDB** exposes a single database/user for WordPress. Configuration is templatized so the container can adapt to custom ports and credentials.
- All services share a dedicated `inception-network` bridge network and persist data through bind-mounted volumes defined in [`srcs/docker-compose.yml`](srcs/docker-compose.yml).

## Repository Layout

```
.
├── Makefile                  # Helper targets for setup, lifecycle, and cleanup
├── secrets/wordpress         # Sample secret files consumed by Docker secrets
├── srcs/
│   ├── .env                  # Central environment configuration for Compose
│   ├── docker-compose.yml    # Service definitions, networks, volumes, secrets
│   └── requirements/         # Docker build contexts for each service
│       ├── nginx/
│       ├── wordpress/
│       └── mariadb/
└── ...
```

## Prerequisites

- Docker and Docker Compose plugin (v2+)
- GNU Make (for the provided `Makefile` workflow)
- Permission to edit `/etc/hosts` (needed for the default domain `rguigneb.42.fr`)

## Configuration

The stack is configured via the `.env` file consumed by Docker Compose. Adjust ports, domain name, and host bind paths as needed:

```dotenv
# srcs/.env
DOMAIN_NAME=example.local
NGINX_PORT=443
WP_PORT=9000
MARIADB_PORT=3306
VOLUME_WORDPRESS_PATH=/home/you/data/wordpress
VOLUME_MARIADB_PATH=/home/you/data/mariadb
WP_DATABASE=wordpress
WP_USER=wordpress
```

Sensitive values (database password and WordPress credentials) are injected with Docker secrets. Each secret file should contain a single value per line, for example:

```text
# secrets/wordpress/wp_admin_user_credentials.txt
admin
admin@example.local
SuperSecretPassword123!
```

## Usage

1. **Create secrets** by populating the files inside `secrets/wordpress/` with your desired credentials.
2. **Bootstrap volumes and hosts entry** (executed automatically by the Makefile):
   ```bash
   make setup
   ```
3. **Build and start the stack**:
   ```bash
   make up
   ```
   This command wraps `docker compose up -d --build -f srcs/docker-compose.yml` and also ensures that the WordPress volume is owned by the `www-data` user.
4. Visit `https://rguigneb.42.fr` (or your configured domain) to access the WordPress site. Accept the browser warning if using the provided self-signed certificate.

### Lifecycle Commands

```bash
make down        # Stop and remove containers while preserving data
make clean       # Stop containers and prune Docker cache/volumes
make clean-data  # Delete bind-mounted data under /home/<user>/data
make re          # Rebuild from scratch (equivalent to fclean + all)
```

## Customization Examples

- **Change the domain and TLS certificate**: update `DOMAIN_NAME` in `.env` and replace the files in `srcs/requirements/nginx/certs/` with your own `fullchain.crt` and `privkey.key`.
- **Add a new WordPress plugin during build** by extending the Dockerfile:
  ```Dockerfile
  # srcs/requirements/wordpress/Dockerfile
  RUN wp plugin install redis-cache --activate --allow-root
  ```
- **Expose MariaDB for local tooling** by publishing the port in `docker-compose.yml`:
  ```yaml
  services:
    mariadb:
      ports:
        - "3306:3306"
  ```

These snippets illustrate how the stack can be adapted without abandoning the Compose-driven workflow.

## Troubleshooting

- **WordPress setup repeats**: ensure the volume directory (`VOLUME_WORDPRESS_PATH`) is writable by UID/GID `33`. The `make up` target applies the correct permissions, but manual runs may require `sudo chown -R 33:33 <path>`.
- **Database connection errors**: confirm that the secret password matches the values in `.env` (`WP_USER`, `WP_DATABASE`) and that the `mariadb` volume persisted the initialization script.
- **SSL warnings**: browsers will warn about the included self-signed certificate. For production, generate a valid certificate and update the files in `srcs/requirements/nginx/certs/`.

## License

This project is distributed for educational purposes as part of the 42 curriculum. Adapt and extend it to fit your own learning environment.
