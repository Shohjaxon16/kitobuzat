import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from './entities/order.entity';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order)
    private ordersRepository: Repository<Order>,
  ) {}

  async confirmPayment(orderId: string, transactionId: string) {
    console.log(`Payment confirmed for order: ${orderId}, transaction: ${transactionId}`);
    return { success: true };
    // MOCK: In a real app we update DB here
    // await this.ordersRepository.update(orderId, { status: 'paid', transactionId });
  }
}
