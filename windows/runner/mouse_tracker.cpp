#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <chrono>
#include <thread>

extern "C" {
    __declspec(dllexport) void StartMouseTracking();
    __declspec(dllexport) void StopMouseTracking();
    __declspec(dllexport) BOOL GetCursorPosition(int* x, int* y);
    __declspec(dllexport) void SimulateMouseClick(int x, int y);
    __declspec(dllexport) void SimulateKeyPress(const char* keys);
}

static HHOOK mouseHook = NULL;
static int lastMouseX = 0;
static int lastMouseY = 0;
static bool tracking = false;

LRESULT CALLBACK MouseProc(int nCode, WPARAM wParam, LPARAM lParam) {
    if (nCode >= 0 && tracking) {
        if (wParam == WM_LBUTTONDOWN) {
            MSLLHOOKSTRUCT* mouseStruct = (MSLLHOOKSTRUCT*)lParam;
            lastMouseX = mouseStruct->pt.x;
            lastMouseY = mouseStruct->pt.y;
            tracking = false;
        }
    }
    return CallNextHookEx(mouseHook, nCode, wParam, lParam);
}

void StartMouseTracking() {
    if (!tracking) {
        tracking = true;
        mouseHook = SetWindowsHookEx(WH_MOUSE_LL, MouseProc, GetModuleHandle(NULL), 0);
    }
}

void StopMouseTracking() {
    if (mouseHook) {
        UnhookWindowsHookEx(mouseHook);
        mouseHook = NULL;
    }
    tracking = false;
}

BOOL GetCursorPosition(int* x, int* y) {
    POINT point;
    if (GetCursorPos(&point)) {
        *x = point.x;
        *y = point.y;
        return TRUE;
    }
    return FALSE;
}

void SimulateMouseClick(int x, int y) {
    // Move cursor to position
    SetCursorPos(x, y);
    
    // Press down
    mouse_event(MOUSEEVENTF_LEFTDOWN, x, y, 0, 0);
    std::this_thread::sleep_for(std::chrono::milliseconds(10));
    
    // Release
    mouse_event(MOUSEEVENTF_LEFTUP, x, y, 0, 0);
}

void SimulateKeyPress(const char* keys) {
    // Simple implementation - you might want to use SendInput for more complex scenarios
    for (int i = 0; keys[i] != '\0'; i++) {
        SHORT vk = VkKeyScanA(keys[i]);
        if (vk != -1) {
            BYTE vkCode = LOBYTE(vk);
            BYTE shiftState = HIBYTE(vk);
            
            if (shiftState & 1) { // Shift key
                keybd_event(VK_SHIFT, 0, 0, 0);
            }
            
            keybd_event(vkCode, 0, 0, 0);
            std::this_thread::sleep_for(std::chrono::milliseconds(10));
            keybd_event(vkCode, 0, KEYEVENTF_KEYUP, 0);
            
            if (shiftState & 1) {
                keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
            }
        }
    }
}