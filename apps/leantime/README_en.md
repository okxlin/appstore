# Leantime

## Introduction

Leantime is an open-source project management platform for teams and startups, with projects, tasks, boards, and knowledge-base features.

## Features

- Stores business data in a MySQL service selected from 1Panel.
- Uses the official `/install` wizard to create the first administrator and database schema.
- Persists user uploads, plugins, and application logs.

## Deployment

- Select an existing 1Panel MySQL service during installation. Leantime uses that service and does not start a bundled database container.
- Keep `LEAN_SESSION_PASSWORD` stable after installation. Changing it invalidates existing login sessions.
- Keep `LEAN_DATA_DIR` under the application's `./data` directory so the install script can safely prepare ownership required by the official image.
- Keep `Secure Cookies` set to `false` for direct HTTP access. Set it to `true` and provide `Public URL` when using an HTTPS reverse proxy.

## Access

- Open `http://<server-address>:<port>/install` after installation to create the first administrator account.
- After setup, sign in at `http://<server-address>:<port>/` and create projects and tasks.

## Persistence And Upgrades

- `LEAN_DATA_DIR` stores public files, user files, plugins, and logs. The selected MySQL service stores business data. Back up both before upgrades.
- The fixed version is for reproducible deployments; `latest` follows the upstream stable image. If an upstream database update is needed, Leantime directs the administrator to `/update`; complete it after taking a backup.
- Do not share a database or data directory between installations.

## References

- Website: <https://leantime.io/>
- Source: <https://github.com/Leantime/leantime>
- Official Docker deployment: <https://github.com/Leantime/docker-leantime>
