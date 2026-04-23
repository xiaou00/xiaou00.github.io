#!/usr/bin/env bash
set -e

PORT=${PORT:-8080}
DIR="$(cd "$(dirname "$0")" && pwd)/index"

if command -v python3 &>/dev/null; then
  echo "Serving at http://localhost:$PORT"
  python3 -m http.server "$PORT" --directory "$DIR"
elif command -v python &>/dev/null; then
  echo "Serving at http://localhost:$PORT"
  cd "$DIR" && python -m SimpleHTTPServer "$PORT"
elif command -v npx &>/dev/null; then
  echo "Serving at http://localhost:$PORT"
  npx serve "$DIR" -l "$PORT"
else
  echo "Error: no suitable HTTP server found (python3, python, or npx required)" >&2
  exit 1
fi
