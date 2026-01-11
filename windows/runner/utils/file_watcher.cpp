#include "file_watcher.h"
#include <iostream>
#include <psapi.h>

FileOpenedListener* FileOpenedListener::instance = nullptr;

FileOpenedListener::FileOpenedListener() : shellHook(nullptr) {
    instance = this;
}

FileOpenedListener::~FileOpenedListener() {
    stopListening();
}

LRESULT CALLBACK FileOpenedListener::shellHookProc(int nCode, WPARAM wParam, LPARAM lParam) {
    if (nCode == HSHELL_REDRAW || nCode == HSHELL_WINDOWCREATED) {
        HWND hwnd = (HWND)wParam;
        if (hwnd) {
            DWORD processId;
            GetWindowThreadProcessId(hwnd, &processId);
            
            HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, processId);
            if (hProcess) {
                char exePath[MAX_PATH];
                if (GetModuleFileNameExA(hProcess, NULL, exePath, MAX_PATH)) {
                    if (instance && instance->fileOpenedCallback) {
                        instance->fileOpenedCallback(std::string(exePath));
                    }
                }
                CloseHandle(hProcess);
            }
        }
    }
    return CallNextHookEx(NULL, nCode, wParam, lParam);
}

void FileOpenedListener::startListening() {
    shellHook = SetWindowsHookEx(WH_SHELL, shellHookProc, NULL, GetCurrentThreadId());
}

void FileOpenedListener::stopListening() {
    if (shellHook) {
        UnhookWindowsHookEx(shellHook);
        shellHook = nullptr;
    }
}

void FileOpenedListener::setCallback(std::function<void(std::string)> callback) {
    fileOpenedCallback = callback;