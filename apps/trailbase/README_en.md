# TrailBase

## Introduction

TrailBase is a lightweight, extensible application backend built with Rust, SQLite, and WebAssembly. It provides a database, authentication, real-time record APIs, an administration dashboard, and an extension runtime in a self-hosted service.

## Features

- SQLite database and administration dashboard
- Authentication and real-time record APIs
- Management of tables, indexes, views, and records
- WebAssembly server extensions
- Non-root runtime with a single persistent data directory

## Usage

After installation, open `http://server-address:port/_/admin/` in a browser. On first start, TrailBase creates the `admin@localhost` administrator and prints a randomly generated initial password to the container log. Find the `Created new admin user` entry, sign in, and change the email address and password immediately.

The Data Directory field is mounted at `/app/traildepot` and defaults to `./data` inside the version directory. It must remain a relative path inside that directory; absolute paths, path traversal, and symbolic links are rejected. The directory contains the database, configuration, secrets, migrations, and uploaded content, and is preserved when the app is uninstalled. Back it up before upgrading.

For public deployments, put TrailBase behind HTTPS and restrict access to the administration interface. Review the upstream documentation before enabling external clients, and tighten the default cross-origin policy for the deployment.
