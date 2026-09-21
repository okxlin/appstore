# Milvus

## Introduction

Milvus is an open-source vector database for vector search and data analytics. It exposes vector data services through gRPC, HTTP, and WebUI interfaces.

This package follows the official Milvus v3.0.2 standalone Docker Compose release. It includes Milvus, etcd for metadata, and MinIO for object storage. The default message queue is provided by the Milvus image, so no 1Panel database or Redis service is required.

## Features

- Vector data insertion, query, search, and index management
- Milvus gRPC API and HTTP/WebUI endpoints
- etcd-backed metadata and MinIO-backed object storage
- Separate persistent directories for Milvus, etcd, and MinIO

## Access

- Milvus gRPC API: `19530` by default
- Milvus HTTP/WebUI: `9091` by default; open `http://<host>:9091/webui/`
- MinIO API: `9000` by default
- MinIO console: `9001` by default

The MinIO ports are published as in the upstream Compose file, but its credentials are fixed by that file at `minioadmin` / `minioadmin`. Treat these ports as internal management endpoints and do not expose them directly to an untrusted public network. Configure credentials and network access according to the upstream documentation before making them public.

Milvus standalone officially requires at least 4 CPU cores and 8 GB of RAM. The CPU must support at least one of SSE4.2, AVX, AVX2, or AVX-512. Actual requirements depend on the dataset and index types.

## Data and lifecycle

This package uses relative bind mounts under the application instance directory; it does not declare Docker named volumes. Relative paths are resolved from the deployed directory containing `docker-compose.yml`:

| Relative host path | Container path | Purpose |
| --- | --- | --- |
| `./milvus-data` | `/var/lib/milvus` | Milvus data and local WAL |
| `./etcd-data` | `/etcd` | etcd metadata |
| `./minio-data` | `/minio_data` | MinIO object data |

The data remains available across container restarts, rebuilds, and upgrades as long as the application instance directory is retained. Back up all three directories and the Compose configuration before an upgrade, migration, or uninstall. Do not assume they behave like Docker named volumes that survive uninstall: removing the application instance directory removes these bind-mounted data directories. The official upgrade procedure keeps the existing etcd, object storage, message queue, and data directories; do not switch message-queue systems during an upgrade. Do not perform an image-only rollback after Milvus has written upgraded state; use a tested backup recovery plan instead.

The official Compose file uses a one-shot volume-permission initializer. To remain compatible with 1Panel's status handling for exited sidecars, this package performs the same marker and recursive ownership initialization in the root `scripts/init.sh`; Compose keeps only the long-running etcd, MinIO, and Milvus services. The Milvus service retains the upstream `seccomp:unconfined` setting.

## Links

- [Website](https://milvus.io/)
- [Docker Compose configuration](https://milvus.io/docs/configure-docker.md)
- [Docker prerequisites](https://milvus.io/docs/prerequisite-docker.md)
- [Official v3.0.2 standalone Compose](https://github.com/milvus-io/milvus/releases/download/v3.0.2/milvus-standalone-docker-compose.yaml)
- [Upgrade guide](https://milvus.io/docs/upgrade_milvus_standalone-docker.md)
- [Source repository](https://github.com/milvus-io/milvus)
