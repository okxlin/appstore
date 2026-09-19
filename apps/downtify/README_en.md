# Downtify

## Introduction

Downtify is a self-hosted music downloader and library manager. It matches
Spotify tracks and playlists to audio sources, downloads the selected audio,
and stores artwork and metadata with the library.

## Features

- Download tracks, albums, and playlists.
- Configure audio format, bitrate, directory layout, and lyrics.
- Monitor playlists, export M3U playlists, and use the browser player.

## Usage

After installation, open `http://<server-ip>:<port>` using the port configured
by `PANEL_APP_PORT_HTTP`. Downtify does not provide built-in authentication:
users who can reach the port can submit media URLs, change settings, remove
download records, and manage files. Restrict the service to a trusted network
or place it behind an authenticated reverse proxy; do not expose it directly to
the public Internet.

`APP_DATA_DIR` stores application settings and the playlist-monitor database.
`APP_DOWNLOADS_DIR` stores downloaded media. Both paths must remain relative to
the application version directory. The initialization script creates them with
permissions for UID/GID `1000:1000`; uninstall preserves the directories.
Back up the data before upgrading or migrating the application.

## Security and legal notes

- The pinned image contains the High-severity `CVE-2026-55404` in yt-dlp
  `2026.6.9`; the fixed version is `2026.7.4`. The advisory concerns `.url`
  and `.desktop` shortcut-writing options, which are not enabled by Downtify's
  normal download flow. The service still processes user-supplied media URLs
  and external media data, so restrict access to trusted users and upgrade as
  soon as upstream publishes an image containing the fixed dependency.
- The container runs as UID/GID `1000:1000`, drops all Linux capabilities, and
  uses a read-only root filesystem with `no-new-privileges`.
- Follow the source service's terms and applicable copyright law when using
  downloaded content.

## References

- Project: <https://github.com/henriquesebastiao/downtify>
- Docker deployment: <https://downtify.henriquesebastiao.com/getting-started/docker-compose/>
- Environment variables: <https://downtify.henriquesebastiao.com/getting-started/environment-variables/>
- License: <https://github.com/henriquesebastiao/downtify/blob/main/LICENSE>
- Vulnerability: <https://nvd.nist.gov/vuln/detail/CVE-2026-55404>
