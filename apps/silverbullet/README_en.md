# SilverBullet

## Introduction

SilverBullet is a programmable, private, browser-based personal knowledge base built around plain Markdown pages. It stores the Space as ordinary files so the workspace can be backed up and moved independently of the container.

## Features

- Create and edit Markdown pages in a browser
- Navigate with wiki-style links, backlinks, search, tasks, queries, and templates
- Extend pages and commands with Space Lua
- Keep the Space directory as portable, backup-friendly files

## Usage

- Open the Web port configured during installation; the default is `3000`.
- Sign in with the username and generated password entered or accepted during installation.
- The configured `SPACE_DIR` is mounted at `/space` and is persisted on the host; back it up before upgrades or uninstall.
- Put a TLS reverse proxy in front of the service before exposing it to an untrusted network.

## Links

- Website: https://silverbullet.md
- Project: https://github.com/silverbulletmd/silverbullet
- Docker guide: https://silverbullet.md/Install/Docker
