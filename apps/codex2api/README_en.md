# Codex2API

## Introduction

Codex2API is a Codex account-pool gateway that exposes OpenAI and Anthropic compatible APIs while managing accounts, scheduling, rate-limit recovery, usage, and access keys. This package uses the upstream single-container SQLite and in-memory cache deployment, without PostgreSQL or Redis.

## Installation and Access

- 1Panel generates `ADMIN_SECRET` during installation. It is the admin credential; record it from the installation form and keep it safe.
- Open `/admin/` through the Web port shown in the application details and sign in with `ADMIN_SECRET`.
- After the first login, create at least one downstream API key on the admin API Keys page before exposing `/v1/*` to clients.
- Before the first API key is created, `/v1/*` returns HTTP 503. Afterwards, requests without a valid API key return HTTP 401.
- Upstream no longer imports downstream keys from `CODEX_API_KEYS`, so this package does not expose that ineffective form field.

## Data and Upgrades

- The SQLite database, account records, and images are stored under `data/data` in the installation directory.
- Application logs are stored under `data/logs` in the installation directory.
- The application stores Codex refresh tokens, access tokens, proxies, and downstream API keys. Back up the complete `data` directory in 1Panel before upgrades, recreation, or migration.

## Security and License Notes

- Deploy only in a trusted environment. Use HTTPS through a reverse proxy, restrict access to the admin dashboard, and configure firewall controls. Never upload real tokens over plaintext HTTP.
- This package forces `CODEX_ALLOW_ANONYMOUS=false`. Downstream API keys must still be created in the admin dashboard and should not be replaced by network controls alone.
- The fixed `2.6.1` image comes from the upstream author's GHCR namespace and retains its verified digest.
- The `latest` package follows the upstream moving tag without a digest so tools such as Watchtower can pull updates. A newly resolved image requires fresh image scanning and renewed verification of admin login, API-key use, restart, and data persistence.
- The upstream README declares the MIT License, but the repository has no standalone `LICENSE` file and the OCI license label is empty. Confirm the applicable license terms before deployment or redistribution.

## References

- Repository: <https://github.com/james-6-23/codex2api>
- Deployment: <https://github.com/james-6-23/codex2api/blob/main/docs/DEPLOYMENT.md>
- Configuration: <https://github.com/james-6-23/codex2api/blob/main/docs/CONFIGURATION.md>
- Official image: <https://github.com/james-6-23/codex2api/pkgs/container/codex2api>
