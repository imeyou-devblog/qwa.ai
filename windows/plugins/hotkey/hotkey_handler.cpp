#include "hotkey_handler.h"
#include <iostream>

HotkeyHandler* HotkeyHandler::instance_ = nullptr;

HotkeyHandler::HotkeyHandler() : hwnd_(nullptr), hotkeyCallback_(nullptr) {
    // Создаем невидимое окно для обработки сообщений
    WNDCLASS wc = {};
    wc.lpfnWndProc = WndProc;
    wc.hInstance = GetModuleHandle(nullptr);
    wc.lpszClassName = L"FlutterHotkeyWindow";
    wc.hCursor = nullptr;
    wc.hbrBackground = nullptr;
    
    RegisterClass(&wc);
    
    hwnd_ = CreateWindow(
        wc.lpszClassName,
        L"Flutter Hotkey Handler",
        0, 0, 0, 0, 0,
        HWND_MESSAGE, nullptr, wc.hInstance, nullptr
    );
    
    if (!hwnd_) {
        std::cerr << "Failed to create hotkey window" << std::endl;
    }
}

HotkeyHandler* HotkeyHandler::GetInstance() {
    if (!instance_) {
        instance_ = new HotkeyHandler();
    }
    return instance_;
}

bool HotkeyHandler::RegisterHotKey(int id, UINT modifier, UINT key) {
    if (!hwnd_) {
        std::cerr << "Hotkey window not initialized" << std::endl;
        return false;
    }
    
    // Удаляем предыдущую регистрацию если есть
    if (registeredHotkeys_[id]) {
        ::UnregisterHotKey(hwnd_, id);
    }
    
    // Регистрируем горячую клавишу
    BOOL result = ::RegisterHotKey(hwnd_, id, modifier, key);
    if (result) {
        registeredHotkeys_[id] = true;
        std::cout << "Registered hotkey: id=" << id 
                  << ", modifier=" << modifier 
                  << ", key=" << key << std::endl;
    } else {
        DWORD error = GetLastError();
        std::cerr << "Failed to register hotkey: id=" << id 
                  << ", error=" << error << std::endl;
    }
    
    return result;
}

void HotkeyHandler::UnregisterHotKey(int id) {
    if (hwnd_) {
        ::UnregisterHotKey(hwnd_, id);
        registeredHotkeys_[id] = false;
    }
}

void HotkeyHandler::UnregisterAll() {
    if (!hwnd_) return;
    
    for (auto& pair : registeredHotkeys_) {
        if (pair.second) {
            ::UnregisterHotKey(hwnd_, pair.first);
            pair.second = false;
        }
    }
    registeredHotkeys_.clear();
}

void HotkeyHandler::SetHotkeyCallback(void(*callback)(int)) {
    hotkeyCallback_ = callback;
}

HotkeyHandler::~HotkeyHandler() {
    UnregisterAll();
    if (hwnd_) {
        DestroyWindow(hwnd_);
        hwnd_ = nullptr;
    }
}

LRESULT CALLBACK HotkeyHandler::WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
        case WM_HOTKEY: {
            int hotkeyId = static_cast<int>(wParam);
            std::cout << "Hotkey pressed: id=" << hotkeyId << std::endl;
            
            // Вызываем callback если он установлен
            if (instance_ && instance_->hotkeyCallback_) {
                instance_->hotkeyCallback_(hotkeyId);
            }
            return 0;
        }
        
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
            
        default:
            return DefWindowProc(hwnd, msg, wParam, lParam);
    }
}