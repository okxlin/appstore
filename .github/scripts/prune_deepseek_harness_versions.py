#!/usr/bin/env python3
"""Give new DeepSeek Harness versions seven days in localApps, then keep three."""

from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import tempfile
from datetime import datetime, timedelta, timezone
from pathlib import Path


APP_ROOT = Path("apps/deepseek-harness-workstation")
RETENTION_FILE = Path(".github/state/deepseek-harness-version-retention.json")
VERSION_RE = re.compile(
    r"(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)"
    r"(?:-(?P<channel>alpha|beta|rc)\.(?P<sequence>\d+))?-workstation"
)
CHANNEL_ORDER = {"alpha": 0, "beta": 1, "rc": 2}
GRACE_PERIOD = timedelta(days=7)
VERSIONS_TO_KEEP = 3


def git(*args: str, check: bool = True) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(
        ["git", *args],
        check=False,
        text=True,
        capture_output=True,
    )
    if check and result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip()
        raise RuntimeError(detail or f"git {' '.join(args)} failed")
    return result


def version_key(name: str) -> tuple[int, int, int, int, int, int]:
    match = VERSION_RE.fullmatch(name)
    if match is None:
        raise ValueError(f"unsupported fixed version directory: {name}")
    channel = match.group("channel")
    return (
        int(match.group("major")),
        int(match.group("minor")),
        int(match.group("patch")),
        1 if channel is None else 0,
        CHANNEL_ORDER.get(channel, 0),
        int(match.group("sequence") or 0),
    )


def parse_timestamp(value: object, name: str) -> datetime:
    if not isinstance(value, str):
        raise RuntimeError(f"invalid retention timestamp for {name}; refusing to prune")
    try:
        parsed = datetime.fromisoformat(value)
    except ValueError as exc:
        raise RuntimeError(f"invalid retention timestamp for {name}; refusing to prune") from exc
    if parsed.tzinfo is None or parsed.utcoffset() is None:
        raise RuntimeError(f"retention timestamp for {name} has no timezone; refusing to prune")
    return parsed.astimezone(timezone.utc)


def initialized_timestamps(
    versions: list[str], existing: dict[str, str], now: datetime
) -> dict[str, str]:
    """Start the grace period when a version is first observed on localApps."""
    normalized_now = now.astimezone(timezone.utc)
    timestamps: dict[str, str] = {}
    for name in versions:
        if name in existing:
            # Validate persisted values before trusting them for deletion.
            parse_timestamp(existing[name], name)
            timestamps[name] = existing[name]
        else:
            timestamps[name] = normalized_now.isoformat(timespec="seconds")
    return timestamps


def prunable_versions(
    versions: list[str], timestamps: dict[str, str], now: datetime
) -> list[str]:
    ordered = sorted(versions, key=version_key)
    if len(ordered) <= VERSIONS_TO_KEEP:
        return []

    newest_introduction = max(parse_timestamp(timestamps[name], name) for name in ordered)
    if now.astimezone(timezone.utc) - newest_introduction < GRACE_PERIOD:
        return []
    return ordered[:-VERSIONS_TO_KEEP]


def load_registry(path: Path) -> dict[str, str]:
    if path.is_symlink():
        raise RuntimeError(f"retention registry must not be a symlink: {path}")
    if not path.exists():
        return {}
    payload = json.loads(path.read_text(encoding="utf-8"))
    if (
        not isinstance(payload, dict)
        or payload.get("schema_version") != 1
        or payload.get("app") != APP_ROOT.as_posix()
        or not isinstance(payload.get("versions"), dict)
    ):
        raise RuntimeError(f"invalid retention registry; refusing to prune: {path}")
    versions = payload["versions"]
    if any(not isinstance(name, str) or not isinstance(value, str) for name, value in versions.items()):
        raise RuntimeError(f"invalid retention registry entries; refusing to prune: {path}")
    return versions


def write_registry(path: Path, timestamps: dict[str, str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "schema_version": 1,
        "app": APP_ROOT.as_posix(),
        "versions": dict(sorted(timestamps.items(), key=lambda item: version_key(item[0]))),
    }
    descriptor, temporary_name = tempfile.mkstemp(
        prefix=f"{path.name}.", suffix=".tmp", dir=path.parent
    )
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8", newline="\n") as output:
            output.write(json.dumps(payload, indent=2) + "\n")
            output.flush()
            os.fsync(output.fileno())
        temporary.replace(path)
    finally:
        temporary.unlink(missing_ok=True)


def main() -> int:
    repo_root = Path(git("rev-parse", "--show-toplevel").stdout.strip()).resolve()
    raw_app_root = repo_root / APP_ROOT
    if raw_app_root.is_symlink():
        raise RuntimeError(f"app directory must not be a symlink: {APP_ROOT}")
    app_root = raw_app_root.resolve()
    expected_apps_root = (repo_root / "apps").resolve()
    if app_root.parent != expected_apps_root or not app_root.is_dir():
        raise RuntimeError(f"unexpected or missing app directory: {APP_ROOT}")

    github_root = repo_root / ".github"
    raw_state_parent = repo_root / RETENTION_FILE.parent
    if github_root.is_symlink() or raw_state_parent.is_symlink():
        raise RuntimeError("retention registry directory must not contain symlinks")
    if raw_state_parent.resolve().parent != github_root.resolve():
        raise RuntimeError(f"unexpected retention registry directory: {RETENTION_FILE.parent}")

    version_names: list[str] = []
    for entry in app_root.iterdir():
        if VERSION_RE.fullmatch(entry.name) is None:
            continue
        if entry.is_symlink() or not entry.is_dir():
            raise RuntimeError(f"refusing to inspect non-directory version path: {entry}")
        if not (entry / "docker-compose.yml").is_file():
            raise RuntimeError(f"fixed version directory has no docker-compose.yml: {entry}")
        version_names.append(entry.name)

    registry_path = repo_root / RETENTION_FILE
    existing = load_registry(registry_path)
    now = datetime.now(timezone.utc)
    timestamps = initialized_timestamps(version_names, existing, now)
    changed = timestamps != existing
    if changed:
        write_registry(registry_path, timestamps)
        print(f"recorded localApps arrival time for {len(set(timestamps) - set(existing))} version(s)")

    if len(version_names) <= VERSIONS_TO_KEEP:
        print(f"found {len(version_names)} fixed workstation versions; nothing to prune")
    else:
        removals = prunable_versions(version_names, timestamps, now)
        if not removals:
            newest_introduction = max(parse_timestamp(timestamps[name], name) for name in version_names)
            remaining = max(timedelta(0), GRACE_PERIOD - (now - newest_introduction))
            print(f"seven-day coexistence window is active; about {int(remaining.total_seconds() // 3600)} hours remain")
        else:
            for name in removals:
                relative = APP_ROOT / name
                status = git("status", "--porcelain", "--", relative.as_posix()).stdout
                if status:
                    raise RuntimeError(f"refusing to prune modified version directory: {relative}")
            for name in removals:
                relative = APP_ROOT / name
                git("rm", "-r", "--", relative.as_posix())
                print(f"pruned {relative}")
            timestamps = {name: value for name, value in timestamps.items() if name not in removals}
            write_registry(registry_path, timestamps)

    git("add", "--", RETENTION_FILE.as_posix())
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, RuntimeError, ValueError, json.JSONDecodeError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        raise SystemExit(1)
