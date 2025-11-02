// Node-friendly seed script (CommonJS) — runs without ts-node
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

(async function main() {
  try {
    console.log('Seeding database (JS)...');
    const user = await prisma.user.create({
      data: { email: 'dev+test@example.com', name: 'Dev Tester' },
    });

    await prisma.apiProject.create({
      data: { userId: user.id, name: 'Example API Project', apiEndpoint: 'https://api.example.com' },
    });

    console.log('Seeding finished (JS).');
  } catch (e) {
    console.error(e);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
})();
