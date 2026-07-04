#!/usr/bin/env python3
import argparse
import json
from copy import deepcopy
from pathlib import Path

import yaml

SPECIAL_KEYS = ("privileged", "network_mode", "runtime", "pid", "ipc", "devices", "cap_add")


def load_apps(args: argparse.Namespace) -> list[str]:
    apps = list(args.app or [])
    if args.apps_file:
        for line in Path(args.apps_file).read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            apps.append(line)
    unique: list[str] = []
    seen: set[str] = set()
    for app in apps:
        if app not in seen:
            unique.append(app)
            seen.add(app)
    return unique


def load_yaml(path: Path) -> dict:
    data = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    return data if isinstance(data, dict) else {}


def normalize_compose(data: dict) -> dict:
    normalized = deepcopy(data)
    normalized.pop("version", None)
    services = normalized.get("services")
    if isinstance(services, dict):
        for service in services.values():
            if isinstance(service, dict):
                service.pop("image", None)
    return normalized


def summarize_upgrade(path: Path) -> bool:
    body_lines = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#!") or line.startswith("#") or line.startswith("set "):
            continue
        body_lines.append(line)
    body = "\n".join(body_lines).strip()
    return bool(body and body != "exit 0")


def collect_special_flags(compose_path: Path, data: dict) -> list[str]:
    findings: list[str] = []
    services = data.get("services")
    if not isinstance(services, dict):
        return findings
    for service_name, service in services.items():
        if not isinstance(service, dict):
            continue
        for key in SPECIAL_KEYS:
            if key in service:
                findings.append(f"{compose_path.parent.name}:{service_name}:{key}={service[key]}")
    return findings


def audit_app(repo_root: Path, app: str) -> dict:
    app_dir = repo_root / "apps" / app
    result = {
        "app": app,
        "exists": app_dir.exists(),
        "compose_files": [],
        "compose_shape_stable": None,
        "max_services": 0,
        "single_service_preferred": None,
        "special_flags": [],
        "nontrivial_upgrade": False,
        "upgrade_scripts": [],
        "eligible_by_heuristic": False,
        "notes": [],
    }
    if not app_dir.exists():
        result["notes"].append("app directory missing")
        return result

    compose_paths = sorted(app_dir.glob("*/docker-compose.yml"))
    result["compose_files"] = [str(path.relative_to(repo_root)) for path in compose_paths]
    if not compose_paths:
        result["notes"].append("no docker-compose.yml found")
        return result

    normalized_shapes = []
    for compose_path in compose_paths:
        data = load_yaml(compose_path)
        services = data.get("services")
        count = len(services) if isinstance(services, dict) else 0
        result["max_services"] = max(result["max_services"], count)
        result["special_flags"].extend(collect_special_flags(compose_path, data))
        normalized_shapes.append(normalize_compose(data))

    result["single_service_preferred"] = result["max_services"] == 1
    result["compose_shape_stable"] = all(shape == normalized_shapes[0] for shape in normalized_shapes[1:])

    for upgrade_path in sorted(app_dir.glob("*/scripts/upgrade.sh")):
        if summarize_upgrade(upgrade_path):
            result["nontrivial_upgrade"] = True
            result["upgrade_scripts"].append(str(upgrade_path.relative_to(repo_root)))

    if result["max_services"] != 1:
        result["notes"].append("multi-service app")
    if result["compose_shape_stable"] is False:
        result["notes"].append("compose shape changed across store snapshots")
    if result["special_flags"]:
        result["notes"].append("special runtime/network privileges present")
    if result["nontrivial_upgrade"]:
        result["notes"].append("non-trivial upgrade migration present")

    result["eligible_by_heuristic"] = (
        result["max_services"] == 1
        and result["compose_shape_stable"] is True
        and not result["special_flags"]
        and not result["nontrivial_upgrade"]
    )
    if result["eligible_by_heuristic"]:
        result["notes"].append("single-service stable candidate")
    return result


def print_table(results: list[dict], only_problems: bool) -> None:
    print(
        "app\teligible\tcompose_stable\tmax_services\tspecial_flags\tnontrivial_upgrade\tnotes"
    )
    for item in results:
        if only_problems and item["eligible_by_heuristic"]:
            continue
        notes = "; ".join(item["notes"]) if item["notes"] else "-"
        print(
            "\t".join(
                [
                    item["app"],
                    str(item["eligible_by_heuristic"]).lower(),
                    str(item["compose_shape_stable"]).lower(),
                    str(item["max_services"]),
                    str(bool(item["special_flags"])).lower(),
                    str(item["nontrivial_upgrade"]).lower(),
                    notes,
                ]
            )
        )


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Audit appstore Renovate automerge whitelist candidates."
    )
    parser.add_argument(
        "--repo-root",
        default=".",
        help="Path to the appstore repository root (default: current directory).",
    )
    parser.add_argument(
        "--apps-file",
        help="Read app names from a whitelist file, ignoring blank lines and comments.",
    )
    parser.add_argument(
        "--app",
        action="append",
        help="Audit a specific app key. Can be passed multiple times.",
    )
    parser.add_argument(
        "--format",
        choices=("table", "json"),
        default="table",
        help="Output format.",
    )
    parser.add_argument(
        "--only-problems",
        action="store_true",
        help="In table output, hide apps that already pass the heuristic.",
    )
    args = parser.parse_args()

    apps = load_apps(args)
    if not apps:
        parser.error("provide --app or --apps-file")

    repo_root = Path(args.repo_root).resolve()
    results = [audit_app(repo_root, app) for app in apps]

    if args.format == "json":
        print(json.dumps(results, ensure_ascii=False, indent=2))
    else:
        print_table(results, args.only_problems)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
