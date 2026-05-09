import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { BullModule } from '@nestjs/bull';
import configuration from './config/configuration';

// Controllers
import { HealthController } from './health/health.controller';

// Entities
import { User } from './modules/users/entities/user.entity';
import { Book } from './modules/books/entities/book.entity';
import { BookCategory } from './modules/books/entities/book-category.entity';
import { UserBook } from './modules/library/entities/user-book.entity';
import { Order } from './modules/orders/entities/order.entity';

// Modules
import { AuthModule } from './modules/auth/auth.module';
import { BooksModule } from './modules/books/books.module';
import { LibraryModule } from './modules/library/library.module';
import { OrdersModule } from './modules/orders/orders.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { UploadModule } from './modules/upload/upload.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        host: config.get<string>('database.host'),
        port: config.get<number>('database.port'),
        database: config.get<string>('database.name'),
        username: config.get<string>('database.user'),
        password: config.get<string>('database.password'),
        ssl: config.get<boolean>('database.ssl')
          ? { rejectUnauthorized: false }
          : false,
        entities: [User, Book, BookCategory, UserBook, Order],
        synchronize: true, // Jadvallarni avtomatik yaratish
        logging: config.get<string>('nodeEnv') === 'development',
      }),
      inject: [ConfigService],
    }),
    BullModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        redis: {
          host: config.get<string>('redis.host'),
          port: config.get<number>('redis.port'),
          password: config.get<string>('redis.password'),
          tls: config.get<boolean>('redis.tls') ? {} : undefined,
        },
      }),
      inject: [ConfigService],
    }),
    AuthModule,
    BooksModule,
    LibraryModule,
    OrdersModule,
    PaymentsModule,
    UploadModule,
  ],
  controllers: [HealthController],
})
export class AppModule {}