# Renovate Automerge Whitelist Policy

This whitelist is intentionally conservative. It is meant for low-touch Renovate image tag bumps, not for general app maintenance.

The current whitelist still contains legacy exceptions. Treat this document as the admission standard for new entries and the pruning standard for future cleanup passes.

## Default admission rule

Add an app to `.github/renovate-automerge-whitelist.txt` only when all of the following are true:

1. The app is single-service, or is an explicitly reviewed exception.
2. The app's compose shape has stayed stable across recent store snapshots.
3. Recent Renovate PRs for the app were effectively image-only updates.
4. The app did not recently require maintainer repair for runtime wiring, env migration, upgrade migration, or source/image trust correction.
5. The app does not depend on auxiliary sidecars whose version drift needs human judgment.

## Strong preferences

- Single-service apps first.
- Stable upstream deployment pattern first.
- No special runtime privileges first.
- Trivial `upgrade.sh` first, but do not reject a legacy stable app only because `upgrade.sh` is non-empty.

## Manual caution flags

These do not always block admission, but they should slow us down:

- `privileged: true`
- `network_mode: host`
- `runtime: nvidia`
- `devices`, `cap_add`, `pid: host`, `ipc: host`
- Non-trivial `scripts/upgrade.sh` is advisory only; by itself it does not block a stable single-service app
- Frequent maintainer follow-up commits after Renovate bumps

## Multi-service apps

Do not add multi-service apps to the whitelist by default.

If a multi-service app needs Renovate automation:

1. Keep it out of the whitelist-first path.
2. Model primary services explicitly in `.github/renovate-primary-services.json`.
3. Require tested maintainer review when only sidecars change or when compose shape changes.

## Audit workflow

Use the local audit helper before adding or pruning entries:

```bash
python3 .github/scripts/renovate_whitelist_audit.py \
  --apps-file .github/renovate-automerge-whitelist.txt \
  --only-problems
```

Check a specific candidate:

```bash
python3 .github/scripts/renovate_whitelist_audit.py \
  --app azahar-linuxserver \
  --app nzbget-linuxserver
```

The helper is heuristic only. It audits current store packaging, not upstream release intent, so a human still needs to confirm that the upstream compose/deployment pattern is stable enough for automerge.

In particular, the helper reports non-trivial `upgrade.sh` as a caution signal, not a hard failure. For older stable apps, a non-empty upgrade script often reflects migration history rather than ongoing automerge risk.
