#!/usr/bin/env bash
set -euo pipefail

APP_ROOT="/var/www"
SCRIPT_ROOT="/opt/dootask-scripts"
EXPECTED_RELEASE="1.8.64"
SOURCE_URL="https://github.com/kuaifan/dootask/archive/refs/tags/v1.8.64.tar.gz"
SOURCE_SHA256="934b422f0917c8fd55b8a65fcdb476c9158d72a20c1d0a6fe62cd88c0fa0b13b"
VENDOR_URL="https://github.com/kuaifan/dootask/releases/download/v1.8.64/vendor.tar.gz"
VENDOR_SHA256="136430ac28ee38820c37167c0eae4c29e8b64d287ea0224a2c4320ff0873596d"
MARKER_FILE="${APP_ROOT}/.1panel-release-version"

log() {
  echo "[dootask-entrypoint] $*"
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[&|]/\\&/g'
}

set_env_value() {
  local key="$1"
  local value="$2"
  local file="${APP_ROOT}/.env"
  local escaped
  escaped="$(escape_sed_replacement "$value")"
  if grep -qE "^${key}=" "$file"; then
    sed -i "s|^${key}=.*|${key}=${escaped}|" "$file"
  else
    printf '%s=%s\n' "$key" "$value" >>"$file"
  fi
}

get_env_value() {
  local key="$1"
  local file="${APP_ROOT}/.env"
  local line
  line="$(grep -E "^${key}=" "$file" 2>/dev/null | tail -n 1 || true)"
  if [[ -z "$line" ]]; then
    return 1
  fi
  printf '%s' "${line#*=}"
}

download_with_sha() {
  local url="$1"
  local target="$2"
  local sha="$3"
  curl -fsSL "$url" -o "$target"
  echo "${sha}  ${target}" | sha256sum -c -
}

bootstrap_source() {
  mkdir -p "${APP_ROOT}" "${APP_ROOT}/storage" "${APP_ROOT}/bootstrap/cache" "${APP_ROOT}/public/uploads"

  if [[ -f "${MARKER_FILE}" ]]; then
    local current_release
    current_release="$(cat "${MARKER_FILE}")"
    if [[ "${current_release}" != "${EXPECTED_RELEASE}" ]]; then
      log "detected existing source release ${current_release}, expected ${EXPECTED_RELEASE}; refusing automatic in-place source replacement"
      exit 1
    fi
  fi

  if [[ ! -f "${APP_ROOT}/artisan" ]]; then
    log "bootstrapping upstream source ${EXPECTED_RELEASE}"
    local tmpdir archive srcdir
    tmpdir="$(mktemp -d)"
    archive="${tmpdir}/dootask-source.tar.gz"
    download_with_sha "${SOURCE_URL}" "${archive}" "${SOURCE_SHA256}"
    tar -xzf "${archive}" -C "${tmpdir}"
    srcdir="$(find "${tmpdir}" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
    cp -a "${srcdir}/." "${APP_ROOT}/"
    echo "${EXPECTED_RELEASE}" >"${MARKER_FILE}"
    rm -rf "${tmpdir}"
  fi

  if [[ ! -f "${APP_ROOT}/vendor/autoload.php" ]]; then
    log "restoring vendor bundle for ${EXPECTED_RELEASE}"
    local tmpdir archive
    tmpdir="$(mktemp -d)"
    archive="${tmpdir}/vendor.tar.gz"
    download_with_sha "${VENDOR_URL}" "${archive}" "${VENDOR_SHA256}"
    rm -rf "${APP_ROOT}/vendor"
    tar -xzf "${archive}" -C "${APP_ROOT}"
    rm -rf "${tmpdir}"
  fi

  mkdir -p "${APP_ROOT}/docker/crontab" "${APP_ROOT}/docker/nginx/site" "${APP_ROOT}/docker/nginx/conf.d"
  cp -f "${SCRIPT_ROOT}/dootask-crontab.sh" "${APP_ROOT}/docker/crontab/crontab.sh"
  chmod +x "${APP_ROOT}/docker/crontab/crontab.sh"
}

apply_source_compat_patches() {
  php "${SCRIPT_ROOT}/dootask-source-patch.php"
}

