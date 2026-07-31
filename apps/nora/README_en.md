## Introduction

**NORA** is a lightweight self-hosted artifact registry. A single service supports Docker Registry v2, Raw, Maven, npm, PyPI, Cargo, Go Modules, NuGet, and other package protocols.

## Features

- Browse artifacts, activity, and runtime status in the built-in Web interface.
- Host and proxy-cache multiple package formats.
- Persist artifacts, indexes, tokens, and configuration in a local volume.
- Optionally enable basic authentication, OIDC, S3 storage, retention, and curation policies.

## Access and security

- Open `/ui/` on the Web port shown in the 1Panel application details.
- Authentication is disabled by default to preserve the upstream zero-configuration workflow. Anyone who can reach the port may be able to upload, download, or delete artifacts, so do not expose it directly to an untrusted network.
- Before public exposure, use HTTPS through a reverse proxy and configure authentication and the correct public URL according to the upstream documentation.
- The public URL is used in generated client links. Keep it aligned with the selected Web port or external domain.

## Data and upgrades

- NORA stores artifact data, indexes, tokens, and configuration in a Docker named volume.
- This package is limited to one instance to prevent multiple installations from competing for the same volume.
- Back up the NORA data volume before upgrading. 1Panel controls whether the volume is removed during uninstall; the package scripts do not delete user data directly.
- `latest` is intentionally movable for users who track releases with container update tools; the numbered version provides a reproducible deployment.

## Default workflow

With the default unauthenticated configuration, upload a small file with `PUT /raw/<path>` and download it from the same URL. This exercises upload, indexing, download, and persistence across restart.

## Links

- Website: <https://getnora.dev>
- Project: <https://github.com/getnora-io/nora>
- Container image: <https://github.com/getnora-io/nora/pkgs/container/nora>
