import { IsEmail, IsString, MinLength, Matches, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RegisterDto {
  @ApiProperty({ example: 'test@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'StrongPass1!' })
  @IsString()
  @MinLength(8)
  @Matches(/((?=.*\\d)|(?=.*\\W+))(?![.\\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message: "Parol kamida 8 ta belgi, 1 ta katta harf va 1 ta raqam/belgidan iborat bo'lishi kerak",
  })
  password: string;

  @ApiProperty({ example: 'Eshmat Toshmatov' })
  @IsString()
  @IsNotEmpty()
  fullName: string;
}
