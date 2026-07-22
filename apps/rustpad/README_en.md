# Rustpad

Rustpad is a collaborative text editor with real-time synchronization and persistent shared documents.

## Access

The web interface listens on `PANEL_APP_PORT_HTTP` (default `3030`). `EXPIRY_DAYS` controls document expiration and `RUST_LOG` controls server logging.

## Persistence

The SQLite database is stored in `APP_DATA_DIR`, mounted at `/data`.

## References

- [GitHub](https://github.com/ekzhang/rustpad)
- [Docker Hub](https://hub.docker.com/r/ekzhang/rustpad)
