# DailyTxT

DailyTxT is an encrypted journal application with Markdown, file uploads, tags, search, maps, templates, and multi-user support.

## Access

The web interface listens on `PANEL_APP_PORT_HTTP` (default `8000`). Log in to the administration interface with the generated `ADMIN_PASSWORD`. Keep the generated `SECRET_TOKEN` private because it protects session cookies.

Disable `ALLOW_REGISTRATION` after creating the required users when public registration is not intended.

## Persistence

Encrypted journal data and uploads are stored in `APP_DATA_DIR`, mounted at `/data`.

## References

- [Website](https://dailytxt.phitux.de)
- [GitHub](https://github.com/PhiTux/DailyTxT)
- [Docker Hub](https://hub.docker.com/r/phitux/dailytxt)
