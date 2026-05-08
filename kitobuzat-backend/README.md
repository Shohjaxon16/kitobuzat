# KitobJoy Backend API

## Local Development
1. docker-compose up -d
2. npm install
3. cp .env.example .env
4. npm run seed
5. npm run start:dev

## Deploy to Railway
1. Push to GitHub
2. Connect repo to Railway
3. Add PostgreSQL and Redis plugins
4. Set environment variables (see railway-env-guide.txt)
5. Railway auto-deploys on every push

## API Docs
- Local: http://localhost:3000/api/docs
- Health: http://localhost:3000/api/v1/health
