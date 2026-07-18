# Kestra

Kestra is an open-source workflow orchestration platform. This package uses the official Kestra image and stores metadata, queue state, and schedules in the selected 1Panel PostgreSQL Runtime.

## Notes

- Install and start a PostgreSQL Runtime in the same 1Panel before installing Kestra, then select it in the install form. 1Panel provisions a dedicated Kestra database and user.
- Sign in with the Basic Auth username and password from the install form. The username must be a valid email address; the password must be at least eight characters and include uppercase, lowercase, and numeric characters.
- Create and run the official `hello_world` Log flow in the UI to verify the base workflow path.
- Business state is stored in PostgreSQL and file storage is kept in `DATA_PATH/storage`. Back up both before upgrading or migrating.
- This package does not mount the Docker socket; the Kestra application process does not run as root. Docker task runners need container-engine control and are intentionally outside the default deployment; assess them separately in an isolated environment using the official Kestra documentation.
- The container uses root only at startup to create and assign `/app/storage`, then immediately drops to Kestra UID/GID `1000`; it does not mount the Docker socket.

## Parameters

| Parameter | Description | Default | Required |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | Kestra web port | `8080` | Yes |
| `PANEL_DB_HOST` | 1Panel PostgreSQL service | - | Yes |
| `PANEL_DB_NAME` | Dedicated Kestra database name | Generated | Yes |
| `PANEL_DB_USER` | Dedicated Kestra database user | Generated | Yes |
| `PANEL_DB_USER_PASSWORD` | Dedicated Kestra database user password | Generated | Yes |
| `KESTRA_BASIC_AUTH_USERNAME` | Initial Basic Auth username (email address) | `admin@kestra.local` | Yes |
| `KESTRA_BASIC_AUTH_PASSWORD` | Initial Basic Auth password | Generated | Yes |
| `DATA_PATH` | Local file storage root (an absolute path outside the install directory preserves it after uninstall) | `/opt/1panel-data/kestra` | Yes |

## Official Resources

- [Kestra installation documentation](https://kestra.io/docs/installation)
- [Kestra Docker Compose example](https://kestra.io/docs/installation/docker)
- [Kestra Hello World flow](https://kestra.io/docs/getting-started/quickstart)
