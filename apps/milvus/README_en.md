# Milvus

## Introduction

Milvus is an open-source vector database for vector search and data analytics. It exposes vector data services through gRPC, HTTP, and WebUI interfaces.

This package follows the official Milvus standalone Docker Compose topology. It includes Milvus, etcd for metadata, and MinIO for object storage. The default message queue is provided by the Milvus image, so no 1Panel database or Redis service is required. Each app-store version directory corresponds to a specific upstream release; use that release's official documentation for version-specific prerequisites and upgrade steps.

## Features

- Vector data insertion, query, search, and index management
- Milvus gRPC API and HTTP/WebUI endpoints
- etcd-backed metadata and MinIO-backed object storage
- Separate persistent directories for Milvus, etcd, and MinIO

## Access

- Configure the host ports for Milvus gRPC, HTTP/WebUI, the MinIO API, and the MinIO console in the 1Panel installation form; use the values shown for the selected version.
- The Milvus WebUI is available at `/webui/` on the configured HTTP/WebUI port. gRPC clients should use the configured gRPC port.
- The MinIO API and console are object-storage management endpoints and should normally remain within a trusted network or reverse-proxy boundary.

Read the selected release's official Docker prerequisites before installation and size CPU, memory, and instruction-set support for the dataset, index types, and concurrency. Before exposing MinIO management endpoints publicly, verify the credential and network requirements in the selected upstream documentation; do not use upstream example credentials in a public deployment.

## Data and lifecycle

This package uses relative bind mounts under the application instance directory; it does not declare Docker named volumes. Relative paths are resolved from the deployed directory containing `docker-compose.yml`:

| Relative host path | Container path | Purpose |
| --- | --- | --- |
| `./milvus-data` | `/var/lib/milvus` | Milvus data and local WAL |
| `./etcd-data` | `/etcd` | etcd metadata |
| `./minio-data` | `/minio_data` | MinIO object data |

The data remains available across container restarts, rebuilds, and upgrades as long as the application instance directory is retained. Do not share one set of data directories between multiple instances. Back up all three directories and the Compose configuration before an upgrade, migration, or uninstall. Do not assume they behave like Docker named volumes that survive uninstall: removing the application instance directory removes these bind-mounted data directories.

Before upgrading, read the official upgrade guidance for both the installed and target releases and confirm whether a direct upgrade is supported or an intermediate version is required. Preserve the existing etcd, object storage, message queue, and data directories. Do not perform an image-only rollback after Milvus has written upgraded state; use a tested backup recovery plan instead.

The official Compose file uses a one-shot volume-permission initializer. To remain compatible with 1Panel's status handling for exited sidecars, this package performs the same marker and recursive ownership initialization in the root `scripts/init.sh`; Compose keeps only the long-running etcd, MinIO, and Milvus services. The Milvus service retains the upstream `seccomp:unconfined` setting.

## Security and Deployment Risks

- The Milvus service retains the upstream Compose `seccomp:unconfined` setting for compatibility with the official standalone topology. Run it on a trusted host and network, and follow upstream security updates.
- Do not expose the MinIO API or console directly to an untrusted public network. Configure strong credentials, access controls, and a reverse-proxy boundary before public access.

## Links

- [Website](https://milvus.io/)
- [Docker Compose configuration](https://milvus.io/docs/configure-docker.md)
- [Docker prerequisites](https://milvus.io/docs/prerequisite-docker.md)
- [Official Docker installation](https://milvus.io/docs/install_standalone-docker.md)
- [Upgrade guide](https://milvus.io/docs/upgrade_milvus_standalone-docker.md)
- [Milvus releases](https://github.com/milvus-io/milvus/releases)
- [Source repository](https://github.com/milvus-io/milvus)
- [Official artwork and logo](https://github.com/milvus-io/artwork)
- [Linux Foundation trademark usage](https://www.linuxfoundation.org/trademark-usage/)

## Logo and trademark notice

This package uses the icon from the [official Milvus artwork repository](https://github.com/milvus-io/artwork) to identify the software it provides. The Milvus name and marks are subject to the [Linux Foundation trademark usage guidelines](https://www.linuxfoundation.org/trademark-usage/); this package does not imply sponsorship or endorsement by Milvus or LF AI & Data.
