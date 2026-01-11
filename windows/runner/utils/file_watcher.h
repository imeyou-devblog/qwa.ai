#pragma once
#include <windows.h>
#include <functional>
#include <string>
#include <vector>

class FileOpenedListener {
public:
    FileOpenedListener();
    ~FileOpenedListener();
    
    void startListening();
    void stopListening();
    void setCallback(std::function<void(std::string)> callback);
    
private:
    static LRESULT CALLBACK shellHookProc(int nCode, WPARAM wParam, LPARAM lParam);
    static FileOpenedListener* instance;
    std::function<void(std::string)> fileOpenedCallback;
    HHOOK shellHook;
};