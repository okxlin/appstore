## Introduction

**OliveTin** provides a simple Web interface for running shell commands predefined by an administrator. Users can only invoke actions explicitly allowed by the configuration, making common maintenance tasks available as buttons.

## Features

- Present predefined commands as Web action buttons.
- Show command output, exit code, start time, and completion status.
- Support action arguments, access control, schedules, webhooks, and external authentication through advanced configuration.
- Persist action configuration and execution history in a configurable data directory.

## Access and security

- Open the HTTP port shown in the application details after installation.
- The default configuration contains only a harmless `Hello from 1Panel` action. It does not mount the Docker socket or enable privileged mode, host networking, or remote-control actions.
- OliveTin executes shell commands from its configuration. Review commands, argument validation, and access policy before adding actions, and do not expose an unauthenticated instance to an untrusted network.
- Docker, SSH, or host-management actions require a separately reviewed least-privilege deployment based on the upstream security documentation. This package does not grant those permissions automatically.

## Data and upgrades

- Configuration, action results, and output logs are stored in the configuration directory selected during installation.
- A safe starter configuration is written on first install; an existing `config.yaml` is never overwritten.
- This package is limited to one instance to prevent multiple installations from sharing one configuration directory.
- The uninstall script does not delete configuration or logs. Back up the configuration directory before upgrades or uninstall.
- `latest` is intentionally movable for users who track releases with container update tools; the numbered version provides a reproducible deployment.

## Default workflow

Open the Web page and run `Hello from 1Panel`. The execution result should show `Hello from 1Panel` with exit code 0. Configuration and execution history persist across container and 1Panel restarts.

## Links

- Website: <https://www.olivetin.app>
- Documentation: <https://docs.olivetin.app>
- Project: <https://github.com/OliveTin/OliveTin>
- Container image: <https://hub.docker.com/r/jamesread/olivetin>
