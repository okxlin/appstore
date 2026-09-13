#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$SCRIPT_DIR/init.sh"

# MDCz 0.14.0 replays the migration that creates this index.  The 0.12.0
# database already contains the same uniquely-defined index, so remove only
# that redundant schema object before the image migration recreates it.
DATA_PATH="${APP_DATA_DIR:-$(sed -n 's/^APP_DATA_DIR=//p' "$SCRIPT_DIR/../.env" 2>/dev/null | tail -n 1)}"
DATA_PATH="${DATA_PATH%\"}"
DATA_PATH="${DATA_PATH#\"}"
DATA_PATH="${DATA_PATH%\'}"
DATA_PATH="${DATA_PATH#\'}"
DATA_PATH="${DATA_PATH:-./data}"
if [[ "$DATA_PATH" != /* ]]; then
  DATA_PATH="$SCRIPT_DIR/../${DATA_PATH#./}"
fi
DB_PATH="$DATA_PATH/data/mdcz.sqlite"
if [[ -f "$DB_PATH" ]] && command -v sqlite3 >/dev/null 2>&1; then
  sqlite3 "$DB_PATH" 'DROP INDEX IF EXISTS "scan_results_task_root_path_idx";'
fi
