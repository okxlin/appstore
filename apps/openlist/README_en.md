# OpenList

## Introduction

OpenList is a file listing service that supports multiple storage backends and lets you manage configured files through a web interface.

## Features

- Browse and manage files from multiple storage backends in one web interface.
- Provides a web UI and a separate S3 service port.
- Can mount a local directory as a storage location.

## Usage

- After installation, open OpenList using the web port (default `40337`). The S3 service uses a separate port (default `5246`).
- On first use, open the container terminal and run `./openlist admin random` to generate an administrator password, or run `./openlist admin set NEW_PASSWORD` to set one.
- `DATA_PATH` stores application data. `MOUNT_PATH` is the local storage directory mounted inside the container. Back up both directories before upgrading.
- `TIME_ZONE` sets the container time zone.

Documentation: <https://docs.oplist.org/>.
