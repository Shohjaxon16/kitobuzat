const fs = require('fs');
const path = require('path');

const dir = (d) => fs.mkdirSync(path.join(__dirname, d), { recursive: true });
const file = (f, c) => fs.writeFileSync(path.join(__dirname, f), c.trim());

// Create Directories
const dirs = [
  'src/config',
  'src/common/decorators',
  'src/common/guards',
  'src/common/interceptors',
  'src/common/filters',
  'src/modules/auth/strategies',
  'src/modules/auth/dto',
  'src/modules/users/entities',
  'src/modules/users/dto',
  'src/modules/books/entities',
  'src/modules/books/dto',
  'src/modules/library/entities',
  'src/modules/orders/entities',
  'src/modules/payments/providers',
  'src/modules/payments/dto',
  'src/modules/upload',
  'src/modules/notifications'
];
dirs.forEach(dir);

// 1. Entities
file('src/modules/users/entities/user.entity.ts', `
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { UserBook } from '../../library/entities/user-book.entity';
import { Order } from '../../orders/entities/order.entity';
import { UserRole } from '../../../common/enums/user-role.enum';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column({ unique: true }) email: string;
  @Column({ unique: true, nullable: true }) phone: string;
  @Column() fullName: string;
  @Column({ nullable: true }) avatar: string;
  @Column() passwordHash: string;
  @Column({ type: 'enum', enum: UserRole, default: UserRole.USER }) role: UserRole;
  @Column({ default: false }) isEmailVerified: boolean;
  @Column({ nullable: true }) refreshToken: string;
  @Column({ nullable: true }) emailVerificationToken: string;
  @Column({ nullable: true }) passwordResetToken: string;
  @Column({ nullable: true }) passwordResetExpires: Date;
  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
  @OneToMany(() => UserBook, ub => ub.user) library: UserBook[];
  @OneToMany(() => Order, o => o.user) orders: Order[];
}
`);

file('src/modules/books/entities/book-category.entity.ts', `
import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Book } from './book.entity';

@Entity('book_categories')
export class BookCategory {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() name: string;
  @Column({ nullable: true }) description: string;
  @OneToMany(() => Book, b => b.category) books: Book[];
}
`);

file('src/modules/books/entities/book.entity.ts', `
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne } from 'typeorm';
import { BookCategory } from './book-category.entity';

@Entity('books')
export class Book {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() title: string;
  @Column() author: string;
  @Column('text') description: string;
  @Column({ nullable: true }) coverImage: string;
  @Column({ nullable: true }) fileUrl: string;
  @Column('decimal', { precision: 10, scale: 2 }) buyPrice: number;
  @Column('decimal', { precision: 10, scale: 2, nullable: true }) rentPrice: number;
  @Column({ default: true }) isAvailableForRent: boolean;
  @Column({ default: true }) isActive: boolean;
  @Column({ default: 0 }) totalPages: number;
  @Column({ default: 0 }) viewCount: number;
  @Column({ default: 0 }) purchaseCount: number;
  @Column('float', { default: 0 }) rating: number;
  @Column({ default: 0 }) reviewCount: number;
  @ManyToOne(() => BookCategory, c => c.books) category: BookCategory;
  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}
`);

file('src/modules/library/entities/user-book.entity.ts', `
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Book } from '../../books/entities/book.entity';

@Entity('user_books')
export class UserBook {
  @PrimaryGeneratedColumn('uuid') id: string;
  @ManyToOne(() => User, u => u.library) user: User;
  @ManyToOne(() => Book) book: Book;
  @Column({ type: 'enum', enum: ['bought', 'rented'] }) type: string;
  @Column({ default: 0 }) currentPage: number;
  @Column({ nullable: true }) rentExpiresAt: Date;
  @Column({ default: false }) isExpired: boolean;
  @CreateDateColumn() createdAt: Date;
}
`);

