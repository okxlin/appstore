# Chhoto URL

## Introduction

Chhoto URL is a lightweight, self-hosted URL shortener backed by SQLite. It
provides a small web interface and an API for creating and managing short
links.

## Features

- Lightweight Rust web application with a responsive frontend.
- SQLite persistence with optional WAL mode provided by the upstream image.
- Password and API-key authentication, configurable redirect behavior, and
  optional public URL metadata.
- Data is stored below the configured application data directory and survives
  upgrades and restarts.

## Usage

After installation, open the configured HTTP port in a browser. The main UI is
available at `/`; administrative link management is available at
`/admin/manage`. Use the generated administrator password for the web admin
interface and the generated API key for API clients.

The default persistent directory is `./data`, mounted as `/data` in the
container. Back up this directory before maintenance or migration. The default
container serves plain HTTP, so put it behind an HTTPS reverse proxy before
exposing it to an untrusted network.
