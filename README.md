# AutoAPIGaurd — AI-first API Security Testing (Prototype)

AutoAPIGaurd is a developer-focused platform that automates discovery and security testing of APIs. This repository contains a working prototype: a TypeScript backend, a Vite + React frontend scaffold, and a Prisma-powered local database with seed data — everything you need to demo the core developer experience.

Why this project matters
- Discover APIs from common formats (OpenAPI, Postman) and run repeatable API security checks.
- Designed to integrate into developer workflows and CI — small, fast, and automatable.
- Focus on actionable findings (authentication, authorization, injection, sensitive data exposure).

What's in this repository 
- backend/ — TypeScript + Express backend
  - Minimal API with a health endpoint (`GET /health`) and Prisma integration.
- frontend/ — Vite + React (TypeScript) scaffold
  - Starter UI ready for extension (upload specs, view scan results, etc.).
- prisma/ — Prisma schema and seeds for fast local development (SQLite)
- scripts/setup.sh — one-command setup for local dev (installs deps, generates client, runs migrations, seeds DB)
- dev-scripts/check_health.sh — quick health-check helper

Try it locally (one command)
1. Make the setup script executable and run it from the repo root:

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

2. Start the servers (two terminals):

```bash
# terminal A
cd backend
npm run dev

# terminal B
cd frontend
npm run dev
```

3. Quick smoke test

```bash
curl -sS http://localhost:4000/health
# expected: {"status":"ok"}

./dev-scripts/check_health.sh
```

Technical highlights
- TypeScript-first backend and frontend for strong DX and maintainability.
- Prisma ORM with a ready local SQLite database for fast iteration.
- Seed scripts (TS + JS fallback) so demos always have sample data.
- Minimal, extensible architecture so features (parsers, scanners, CI hooks) can be added quickly.

Who should look at this
- Developers building secure APIs who want an automated, CI-friendly testing workflow.
- Security engineers interested in lightweight, reproducible API scans integrated into dev pipelines.
- Potential contributors or partners who want to help expand tests, parsers, and integrations.

Contact / Next steps
- If you want a demo or help extending this prototype (parsers, UI, OWASP ZAP integration), open an issue or a PR.

License: see `LICENSE` in the repository root.
