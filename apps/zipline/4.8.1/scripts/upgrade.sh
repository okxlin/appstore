#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
source "${ROOT_DIR}/scripts/credentials.sh"

zipline_restore_upgrade_credentials "$ROOT_DIR" "$ENV_FILE"

command -v docker >/dev/null 2>&1 || zipline_fail "Docker is required to verify the Zipline migration before upgrading"
command -v timeout >/dev/null 2>&1 || zipline_fail "timeout is required to verify the Zipline migration before upgrading"

compose=(docker compose --project-directory "$ROOT_DIR" -f "$ROOT_DIR/docker-compose.yml")
"${compose[@]}" up -d zipline-postgres

postgres_db="$(zipline_read_env_value "$ENV_FILE" POSTGRES_DB)" ||
  zipline_fail "POSTGRES_DB is missing from Zipline .env"
postgres_user="$(zipline_read_env_value "$ENV_FILE" POSTGRES_USER)" ||
  zipline_fail "POSTGRES_USER is missing from Zipline .env"

ready=false
for attempt in {1..60}; do
  if "${compose[@]}" exec -T zipline-postgres pg_isready -q -U "$postgres_user" -d "$postgres_db"; then
    ready=true
    break
  fi
  sleep 2
done
[[ "$ready" == true ]] || zipline_fail "Zipline PostgreSQL did not become ready for the staged upgrade"

drizzle_table_exists="$(timeout 15 "${compose[@]}" exec -T zipline-postgres \
  sh -ec 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Atq -c "$1"' sh \
  "SELECT to_regclass('drizzle.__drizzle_migrations') IS NOT NULL")" ||
  zipline_fail "Zipline migration history could not be verified; keep the existing version and repair the database before upgrading"

migration_state="prisma"
if [[ "$drizzle_table_exists" == t ]]; then
  drizzle_history="$(timeout 15 "${compose[@]}" exec -T zipline-postgres \
    sh -ec 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Atq -c "$1"' sh \
    "SELECT EXISTS (SELECT 1 FROM drizzle.__drizzle_migrations)")" ||
    zipline_fail "Zipline Drizzle migration history could not be verified; keep the existing version and repair the database before upgrading"
  if [[ "$drizzle_history" == t ]]; then
    migration_state="drizzle"
  fi
fi

if [[ "$migration_state" != drizzle ]]; then
  prisma_migration_state="$(timeout 15 "${compose[@]}" exec -T zipline-postgres sh -ec 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Atq -c "SELECT CASE WHEN count(*) = 1 AND bool_and(finished_at IS NOT NULL AND rolled_back_at IS NULL AND applied_steps_count >= 1) THEN '\''ok'\'' ELSE '\''bad'\'' END FROM public._prisma_migrations WHERE migration_name = '\''20260806081144_remove_version_api'\'' AND checksum = '\''08368d44344f934f07757dc014bd3a2022b14a8b377e1f8f5fb2d4836c3dc1ce'\'';"')" ||
    zipline_fail "Zipline 4.7 migration history could not be verified; keep the existing version and repair the database before upgrading"
  [[ "$prisma_migration_state" == ok ]] ||
    zipline_fail "Zipline 4.7 migration is missing or incomplete; keep the existing version and allow its migration to finish before upgrading"
  migration_state="prisma"
fi

if [[ "$migration_state" == drizzle ]]; then
  printf '%s\n' "Zipline Drizzle migration history verified; proceeding with the 4.8 upgrade."
else
  printf '%s\n' "Zipline 4.7 migration verified; proceeding with the 4.8 upgrade."
fi
