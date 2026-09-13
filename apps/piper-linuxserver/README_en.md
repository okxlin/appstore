# Piper

## Introduction

Piper is a local neural text-to-speech service exposed through the Wyoming protocol. This package uses the LinuxServer.io container image.

## Features

- Local text-to-speech processing with configurable Piper voices.
- Wyoming protocol access on the configured port.
- Persistent configuration and downloaded voice data through the mapped config directory.

## Usage

1. Install the app and set `PIPER_VOICE` to a supported voice model.
2. Connect a Wyoming-compatible client to the configured `PANEL_APP_PORT_WYOMING` port.
3. Keep `CONFIG_PATH` on persistent storage so downloaded models and settings survive upgrades.

Optional settings include local-only mode, speaking rate, noise controls, speaker number, and streaming behavior.

## References

- Official project: <https://github.com/rhasspy/piper>
- Container documentation: <https://docs.linuxserver.io/images/docker-piper/>
- Container source: <https://github.com/linuxserver/docker-piper>