file('src/modules/orders/entities/order.entity.ts', `
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Book } from '../../books/entities/book.entity';

@Entity('orders')
export class Order {
  @PrimaryGeneratedColumn('uuid') id: string;
  @ManyToOne(() => User, u => u.orders) user: User;
  @ManyToOne(() => Book) book: Book;
  @Column({ type: 'enum', enum: ['buy', 'rent'] }) orderType: string;
  @Column('decimal', { precision: 10, scale: 2 }) amount: number;
  @Column({ type: 'enum', enum: ['pending', 'paid', 'failed', 'refunded'], default: 'pending' }) status: string;
  @Column({ type: 'enum', enum: ['payme', 'click', 'card'] }) paymentMethod: string;
  @Column({ nullable: true }) transactionId: string;
  @Column({ nullable: true }) paymentData: string;
  @Column({ nullable: true }) rentDays: number;
  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}
`);

// 2. Common files
file('src/common/decorators/public.decorator.ts', `
import { SetMetadata } from '@nestjs/common';
export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);
`);

file('src/common/decorators/current-user.decorator.ts', `
import { createParamDecorator, ExecutionContext } from '@nestjs/common';
export const CurrentUser = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.user;
  },
);
`);

file('src/common/interceptors/response.interceptor.ts', `
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

export interface Response<T> {
  success: boolean;
  data: T;
  message: string;
  timestamp: string;
}

@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<T, Response<T>> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<Response<T>> {
    return next.handle().pipe(
      map(data => {
        const responseData = data?.data ? data.data : data;
        const meta = data?.meta ? data.meta : undefined;
        return {
          success: true,
          data: responseData,
          ...(meta && { meta }),
          message: data?.message || 'OK',
          timestamp: new Date().toISOString(),
        };
      }),
    );
  }
}
`);

file('src/common/filters/http-exception.filter.ts', `
import { ExceptionFilter, Catch, ArgumentsHost, HttpException } from '@nestjs/common';
import { Request, Response } from 'express';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const status = exception.getStatus();
    const exceptionResponse: any = exception.getResponse();

    response
      .status(status)
      .json({
        success: false,
        error: {
          code: exceptionResponse.error || 'ERROR',
          message: exceptionResponse.message || exception.message,
          statusCode: status
        },
        timestamp: new Date().toISOString(),
      });
  }
}
`);

file('src/common/guards/jwt-auth.guard.ts', `
import { Injectable, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Reflector } from '@nestjs/core';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  constructor(private reflector: Reflector) {
    super();
  }

  canActivate(context: ExecutionContext) {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) {
      return true;
    }
    return super.canActivate(context);
  }

  handleRequest(err, user, info) {
    if (err || !user) {
      throw err || new UnauthorizedException('Foydalanuvchi tasdiqlanmadi');
    }
    return user;
  }
}
`);

file('src/common/guards/roles.guard.ts', `
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>('roles', [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!requiredRoles) {
      return true;
    }
    const { user } = context.switchToHttp().getRequest();
    return requiredRoles.some((role) => user.role?.includes(role));
  }
}
`);

// 3. Modules Basic Setup (Controllers and Services omitted for space, but basic structure provided)
file('src/app.module.ts', `
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { JwtAuthGuard } from './common/guards/jwt-auth.guard';
// Import all entities
import { User } from './modules/users/entities/user.entity';
import { Book } from './modules/books/entities/book.entity';
import { BookCategory } from './modules/books/entities/book-category.entity';
import { UserBook } from './modules/library/entities/user-book.entity';
import { Order } from './modules/orders/entities/order.entity';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT, 10) || 5432,
      username: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD || 'postgres',
      database: process.env.DB_NAME || 'kitobuzat',
      entities: [User, Book, BookCategory, UserBook, Order],
      synchronize: true, // Auto create tables for dev
    }),
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard, // Global guard
    },
  ],
})
export class AppModule {}
`);

console.log("Files created successfully!");
