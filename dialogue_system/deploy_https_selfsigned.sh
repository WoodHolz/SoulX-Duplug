#!/usr/bin/env bash
set -euo pipefail

# Self-signed HTTPS launcher for dialogue_system.
# Usage:
#   bash deploy_https_selfsigned.sh
# Optional env:
#   PORT=55556 CERT_KEY=~/certs/dev.key CERT_CRT=~/certs/dev.crt bash deploy_https_selfsigned.sh

PORT="${PORT:-55556}"
HOST="${HOST:-0.0.0.0}"
CERT_KEY="${CERT_KEY:-$HOME/certs/dev.key}"
CERT_CRT="${CERT_CRT:-$HOME/certs/dev.crt}"

if [[ ! -f "${CERT_KEY}" || ! -f "${CERT_CRT}" ]]; then
  echo "[error] Certificate files not found."
  echo "Expected:"
  echo "  CERT_KEY=${CERT_KEY}"
  echo "  CERT_CRT=${CERT_CRT}"
  echo
  echo "Create them first (example):"
  echo "  mkdir -p ~/certs"
  echo "  openssl req -x509 -newkey rsa:2048 -nodes \\"
  echo "    -keyout ~/certs/dev.key \\"
  echo "    -out ~/certs/dev.crt \\"
  echo "    -days 365 \\"
  echo "    -subj \"/CN=zhenhongwoo.top\" \\"
  echo "    -addext \"subjectAltName=DNS:zhenhongwoo.top,IP:106.75.44.168\""
  exit 1
fi

echo "[deploy] HTTPS startup with self-signed cert"
echo "[deploy] host=${HOST} port=${PORT}"
echo "[deploy] cert=${CERT_CRT}"
echo "[deploy] key=${CERT_KEY}"

exec uvicorn app:app \
  --host "${HOST}" \
  --port "${PORT}" \
  --ssl-keyfile "${CERT_KEY}" \
  --ssl-certfile "${CERT_CRT}"
