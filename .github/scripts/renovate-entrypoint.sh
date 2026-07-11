#!/usr/bin/env bash

set -euo pipefail

log_file="$(mktemp -t renovate-output.XXXXXX)"
trap 'rm -f "$log_file"' EXIT

set +e
renovate "$@" 2>&1 | tee "$log_file"
renovate_status=${PIPESTATUS[0]}
set -e

if grep -Eiq 'External host error causing abort|"result"[[:space:]]*:[[:space:]]*"external-host-error"' "$log_file"; then
  echo "Renovate aborted because an external host failed; dependency processing is incomplete." >&2
  exit 1
fi

exit "$renovate_status"
