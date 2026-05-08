import { Injectable } from '@nestjs/common';

@Injectable()
export class PaymentsService {
  async initiatePayment(orderId: string, amount: number, method: string) {
    // MOCK: In production replace with real Payme/Click
    const mockTransactionId = `mock_${Date.now()}_${orderId}`;
    return {
      success: true,
      transactionId: mockTransactionId,
      paymentUrl: `http://localhost:3000/api/v1/payments/mock-pay?orderId=${orderId}&amount=${amount}`,
      message: 'Mock payment initialized (local dev only)'
    };
  }

  async verifyPayment(transactionId: string) {
    // MOCK: Always returns paid
    return {
      success: true,
      status: 'paid',
      transactionId
    };
  }
}
