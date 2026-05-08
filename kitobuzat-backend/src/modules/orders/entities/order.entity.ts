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