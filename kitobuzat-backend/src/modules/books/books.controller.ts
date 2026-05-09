import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { BooksService } from './books.service';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('books')
@Controller('books')
export class BooksController {
  constructor(private readonly booksService: BooksService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Barcha kitoblarni olish' })
  findAll(@Query() query: any) {
    return this.booksService.findAll(query);
  }

  @Public()
  @Get('featured')
  @ApiOperation({ summary: 'Hafta kitobini olish' })
  findFeatured() {
    return this.booksService.findFeatured();
  }

  @Public()
  @Get('categories')
  @ApiOperation({ summary: 'Barcha kategoriyalarni olish' })
  findAllCategories() {
    return this.booksService.findAllCategories();
  }

  @Public()
  @Get('seed')
  @ApiOperation({ summary: 'Kitoblarni bazaga to\'ldirish (Seed)' })
  seed() {
    return this.booksService.seed();
  }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Bitta kitobni ID orqali olish' })
  findOne(@Param('id') id: string) {
    return this.booksService.findOne(id);
  }
}
