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