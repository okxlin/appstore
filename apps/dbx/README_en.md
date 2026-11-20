# DBX

## Introduction

DBX is a lightweight, self-hosted database manager for more than 25 database
systems, including MySQL, PostgreSQL, SQLite, Redis, MongoDB, and DuckDB.

## Features

- Manage database connections from a browser-based interface.
- Persist connections, drivers, and other application data under `/app/data`.
- Protect the Web UI with the `PANEL_DB_PASSWORD` value configured during install.

## Deployment

Set a strong access password and expose the configured `PANEL_APP_PORT_HTTP`
port. Back up `./data` before an upgrade or migration. The currently packaged
`t8y2/dbx:0.6.72` image is pinned to manifest digest
`sha256:30bc1628fef79e17d36ba0cfaf48c08f8d6f5e43124929b52689494aa216f01e`.
The retained image versions support amd64 and arm64.

## Security notice

The current Compose file does not use privileged mode, host networking, or a
Docker Socket. A historical Trivy 0.72.0 record for `t8y2/dbx:0.6.16` lists six
Critical base-image/package findings: CVE-2026-58016, CVE-2025-7458,
CVE-2026-13221, CVE-2026-42496, CVE-2026-8376, and CVE-2023-45853. Version
0.6.72 was not scanned as part of this update, so that historical record does
not establish its current CVE status.
