@echo off
chcp 65001 > nul

if "%~1"=="" (
    echo Перетащите ZIP-файл на этот скрипт
    echo.
    pause
    exit /b
)

set "ARCHIVE=%~1"
set "DIR=%~dp1"
set "FILENAME=%~nx1"

echo Обрабатываю: %FILENAME%
echo.

:: 1. Получаем размер в байтах
for %%F in ("%ARCHIVE%") do set "SIZE=%%~zF"
echo Размер: %SIZE% байт

:: 2. Вычисляем SHA256
echo Вычисляю SHA256...
powershell -Command "Get-FileHash '%ARCHIVE%' -Algorithm SHA256 | Select-Object -ExpandProperty Hash" > "%DIR%temp_hash.txt"

set /p HASH=<"%DIR%temp_hash.txt"
del "%DIR%temp_hash.txt"

:: Приводим к нижнему регистру
powershell -Command "'%HASH%'.ToLower()" > "%DIR%temp_hash.txt"
set /p HASH=<"%DIR%temp_hash.txt"
del "%DIR%temp_hash.txt"

echo SHA256: %HASH%

:: 3. Записываем в checksum.sha256
echo %HASH% > "%DIR%checksum.sha256"
echo.
echo checksum.sha256 создан

:: 4. Показываем JSON для version.json
echo.
echo =================================
echo ДАННЫЕ ДЛЯ version.json:
echo =================================
echo "size_bytes": %SIZE%
echo "checksum": "%HASH%"
echo.

pause