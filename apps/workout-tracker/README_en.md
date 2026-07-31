# Workout Tracker

Workout Tracker is a self-hosted activity log for individuals, families, and small groups. It records running, cycling, and other workouts, imports GPX/FIT tracks, and presents routes, statistics, and daily measurements in a browser.

## Usage

- A fresh database creates the administrator account `admin` with password `admin`. Change the password from the administrator user edit page immediately after signing in.
- The package uses SQLite by default. The database and application state are stored under the selected data directory's `data` subdirectory; imported files use the `imports` subdirectory.
- 1Panel generates the session encryption key during installation. Backups and migrations must preserve both this key and the data directory, or existing sessions will become invalid.
- The install form can disable registration and social features or enable offline mode. Offline mode avoids external geocoding requests.
- New accounts require administrator activation by default.

## Security And Upgrades

- The fixed image preflight found several High dependency issues with available fixes, including a denial of service through malformed Markdown. Limit accounts to trusted users and recheck the current image before public deployment.
- The container runs as UID/GID `1000:1000`, uses a read-only root filesystem, drops all Linux capabilities, and enables `no-new-privileges`.
- Before updating, back up the selected data directory and the session encryption key from the install form. Do not remove the SQLite database or `imports` directory during an update.

## References

- Project: <https://github.com/jovandeginste/workout-tracker>
- Docker and configuration guide: <https://github.com/jovandeginste/workout-tracker/blob/d72d10327582230c6e67c976e067a820eeadf68d/README.md>
- License: <https://github.com/jovandeginste/workout-tracker/blob/d72d10327582230c6e67c976e067a820eeadf68d/LICENSE> (MIT)
