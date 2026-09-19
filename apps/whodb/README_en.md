# WhoDB

## Introduction

WhoDB is a lightweight browser workspace for exploring, querying, and editing multiple database systems.

## Features

- Browse schemas and edit data across multiple database engines.
- Run queries, inspect relationships, and import or export data.
- Optionally connect local or hosted AI providers.
- Persist encrypted database login sessions.
- Persist and connect local SQLite or DuckDB files through a separate directory.

## Access and configuration

After installation, open `http://<server-ip>:8080`; the actual published port is the value of `PANEL_APP_PORT_HTTP` in the installation form.

- `APP_DATA_DIR` is mounted at `/data` for encrypted sessions and the key cache.
- `DB_DATA_DIR` is mounted at `/db` for local SQLite and DuckDB files. Enter a path relative to `/db`, such as `example.db`, in WhoDB.
- Leave `WHODB_ENCRYPTION_KEY` as `generate` to create and persist a 64-character hexadecimal key. Do not replace the key while existing sessions are in use.
- Set `WHODB_SECURE` to `true` when WhoDB is behind an HTTPS reverse proxy.

## Security and data handling

WhoDB stores database credentials in encrypted browser sessions. Protect the application `.env`, `APP_DATA_DIR`, `DB_DATA_DIR`, and backups. The Community image does not provide a separate global access login, so do not expose the port to an untrusted network; use a VPN, IP allowlist, or an authenticated 1Panel reverse proxy. Optional AI providers may receive user requests and database context, so review the selected provider's data and credential policy.

Back up both persistent directories before upgrades, migrations, or uninstalling.

## References

- Website: <https://whodb.com/>
- Source: <https://github.com/clidey/whodb>
- Documentation: <https://docs.whodb.com/>
- Docker persistence: <https://github.com/clidey/whodb/blob/main/README.md#docker-with-persistent-sessions>
