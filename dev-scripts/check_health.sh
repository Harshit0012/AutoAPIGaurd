#!/usr/bin/env bash
set -euo pipefail

# Health-check script for local dev servers
# Usage: ./dev-scripts/check_health.sh

print_header() {
  echo
  echo "========================================"
  echo " $1"
  echo "========================================"
}

# Backend health check (default port 4000)
BACKEND_URL=${BACKEND_URL:-http://localhost:4000/health}
FRONTEND_URL=${FRONTEND_URL:-http://localhost:5173/}

print_header "Checking backend: $BACKEND_URL"
if curl -fsS "$BACKEND_URL" -m 5; then
  echo -e "\nBackend responded OK"
else
  echo -e "\nBackend did not respond (or returned non-2xx)." >&2
fi

print_header "Checking frontend: $FRONTEND_URL"
# For frontend we fetch the HTML head title to keep output small
if curl -fsS "$FRONTEND_URL" -m 5 | sed -n '1,60p'; then
  echo -e "\nFrontend responded OK (HTML returned)"
else
  echo -e "\nFrontend did not respond (or returned non-2xx)." >&2
fi

print_header "Done"
