#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

ensure_env_default() {
  local key="$1"
  local value="$2"

  if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE not found; skipped $key migration"
    return
  fi

  if grep -qE "^${key}=" "$ENV_FILE"; then
    echo "$key already exists"
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added $key"
}

read_env_value() {
  local key="$1"
  if [[ -f "$ENV_FILE" ]]; then
    sed -n -E "s/^${key}=(.*)$/\1/p" "$ENV_FILE" | tail -n 1
  fi
}

write_mongo_init_script() {
  local mongo_init_path="$1"
  mkdir -p "$mongo_init_path"
  cat > "$mongo_init_path/init-mongo.sh" <<'EOF'
#!/bin/bash
if which mongosh > /dev/null 2>&1; then
  mongo_init_bin='mongosh'
else
  mongo_init_bin='mongo'
fi
"${mongo_init_bin}" <<MONGOEOF
use ${MONGO_AUTHSOURCE}
db.auth("${MONGO_INITDB_ROOT_USERNAME}", "${MONGO_INITDB_ROOT_PASSWORD}")
db.createUser({
  user: "${MONGO_USER}",
  pwd: "${MONGO_PASS}",
  roles: [
    "clusterMonitor",
    { db: "${MONGO_DBNAME}", role: "dbOwner" },
    { db: "${MONGO_DBNAME}_stat", role: "dbOwner" },
    { db: "${MONGO_DBNAME}_audit", role: "dbOwner" },
    { db: "${MONGO_DBNAME}_restore", role: "dbOwner" }
  ]
})
MONGOEOF
EOF
  chmod 755 "$mongo_init_path/init-mongo.sh"
}

if [[ -f "$ENV_FILE" ]]; then
  ensure_env_default "MONGO_INIT_PATH" "./data/mongo-init"
fi

mongo_init_path="${MONGO_INIT_PATH:-$(read_env_value MONGO_INIT_PATH)}"
mongo_init_path="${mongo_init_path:-./data/mongo-init}"
write_mongo_init_script "$mongo_init_path"
