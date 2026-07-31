# HitKeep

## Introduction

HitKeep is a privacy-first web and product analytics platform. It combines its dashboard, DuckDB storage, and event queue in a single container without requiring a separate database or cache service.

## Features

- Cookie-free pageview, visitor, event, conversion, and acquisition analytics
- Multi-site dashboards, goals, funnels, UTM reporting, and Web Vitals
- Team permissions, share links, API clients, and a read-only MCP endpoint
- Embedded DuckDB with data, archives, and backups kept under the configured data directory

Open HitKeep on the configured port after installation and create the first administrator account. The public URL must match the protocol, host, and port used by browsers; use the external HTTPS URL when deploying behind a reverse proxy. Keep the JWT secret unchanged across upgrades and restarts.
