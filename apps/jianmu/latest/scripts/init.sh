#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/../.env"
if [[ -f "${ENV_FILE}" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "${ENV_FILE}"
  set +a
fi

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p "${DATA_DIR}/server-data"

escape_sql_string() {
  local value="${1:-}"
  printf "%s" "${value//\'/\'\'}"
}

escape_sql_identifier() {
  local value="${1:-}"
  printf "%s" "${value//\`/\`\`}"
}

resolve_managed_mysql() {
  local host_value="${1:-}"
  local agent_db="/opt/1panel/db/agent.db"
  if [[ -z "$host_value" ]] || [[ ! -f "$agent_db" ]] || ! command -v sqlite3 >/dev/null 2>&1; then
    return 1
  fi

  local host_sql
  host_sql="$(escape_sql_string "$host_value")"
  sqlite3 -tabs "$agent_db" "
SELECT apps.key,
       app_installs.container_name,
       app_installs.service_name,
       COALESCE(json_extract(app_installs.env, '$.PANEL_DB_ROOT_PASSWORD'), '')
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
}

wait_mysql_ready() {
  local container_name="${1:-}"
  local client_bin="${2:-mysql}"
  local root_password="${3:-}"
  local attempt

  for attempt in $(seq 1 30); do
    if docker exec "$container_name" "$client_bin" -uroot "-p${root_password}" -e "SELECT 1;" >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done

  return 1
}

bootstrap_managed_mysql() {
  local db_key="${1:-}"
  local container_name="${2:-}"
  local service_name="${3:-}"
  local root_password="${4:-}"
  local client_bin="mysql"

  if [[ -z "$container_name" ]] || [[ -z "$root_password" ]]; then
    return 1
  fi
  if [[ "$db_key" == "mariadb" ]]; then
    client_bin="mariadb"
  fi
  if ! command -v docker >/dev/null 2>&1; then
    echo "docker CLI not found; skipped managed MySQL bootstrap"
    return 1
  fi
  if ! wait_mysql_ready "$container_name" "$client_bin" "$root_password"; then
    echo "managed MySQL container [$container_name] was not ready before timeout"
    return 1
  fi

  local db_name_sql
  local db_user_sql
  local db_password_sql
  db_name_sql="$(escape_sql_identifier "${PANEL_DB_NAME:-jianmu}")"
  db_user_sql="$(escape_sql_string "${PANEL_DB_USER:-jianmu}")"
  db_password_sql="$(escape_sql_string "${PANEL_DB_USER_PASSWORD:-}")"

  echo "bootstrapping Jianmu database on managed MySQL app [$service_name]"
  docker exec -i "$container_name" "$client_bin" -uroot "-p${root_password}" <<SQL
CREATE DATABASE IF NOT EXISTS \`${db_name_sql}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${db_user_sql}'@'%' IDENTIFIED BY '${db_password_sql}';
ALTER USER '${db_user_sql}'@'%' IDENTIFIED BY '${db_password_sql}';
GRANT ALL PRIVILEGES ON \`${db_name_sql}\`.* TO '${db_user_sql}'@'%';
FLUSH PRIVILEGES;
SQL
}

if managed_mysql_row="$(resolve_managed_mysql "${PANEL_DB_HOST:-}")"; then
  IFS=$'\t' read -r managed_db_key managed_container_name managed_service_name managed_root_password <<<"${managed_mysql_row}"
  if [[ -n "${managed_container_name:-}" ]] && [[ -n "${managed_root_password:-}" ]]; then
    bootstrap_managed_mysql \
      "${managed_db_key:-}" \
      "${managed_container_name:-}" \
      "${managed_service_name:-${PANEL_DB_HOST:-}}" \
      "${managed_root_password:-}"
  fi
fi
