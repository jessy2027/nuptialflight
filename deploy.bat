@echo off
setlocal
ECHO 🚀 Starting Full Backend Deployment with Docker Compose...

docker-compose --version >nul 2>nul
if %errorlevel% neq 0 (
    ECHO ❌ Error: 'docker-compose' is not installed or not in your PATH. Please install it.
    goto :eof
)
if not exist "assets\.env" (
    ECHO ⚠️ Warning: 'assets\.env' not found. Creating from example.
    copy "assets\env.example" "assets\.env" >nul
    ECHO 🛑 Please edit 'assets\.env' with your passwords and keys, then run again.
    goto :eof
)
if not exist "tiles\*.mbtiles" (
    ECHO ⚠️ Warning: No map data found in 'tiles\' folder.
    ECHO    Please download an .mbtiles file and place it there. See tiles\README.md
)

ECHO 🐳 Building and starting services in detached mode...
docker-compose up --build -d

ECHO.
ECHO ✅ Backend services are starting.
ECHO    -> ArangoDB: http://localhost:8530
ECHO    -> CORS Proxy: http://localhost:3000
ECHO    -> Tile Server: http://localhost:8080
ECHO.
ECHO To view logs, run: "docker-compose logs -f"
ECHO To stop services, run: "docker-compose down"
endlocal 