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
  @Column({ default: false }) isFeatured: boolean;
  @ManyToOne(() => BookCategory, c => c.books) category: BookCategory;
  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}