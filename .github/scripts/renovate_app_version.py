#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path, PurePosixPath
from typing import Any, NamedTuple

import yaml


class VersionSelection(NamedTuple):
    service: str
    version: str
    changed_services: list[str]
    reason: str


def services(compose: dict[str, Any]) -> dict[str, dict[str, Any]]:
    raw_services = compose.get("services")
    if not isinstance(raw_services, dict):
        raise ValueError("compose services must be a mapping")
    return {
        str(name): value
        for name, value in raw_services.items()
        if isinstance(value, dict)
    }


def image_tag(image: object) -> str:
    value = str(image or "").strip()
    if not value or "@" in value:
        return ""
    slash = value.rfind("/")
    colon = value.rfind(":")
    if colon <= slash:
        return ""
    tag = value[colon + 1 :].strip()
    return tag[1:] if tag.startswith("v") else tag


def select_target_version(
    app: str,
    base_compose: dict[str, Any],
    head_compose: dict[str, Any],
    primary_policy: dict[str, list[str]],
) -> VersionSelection:
    base_services = services(base_compose)
    head_services = services(head_compose)
    service_names = sorted(set(base_services) | set(head_services))
    changed = [
        name
        for name in service_names
        if base_services.get(name, {}).get("image") != head_services.get(name, {}).get("image")
    ]
    if not changed:
        return VersionSelection("", "", [], "no service image changed")

    service_count = max(len(base_services), len(head_services))
    if service_count == 1:
        candidates = changed
    else:
        primary_services = primary_policy.get(app) or []
        if not primary_services:
            return VersionSelection("", "", changed, "multi-service compose has no primary service mapping")
        candidates = [name for name in primary_services if name in changed]
        if not candidates:
            return VersionSelection("", "", changed, "multi-service compose changed only auxiliary services")

    versions: dict[str, str] = {}
    for service in candidates:
        tag = image_tag(head_services.get(service, {}).get("image"))
        if not tag:
            raise ValueError(f"changed primary service has no usable image tag: {service}")
        versions[service] = tag

    unique_versions = sorted(set(versions.values()))
    if len(unique_versions) != 1:
        detail = ", ".join(f"{service}={version}" for service, version in versions.items())
        raise ValueError(f"changed primary services have different target tags: {detail}")

    return VersionSelection(candidates[0], unique_versions[0], changed, "primary service image changed")


def load_yaml_text(text: str, label: str) -> dict[str, Any]:
    payload = yaml.safe_load(text) or {}
    if not isinstance(payload, dict):
        raise ValueError(f"{label} must decode to a mapping")
    return payload


def git_show(ref: str, path: str) -> str:
    result = subprocess.run(
        ["git", "show", f"{ref}:{path}"],
        check=False,
        text=True,
        capture_output=True,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip() or f"unable to read {path} at {ref}")
    return result.stdout


def validate_compose_path(app: str, old_version: str, raw_path: str) -> str:
    path = PurePosixPath(raw_path)
    expected_parent = PurePosixPath("apps") / app / old_version
    if path.name != "docker-compose.yml" or path.parent != expected_parent:
        raise ValueError(f"compose path must be {expected_parent}/docker-compose.yml")
    return path.as_posix()


def main() -> int:
    parser = argparse.ArgumentParser(description="Select the app version from the changed primary service image.")
    parser.add_argument("--app", required=True)
    parser.add_argument("--old-version", required=True)
    parser.add_argument("--compose", required=True)
    parser.add_argument("--base-ref", required=True)
    parser.add_argument("--policy-file", required=True)
    args = parser.parse_args()

    compose_path = validate_compose_path(args.app, args.old_version, args.compose)
    head_compose = load_yaml_text(Path(compose_path).read_text(encoding="utf-8"), "head compose")
    base_compose = load_yaml_text(git_show(args.base_ref, compose_path), "base compose")
    policy_payload = json.loads(Path(args.policy_file).read_text(encoding="utf-8"))
    if not isinstance(policy_payload, dict):
        raise ValueError("primary service policy must decode to an object")
    primary_policy = {
        str(app): [str(service) for service in configured]
        for app, configured in policy_payload.items()
        if isinstance(configured, list)
    }

    selection = select_target_version(args.app, base_compose, head_compose, primary_policy)
    if not selection.version:
        print(f"skip: {selection.reason}; changed={','.join(selection.changed_services)}", file=sys.stderr)
        return 0
    print(selection.version)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
