@echo off
setlocal
cd /d "%~dp0.."

if not exist ".env" (
    echo [AVISO] Arquivo .env nao encontrado. Rode scripts\instalar.bat primeiro.
    pause
    exit /b 1
)

if not exist "node_modules" (
    echo Instalando dependencias...
    call npm install
)

start "" http://localhost:3000
node index.js
pause
