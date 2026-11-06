#!/usr/bin/env python3
from __future__ import annotations

import argparse
import copy
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any

import yaml


class GateReject(Exception):
    pass


def run_git(*args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", *args], check=False, text=True, capture_output=True
    )


def tree_files(ref: str, directory: str) -> dict[str, tuple[str, str]]:
    result = run_git("ls-tree", "-r", "-z", ref, "--", directory)
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or f"unable to read tree {ref}:{directory}")
    prefix = directory.rstrip("/") + "/"
    files: dict[str, tuple[str, str]] = {}
    for entry in result.stdout.split("\0"):
        if not entry:
            continue
        metadata, path = entry.split("\t", 1)
        mode, object_type, oid = metadata.split(" ", 2)
        if object_type == "blob" and path.startswith(prefix):
            files[path[len(prefix) :]] = (mode, oid)
    return files


def git_show(ref: str, path: str) -> str:
    result = run_git("show", f"{ref}:{path}")
    if result.returncode != 0:
        raise GateReject(f"cannot read Compose file {ref}:{path}")
    return result.stdout


def read_compose(path: str, content: str) -> tuple[dict[str, Any], dict[str, Any]]:
    try:
        data = yaml.safe_load(content) or {}
    except yaml.YAMLError as exc:
        raise GateReject(f"invalid Compose YAML: {path}: {exc}") from exc
    if not isinstance(data, dict):
        raise GateReject(f"invalid Compose mapping: {path}")
    services = data.get("services")
    if not isinstance(services, dict) or len(services) != 1:
        raise GateReject(f"Compose must contain exactly one service: {path}")
    return data, services


def digest_reference(image: object) -> tuple[str, str] | None:
    if not isinstance(image, str):
        return None
    match = re.fullmatch(r"([^@\s]+)@sha256:([0-9a-fA-F]{64})", image)
    if match is None:
        return None
    return match.group(1), match.group(2).lower()


def verify_compose_pair(
    old_path: str, old_raw: str, new_path: str, new_raw: str
) -> bool:
    old_data, old_services = read_compose(old_path, old_raw)
    new_data, new_services = read_compose(new_path, new_raw)
    old_service = next(iter(old_services.values()))
    new_service = next(iter(new_services.values()))
    if not isinstance(old_service, dict) or not isinstance(new_service, dict):
        raise GateReject(f"Compose service must be a mapping: {new_path}")
    old_image = old_service.get("image")
    new_image = new_service.get("image")
    if not isinstance(old_image, str) or not isinstance(new_image, str) or old_image == new_image:
        raise GateReject(f"Compose service image must change: {new_path}")

    old_normalized = copy.deepcopy(old_data)
    new_normalized = copy.deepcopy(new_data)
    old_normalized.pop("version", None)
    new_normalized.pop("version", None)
    for service in old_normalized["services"].values():
        if isinstance(service, dict):
            service.pop("image", None)
    for service in new_normalized["services"].values():
        if isinstance(service, dict):
            service.pop("image", None)
    if old_normalized != new_normalized:
        raise GateReject(f"Compose changed beyond its service image: {new_path}")

    old_digest = digest_reference(old_image)
    new_digest = digest_reference(new_image)
    return bool(
        old_digest is not None
        and new_digest is not None
        and old_digest[0] == new_digest[0]
        and old_digest[1] != new_digest[1]
    )


def app_names(files: list[dict[str, Any]]) -> set[str]:
    apps: set[str] = set()
    for item in files:
        for path in (item.get("filename"), item.get("previous_filename")):
            if not path:
                continue
            match = re.fullmatch(r"apps/([^/]+)/.+", path)
            if match is None:
                raise GateReject(f"changed file outside apps/: {path}")
            apps.add(match.group(1))
    if len(apps) != 1:
        raise GateReject(f"PR must affect exactly one app, got {', '.join(sorted(apps))}")
    return apps


