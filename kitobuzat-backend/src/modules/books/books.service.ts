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
}
