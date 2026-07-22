# Cowrie

Cowrie is a medium-interaction SSH and Telnet honeypot that records login attempts, commands, and downloaded files.

## Access

- SSH honeypot: `PANEL_APP_PORT_SSH` (default `2222`)
- Telnet honeypot: `PANEL_APP_PORT_TELNET` (default `2223`)

These ports are intentionally exposed to untrusted traffic. Deploy Cowrie only in an isolated network or behind carefully scoped firewall rules. Do not place it on a production host without reviewing the containment boundary.

Telnet is enabled through the upstream-supported `COWRIE_TELNET_ENABLED=yes` container setting so both published ports provide the documented service.

## Persistence

Logs, downloads, runtime state, and operator configuration are stored in `APP_DATA_DIR`; configuration is under `APP_DATA_DIR/etc`. Uninstalling the app removes its containers but preserves this directory.

The container runs as UID and GID `999`; the initialization script prepares the data directory with matching ownership.

## References

- [Website](https://cowrie.org)
- [GitHub](https://github.com/cowrie/cowrie)
- [Documentation](https://docs.cowrie.org)
