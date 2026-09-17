# krita-linuxserver

## Introduction

Krita is a professional digital painting application. This LinuxServer.io image
provides a browser-accessible desktop session for Krita.

## Features

- Use Krita for digital painting and image editing in a web browser.
- Persist Krita settings and user files in the configured data directory.
- Choose the browser title, dashboard, desktop locale, and time zone during installation.

## Usage

After installation, open the configured HTTPS port in a browser and accept the
self-signed certificate warning when prompted. HTTP on port 3000 is intended for
use behind a reverse proxy; HTTPS on port 3001 is the direct secure endpoint.

Set `CUSTOM_USER` and `PASSWORD` to enable Basic Auth. Keep the container behind
a trusted network or a properly secured reverse proxy before exposing it to the
Internet. The browser session includes a terminal, so access to the GUI grants
root access inside the container.

The `CONFIG_PATH` directory stores the container configuration and user data.
Back up this directory before upgrading or migrating the application.

See the [official Krita image documentation](https://docs.linuxserver.io/images/docker-krita/)
for GPU acceleration, reverse proxy, security, and advanced Selkies settings.
