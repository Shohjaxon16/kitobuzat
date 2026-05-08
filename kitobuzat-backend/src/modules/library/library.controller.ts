import { Controller, Get, Patch, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { LibraryService } from './library.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';

@ApiTags('library')
@ApiBearerAuth('JWT-auth')
@UseGuards(JwtAuthGuard)
@Controller('library')
export class LibraryController {
  constructor(private readonly libraryService: LibraryService) {}

  @Get('my')
  @ApiOperation({ summary: 'Mening kutubxonamni olish' })
  findMyLibrary(@Request() req) {
    return this.libraryService.findMyLibrary(req.user.id);
  }

  @Patch(':bookId/progress')
  @ApiOperation({ summary: 'O\'qish jarayonini yangilash' })
  updateProgress(
    @Request() req,
    @Param('bookId') bookId: string,
    @Body('currentPage') currentPage: number,
  ) {
    return this.libraryService.updateProgress(req.user.id, bookId, currentPage);
  }
}
