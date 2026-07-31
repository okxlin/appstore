# Simon

> **High-privilege warning**: Simon's core Docker monitoring feature requires a read-only bind of `/var/run/docker.sock`. A Docker socket mounted as a read-only file still exposes Docker APIs capable of controlling the host. Deploy this application only on a trusted server and protect its interface with a strong bcrypt password hash.

Simon is a lightweight system monitoring dashboard with live host metrics, historical trends, Docker container status, and log viewing.

## Features

- Displays CPU, memory, disk, network, and disk I/O metrics
- Shows Docker container status, resource usage, and logs
- Persists historical metrics and alert configuration in SQLite
- Supports Telegram, ntfy, and custom webhook alerts

## Installation

The install form requires a bcrypt password hash. Generate a cost-12 hash with a compatible bcrypt tool in a trusted terminal; do not enter a plaintext password.

This package mounts `/sys` and the Docker socket read-only and stores SQLite data in the version directory's `data` directory. It does not mount the host root or enable file browsing by default, preventing arbitrary host files from being exposed through the web interface.

Whether monitoring history is removed during uninstall is controlled by the 1Panel data-removal option. Uninstalling Simon does not stop, remove, or modify any monitored container.
