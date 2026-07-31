# Pulse

Pulse is an infrastructure monitoring and alerting application for Proxmox VE, Proxmox Backup Server, Docker, Kubernetes, TrueNAS, and VMware environments.

## Features

- Monitors Proxmox nodes, virtual machines, containers, storage, backups, and replication jobs
- Retains historical metrics and evaluates alert thresholds
- Combines multiple infrastructure platforms in one interface
- Provides notifications, health views, and a responsive user interface

## Installation

Installation creates a Pulse administrator account. When the password is set to `generate`, the initialization script generates a 32-character random password and stores it in the version directory's `.env` file. A custom password may contain 12 to 128 supported characters.

After installation, add a Proxmox node from the infrastructure settings. Use a least-privilege Proxmox API token and ensure that its API address is reachable from `1panel-network`. Pulse listens on port `7655` by default. Configuration, encrypted infrastructure credentials, and metrics history are stored in the version directory's `data` directory.

Usage telemetry is disabled by default. This package does not mount the Docker socket and keeps Docker update actions disabled. Uninstall does not change connected Proxmox systems. Persistent-data removal remains controlled by the 1Panel uninstall option.
