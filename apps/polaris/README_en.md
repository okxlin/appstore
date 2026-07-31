# Polaris

Polaris is a self-hosted music collection and streaming server for browsers and mobile devices.

## Deployment

- The image comes from the Connectical container project endorsed by the Polaris installation guide.
- Open the configured HTTP port, create an administrator, and add `/music` as the collection directory.
- Music is mounted read-only. Cache and application data are owned by Polaris UID/GID `100:100`.
- Application data includes accounts, playlists, the collection index, and the application database. Back it up before upgrading.
- Uninstalling the app does not delete music, cache, or application data.

## Data directories

| Variable | Purpose | Default |
| --- | --- | --- |
| `POLARIS_MUSIC_DIR` | Read-only music library | `./data/music` |
| `POLARIS_CACHE_DIR` | Scan and artwork cache | `./data/cache` |
| `POLARIS_DATA_DIR` | Accounts, index, and database | `./data/data` |

The initialization script rejects symbolic links in configured directories and recursively assigns cache and data ownership to `100:100`. Use dedicated directories for Polaris.

## References

- Website: <https://polaris.stream>
- Source: <https://github.com/agersant/polaris>
- Container documentation: <https://github.com/ogarcia/docker-polaris>
