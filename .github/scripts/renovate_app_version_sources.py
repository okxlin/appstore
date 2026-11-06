#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any

from renovate_app_version import image_tag, load_yaml_text, services


VERSION_PREFIX_RE = re.compile(r"^[vV]?(\d+(?:\.\d+)*)(.*)$")
PRERELEASE_RE = re.compile(r"(?:^|[-.])(?:alpha|beta|rc|pre|preview|dev|snapshot|nightly)(?:[-.+]|\d|$)", re.IGNORECASE)
ROLLING_VERSIONS = {"latest", "stable"}


def parse_compose_path(raw_path: str) -> tuple[str, str]:
    parts = raw_path.split("/")
    if (len(parts) != 4 or parts[0] != "apps" or parts[3] != "docker-compose.yml"
            or any(part in {"", ".", ".."} for part in parts)):
        raise ValueError(f"invalid app Compose path: {raw_path}")
    return parts[1], parts[2]


def git_path_exists(base_ref: str, path: str) -> bool:
    result = subprocess.run(
        ["git", "cat-file", "-e", f"{base_ref}:{path}"],
        text=True,
        capture_output=True,
        check=False,
    )
    return result.returncode == 0


def compose_at(ref: str, path: str, label: str) -> dict[str, Any]:
    result = subprocess.run(
        ["git", "show", f"{ref}:{path}"],
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise ValueError(f"unable to read {label} Compose file {path}: {result.stderr.strip()}")
    return load_yaml_text(result.stdout, f"{label} Compose file {path}")


def changed_primary_image_versions(
    base: dict[str, Any],
    head: dict[str, Any],
    app: str,
    policy: dict[str, list[str]],
) -> tuple[list[str], str] | None:
    base_services = services(base)
    head_services = services(head)
    service_names = sorted(set(base_services) | set(head_services))
    changed_services = {
        name
        for name in service_names
        if base_services.get(name, {}).get("image") != head_services.get(name, {}).get("image")
    }
    if not changed_services:
        return None

    if max(len(base_services), len(head_services)) == 1:
        primary_services = changed_services
    else:
        configured = policy.get(app) or []
        primary_services = changed_services.intersection(configured)
        if not primary_services:
            return None

    old_tags: list[str] = []
    new_tags: set[str] = set()
    for name in sorted(primary_services):
        old_tag = image_tag(base_services.get(name, {}).get("image"))
        new_tag = image_tag(head_services.get(name, {}).get("image"))
        if not new_tag:
            continue
        if old_tag == new_tag:
            continue
        if old_tag:
            old_tags.append(old_tag)
        new_tags.add(new_tag)

    if not new_tags:
        return None
    if len(new_tags) != 1:
        raise ValueError(f"{app}: primary services were updated to different target tags")
    return old_tags, next(iter(new_tags))


def version_order_key(tag: str) -> tuple[tuple[int, ...], int]:
    match = VERSION_PREFIX_RE.fullmatch(tag.strip())
    if not match:
        raise ValueError(f"cannot order source image version tag {tag!r}")
    core = tuple(int(part) for part in match.group(1).split("."))
    while len(core) > 1 and core[-1] == 0:
        core = core[:-1]
    suffix = match.group(2)
    is_prerelease = bool(suffix and PRERELEASE_RE.search(suffix))
    return core, 0 if is_prerelease else 1


def select_sources(
    paths: list[str],
    base_ref: str,
    head_ref: str,
    policy: dict[str, list[str]],
) -> list[str]:
    if not all(re.fullmatch(r"[0-9a-fA-F]{40,64}", ref) for ref in (base_ref, head_ref)):
        raise ValueError("base and head refs must be full Git commit SHAs")
    grouped: dict[str, list[str]] = {}
    for raw_path in paths:
        if not raw_path.endswith("/docker-compose.yml"):
            continue
        app, version = parse_compose_path(raw_path)
        if version in ROLLING_VERSIONS or not git_path_exists(base_ref, raw_path):
            continue
        grouped.setdefault(app, []).append(raw_path)

    selected: list[str] = []
    for app in sorted(grouped):
        candidates = sorted(set(grouped[app]))
        ranked: list[
            tuple[
                tuple[tuple[tuple[int, ...], int], tuple[tuple[int, ...], int]],
                str,
                str,
                str,
            ]
        ] = []
        for path in candidates:
            _, directory_version = parse_compose_path(path)
            baseline = compose_at(base_ref, path, "base")
            candidate = changed_primary_image_versions(
                baseline,
                compose_at(head_ref, path, "head"),
                app,
                policy,
            )
            if candidate is None:
                continue
            old_tags, new_tag = candidate
            old_tag = max(old_tags, key=version_order_key) if old_tags else ""
            try:
                old_image_key = version_order_key(old_tag) if old_tag else ((), 0)
            except ValueError:
                old_image_key = ((), 0)
            rank = (old_image_key, version_order_key(directory_version))
            ranked.append((rank, path, old_tag, new_tag))
        if not ranked:
            continue
        target_tags = {item[3] for item in ranked}
        if len(target_tags) != 1:
            raise ValueError(f"{app}: changed source Compose files target different image tags")
        highest = max(item[0] for item in ranked)
        winners = [item for item in ranked if item[0] == highest]
        if len(winners) != 1:
            detail = ", ".join(f"{path}={old_tag}" for _, path, old_tag, _ in winners)
            raise ValueError(f"{app}: ambiguous newest source Compose files: {detail}")
        selected.append(winners[0][1])
    return selected


def load_policy(path: Path) -> dict[str, list[str]]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict):
        raise ValueError("primary service policy must decode to an object")
    return {
        str(app): [str(service) for service in names]
        for app, names in payload.items()
        if isinstance(names, list)
    }


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Choose the newest existing source Compose path per updated app."
    )
    parser.add_argument("--base-ref", required=True)
    parser.add_argument("--head-ref", required=True)
    parser.add_argument("--changed-files", required=True, type=Path)
    parser.add_argument("--policy-file", required=True, type=Path)
    parser.add_argument("--output-file", required=True, type=Path)
    args = parser.parse_args()

    raw_paths = args.changed_files.read_bytes().split(b"\0")
    paths = [item.decode("utf-8") for item in raw_paths if item]
    selected = select_sources(paths, args.base_ref, args.head_ref, load_policy(args.policy_file))
    args.output_file.write_bytes(b"".join(path.encode("utf-8") + b"\0" for path in selected))
    for path in selected:
        print(path)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(str(exc), file=sys.stderr)
        raise SystemExit(1)
