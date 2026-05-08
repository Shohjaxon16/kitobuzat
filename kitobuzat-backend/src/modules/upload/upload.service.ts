import { Injectable } from '@nestjs/common';
import * as fs from 'fs';

@Injectable()
export class UploadService {
  async uploadFile(file: Express.Multer.File): Promise<string> {
    if (process.env.NODE_ENV === 'development') {
      // Save locally
      const uploadDir = './uploads';
      if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });
      const fileName = `${Date.now()}-${file.originalname}`;
      fs.writeFileSync(`${uploadDir}/${fileName}`, file.buffer);
      return `http://localhost:3000/uploads/${fileName}`;
    }
    // Production: use real S3
    return this.uploadToS3(file);
  }

  private async uploadToS3(file: Express.Multer.File): Promise<string> {
    // S3 Mock logic for now
    return `https://s3.amazonaws.com/kitobuzat-files/${file.originalname}`;
  }
}
