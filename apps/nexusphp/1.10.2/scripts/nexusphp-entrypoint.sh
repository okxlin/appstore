#!/usr/bin/env bash
set -euo pipefail

ROOT_PATH="/nexusphp"
MYSQL_DATA_DIR="/var/lib/mysql"
REDIS_DATA_DIR="/var/lib/redis"
LOG_DIR="/tmp/nexus"
BACKUP_DIR="/tmp/nexusphp_backup"
FPM_LOG="/var/log/fpm-php.www.log"
RELEASE_VERSION="${APP_RELEASE_VERSION:-v1.10.2}"
DOMAIN_NAME="${DOMAIN:-127.0.0.1}"
BOOTSTRAP_MARKER="${ROOT_PATH}/.appstore-release"

run_service() {
  echo "Running service: $1"
  /etc/init.d/"$1" start
}

prepare_runtime_dirs() {
  mkdir -p "$ROOT_PATH" "$MYSQL_DATA_DIR" "$REDIS_DATA_DIR" "$LOG_DIR" "$BACKUP_DIR"
  touch "$FPM_LOG"
  chown -R mysql:mysql "$MYSQL_DATA_DIR"
  chown -R redis:redis "$REDIS_DATA_DIR"
  chown -R www-data:www-data "$ROOT_PATH" "$LOG_DIR" "$BACKUP_DIR" "$FPM_LOG"
}

bootstrap_code_if_needed() {
  if [[ -f "$BOOTSTRAP_MARKER" ]]; then
    current_release="$(cat "$BOOTSTRAP_MARKER" 2>/dev/null || true)"
    if [[ -n "$current_release" && "$current_release" != "$RELEASE_VERSION" ]]; then
      echo "Refusing automatic in-place upgrade from ${current_release} to ${RELEASE_VERSION}."
      echo "Back up APP_DATA_DIR and perform an explicit reviewed upgrade before changing APP_RELEASE_VERSION."
      exit 1
    fi
  fi

  if [[ -f "$BOOTSTRAP_MARKER" && -d "${ROOT_PATH}/vendor" && -f "${ROOT_PATH}/artisan" ]]; then
    return
  fi

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN
  archive="${tmpdir}/release.tar.gz"

  echo "Bootstrapping NexusPHP release ${RELEASE_VERSION} ..."
  wget -qO "$archive" "https://github.com/xiaomlove/nexusphp/archive/refs/tags/${RELEASE_VERSION}.tar.gz"
  tar -xf "$archive" -C "$tmpdir"

  src_dir="$(find "$tmpdir" -mindepth 1 -maxdepth 1 -type d -name 'nexusphp-*' | head -n 1)"
  if [[ -z "$src_dir" ]]; then
    echo "Failed to locate extracted NexusPHP release directory."
    exit 1
  fi

  find "$ROOT_PATH" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  cp -a "${src_dir}/." "$ROOT_PATH/"
  cp -a "${ROOT_PATH}/nexus/Install/install" "${ROOT_PATH}/public"
  chown -R www-data:www-data "$ROOT_PATH"

  su -s /bin/sh www-data -c "cd \"$ROOT_PATH\" && composer install --no-interaction --prefer-dist"

  printf '%s\n' "$RELEASE_VERSION" > "$BOOTSTRAP_MARKER"
  chown www-data:www-data "$BOOTSTRAP_MARKER"
}

ensure_nginx_config() {
  cp /etc/nginx/conf.d/nexusphp.conf.example /etc/nginx/conf.d/nexusphp.conf
  sed -i "s|server_name.*|server_name ${DOMAIN_NAME};|" /etc/nginx/conf.d/nexusphp.conf
}

ensure_internal_database() {
  run_service mysql
  mysql -e "create database if not exists nexusphp default charset=utf8mb4 collate utf8mb4_general_ci;"
  mysql -e "create user if not exists 'nexusphp'@'localhost' identified by 'nexusphp';"
  mysql -e "grant all privileges on nexusphp.* to 'nexusphp'@'localhost'; flush privileges;"
}

patch_env_example() {
  if [[ ! -f "${ROOT_PATH}/.env.example" ]]; then
    return
  fi

  sed -i "s|^APP_URL=.*|APP_URL=http://${DOMAIN_NAME}|" "${ROOT_PATH}/.env.example"
  sed -i "s|^DB_HOST=.*|DB_HOST=127.0.0.1|" "${ROOT_PATH}/.env.example"
  sed -i "s|^DB_PORT=.*|DB_PORT=3306|" "${ROOT_PATH}/.env.example"
  sed -i "s|^DB_DATABASE=.*|DB_DATABASE=nexusphp|" "${ROOT_PATH}/.env.example"
  sed -i "s|^DB_USERNAME=.*|DB_USERNAME=nexusphp|" "${ROOT_PATH}/.env.example"
  sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=nexusphp|" "${ROOT_PATH}/.env.example"
  sed -i "s|^REDIS_HOST=.*|REDIS_HOST=127.0.0.1|" "${ROOT_PATH}/.env.example"
  sed -i "s|^REDIS_PORT=.*|REDIS_PORT=6379|" "${ROOT_PATH}/.env.example"
  sed -i "s|^REDIS_DB=.*|REDIS_DB=0|" "${ROOT_PATH}/.env.example"
  sed -i "s|^LOG_FILE=.*|LOG_FILE=/tmp/nexus/nexus.log|" "${ROOT_PATH}/.env.example"
  sed -i "s|^TIMEZONE=.*|TIMEZONE=${TZ:-PRC}|" "${ROOT_PATH}/.env.example"
}

start_runtime() {
  run_service redis-server
  run_service php8.2-fpm
  run_service nginx
  run_service cron

  supervisord -c /etc/supervisor/supervisord.conf
  supervisorctl reread
  supervisorctl update
  supervisorctl start nexus-queue:*
}

prepare_runtime_dirs
bootstrap_code_if_needed
ensure_nginx_config
ensure_internal_database
patch_env_example
start_runtime

tail -f /etc/mysql/mysql.conf.d/mysqld.cnf
