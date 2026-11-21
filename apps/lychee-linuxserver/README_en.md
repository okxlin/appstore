# Lychee

## Introduction

Lychee is a self-hosted photo management and sharing application maintained by LinuxServer.io.

## Features

- Manage and share photos through a web interface.
- Store application configuration and database files under `CONFIG_PATH`.
- Store photos under `PICTURES_PATH`.

## Deployment

Install the app through 1Panel and open the configured `PANEL_APP_PORT_HTTP` port. Complete the initial account setup in the web interface. The image supports amd64 and arm64.

For a new install, point `PICTURES_PATH` to an empty directory so Lychee can manage it. Do not empty this directory when upgrading an existing install.

## Ports

| Variable | Description | Default | Required |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | HTTP port | `80` | Yes |

## Persistent data

| Variable | Description | Default | Required |
| --- | --- | --- | --- |
| `CONFIG_PATH` | Configuration and database directory | `./data/config` | Yes |
| `PICTURES_PATH` | Photo directory | `./data/pictures` | Yes |

Back up both directories in 1Panel before an upgrade or migration. Upgrades keep the configured paths and database settings; they do not move configuration or photo data.

Relative paths inside the app directory can be created by the init script. Existing absolute paths and relative paths outside the app directory must already exist. The init script does not create external paths or recursively change their ownership. Make sure the container user with UID/GID `1000:1000` can read and write them.

## Configuration

The install form includes timezone, gallery name, public URL, trusted proxies, and database connection settings. The upgrade script adds missing legacy defaults for `APP_NAME`, `APP_URL`, `TRUSTED_PROXIES`, `DB_CONNECTION`, and `DB_DATABASE`; it preserves database values already present in `.env`.

## References

- Website: <https://lycheeorg.dev/>
- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-lychee/>
- Source: <https://github.com/linuxserver/docker-lychee>
