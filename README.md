# AutoAPIGaurd

AutoAPIGaurd is a developer-first, AI-powered API security testing platform that helps teams automatically discover API endpoints from OpenAPI specs, Postman collections, or source code and run continuous security checks (OWASP API Top 10) in CI/CD.

This repository contains a small starter scaffold (backend + frontend) and a 16-week build plan (see `Auto API Guard Build Plan.md`) describing the intended product roadmap.

## What this repo currently contains

- `backend/` — Minimal Node.js + TypeScript Express app with Prisma configuration.
  - `src/index.ts` — simple health endpoint (`GET /health`).
  - `package.json` — dev script (`npm run dev`).
  - `prisma/schema.prisma` — Prisma schema (currently configured for PostgreSQL in source, but you can use SQLite for local dev).
- `frontend/` — Vite + React starter app (TypeScript) with basic UI files and `npm run dev` script.
- `dev-scripts/check_health.sh` — small helper to check backend and frontend dev servers.
- `Auto API Guard Build Plan.md` — a detailed 16-week roadmap and product plan.

## Current state (short)

- Minimal working backend health route returning `{ "status": "ok" }`.
- Frontend Vite app is present and serves the default template.
- Prisma schema exists and was switched to SQLite for local development (`datasource.provider = "sqlite"`).
- The repository is initialized and linked to `https://github.com/Harshit0012/AutoAPIGaud`.

## Progress so far (what you and I changed)

Below is a concise list of concrete changes made in this workspace during Week 1 setup (so you and I have a clear record):

- Git & remote
  - Initialized a local git repository and pushed the project to `https://github.com/Harshit0012/AutoAPIGaud` (merged with the remote README/LICENSE).

- Backend
  - Created a minimal Express TypeScript backend at `backend/src/index.ts` with a `/health` endpoint.
  - Added `backend/.env` and `backend/.env.example` pointing to `DATABASE_URL="file:./dev.db"` for SQLite local dev.
  - Switched Prisma datasource to SQLite in `backend/prisma/schema.prisma` and added minimal models (`User`, `ApiProject`).
  - Updated `backend/prisma.config.ts` to load `.env` early so the Prisma CLI picks up `DATABASE_URL`.
  - Removed a custom Prisma generator output so the client is generated into the default location expected by `@prisma/client`.
  - Added seeding scripts:
    - `backend/prisma/seed.ts` (TypeScript seed)
    - `backend/prisma/seed.js` (CommonJS JS fallback to run with plain `node`)
  - Added npm scripts in `backend/package.json`:
    - `prisma:generate`, `prisma:migrate`, `prisma:seed`, and `prisma:seed:js`.
  - Updated `backend/tsconfig.json` to include Node types so TypeScript recognizes `process` and Node globals.

- Prisma & DB
  - Ran `prisma generate` to create the Prisma client.
  - Ran `prisma migrate dev --name init` to apply migrations — the CLI reported the schema is already in sync and created (or will create) `dev.db` when migrations run.

- Dev helpers
  - Added `dev-scripts/check_health.sh` to quickly validate backend and frontend dev servers.

If any of the items above are unfamiliar, I can revert or explain the exact files changed.

## Quickstart (local development)

Prerequisites:
- Node.js (use `nvm` to install an LTS version)
- npm (bundled with Node)
- (Optional) Docker if you want to run Postgres locally

Recommended for fast local development: use SQLite (no Docker required).

1. Install dependencies

```bash
# from repo root
cd backend
npm install

cd ../frontend
npm install
```

2. Configure local environment (SQLite example)

```bash
cd backend
cat > .env <<'ENV'
DATABASE_URL="file:./dev.db"
PORT=4000
NODE_ENV=development
ENV
```

3. Update Prisma datasource (if you want me to do this automatically, I can) — in `backend/prisma/schema.prisma` change the `provider` to `sqlite`:

```prisma
datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}
```

4. Generate Prisma client and run migrations

```bash
cd backend
npx prisma generate
npx prisma migrate dev --name init
```

5. Start dev servers

```bash
# terminal A
cd backend
npm run dev

# terminal B
cd frontend
npm run dev
```

6. Health checks

```bash
# from repo root
chmod +x dev-scripts/check_health.sh
./dev-scripts/check_health.sh

# or manual
curl -sS http://localhost:4000/health
curl -sS http://localhost:5173/
```

## Troubleshooting

- Prisma error `Missing required environment variable: DATABASE_URL`: create `backend/.env` (see step 2) or export `DATABASE_URL` in your shell before running Prisma commands.
- If you prefer Postgres, run in Docker and set `DATABASE_URL` accordingly:

```bash
docker run --name apiguard-postgres -e POSTGRES_PASSWORD=apiguardpw -e POSTGRES_USER=apiguard -e POSTGRES_DB=apiguard -p 5432:5432 -d postgres:15
# then set DATABASE_URL to:
# postgresql://apiguard:apiguardpw@localhost:5432/apiguard?schema=public
```

## Next recommended steps (short-term roadmap)

1. Finish Week 1 tasks: wire up Prisma (SQLite or Postgres), create `.env.example`, and add a `prisma/seed.ts` for test data.
2. Week 2: add user model + simple JWT auth (register/login) so you can protect endpoints.
3. Weeks 3-4: implement OpenAPI/Postman parsers and an upload UI in the frontend.

See `Auto API Guard Build Plan.md` for the full 16-week plan.

## Contributing

Open a PR against `main` or create issues for larger tasks. If you'd like me to implement any of the Week 1 or Week 2 items, tell me and I will add the files and run the migrations for you.

## License
This repository currently contains a `LICENSE` file (see project root).
