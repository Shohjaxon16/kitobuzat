# KitobJoy: Production-Ready Integration Walkthrough

Ushbu hujjat loyihani backend va frontend qismlarini to'liq birlashtirish hamda Railway platformasiga joylashtirish bo'yicha yo'riqnomadir.

## 1. Backend: Production Sozlamalari
Backend endi dinamik konfiguratsiyaga ega (`ConfigModule`). Bu Railway va Docker muhitlari uchun juda muhim.

### Muhim fayllar:
- `src/config/configuration.ts`: Barcha muhit o'zgaruvchilarini boshqaradi.
- `railway.json`: Railway'da avtomatik build va deploy qilish uchun.
- `src/health/health.controller.ts`: Server holatini kuzatish uchun endpoint (`/api/v1/health`).

### Local ishga tushirish:
```bash
cd kitobuzat-backend
npm install
docker-compose up -d
npm run seed
npm run start:dev
```

## 2. Frontend: API Integratsiyasi
Flutter ilovasi endi backend bilan `ApiService` orqali muloqot qiladi.

### Yangilangan oqim:
- **Auth**: `AuthProvider` orqali login va registratsiya. Tokenlar `SharedPreferences`da saqlanadi.
- **Home**: `BooksProvider` orqali kitoblar va kategoriyalar real vaqtda bazadan olinadi.
- **Library**: `LibraryProvider` foydalanuvchi kitoblari va o'qish jarayonini boshqaradi.

## 3. Railway Deployment (Qisqa qadamlar)
1. **GitHub**: Kodni GitHub'ga push qiling.
2. **Railway Project**: Railway'da yangi loyiha yarating va reponi bog'lang.
3. **Database**: "New Service" -> "Database" -> "PostgreSQL" qo'shing.
4. **Redis**: "New Service" -> "Database" -> "Redis" qo'shing.
5. **Variables**: `railway-env-guide.txt` ichidagi o'zgaruvchilarni Railway konsoliga nusxalang.

## 4. Muhim Eslatmalar
- **SSL**: Production'da PostgreSQL ulanishi uchun SSL avtomatik yoqiladi.
- **CORS**: Faqat `kitobuzat.uz` domeniga ruxsat berilgan (Production rejimida).
- **Validation**: Barcha requestlar `ValidationPipe` orqali tekshiriladi (Xavfsizlik uchun).

---
✅ **Loyiha endi to'liq integratsiya qilingan va jonli efirga (Live) chiqishga tayyor!**
