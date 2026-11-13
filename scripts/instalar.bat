@echo off
setlocal
cd /d "%~dp0.."

echo ==============================================
echo  Instalador - Catalogo JoJo (MySQL + Node.js)
echo ==============================================
echo.

where node >nul 2>nul
if errorlevel 1 (
    echo [ERRO] Node.js nao encontrado. Instale em https://nodejs.org e rode de novo.
    pause
    exit /b 1
)

set "MYSQLBIN=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
if not exist "%MYSQLBIN%" (
    set /p MYSQLBIN=Caminho completo do mysql.exe: 
)
if not exist "%MYSQLBIN%" (
    echo [ERRO] mysql.exe nao encontrado nesse caminho.
    pause
    exit /b 1
)

set /p MYSQLUSER=Usuario do MySQL [root]: 
if "%MYSQLUSER%"=="" set "MYSQLUSER=root"

set /p MYSQLPW=Senha do MySQL: 

> .env echo MYSQL_HOST=localhost
>> .env echo MYSQL_PORT=3306
>> .env echo MYSQL_USER=%MYSQLUSER%
>> .env echo MYSQL_PASSWORD=%MYSQLPW%
>> .env echo MYSQL_DATABASE=jojo_db
echo.
echo Arquivo .env criado.

echo.
echo Importando o banco (isso RECRIA as tabelas do jojo_db)...
set "MYSQL_PWD=%MYSQLPW%"
"%MYSQLBIN%" --user=%MYSQLUSER% --default-character-set=utf8mb4 < "sql\banco_jojo_completo.sql"
if errorlevel 1 (
    echo.
    echo [ERRO] Falha ao importar o banco. Confira usuario e senha do MySQL.
    pause
    exit /b 1
)
set "MYSQL_PWD="

echo.
echo Instalando dependencias (npm install)...
call npm install
if errorlevel 1 (
    echo [ERRO] npm install falhou.
    pause
    exit /b 1
)

echo.
echo Tudo pronto. Rode scripts\rodar.bat para iniciar o site.
pause
