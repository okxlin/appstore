## Introduction

**Songloft** is a self-hosted personal music server with local library scanning, metadata management, Web playback, playlists, and cross-platform clients. This package uses the upstream full image with its embedded Web interface and SQLite database, so no external database is required.

## Features

- Scan a local music directory and extract cover art and audio metadata.
- Browse, search, and play music from the built-in Web interface.
- Manage playlists, play history, lyrics, network audio, and video containers.
- Use REST APIs, cross-platform clients, and optional plugins.
- Persist the SQLite database, configuration, plugins, cache, logs, and managed runtime binary in a dedicated data directory.

## Usage

- Enter an administrator password during installation. The package does not use the insecure upstream `admin/admin` default credentials.
- Open Songloft through the Web port shown in the app details, then sign in with the administrator credentials from the install form.
- The music directory is mounted at `/app/music` inside the container. Place music in the host directory selected in the install form, then start a scan from the Web interface.
- The default healthcheck calls `/api/v1/health`; it does not replace login, scan, and playback verification.

## Data and Upgrades

- The data directory contains the SQLite database, configuration, plugins, cache, logs, and the `songloft` runtime binary managed by the upstream entrypoint.
- The music directory is writable because Songloft can scan, import, and organize files. Back up both the data and music directories before an upgrade.
- Prefer updating the application image through 1Panel. Songloft's in-app updater replaces the runtime binary in the data directory, which can remain active after a container restart or image rollback.
- To restore the binary shipped by the selected image, back up the data, stop the app, and remove only the `songloft` runtime binary from the data directory. The upstream entrypoint copies it from the image on the next start.
- 1Panel's uninstall choice controls bind-mounted data removal. The app scripts do not delete the database or user music directly.

## Security Notes

- Use a strong administrator password. Enable HTTPS through a reverse proxy and restrict administrative access when exposing Songloft publicly.
- Plugins and network-audio features can access external addresses. Install only trusted plugins and review their permissions.

## Links

- Website: https://songloft.hanxi.cc
- Project: https://github.com/songloft-org/songloft
- Image: https://hub.docker.com/r/songloft/songloft
