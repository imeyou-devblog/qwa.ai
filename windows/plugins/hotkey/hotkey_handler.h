#pragma once

#include <windows.h>
#include <map>
#include <memory>

class HotkeyHandler {
public:
    static HotkeyHandler* GetInstance();
    
    bool RegisterHotKey(int id, UINT modifier, UINT key);
    void UnregisterHotKey(int id);
    void UnregisterAll();
    ~HotkeyHandler();

    // Метод для установки callback функции когда горячая клавиша нажата
    void SetHotkeyCallback(void(*callback)(int));

private:
    HotkeyHandler();
    static LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
    
    HWND hwnd_;
    static HotkeyHandler* instance_;
    std::map<int, bool> registeredHotkeys_;
    void(*hotkeyCallback_)(int) = nullptr;
};