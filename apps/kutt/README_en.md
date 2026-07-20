# Kutt

## Introduction

Kutt is a self-hosted URL shortener for creating, managing, and viewing statistics for short links.

## Features

- Create the administrator account in the browser on the first start.
- Create and manage short links, including custom short addresses.
- Use SQLite by default without a separate database service.
- Configure both the database and customizations directories in the install form.

## Configuration

- Set `Public domain` to the hostname or `hostname:port` users use to reach Kutt, such as `short.example.com` or `short.example.com:3000`. Do not include a protocol prefix.
- 1Panel generates the JWT secret. Do not rotate it casually on an existing installation.
- Registration and anonymous links are disabled by default. Change those visible install settings only when that exposure is intended.
- Keep `Trust reverse proxy` set to `false` for direct HTTP-port access. Enable it only when a trusted proxy passes client address information correctly.

## Data and uninstall

SQLite data is stored in the data directory and interface customizations are stored in the customizations directory. Uninstalling stops and removes the container but preserves those host directories; back up short-link data before removing them.

## References

- Website: <https://kutt.it/>
- Source: <https://github.com/thedevs-network/kutt>
- Docker Compose: <https://github.com/thedevs-network/kutt/blob/main/docker-compose.yml>
