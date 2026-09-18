# yaak-linuxserver

## Introduction

Yaak is a browser-accessible desktop API client distributed in a LinuxServer.io container image. It supports organizing and executing REST, GraphQL, and gRPC requests.

## Features

- REST, GraphQL, and gRPC request workflows
- Browser-accessible desktop interface
- Basic Auth protection for the web entry point

## Usage

- Open the HTTP port configured by `PANEL_APP_PORT_HTTP` after installation.
- Use `CUSTOM_USER` and `PASSWORD` for Basic Auth.
- Configuration is persisted under `CONFIG_PATH`; back up this directory before upgrades or migration.
- Keep the management port on a trusted network and use an HTTPS reverse proxy for external access.

## Security notice

The reviewed `linuxserver/yaak:2026.8.0` image contains four `linux-libc-dev` Critical findings (CVE-2026-64535, CVE-2026-64564, CVE-2026-72287, and CVE-2026-74394) for which the current Trivy report provides no fixed version. This package is delivered under an authorized risk-acceptance review; the findings are not claimed to be fixed. Update when the upstream image provides a remediation.
