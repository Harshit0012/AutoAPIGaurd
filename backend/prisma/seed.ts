import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database...');

  // Create a test user
  const user = await prisma.user.create({
    data: {
      email: 'dev+test@example.com',
      name: 'Dev Tester',
    },
  });

  // Create a sample project
  await prisma.apiProject.create({
    data: {
      userId: user.id,
      name: 'Example API Project',
      apiEndpoint: 'https://api.example.com',
    },
  });

  console.log('Seeding finished.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
