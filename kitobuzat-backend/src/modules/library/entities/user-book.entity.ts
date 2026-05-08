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