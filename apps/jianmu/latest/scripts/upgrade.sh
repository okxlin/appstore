#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

escape_sql_string() {
  local value="${1:-}"
  printf "%s" "${value//\'/\'\'}"
}

infer_db_type_from_host() {
  local host_value="${1:-}"
  local agent_db="/opt/1panel/db/agent.db"

  if [[ -n "$host_value" && -f "$agent_db" ]] && command -v sqlite3 >/dev/null 2>&1; then
    local host_sql
    local detected
    host_sql="$(escape_sql_string "$host_value")"
    detected="$(
      sqlite3 "$agent_db" "
SELECT apps.key
FROM app_installs
JOIN apps ON apps.id = app_installs.app_id
WHERE apps.key IN ('mysql', 'localmysql', 'mariadb')
  AND (
    app_installs.name = '${host_sql}'
    OR app_installs.service_name = '${host_sql}'
    OR app_installs.container_name = '${host_sql}'
  )
ORDER BY app_installs.id DESC
LIMIT 1;
"
    )"
    if [[ -n "$detected" ]]; then
      printf '%s\n' "$detected"
      return
    fi
  fi

  case "$host_value" in
    *localmysql*)
      printf 'localmysql\n'
      ;;
    *mariadb*)
      printf 'mariadb\n'
      ;;
    *)
      printf 'mysql\n'
      ;;
  esac
}

migrate_db_type() {
  if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE not found; skipped PANEL_DB_TYPE migration"
    return
  fi

  if grep -qE '^PANEL_DB_TYPE=' "$ENV_FILE"; then
    echo "PANEL_DB_TYPE already exists"
    return
  fi

  local current_host
  local detected_type
  current_host="$(sed -n -E 's/^PANEL_DB_HOST=//p' "$ENV_FILE" | tail -n 1)"
  detected_type="$(infer_db_type_from_host "$current_host")"
  printf 'PANEL_DB_TYPE=%s\n' "$detected_type" >> "$ENV_FILE"
  echo "Added PANEL_DB_TYPE=$detected_type"
}

migrate_db_port() {
  if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE not found; skipped PANEL_DB_PORT migration"
    return
  fi

  if grep -qE '^PANEL_DB_PORT=' "$ENV_FILE"; then
    echo "PANEL_DB_PORT already exists"
    return
  fi

  if grep -qE '^DB_PORT=' "$ENV_FILE"; then
    local current
    current="$(sed -n -E 's/^DB_PORT=//p' "$ENV_FILE" | tail -n 1)"
    printf 'PANEL_DB_PORT=%s\n' "$current" >> "$ENV_FILE"
    echo "Added PANEL_DB_PORT from legacy DB_PORT"
    return
  fi

  printf 'PANEL_DB_PORT=3306\n' >> "$ENV_FILE"
  echo "Added default PANEL_DB_PORT"
}

migrate_db_type
migrate_db_port

echo "Jianmu is currently pinned to the verified official image line ui/server v2.8.2 and worker v1.0.13."
echo "Automatic in-place app upgrades are intentionally disabled for this package."
echo "Back up APP_DATA_DIR, the MySQL-compatible database, and the configured Jianmu secrets before changing packaged versions or rotating credentials."
exit 0
