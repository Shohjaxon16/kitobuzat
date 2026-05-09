import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Book } from './entities/book.entity';
import { BookCategory } from './entities/book-category.entity';

@Injectable()
export class BooksService {
  constructor(
    @InjectRepository(Book)
    private readonly bookRepository: Repository<Book>,
    @InjectRepository(BookCategory)
    private readonly categoryRepository: Repository<BookCategory>,
  ) {}

  async findAll(query: any) {
    const { category, search, page = 1, limit = 20, sortBy = 'newest' } = query;
    const qb = this.bookRepository.createQueryBuilder('book');

    if (category) {
      qb.innerJoin('book.category', 'category', 'category.slug = :category', { category });
    }

    if (search) {
      qb.andWhere('book.title ILIKE :search OR book.author ILIKE :search', { search: `%${search}%` });
    }

    const [items, total] = await qb
      .skip((page - 1) * limit)
      .take(limit)
      .orderBy('book.createdAt', sortBy === 'newest' ? 'DESC' : 'ASC')
      .getManyAndCount();

    return {
      success: true,
      data: items,
      meta: { total, page, limit },
    };
  }

  async findOne(id: string) {
    const book = await this.bookRepository.findOne({ where: { id } });
    if (!book) throw new NotFoundException('Kitob topilmadi');
    return { success: true, data: book };
  }

  async findFeatured() {
    const book = await this.bookRepository.findOne({ where: { isFeatured: true } });
    return { success: true, data: book };
  }

  async findAllCategories() {
    const categories = await this.categoryRepository.find();
    return { success: true, data: categories };
  }

  async seed() {
    const categoriesData = [
      { name: 'Badiiy adabiyot', slug: 'badiiy' },
      { name: 'Psixologiya', slug: 'psixologiya' },
      { name: 'Biznes va moliya', slug: 'biznes' },
      { name: 'Ilmiy-ommabop', slug: 'ilmiy' },
    ];

    for (const cat of categoriesData) {
      const exists = await this.categoryRepository.findOneBy({ slug: cat.slug });
      if (!exists) {
        await this.categoryRepository.save(this.categoryRepository.create(cat));
      }
    }

    const badiiy = await this.categoryRepository.findOneBy({ slug: 'badiiy' });
    const psixologiya = await this.categoryRepository.findOneBy({ slug: 'psixologiya' });
    const biznes = await this.categoryRepository.findOneBy({ slug: 'biznes' });
    const ilmiy = await this.categoryRepository.findOneBy({ slug: 'ilmiy' });

    const booksData = [
      {
        title: 'Alkimyogar',
        author: 'Paulo Coelho',
        description: 'Sening taqdiring - bu o\'zing orzu qilgan narsaga erishishdir. Dunyo senga yordam berish uchun birlashadi...',
        coverImage: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=800',
        buyPrice: 45000,
        rentPrice: 5000,
        category: badiiy,
        isFeatured: true,
        rating: 4.9,
      },
      {
        title: '1984',
        author: 'George Orwell',
        description: '"Katta og\'a seni kuzatmoqda". Erkinlik - bu ikki karra ikki to\'rt deya olish erkinligidir.',
        coverImage: 'https://images.unsplash.com/photo-1543004404-435756baa67d?auto=format&fit=crop&q=80&w=800',
        buyPrice: 38000,
        rentPrice: 4000,
        category: badiiy,
        rating: 4.8,
      },
      {
        title: 'Dunyoning ishlari',
        author: 'O\'tkir Hoshimov',
        description: 'Ona haqida yozilmagan doston, aytilmagan qo\'shiq qolmagan. Samimiy qissa.',
        coverImage: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&q=80&w=800',
        buyPrice: 35000,
        rentPrice: 3000,
        category: badiiy,
        rating: 5.0,
      },
      {
        title: 'Atom odatlar',
        author: 'James Clear',
        description: 'Kichik o\'zgarishlar, ulkan natijalar. Har kuni 1 foizga yaxshilanish.',
        coverImage: 'https://images.unsplash.com/photo-1589998059171-988d887df646?auto=format&fit=crop&q=80&w=800',
        buyPrice: 55000,
        rentPrice: 6000,
        category: psixologiya,
        rating: 4.9,
      },
      {
        title: 'Boy ota, kambag\'al ota',
        author: 'Robert Kiyosaki',
        description: 'Boylar pul uchun ishlamaydi, ular pulni o\'zlari uchun ishlashga majbur qilishadi.',
        coverImage: 'https://images.unsplash.com/photo-1592492159418-39f319320569?auto=format&fit=crop&q=80&w=800',
        buyPrice: 42000,
        rentPrice: 5000,
        category: biznes,
        rating: 4.7,
      },
      {
        title: 'Kichik shahzoda',
        author: 'Antoine de Saint-Exupéry',
        description: 'Faqat qalb bilan ko\'rgandagina haqiqatni ko\'rish mumkin.',
        coverImage: 'https://images.unsplash.com/photo-1511108690759-009324a90311?auto=format&fit=crop&q=80&w=800',
        buyPrice: 28000,
        rentPrice: 3000,
        category: badiiy,
        rating: 4.9,
      },
      {
        title: 'Shaytanat',
        author: 'Tohir Malik',
        description: 'Jinoyat olami, inson nafsi va adolat o\'rtasidagi abadiy kurash.',
        coverImage: 'https://images.unsplash.com/photo-1474932430478-367dbb6832c1?auto=format&fit=crop&q=80&w=800',
        buyPrice: 120000,
        rentPrice: 15000,
        category: badiiy,
        rating: 4.8,
      },
      {
        title: 'Sapiens',
        author: 'Yuval Noah Harari',
        description: 'Insoniyatning qisqacha tarixi. Qanday qilib biz dunyo hukmdoriga aylandik?',
        coverImage: 'https://images.unsplash.com/photo-1532012197367-2d2d1f114631?auto=format&fit=crop&q=80&w=800',
        buyPrice: 75000,
        rentPrice: 8000,
        category: ilmiy,
        rating: 4.6,
      },
      {
        title: 'Yulduzli tunlar',
        author: 'Pirimqul Qodirov',
        description: 'Bobur Mirzo hayoti va uning ulkan saltanat barpo etish yo\'lidagi iztiroblari.',
        coverImage: 'https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&q=80&w=800',
        buyPrice: 58000,
        rentPrice: 6000,
        category: badiiy,
        rating: 5.0,
      },
      {
        title: 'Usta va Margarita',
        author: 'Mixail Bulgakov',
        description: 'Muhabbat va sadoqat o\'limdan ham kuchliroq. Sehrli asar.',
        coverImage: 'https://images.unsplash.com/photo-1541963463532-d68292c34b19?auto=format&fit=crop&q=80&w=800',
        buyPrice: 48000,
        rentPrice: 5000,
        category: badiiy,
        rating: 4.7,
      },
    ];

    for (const bookData of booksData) {
      const exists = await this.bookRepository.findOneBy({ title: bookData.title });
      if (!exists) {
        const book = this.bookRepository.create(bookData);
        await this.bookRepository.save(book);
      }
    }

    return { success: true, message: 'Kitoblar muvaffaqiyatli qo\'shildi' };
  }
}
