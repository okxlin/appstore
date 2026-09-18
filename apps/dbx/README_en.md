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
port. Back up `./data` before an upgrade or migration. The app uses the
official `t8y2/dbx` image, pinned to the reviewed `0.6.16` manifest digest.

## Security notice

The reviewed image has no privileged mode, host networking, or Docker Socket.
Trivy 0.72.0 reports six Critical base-image/package findings with no fixed
version: CVE-2026-58016, CVE-2025-7458, CVE-2026-13221, CVE-2026-42496,
CVE-2026-8376, and CVE-2023-45853. These findings are recorded as accepted
upstream risk and should be rechecked when the upstream image publishes fixes.
