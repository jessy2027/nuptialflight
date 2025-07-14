#!/bin/bash
set -e
echo "🚀 Starting Full Backend Deployment with Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Error: 'docker-compose' is not installed. Please install it to continue."
    exit 1
fi
if [ ! -f "assets/.env" ]; then
    echo "⚠️ Warning: 'assets/.env' not found. Creating from example."
    cp assets/env.example assets/.env
    echo "🛑 Please edit 'assets/.env' with your passwords and keys, then run again."
    exit 1
fi
if [ ! -f "tiles/*.mbtiles" ]; then
    echo "⚠️ Warning: No map data found in 'tiles/' folder."
    echo "   Please download an .mbtiles file and place it there. See tiles/README.md"
fi

echo "🐳 Building and starting services in detached mode..."
docker-compose up --build -d
echo "✅ Backend services are starting."
echo "   -> ArangoDB: http://localhost:8530"
echo "   -> CORS Proxy: http://localhost:3000"
echo "   -> Tile Server: http://localhost:8080"
echo "   To view logs, run: docker-compose logs -f"
echo "   To stop services, run: docker-compose down" 