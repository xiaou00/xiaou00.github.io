#!/usr/bin/env bash
set -e

PORT=${PORT:-8080}
DIR="$(cd "$(dirname "$0")" && pwd)/blog"

if command -v npx &>/dev/null; then
  echo "Serving at http://localhost:$PORT (live-reload enabled)"
  npx --yes browser-sync start \
    --server "$DIR" \
    --port "$PORT" \
    --files "$DIR/**/*" \
    --no-open
elif command -v python3 &>/dev/null; then
  echo "Serving at http://localhost:$PORT (no live-reload)"
  python3 -m http.server "$PORT" --directory "$DIR"
elif command -v python &>/dev/null; then
  echo "Serving at http://localhost:$PORT (no live-reload)"
  cd "$DIR" && python -m SimpleHTTPServer "$PORT"
else
  echo "Error: no suitable HTTP server found (npx, python3, or python required)" >&2
  exit 1
fi
