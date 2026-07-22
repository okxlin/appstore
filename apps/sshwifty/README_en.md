# SSHwifty

SSHwifty is a browser-based SSH and Telnet client for connecting to remote systems through a self-hosted web interface.

## Access

The web interface listens on `PANEL_APP_PORT_HTTP` (default `8182`). Only expose it to trusted users and networks because it can initiate remote terminal sessions.

## Persistence

SSHwifty loads its runtime configuration from environment variables by default and does not require a persistent data directory.

## References

- [GitHub](https://github.com/nirui/sshwifty)
- [Docker Hub](https://hub.docker.com/r/niruix/sshwifty)
