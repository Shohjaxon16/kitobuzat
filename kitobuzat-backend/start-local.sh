#!/bin/bash
echo "Starting KitobJoy Backend Local Dev (Bash)..."
echo ""

echo "[1/4] Starting Docker services..."
docker-compose up -d

echo ""
echo "[2/4] Waiting for DB to be ready..."
sleep 5

echo ""
echo "[3/4] Installing dependencies..."
npm install

echo ""
echo "[4/4] Seeding database..."
npm run seed

echo ""
echo "✅ Setup complete!"
echo ""
echo "Starting server..."
npm run start:dev
