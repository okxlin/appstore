## Introduction

**Librarr** is a self-hosted media manager for ebooks, audiobooks, and manga. It provides a unified Web interface for managing local libraries, wishlists, search, and download workflows.

## Features

- Manage separate ebook, audiobook, and manga directories.
- Maintain wishlists, reading history, tags, and monitored authors.
- Upload local media files and organize them into the selected directories.
- Optionally integrate qBittorrent, Audiobookshelf, Kavita, Komga, and other services.

## First use

- Open the Web port after installation.
- Register the administrator account on first use. The first user automatically becomes an administrator.
- Media directories default to `data/ebooks`, `data/audiobooks`, and `data/manga` under the application version directory. You can select other host paths in the installation form.

## Data and upgrades

- Users, wishlists, settings, and activity are stored in a SQLite database in the selected application data directory.
- Media files are stored in the three host directories selected during installation.
- This package is limited to one instance to prevent multiple installations from competing for the same data directory.
- The uninstall script does not remove media directories. Back up both the database volume and media directories before uninstalling or upgrading.
- `latest` is intentionally movable for users who track releases with container update tools; the numbered version provides a reproducible deployment.

## Default workflow

After registering the first administrator, add and remove a wishlist item, then upload a valid ebook and view its upload record. This exercises authentication, SQLite persistence, media-directory writes, and recovery after a restart.

## Links

- Project: <https://github.com/JeremiahM37/librarr>
- Container image: <https://github.com/JeremiahM37/librarr/pkgs/container/librarr>
