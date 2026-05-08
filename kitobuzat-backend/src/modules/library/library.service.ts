import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserBook } from './entities/user-book.entity';

@Injectable()
export class LibraryService {
  constructor(
    @InjectRepository(UserBook)
    private readonly userBookRepository: Repository<UserBook>,
  ) {}

  async findMyLibrary(userId: string) {
    const items = await this.userBookRepository.find({
      where: { user: { id: userId } },
      relations: ['book'],
      order: { createdAt: 'DESC' },
    });
    return { success: true, data: items };
  }

  async updateProgress(userId: string, bookId: string, currentPage: number) {
    const item = await this.userBookRepository.findOne({
      where: { user: { id: userId }, book: { id: bookId } },
    });
    if (!item) throw new NotFoundException('Kitob kutubxonangizda topilmadi');
    item.currentPage = currentPage;
    await this.userBookRepository.save(item);
    return { success: true, message: 'Jarayon yangilandi' };
  }
}
