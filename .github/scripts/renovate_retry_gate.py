#!/usr/bin/env python3
import argparse
import json
import re
from datetime import datetime, timedelta, timezone
from pathlib import Path


MIN_RETRY_AGE = timedelta(minutes=55)
MAX_DAILY_ATTEMPTS = 6
DOCKER_HUB_429 = re.compile(
    r"(?:status\s+code\s+429|"
    r"\b429\b.{0,80}(?:too many requests|rate.?limit)|"
    r"(?:too many requests|rate.?limit).{0,80}\b429\b)",
    re.IGNORECASE | re.DOTALL,
)
DOCKER_HUB_MARKER = re.compile(
    r"docker\s*hub|(?:index|registry-1)\.docker\.io|\bdocker\.io\b",
    re.IGNORECASE,
)


def parse_timestamp(value: str) -> datetime:
    parsed = datetime.fromisoformat(value.replace("Z", "+00:00"))
    if parsed.tzinfo is None:
        parsed = parsed.replace(tzinfo=timezone.utc)
    return parsed.astimezone(timezone.utc)


def evaluate_retry(runs: list[dict], log_text: str, now: datetime) -> dict:
    if not runs:
        return {"decision": "skip", "reason": "no Renovate runs found"}

    latest = max(runs, key=lambda run: parse_timestamp(run["createdAt"]))
    if latest.get("status") != "completed":
        return {"decision": "skip", "reason": "latest Renovate run is not complete"}
    if latest.get("conclusion") != "failure":
        return {"decision": "skip", "reason": "latest Renovate run did not fail"}
    if not (DOCKER_HUB_429.search(log_text) and DOCKER_HUB_MARKER.search(log_text)):
        return {"decision": "skip", "reason": "latest failure is not a confirmed Docker Hub 429"}

    completed_at = parse_timestamp(latest.get("updatedAt") or latest["createdAt"])
    now = now.astimezone(timezone.utc)
    if now - completed_at < MIN_RETRY_AGE:
        return {"decision": "wait", "reason": "429 cooldown has not reached 55 minutes"}

    attempts_today = sum(
        1
        for run in runs
        if parse_timestamp(run["createdAt"]).date() == now.date()
    )
    if attempts_today >= MAX_DAILY_ATTEMPTS:
        return {"decision": "limit", "reason": "daily full-scan attempt limit reached"}

    return {
        "decision": "retry",
        "reason": "latest full scan failed with a mature Docker Hub 429",
        "run_id": latest.get("databaseId"),
        "attempts_today": attempts_today,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--runs", required=True, type=Path)
    parser.add_argument("--logs", required=True, type=Path)
    parser.add_argument("--now")
    args = parser.parse_args()

    runs = json.loads(args.runs.read_text(encoding="utf-8"))
    log_text = args.logs.read_text(encoding="utf-8", errors="replace")
    now = parse_timestamp(args.now) if args.now else datetime.now(timezone.utc)
    print(json.dumps(evaluate_retry(runs, log_text, now), ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
