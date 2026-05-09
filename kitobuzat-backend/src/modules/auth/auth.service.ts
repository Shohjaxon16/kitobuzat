import { Injectable, UnauthorizedException, ConflictException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';
import { User } from '../users/entities/user.entity';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async register(dto: RegisterDto) {
    console.log(`[AUTH] Registering user: ${dto.email}`);
    
    console.log('[AUTH] Checking existing user...');
    const existing = await this.usersRepository.findOne({ where: { email: dto.email } });
    if (existing) throw new ConflictException("Bu email allaqachon ro'yxatdan o'tgan");

    console.log('[AUTH] Hashing password...');
    const passwordHash = await bcrypt.hash(dto.password, 12);
    
    console.log('[AUTH] Creating user object...');
    const emailVerificationToken = uuidv4();

    const user = this.usersRepository.create({
      email: dto.email,
      fullName: dto.fullName,
      passwordHash,
      emailVerificationToken,
      isEmailVerified: true,
    });
    
    console.log('[AUTH] Saving user to database...');
    await this.usersRepository.save(user);

    console.log(`[AUTH] Success! Verification token: ${emailVerificationToken}`);
    return { message: 'Emailingizga tasdiqlash xati yuborildi' };
  }

  async login(dto: LoginDto) {
    const user = await this.usersRepository.findOne({ where: { email: dto.email } });
    if (!user) throw new UnauthorizedException("Email yoki parol noto'g'ri");
    // if (!user.isEmailVerified) throw new UnauthorizedException('Email tasdiqlanmagan');

    const isMatch = await bcrypt.compare(dto.password, user.passwordHash);
    if (!isMatch) throw new UnauthorizedException("Email yoki parol noto'g'ri");

    return this.generateTokens(user);
  }

  async refresh(refreshToken: string) {
    try {
      const payload = this.jwtService.verify(refreshToken, {
        secret: this.configService.get<string>('JWT_REFRESH_SECRET') || 'refresh_secret',
      });
      const user = await this.usersRepository.findOne({ where: { id: payload.sub } });
      if (!user || !user.refreshToken) throw new UnauthorizedException('Yaroqsiz token');

      const isMatch = await bcrypt.compare(refreshToken, user.refreshToken);
      if (!isMatch) throw new UnauthorizedException('Yaroqsiz token');

      return this.generateTokens(user);
    } catch (e) {
      throw new UnauthorizedException("Token muddati o'tgan yoki yaroqsiz");
    }
  }

  async logout(userId: string) {
    await this.usersRepository.update(userId, { refreshToken: null });
    return { message: 'Chiqildi' };
  }

  async verifyEmail(token: string) {
    const user = await this.usersRepository.findOne({ where: { emailVerificationToken: token } });
    if (!user) throw new NotFoundException('Yaroqsiz token');

    user.isEmailVerified = true;
    user.emailVerificationToken = null;
    await this.usersRepository.save(user);

    return { message: 'Email tasdiqlandi' };
  }

  private async generateTokens(user: User) {
    const payload = { sub: user.id, email: user.email, role: user.role };
    
    const accessToken = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, {
      secret: this.configService.get<string>('JWT_REFRESH_SECRET') || 'refresh_secret',
      expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRES') || '7d',
    });

    const hashedRefreshToken = await bcrypt.hash(refreshToken, 10);
    user.refreshToken = hashedRefreshToken;
    await this.usersRepository.save(user);

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        avatar: user.avatar,
        role: user.role,
      },
    };
  }
}
