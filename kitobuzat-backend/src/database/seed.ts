import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from '../modules/users/entities/user.entity';
import { Book } from '../modules/books/entities/book.entity';
import { BookCategory } from '../modules/books/entities/book-category.entity';
import { UserRole } from '../common/enums/user-role.enum';
import * as dotenv from 'dotenv';

dotenv.config();

const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT, 10) || 5433,
  username: process.env.DB_USER || 'kitobuzat_user',
  password: process.env.DB_PASSWORD || 'kitobuzat_pass_123',
  database: process.env.DB_NAME || 'kitobuzat',
  entities: [User, Book, BookCategory],
  synchronize: true,
});

async function seed() {
  await AppDataSource.initialize();
  console.log('Database connected!');

  const userRepository = AppDataSource.getRepository(User);
  const categoryRepository = AppDataSource.getRepository(BookCategory);
  const bookRepository = AppDataSource.getRepository(Book);

  const adminPassword = await bcrypt.hash('Admin123!', 12);
  const admin = userRepository.create({
    email: 'admin@kitobuzat.uz',
    passwordHash: adminPassword,
    fullName: 'Admin Foydalanuvchi',
    role: UserRole.ADMIN,
    isEmailVerified: true,
  });

  const testPassword = await bcrypt.hash('Test123!', 12);
  const testUser = userRepository.create({
    email: 'test@kitobuzat.uz',
    passwordHash: testPassword,
    fullName: 'Test Foydalanuvchi',
    role: UserRole.USER,
    isEmailVerified: true,
  });

  await userRepository.save([admin, testUser]);
  console.log('Users seeded!');

  const categoryNames = ["Roman", "Ilmiy", "Tarix", "Biznes", "Bolalar", "She'riyat"];
  const categories = categoryNames.map(name => categoryRepository.create({ name }));
  await categoryRepository.save(categories);
  console.log('Categories seeded!');

  const sampleBooks = [
    { title: "O'tkan Kunlar", author: "Abdulla Qodiriy", buyPrice: 35000, rentPrice: 8500, isAvailableForRent: true, rating: 4.6, totalPages: 287 },
    { title: "Mehrobdan Chayon", author: "Abdulla Qodiriy", buyPrice: 28000, rentPrice: 7000, isAvailableForRent: true, rating: 4.2, totalPages: 312 },
    { title: "Atomic Habits", author: "James Clear", buyPrice: 45000, rentPrice: 0, isAvailableForRent: false, rating: 4.7, totalPages: 278 },
    { title: "Sarob", author: "Abdulla Qahhor", buyPrice: 22000, rentPrice: 6000, isAvailableForRent: true, rating: 4.8, totalPages: 198 },
    { title: "Rich Dad Poor Dad", author: "Robert Kiyosaki", buyPrice: 38000, rentPrice: 9000, isAvailableForRent: true, rating: 4.3, totalPages: 336 }
  ];

  const books = sampleBooks.map(b => bookRepository.create({ ...b, category: categories[0] }));
  await bookRepository.save(books);
  console.log('Books seeded!');

  await AppDataSource.destroy();
  console.log('Seeding completed successfully!');
}

seed().catch(err => {
  console.error('Seeding failed:', err);
  process.exit(1);
});
