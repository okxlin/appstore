# Xiaomi Album Syncer

## Introduction

Xiaomi Album Syncer downloads Xiaomi Cloud albums and recordings to local
storage through a browser-based interface. It supports full, incremental, and
scheduled synchronization and organizes downloaded files by album.

## Features

- Synchronize Xiaomi Cloud albums, recordings, and related metadata.
- Run full, incremental, or scheduled synchronization jobs.
- Configure the service through a Web UI and preserve job state locally.
- Support Xiaomi account authorization with the credentials documented by the
  upstream project.

## Usage

After installation, open `http://<server-ip>:<port>` using the port configured
by `PANEL_APP_PORT_HTTP` (the default is `8232`). On first access, set a strong
management password for the application, then complete Xiaomi account
authorization according to the upstream documentation.

`DOWNLOAD_DIR` is mounted at `/app/download` and stores synchronized albums and
recordings. `DATABASE_DIR` is mounted at `/app/db` and stores authorization,
tasks, and synchronization records. Back up both directories before upgrading.

Treat the database directory as sensitive: it may contain Xiaomi account
authorization data. Restrict host access, use HTTPS through a 1Panel reverse
proxy when exposing the Web UI, and only synchronize content you are allowed to
access.

## References

- Project and documentation: <https://github.com/Coooolfan/XiaomiAlbumSyncer>
- Docker image: <https://hub.docker.com/r/coolfan1024/xiaomi-album-syncer>
