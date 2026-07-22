# Baby Buddy

Baby Buddy is a self-hosted baby-care tracker for feeding, sleep, diaper changes, growth, and other daily activities.

## Access

The web interface listens on `PANEL_APP_PORT_HTTP` (default `8000`). The upstream image initially uses `admin` / `admin`; change this password immediately after the first login.

## Persistence

Application configuration and SQLite data are stored in `APP_DATA_DIR`, mounted at `/config`. `PUID` and `PGID` control file ownership.

## References

- [Documentation](https://docs.baby-buddy.net)
- [GitHub](https://github.com/babybuddy/babybuddy)
- [Container image](https://github.com/linuxserver/docker-babybuddy)