def verify_added_version_package(
    base_sha: str, head_sha: str, app: str, files: list[dict[str, Any]]
) -> bool:
    target_dirs: set[str] = set()
    changed_paths: set[str] = set()
    for item in files:
        path = item.get("filename", "")
        parts = path.split("/")
        if (
            item.get("status") != "added"
            or item.get("previous_filename")
            or len(parts) < 4
            or parts[0] != "apps"
            or parts[1] != app
            or any(part in {"", ".", ".."} for part in parts)
        ):
            raise GateReject("new version packages must contain only added files under one app directory")
        target_dirs.add("/".join(parts[:3]))
        changed_paths.add(path)
    if len(target_dirs) != 1:
        raise GateReject("PR must add exactly one version directory")
    target_dir = next(iter(target_dirs))
    target_tree = tree_files(head_sha, target_dir)
    if not target_tree or {f"{target_dir}/{path}" for path in target_tree} != changed_paths:
        raise GateReject("added version directory must exactly match the PR file list")
    compose_path = f"{target_dir}/docker-compose.yml"
    if "docker-compose.yml" not in target_tree:
        raise GateReject("added version directory must include docker-compose.yml")

    base_app = tree_files(base_sha, f"apps/{app}")
    source_versions = sorted(
        path.split("/", 1)[0]
        for path in base_app
        if path.count("/") == 1 and path.endswith("/docker-compose.yml")
    )
    for source_version in source_versions:
        source_dir = f"apps/{app}/{source_version}"
        source_tree = tree_files(base_sha, source_dir)
        if set(source_tree) != set(target_tree):
            continue
        if any(source_tree[path][0] != target_tree[path][0] for path in source_tree):
            continue
        if any(
            source_tree[path][1] != target_tree[path][1]
            for path in source_tree
            if path != "docker-compose.yml"
        ):
            continue
        old_compose = git_show(base_sha, f"{source_dir}/docker-compose.yml")
        new_compose = git_show(head_sha, compose_path)
        verify_compose_pair(
            f"{source_dir}/docker-compose.yml", old_compose, compose_path, new_compose
        )
        print(
            f"verified added version package {target_dir} as an image-only copy of {source_dir}"
        )
        return False
    raise GateReject("added version directory does not exactly copy a base package except for image")


def verify_existing_compose_updates(
    base_sha: str, head_sha: str, app: str, files: list[dict[str, Any]]
) -> bool:
    compose_files: list[tuple[str, str]] = []
    for item in files:
        filename = item.get("filename", "")
        previous = item.get("previous_filename")
        if not filename.endswith("/docker-compose.yml") and not (
            previous and previous.endswith("/docker-compose.yml")
        ):
            raise GateReject(f"whitelisted PR contains a non-Compose file: {filename}")
        compose_files.append((previous or filename, filename))
    if not compose_files:
        raise GateReject("PR must change at least one docker-compose.yml")

    digest_only = True
    for old_path, new_path in compose_files:
        old_match = re.fullmatch(r"apps/([^/]+)/.+/docker-compose\.yml", old_path)
        new_match = re.fullmatch(r"apps/([^/]+)/.+/docker-compose\.yml", new_path)
        if not old_match or not new_match or old_match.group(1) != app or new_match.group(1) != app:
            raise GateReject(f"invalid Compose path for app {app}: {new_path}")
        old_raw = git_show(base_sha, old_path)
        new_raw = git_show(head_sha, new_path)
        if not verify_compose_pair(old_path, old_raw, new_path, new_raw):
            digest_only = False
        print(f"verified {new_path}: image-only update")
    return digest_only


def verify_shape(base_sha: str, head_sha: str, files: list[dict[str, Any]]) -> dict[str, Any]:
    if not files:
        raise GateReject("PR does not change files")
    apps = app_names(files)
    app = next(iter(apps))
    if all(item.get("status") == "added" for item in files):
        digest_only = verify_added_version_package(base_sha, head_sha, app, files)
        return {"app": app, "digest_only": digest_only, "kind": "added-version-package"}
    digest_only = verify_existing_compose_updates(base_sha, head_sha, app, files)
    return {"app": app, "digest_only": digest_only, "kind": "compose-update"}


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify a whitelist Renovate PR image-only shape.")
    parser.add_argument("--base-sha", required=True)
    parser.add_argument("--head-sha", required=True)
    parser.add_argument("--files-json", required=True, type=Path)
    parser.add_argument("--output-json", required=True, type=Path)
    args = parser.parse_args()
    if not all(re.fullmatch(r"[0-9a-fA-F]{40,64}", sha) for sha in (args.base_sha, args.head_sha)):
        raise ValueError("base and head must be full Git commit SHAs")
    files = json.loads(args.files_json.read_text(encoding="utf-8"))
    if not isinstance(files, list) or any(not isinstance(item, dict) for item in files):
        raise ValueError("PR file list must be a JSON array of objects")
    result = verify_shape(args.base_sha, args.head_sha, files)
    args.output_json.parent.mkdir(parents=True, exist_ok=True)
    args.output_json.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"single-app image-only update verified: {result['app']} ({result['kind']})")
    print(f"digest_only={'true' if result['digest_only'] else 'false'}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except GateReject as exc:
        print(str(exc), file=sys.stderr)
        raise SystemExit(42)
