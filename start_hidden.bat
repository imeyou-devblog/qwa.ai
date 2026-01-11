@echo off
chcp 65001 >nul
echo Запуск тамагочи без консоли...

:: Собираем приложение
echo Сборка приложения...
flutter build windows --release

:: Запускаем без консоли
echo Запуск приложения...
start /B "ImeYou Tamagochi" build\windows\x64\runner\Release\imeyou_pet.exe

echo Тамагочи запущен! Консоль закроется через 3 секунды...
timeout /t 3 /nobreak >nul
exit