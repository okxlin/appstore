# Elizabeth

## Introduction

**Elizabeth** is a self-hosted real-time file and message sharing tool that
requires no account registration. Users share Markdown messages, files, images,
and links through rooms, while one Rust container serves the API, WebSocket
endpoint, and embedded web interface.

## Features

- **Real-time rooms**: Synchronizes messages and room state over WebSocket and
  supports shareable room links.
- **File and message sharing**: Supports Markdown, code highlighting, images,
  PDFs, text files, and link previews.
- **Security and permissions**: Provides JWT sessions, room passwords, granular
  permissions, expiry policies, and entry limits.
- **Lightweight deployment**: Runs as a single container with SQLite by default
  and can connect to an external PostgreSQL database.

## Access

- The web port is configured in the install form and defaults to `4092`.
- Open the web UI after install to create rooms and share links without
  registration.
- Health endpoint: `/api/v1/health`. The container healthcheck uses the bundled
  `board health` probe, because the image ships no `curl`.

## Persistence

- `APP_DATA_DIR` mounts to `/app/data` for SQLite and other local state.
- `APP_STORAGE_DIR` mounts to `/app/storage` for room file uploads.
- Both directories belong to the container user `65532:65532` with mode `0750`.
  `scripts/init.sh` applies that ownership on install and upgrade; keep it when
  migrating data by hand.
- Back up both directories before upgrades or migrations.
- Keep `JWT_SECRET` stable across upgrades to avoid invalidating sessions.

## Security

- The container runs as the non-root user `65532` with `read_only`,
  `cap_drop: ALL`, `no-new-privileges`, and a `/tmp` tmpfs.
- The runtime image is distroless: it contains only the C runtime, CA
  certificates, and timezone data — no shell, no package manager, no `curl`.
  `docker exec` therefore cannot open a shell inside the container; use the
  container logs for troubleshooting.
- The install form randomizes `JWT_SECRET`; use a strong secret for public
  deployments.
- For public access, terminate TLS with a reverse proxy and configure room
  passwords or permissions as needed.
