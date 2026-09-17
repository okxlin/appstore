# Flagsmith

## Introduction

Flagsmith is an open-source feature flag and remote configuration platform for managing flags, environments, identities and segments through an API and SDKs.

## Features

- Manage feature flags across projects and environments.
- Target identities and segments for gradual releases.
- Serve configuration through client and server SDKs and the REST API.
- Store flag analytics and process background tasks.

## Installation and access

- Prepare a running PostgreSQL service in 1Panel and select it in the installation form. The panel creates and links the application database and user.
- Open `http://<server-ip>:8000` after installation; use the value of `PANEL_APP_PORT_HTTP` if the port was changed, then create the first account.
- Set `FLAGSMITH_DOMAIN` to the host and optional port users will access, without `http://` or a path.
- For public deployments, use an HTTPS reverse proxy and set `FLAGSMITH_ALLOWED_HOSTS` to the actual domain.

## Data and security

- PostgreSQL stores application data. Back up the linked database before upgrades or uninstalling; uninstalling this app does not delete the external PostgreSQL service.
- `DJANGO_SECRET_KEY` is generated on first installation and must not be shared or committed.
- Registration is enabled by default. Set `PREVENT_SIGNUP` to `true` after creating the administrator account if appropriate.
- Optional OAuth, SAML, SMTP, webhook and other integrations should use least-privilege credentials.

## References

- Website: <https://www.flagsmith.com/>
- Source: <https://github.com/Flagsmith/flagsmith>
- Documentation: <https://docs.flagsmith.com/deployment-self-hosting/hosting-guides/docker>
- License: BSD-3-Clause
