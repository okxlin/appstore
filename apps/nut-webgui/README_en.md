# NUT Web GUI

NUT Web GUI is a lightweight web interface for Network UPS Tools (NUT), displaying UPS status, variables, and events.

## Features

- Automatically refreshes UPS status and variables
- Provides a JSON API, event WebSocket, and OpenMetrics metrics
- Supports multiple NUT servers, TLS, and optional web authentication
- Can run `INSTCMD`, `SET VAR`, and FSD operations when the NUT user permits them

## Installation

This application does not include a NUT server and does not access UPS hardware directly. Before installation, provide an `upsd` address and port reachable from the 1Panel container network. Also provide a username and password when the `upsd` server requires authentication.

The package uses an ordinary Docker bridge network and does not enable host networking. If the NUT server runs on the same host, enter an address reachable from the Docker network; `127.0.0.1` inside this container refers to the container itself.

Configuration files and the session-signing key are stored in the version directory's `data` directory. Whether that directory is removed during uninstall is controlled by the 1Panel data-removal option. Uninstall does not send control commands to the external NUT server.

## Security

A NUT account used only for monitoring should not receive `INSTCMD` or FSD privileges. Grant control permissions to the external NUT user only when remote UPS control is explicitly required.
