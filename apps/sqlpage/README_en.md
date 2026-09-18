# SQLPage

## Introduction

SQLPage turns SQL queries into dynamic web pages. The 1Panel package runs the
SQLPage server with its web root stored in the app data directory, so site
content remains available across container upgrades.

## Features

- Build pages and forms from SQL files.
- Serve site content from the persistent `APP_DATA_DIR` directory.
- Keep SQLPage configuration in the package's read-only `config` directory.
- Disable dangerous HTML, protocol, and command execution options by default.

## Usage

After installation, open the configured HTTP port in the 1Panel app details.
Place site SQL files in the app data directory and adjust `config/sqlpage.json`
when you need to change the server configuration. The package uses the
configured bind address, port, environment, log level, response compression,
upload limit, data directory, and timezone values from the install form.
