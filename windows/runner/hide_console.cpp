#include <windows.h>

#ifdef _DEBUG
// В debug режиме оставляем консоль
int main() {
    return 0;
}
#else
// В release режиме скрываем консоль
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, 
                   LPSTR lpCmdLine, int nCmdShow) {
    // Скрываем консольное окно
    FreeConsole();
    
    // Запускаем основное приложение
    return main();
}
#endif