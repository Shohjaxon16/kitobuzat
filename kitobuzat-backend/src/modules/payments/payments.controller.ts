import { Controller, Get, Query } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { PaymentsService } from './payments.service';
import { OrdersService } from '../orders/orders.service';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('payments')
@Controller('payments')
export class PaymentsController {
  constructor(
    private readonly paymentsService: PaymentsService,
    private readonly ordersService: OrdersService
  ) {}

  @Public()
  @Get('mock-pay')
  async mockPay(@Query('orderId') orderId: string, @Query('amount') amount: string) {
    await this.ordersService.confirmPayment(orderId, `mock_${Date.now()}`);
    return {
      success: true,
      message: "✅ Mock to'lov muvaffaqiyatli! Order: " + orderId + ", Summa: " + amount + " so'm",
      html: `<html><body style="font-family:sans-serif;text-align:center;padding:40px">
        <h2 style="color:green">✅ To'lov muvaffaqiyatli!</h2>
        <p>Buyurtma: ${orderId}</p>
        <p>Summa: ${amount} so'm</p>
        <p>Endi ilovaga qayting</p>
      </body></html>`
    };
  }
}
