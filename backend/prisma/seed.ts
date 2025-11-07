// Seed shim: prefer running the CommonJS seed (prisma/seed.js)
// Use `npm run prisma:seed` which calls the JS seed by default.

if (require.main === module) {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  require('./seed.js');
}

export {};
