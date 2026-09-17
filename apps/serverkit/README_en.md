# ServerKit

## Introduction

ServerKit is a self-hosted panel for connecting remote servers and managing fleet operations, terminals, deployments, monitoring, backups, security, and sites.

This package uses the upstream all-in-one Docker image `jhd3197/serverkit`, which serves the API, React SPA, and Socket.IO service from one container.

## Features

- Connect to and manage remote servers and server fleets.
- Provide terminal, deployment, monitoring, backup, and security capabilities.
- Serve a unified browser panel with real-time Socket.IO communication.

## Container scope

This is ServerKit's containerized deployment. The package does not mount the Docker Socket or the host filesystem and does not use privileged mode. As a result, it cannot manage the current 1Panel host's systemd services, host Nginx, host packages, or local sites. It is intended for evaluation, managing other connected remote servers, or running behind a reverse proxy.

## First use

1. During installation, provide unique values for `SECRET_KEY`, `JWT_SECRET_KEY`, and the Fernet-format `SERVERKIT_ENCRYPTION_KEY`.
2. Generate a Fernet key with:

   ```bash
   python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
   ```

   Generate the first two keys with `openssl rand -hex 32`. Keep all keys safe; changing them invalidates existing sessions or encrypted data.
3. Open ServerKit on the configured HTTP port. On the first visit, use the registration page to create the first user; the first user is given the administrator role.
4. When using a reverse proxy, set `SERVERKIT_PUBLIC_URL`. Set `TRUST_PROXY_HEADERS` to `true` only when every request is guaranteed to pass through a trusted proxy. Add multiple browser origins as a comma-separated `CORS_ORIGINS` value.

The SQLite database is persisted at `data/serverkit.db` in the application install directory and bind-mounted to `/app/instance`. This keeps the data under the 1Panel application directory for application backups. Do not remove this directory unless the ServerKit data can be discarded. When upgrading from the legacy `serverkit-data` volume, the target version migrates the SQLite files when the new directory is empty; the legacy volume is retained and is not deleted automatically.

## Versions

Both `latest` and the pinned `1.11.4` release are available. They use the upstream Docker Hub image and support amd64 and arm64.

## Links

- [Upstream project](https://github.com/jhd3197/ServerKit)
- [Docker deployment guide](https://github.com/jhd3197/ServerKit/blob/v1.11.4/docs/INSTALLATION.md#quick-install-docker)
- [Upstream Compose file](https://github.com/jhd3197/ServerKit/blob/v1.11.4/docker-compose.yml)

The ServerKit upstream project is licensed under the MIT License. See the [upstream license](https://github.com/jhd3197/ServerKit/blob/v1.11.4/LICENSE).