ensure_env_file() {
  if [[ ! -f "${APP_ROOT}/.env" ]]; then
    cp "${APP_ROOT}/.env.docker" "${APP_ROOT}/.env"
  fi

  local current_app_url derived_app_url
  current_app_url="$(get_env_value APP_URL || true)"
  derived_app_url="http://127.0.0.1:${PANEL_APP_PORT_HTTP}"

  set_env_value "APP_NAME" "DooTask"
  set_env_value "APP_ENV" "production"
  set_env_value "APP_DEBUG" "false"
  set_env_value "APP_SCHEME" "auto"
  set_env_value "TIMEZONE" "${TIMEZONE}"
  if [[ -z "${current_app_url}" || "${current_app_url}" == "http://localhost" || "${current_app_url}" == http://127.0.0.1* ]]; then
    set_env_value "APP_URL" "${derived_app_url}"
  fi
  set_env_value "APP_PORT" "${PANEL_APP_PORT_HTTP}"
  set_env_value "APP_ID" "${CONTAINER_NAME:-dootask}"
  set_env_value "APP_IPPR" ""
  set_env_value "APP_DEV_PORT" ""
  set_env_value "DB_CONNECTION" "mysql"
  set_env_value "DB_HOST" "${PANEL_DB_HOST}"
  set_env_value "DB_PORT" "${DB_PORT}"
  set_env_value "DB_DATABASE" "${PANEL_DB_NAME}"
  set_env_value "DB_USERNAME" "${PANEL_DB_USER}"
  set_env_value "DB_PASSWORD" "${PANEL_DB_USER_PASSWORD}"
  set_env_value "DB_PREFIX" "${DB_PREFIX}"
  set_env_value "CACHE_DRIVER" "redis"
  set_env_value "QUEUE_CONNECTION" "redis"
  set_env_value "SESSION_DRIVER" "redis"
  set_env_value "REDIS_HOST" "${REDIS_HOST}"
  set_env_value "REDIS_PORT" "${REDIS_PORT}"
  if [[ -z "${PANEL_REDIS_ROOT_PASSWORD}" || "${PANEL_REDIS_ROOT_PASSWORD}" == "null" ]]; then
    set_env_value "REDIS_PASSWORD" "null"
  else
    set_env_value "REDIS_PASSWORD" "${PANEL_REDIS_ROOT_PASSWORD}"
  fi
  set_env_value "REDIS_DB" "${REDIS_DB}"
  set_env_value "REDIS_CACHE_DB" "1"
  set_env_value "LARAVELS_LISTEN_IP" "0.0.0.0"
  set_env_value "LARAVELS_LISTEN_PORT" "20000"
}

ensure_app_key() {
  local app_key
  app_key="$(get_env_value APP_KEY || true)"
  if [[ -n "${app_key}" ]]; then
    return 0
  fi
  app_key="$(php artisan key:generate --show --no-interaction)"
  set_env_value "APP_KEY" "${app_key}"
}

ensure_vendor_fallback() {
  if [[ -f "${APP_ROOT}/vendor/autoload.php" ]]; then
    return 0
  fi
  log "vendor bundle missing after restore, running composer install fallback"
  COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader
}

wait_for_mysql() {
  log "waiting for MySQL ${PANEL_DB_HOST}:${DB_PORT}"
  for _ in $(seq 1 90); do
    if php -r '
      try {
        $pdo = new PDO(
          "mysql:host=" . getenv("PANEL_DB_HOST") . ";port=" . getenv("DB_PORT") . ";dbname=" . getenv("PANEL_DB_NAME") . ";charset=utf8mb4",
          getenv("PANEL_DB_USER"),
          getenv("PANEL_DB_USER_PASSWORD"),
          [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );
        exit(0);
      } catch (Throwable $e) {
        fwrite(STDERR, $e->getMessage());
        exit(1);
      }
    ' >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done
  log "MySQL did not become ready in time"
  return 1
}

wait_for_redis() {
  log "waiting for Redis ${REDIS_HOST}:${REDIS_PORT}"
  for _ in $(seq 1 90); do
    if php -r '
      try {
        $redis = new Redis();
        $redis->connect(getenv("REDIS_HOST"), (int) getenv("REDIS_PORT"), 2.5);
        $password = getenv("PANEL_REDIS_ROOT_PASSWORD");
        if ($password !== false && $password !== "" && strtolower($password) !== "null") {
          $redis->auth($password);
        }
        $redis->select((int) getenv("REDIS_DB"));
        if ($redis->ping() === false) {
          exit(1);
        }
        exit(0);
      } catch (Throwable $e) {
        fwrite(STDERR, $e->getMessage());
        exit(1);
      }
    ' >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done
  log "Redis did not become ready in time"
  return 1
}

run_app_setup() {
  php artisan config:clear >/dev/null 2>&1 || true
  php artisan cache:clear >/dev/null 2>&1 || true
  php artisan migrate --force
  php "${SCRIPT_ROOT}/dootask-bootstrap.php"
}

main() {
  cd "${APP_ROOT}"
  bootstrap_source
  apply_source_compat_patches
  ensure_env_file
  ensure_vendor_fallback
  ensure_app_key
  wait_for_mysql
  wait_for_redis
  run_app_setup
  exec /usr/bin/supervisord -n
}

main "$@"
