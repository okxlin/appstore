# Thunderbird

## Introduction
Thunderbird is an open-source email client. This App Store package uses the third-party container image maintained by jlesage; it is not an official Thunderbird project image.

## Features
- Use Thunderbird's graphical interface in a web browser.
- Connect to the desktop interface with a VNC client.
- Persist configuration, state, and other required files under `/config`.

## Usage
- Open `https://<server-address>:<PANEL_APP_PORT_HTTP>` in a browser. HTTPS is enabled by default; set `SECURE_CONNECTION` to `0` to use HTTP.
- Connect a VNC client to `<server-address>:<PANEL_APP_PORT_VNC>`. The default connection uses an SSL tunnel, so the client must support that mode.
- `CONFIG_PATH` defaults to `./data` and is mounted at `/config`. Back up this directory in 1Panel before upgrading or migrating.
- VNC passwords are limited to 8 characters. When `SECURE_CONNECTION` is enabled, `SECURE_CONNECTION_VNC_METHOD` selects the VNC security mode.
- A negative `APP_NICENESS` value uses the `SYS_NICE` capability to raise process priority; the default value `0` does not raise priority.

When upgrading from an earlier package, the existing `VNC_PORT` value is used to retain the old VNC port. After the upgrade, `PANEL_APP_PORT_VNC` controls the host port. The legacy VNC listening-port value is retained inside the container for compatibility with saved installation settings.

## References
- Website: <https://www.thunderbird.net>
- Thunderbird documentation: <https://support.mozilla.org/en-US/products/thunderbird>
- Thunderbird source: <https://github.com/thunderbird>
- Container project: <https://github.com/jlesage/docker-thunderbird/tree/v26.11.2>
