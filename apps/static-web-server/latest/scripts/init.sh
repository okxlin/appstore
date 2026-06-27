#!/usr/bin/env bash
set -euo pipefail
DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p "${DATA_DIR}"
if [ ! -f "${DATA_DIR}/index.html" ]; then
  cat > "${DATA_DIR}/index.html" <<'EOF'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Static Web Server</title>
</head>
<body>
  <h1>Static Web Server</h1>
  <p>Your 1Panel static site directory is ready.</p>
</body>
</html>
EOF
fi
chmod -R a+rX "${DATA_DIR}" 2>/dev/null || true
