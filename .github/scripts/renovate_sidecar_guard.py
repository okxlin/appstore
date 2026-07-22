#!/usr/bin/env python3
import argparse
import json
import re
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path

import yaml


@dataclass
class ComposeDecision:
    app: str
    path: str
    services_total: int
    changed_services: list[str]
    primary_services: list[str]
    outcome: str
    detail: str


def run(cmd: list[str], *, check: bool = True) -> subprocess.CompletedProcess[str]:
    proc = subprocess.run(
        cmd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if check and proc.returncode != 0:
        raise RuntimeError(f"command failed: {' '.join(cmd)}\n{proc.stderr}")
    return proc


def gh_json(args: list[str]) -> object:
    proc = run(["gh", "api", *args])
    return json.loads(proc.stdout)


def fetch_refs(base_sha: str, head_sha: str) -> None:
    last_error = ""
    for _ in range(5):
        proc = run(
            ["git", "fetch", "--no-tags", "--depth=1", "origin", base_sha, head_sha],
            check=False,
        )
        if proc.returncode == 0:
            return
        last_error = proc.stderr
        if "shallow file has changed since we read it" not in proc.stderr and "shallow.lock" not in proc.stderr:
            break
        time.sleep(1)
    raise RuntimeError(
        f"command failed: git fetch --no-tags --depth=1 origin {base_sha} {head_sha}\n{last_error}"
    )


def git_show(ref: str, path: str) -> str | None:
    proc = run(["git", "show", f"{ref}:{path}"], check=False)
    if proc.returncode != 0:
        return None
    return proc.stdout


def load_compose(ref: str, candidates: list[str]) -> tuple[str | None, dict]:
    for path in candidates:
        if not path:
            continue
        raw = git_show(ref, path)
        if raw is None:
            continue
        data = yaml.safe_load(raw) or {}
        if not isinstance(data, dict):
            return path, {}
        return path, data
    return None, {}


def extract_app(path: str) -> str | None:
    match = re.match(r"^apps/([^/]+)/", path)
    return match.group(1) if match else None


def resolve_primary_services(
    app: str,
    configured: list[str],
    base_data: dict,
    head_data: dict,
) -> list[str]:
    if configured:
        return configured

    base_services = base_data.get("services")
    head_services = head_data.get("services")
    if not isinstance(base_services, dict) or not isinstance(head_services, dict):
        return []
    if max(len(base_services), len(head_services)) <= 1:
        return []
    if app in base_services and app in head_services:
        return [app]
    return []


def compare_compose(
    app: str,
    path: str,
    base_data: dict,
    head_data: dict,
    primary_services: list[str],
) -> ComposeDecision:
    base_services = base_data.get("services")
    head_services = head_data.get("services")
    if not isinstance(base_services, dict) or not isinstance(head_services, dict):
        return ComposeDecision(app, path, 0, [], primary_services, "skip", "compose services missing")

    service_count = max(len(base_services), len(head_services))
    if service_count <= 1:
        return ComposeDecision(app, path, service_count, [], primary_services, "allow", "single-service compose")

    changed_services = []
    all_service_names = sorted(set(base_services) | set(head_services))
    for name in all_service_names:
        old = base_services.get(name) if isinstance(base_services.get(name), dict) else {}
        new = head_services.get(name) if isinstance(head_services.get(name), dict) else {}
        old_image = old.get("image")
        new_image = new.get("image")
        if old_image != new_image:
            changed_services.append(name)

    if not changed_services:
        return ComposeDecision(app, path, service_count, [], primary_services, "skip", "no image changes detected")

    if not primary_services:
        return ComposeDecision(
            app,
            path,
            service_count,
            changed_services,
            primary_services,
            "unknown",
            "no primary service mapping",
        )

    if any(name in primary_services for name in changed_services):
        return ComposeDecision(
            app,
            path,
            service_count,
            changed_services,
            primary_services,
            "allow",
            "primary service image changed",
        )

    return ComposeDecision(
        app,
        path,
        service_count,
        changed_services,
        primary_services,
        "close",
        "multi-service compose changed only auxiliary services",
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", required=True)
    parser.add_argument("--pr", required=True, type=int)
    parser.add_argument("--policy-file", required=True)
    args = parser.parse_args()

    policy = json.loads(Path(args.policy_file).read_text(encoding="utf-8"))
    pr = gh_json([f"repos/{args.repo}/pulls/{args.pr}"])
    files = gh_json([f"repos/{args.repo}/pulls/{args.pr}/files", "--paginate"])

    base_sha = pr["base"]["sha"]
    head_sha = pr["head"]["sha"]
    fetch_refs(base_sha, head_sha)

    decisions: list[ComposeDecision] = []
    seen_compose = False

    for file_info in files:
        filename = file_info["filename"]
        previous = file_info.get("previous_filename")
        if not (filename.endswith("/docker-compose.yml") or (previous and previous.endswith("/docker-compose.yml"))):
            continue
        seen_compose = True
        app = extract_app(filename) or extract_app(previous or "")
        if not app:
            decisions.append(
                ComposeDecision("unknown", filename, 0, [], [], "unknown", "file outside apps/")
            )
            continue

        resolved_base_path, base_data = load_compose(base_sha, [previous or filename, filename])
        resolved_head_path, head_data = load_compose(head_sha, [filename, previous or filename])
        if not resolved_base_path or not resolved_head_path:
            decisions.append(
                ComposeDecision(app, filename, 0, [], policy.get(app, []), "unknown", "unable to load compose from git")
            )
            continue

        primary_services = resolve_primary_services(
            app,
            policy.get(app, []),
            base_data,
            head_data,
        )
        decisions.append(
            compare_compose(
                app=app,
                path=resolved_head_path,
                base_data=base_data,
                head_data=head_data,
                primary_services=primary_services,
            )
        )

    if not seen_compose:
        result = {
            "decision": "allow",
            "reason": "no compose files changed",
            "details": [],
        }
    else:
        closable = [d for d in decisions if d.outcome == "close"]
        blocking_unknown = [d for d in decisions if d.outcome == "unknown"]
        primary_changed = [d for d in decisions if d.outcome == "allow"]
        if closable and not blocking_unknown and not primary_changed:
            summary = "; ".join(
                f"{d.app}:{','.join(d.changed_services)}" for d in closable
            )
            result = {
                "decision": "close",
                "reason": f"sidecar-only Renovate update detected ({summary})",
                "details": [d.__dict__ for d in decisions],
            }
        else:
            result = {
                "decision": "allow",
                "reason": "keep PR open",
                "details": [d.__dict__ for d in decisions],
            }

    json.dump(result, sys.stdout, ensure_ascii=False, indent=2)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
