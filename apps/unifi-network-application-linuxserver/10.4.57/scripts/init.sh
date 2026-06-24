#!/usr/bin/env bash
set -euo pipefail
mkdir -p ./data/config ./data/mongo ./data/mongo-init
cat > ./data/mongo-init/init-mongo.sh <<'EOF'
#!/bin/sh
set -e
if command -v mongosh >/dev/null 2>&1; then
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
chmod 755 ./data/mongo-init/init-mongo.sh
chown -R 1000:1000 ./data 2>/dev/null || true
