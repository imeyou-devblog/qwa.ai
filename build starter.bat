@echo off
chcp 65001 >nul
echo Запуск тамагочи без консоли...

:: Собираем приложение
echo Сборка приложения...
set PATH=%PATH%;C:\games\flutter_windows_3.35.3-stable\flutter\bin
flutter build windows --release
echo Тамагочи забилдился! Консоль закроется через 3 секунды...
timeout /t 3 /nobreak >nul
exit