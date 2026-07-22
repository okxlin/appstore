# Grocy

Grocy is a self-hosted household ERP application for groceries, shopping lists, chores, recipes, meal planning, and inventory.

## Access

The web interface listens on `PANEL_APP_PORT_HTTP` (default `80`). Follow the upstream documentation for the current initial login credentials and change them after login.

## Persistence

Configuration and SQLite data are stored in `APP_DATA_DIR`, mounted at `/config`. `PUID` and `PGID` control file ownership.

## References

- [Website](https://grocy.info)
- [GitHub](https://github.com/grocy/grocy)
- [Container image](https://github.com/linuxserver/docker-grocy)
