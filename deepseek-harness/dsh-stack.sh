#!/usr/bin/env bash
set -euo pipefail

DSH_WEB_PORT="${DSH_WEB_PORT:-3080}"

cleanup() {
  if [[ -n "${DSH_PID:-}" ]] && kill -0 "$DSH_PID" 2>/dev/null; then
    kill "$DSH_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

dsh web --host 127.0.0.1 --port "$DSH_WEB_PORT" --no-open "$@" &
DSH_PID=$!

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
