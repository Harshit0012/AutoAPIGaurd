// Quick data verification script for Week 1 seed
// Usage: from backend/ run `node check_data.js` or `npm run check:data`

require('dotenv').config(); // loads backend/.env so Prisma can connect
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  try {
    console.log('Checking database connection and seeded data...');

    const users = await prisma.user.findMany({ take: 5 });
    const projects = await prisma.apiProject.findMany({ take: 5 });

    console.log(`users: ${users.length}`);
    if (users.length) console.log('sample user:', users[0]);

    console.log(`apiProjects: ${projects.length}`);
    if (projects.length) console.log('sample project:', projects[0]);

    // simple sanity: ensure at least one user and one project
    if (users.length === 0 || projects.length === 0) {
      console.warn('Warning: expected seeded data not found (0 rows).');
      process.exitCode = 2;
    } else {
      console.log('Seed check OK.');
    }
  } catch (err) {
    console.error('Error while checking data:', err);
    process.exitCode = 1;
  } finally {
    await prisma.$disconnect();
  }
}

main();
