#!/usr/bin/env bash
set -euo pipefail

# scripts/setup.sh
# Automates local dev setup: installs deps, creates .env (if missing), generates Prisma client,
# runs migrations, and seeds the DB (JS fallback). Run from repo root:
#   chmod +x scripts/setup.sh
#   ./scripts/setup.sh

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BACKEND_DIR="$REPO_ROOT/backend"
FRONTEND_DIR="$REPO_ROOT/frontend"

echo "Repo root: $REPO_ROOT"

command_exists() { command -v "$1" >/dev/null 2>&1; }

# Ensure Node/npm available
if ! command_exists npm; then
  echo "npm not found. Install Node.js (use nvm recommended)."
  exit 1
fi

# 1) Backend: install deps
echo "\n==> Installing backend dependencies"
cd "$BACKEND_DIR"
npm install --no-audit --no-fund

# 2) Ensure .env exists (don't overwrite)
if [ ! -f "$BACKEND_DIR/.env" ]; then
  echo "Creating backend/.env for local SQLite dev"
  cat > "$BACKEND_DIR/.env" <<'ENV'
DATABASE_URL="file:./dev.db"
PORT=4000
NODE_ENV=development
ENV
else
  echo "backend/.env already exists — leaving it untouched"
fi

# 3) Generate Prisma client
echo "\n==> Generating Prisma client"
# Use npm script if present, otherwise npx
if npm run | grep -q "prisma:generate" 2>/dev/null; then
  npm run prisma:generate
else
  npx prisma generate
fi

# 4) Run migrations (dev)
echo "\n==> Applying Prisma migrations (dev)"
if npm run | grep -q "prisma:migrate" 2>/dev/null; then
  npm run prisma:migrate || true
else
  npx prisma migrate dev --name init || true
fi

# 5) Seed DB (prefer JS fallback to avoid ts-node ESM issues)
echo "\n==> Seeding database (JS fallback)"
if npm run | grep -q "prisma:seed:js" 2>/dev/null; then
  npm run prisma:seed:js || (echo "JS seed failed, trying TS seed..." && npm run prisma:seed)
else
  if [ -f "$BACKEND_DIR/prisma/seed.js" ]; then
    node prisma/seed.js || (echo "JS seed failed, trying TS seed..." && npx ts-node prisma/seed.ts)
  else
    echo "No seed.js found; attempting TS seed"
    npx ts-node prisma/seed.ts
  fi
fi

# 6) Frontend: install deps
echo "\n==> Installing frontend dependencies"
cd "$FRONTEND_DIR"
npm install --no-audit --no-fund

echo "\nSetup complete. Next steps:"
echo " - Start backend: (cd backend && npm run dev)"
echo " - Start frontend: (cd frontend && npm run dev)"
echo " - Health check: ./dev-scripts/check_health.sh"

exit 0
