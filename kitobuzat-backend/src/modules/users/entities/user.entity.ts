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