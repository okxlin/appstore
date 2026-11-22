# OrcaSlicer

## Introduction
OrcaSlicer is a browser-accessible 3D printing slicer desktop maintained by LinuxServer.io.

## Features
- Run the OrcaSlicer desktop through the Selkies web interface.
- Protect web access with Basic Auth.
- Persist application settings in the `/config` directory.

## Deployment
- Deploy with Docker Compose from 1Panel.
- Supported architectures: amd64 and arm64.
- The fixed package is `2.5.2`; `latest` follows the upstream floating tag.
- Use the HTTP or HTTPS port shown in the 1Panel app form.

## Ports
| Variable | Description | Default |
| --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | HTTP port | 3000 |
| `PANEL_APP_PORT_HTTPS` | HTTPS port | 3001 |

## Persistent data
`CONFIG_PATH` is mounted to `/config`. Back up this directory before upgrades or migrations.

## Authentication
Set `CUSTOM_USER` and `PASSWORD` in the app form. 1Panel generates a random password for a new installation.

## References
- Website: <https://orcaslicer.com/>
- Documentation: <https://docs.linuxserver.io/images/docker-orcaslicer/>
- Source: <https://github.com/linuxserver/docker-orcaslicer>
