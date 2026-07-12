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
6. Persist the self-hosted cache with the SHA-pinned `actions/cache` step in `.github/workflows/renovate.yml`.

## Docker Hub 429 retry policy

`.github/workflows/renovate-rate-limit-retry.yml` checks the latest full Renovate run once per hour. It dispatches another full scan only when the latest run is a completed failure whose logs explicitly contain a registry `429`, the failure is at least 55 minutes old, and fewer than six full scans were started that UTC day. Successful, incomplete, unrelated, and young failures are not retried.

The retry controller does not keep a runner sleeping during Docker Hub's cooldown. The newly dispatched run becomes the latest run immediately, so later checks stop until that run completes. The daily cap bounds repeated registry failures.

## Multi-service update policy

Renovate cannot natively express a dependency rule where an auxiliary image may update only when a separate primary image also updates. `.github/renovate-primary-services.json` therefore identifies primary services, while `.github/scripts/renovate_sidecar_guard.py` closes PRs that change only auxiliary images in a multi-service app. The guard also removes the closed PR's temporary branch only when it belongs to this repository and uses a known Renovate branch prefix; fork branches are never deleted.

This is post-creation suppression, not a guarantee that Renovate never creates a temporary branch or PR. Continue disabling known auxiliary packages in `.github/renovate-docker.json` where a stable path/package rule is available. Single-service apps using the same image name are unaffected because those rules and the runtime guard are scoped by app path and Compose service count.

The workflow stores Renovate's public package lookup cache and repository extraction cache under `/tmp/renovate-cache`. Private package caching remains disabled. Cache writes come only from the scheduled or manually dispatched trusted workflow.

GitHub Actions cache entries are immutable, so each run uses a unique key and restores the newest compatible prefix. The configuration hash separates policy generations, while the broader fallback retains public package lookup data after policy changes. Monitor the reported directory size and repository cache inventory to avoid churn against GitHub's default cache quota.

Restore and save are separate steps. A failed registry scan may still save valid package cache entries for the next run, but the workflow refuses to save a cache larger than 512 MiB.

## Cache security boundary

- Treat cache contents as readable by contributors who can open pull requests. Never write credentials, tokens, generated environment files, or private registry responses under `/tmp/renovate-cache`.
- Keep `RENOVATE_CACHE_PRIVATE_PACKAGES` set to `false`.
- Keep cache writes limited to this scheduled/manual workflow; do not add `pull_request` or `pull_request_target` triggers.
- Keep `actions/cache` pinned to a reviewed commit SHA.
- Keep the workflow's default `GITHUB_TOKEN` read-only. Renovate writes through the dedicated `GITHUBTOKEN` secret.
- Keep a bounded job timeout so a stalled registry cannot consume a runner indefinitely.
- The restored directory contains Renovate data, not executable project scripts. Do not add cached paths to `PATH`, source files from them, or execute binaries restored from the cache.
- A cache miss or corrupt entry must degrade to a fresh lookup. It must not bypass Renovate validation, sidecar guards, app-version checks, or maintainer review.
- Keep Docker Hub credentials scoped to `docker.io`, `index.docker.io`, and `registry-1.docker.io`. Do not use a hostless Docker rule that would send them to unrelated registries.

## Change checklist

After changing either controller:

```bash
python3 .github/scripts/test_renovate_app_version.py
```

Before a full scan, verify that Docker Hub accepts the configured repository secrets:

```bash
gh workflow run renovate-dockerhub-preflight.yml --ref localApps
```

Validate both JSON configurations with the Renovate version used by `.github/workflows/renovate.yml`, then run the self-hosted workflow manually. Confirm that its log lists only `docker-compose`, its branches start with `selfhosted-renovate/`, and the hosted App does not close them before retiring an older duplicate dashboard.
