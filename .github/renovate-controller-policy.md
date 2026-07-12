# Renovate Controller Policy

This repository intentionally uses two Renovate controllers with disjoint ownership.

| Controller | Configuration | Managers | Branch prefix | Dashboard |
| --- | --- | --- | --- | --- |
| Mend Renovate App | `renovate.json` | `github-actions` | `renovate/` | `Dependency Dashboard` |
| GitHub Actions self-hosted Renovate | `.github/renovate-global.js` and `.github/renovate-docker.json` | `docker-compose` | `selfhosted-renovate/` | `Dependency Dashboard (Docker Images)` |

The self-hosted controller sets `requireConfig: "ignored"` so the hosted controller's root configuration cannot replace its Compose-only manager scope. Do not remove this boundary or merge the two configuration files.

## Ownership invariants

1. The controllers must not share an enabled manager.
2. The controllers must not share a branch prefix.
3. The controllers must not share a dashboard title.
4. App versioning, sidecar guards, and app automerge workflows must recognize `selfhosted-renovate/` branches.
5. Do not split the Compose catalog across concurrent Renovate instances unless each instance also has an exclusive branch namespace and cleanup scope. Directory-only sharding is insufficient because one instance can close another instance's branches and PRs.

These rules follow Renovate's documented manager allowlist, branch ownership, dashboard title, and repository-config behavior:

- <https://docs.renovatebot.com/configuration-options/#enabledmanagers>
- <https://docs.renovatebot.com/configuration-options/#branchprefix>
- <https://docs.renovatebot.com/configuration-options/#dependencydashboardtitle>
- <https://docs.renovatebot.com/self-hosted-configuration/#requireconfig>

## Scaling order

For a growing app catalog, apply capacity improvements in this order:

1. Authenticate high-volume registries, especially Docker Hub.
2. Keep manager ownership disjoint so the same dependency is not queried twice.
3. Run the full Compose scan on a schedule or manually, with workflow concurrency preventing overlap.
4. Suppress historical tracks and auxiliary-only updates in `.github/renovate-docker.json`.
5. Group application images that must move together and keep multi-service updates under tested maintainer review.
6. Add persistent repository/cache storage only when the GitHub Actions cache or an external cache backend is intentionally adopted and pinned.

Setting `repositoryCache: "enabled"` alone does not persist useful state between ephemeral GitHub-hosted runners. A cache action, Redis, or S3-backed cache requires a separate dependency and operational review before adoption.

## Change checklist

After changing either controller:

```bash
python3 .github/scripts/test_renovate_app_version.py
```

Validate both JSON configurations with the Renovate version used by `.github/workflows/renovate.yml`, then run the self-hosted workflow manually. Confirm that its log lists only `docker-compose`, its branches start with `selfhosted-renovate/`, and the hosted App does not close them before retiring an older duplicate dashboard.
