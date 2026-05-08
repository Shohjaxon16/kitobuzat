import { Controller, Post, Body, Get, Query, Req, UnauthorizedException } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Public()
  @Post('register')
  @ApiOperation({ summary: "Yangi foydalanuvchini ro'yxatdan o'tkazish" })
  async register(@Body() registerDto: RegisterDto) {
    console.log('[CONTROLLER] Register called with:', registerDto);
    return this.authService.register(registerDto);
  }

  @Public()
  @Post('login')
  @ApiOperation({ summary: 'Tizimga kirish' })
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Public()
  @Post('refresh')
  @ApiOperation({ summary: 'Tokenni yangilash' })
  async refresh(@Body('refreshToken') refreshToken: string) {
    if (!refreshToken) throw new UnauthorizedException('Refresh token required');
    return this.authService.refresh(refreshToken);
  }

  @Post('logout')
  @ApiOperation({ summary: 'Tizimdan chiqish' })
  async logout(@Req() req) {
    return this.authService.logout(req.user.id);
  }

  @Public()
  @Get('verify-email')
  @ApiOperation({ summary: 'Emailni tasdiqlash' })
  async verifyEmail(@Query('token') token: string) {
    return this.authService.verifyEmail(token);
  }
}
