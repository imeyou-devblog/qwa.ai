#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>
#include <memory>
#include <gdiplus.h>
#include <vector>
#include "flutter_window.h"
#include "utils.h"
#include <fstream>
#include <flutter/plugin_registrar_windows.h>
#include <sstream>
#include <string>
#include <shlobj.h>
// ZXing
#include "3dparty/zxing/ReadBarcode.h"
#include "3dparty/zxing/BarcodeFormat.h"
#include "3dparty/zxing/TextUtfEncoding.h"
#include "3dparty/zxing/ImageView.h"
#include "3dparty/zxing/Result.h"
#include "3dparty/zxing/ReaderOptions.h"
//#include <opencv2/opencv.hpp>
//#include <onnxruntime_cxx_api.h>
#include <codecvt>
#include <chrono>
#include <thread>
#include <atomic>
#include <mutex>
#include <cstdio>
#include <regex>

#include <stdexcept>
#include <array>
#include <iomanip>
#include <UIAutomation.h>

#include <shlobj.h>
#include <shobjidl.h>
#include <oleidl.h>
#include <comdef.h>
#include <shellapi.h>

#include "plugins/hotkey/hotkey_plugin.h"
// Для работы с JSON (если нужно)
#pragma comment(lib, "ole32.lib")
#pragma comment(lib, "shell32.lib")
#include <shlobj.h>
#include <exdisp.h>
#include <shldisp.h>
#include <comdef.h>

#pragma comment(lib, "gdiplus.lib")

using namespace Gdiplus;
#include <shellapi.h> // Для SHGetFileInfo
#include <commctrl.h> // Для HIMAGELIST
#include <iomanip>
#include <sstream>

#include <iomanip>
#include <sstream>
#include <shellapi.h>
#include <appmodel.h>
#include <wrl.h>
#include "file_drag_drop_plugin.h"
HWND g_mainWindow = nullptr;
HWND g_flutterWindow = nullptr;
WNDPROC g_originalWndProc = nullptr;
WNDPROC g_flutterOriginalWndProc = nullptr;

bool g_isFullClickable = false;
bool g_isSubclassInitialized = false;
bool g_isCurrentlyExpanded = false;

#define TIMER_CHECK_MOUSE 1001

#ifndef GET_X_LPARAM
#define GET_X_LPARAM(lp) ((int)(short)LOWORD(lp))
#endif

#ifndef GET_Y_LPARAM
#define GET_Y_LPARAM(lp) ((int)(short)HIWORD(lp))
#endif

void UpdateClickableRegion(bool inside)
{
    if (!g_mainWindow)
        return;

    bool shouldExpand = g_isFullClickable || inside;
    
    // Обновляем только если состояние изменилось
    if (shouldExpand == g_isCurrentlyExpanded)
        return;
    
    g_isCurrentlyExpanded = shouldExpand;

    RECT rc;
    GetClientRect(g_mainWindow, &rc);

    if (shouldExpand)
    {
        // Полная кликабельность или курсор в зоне - полное окно видимо
        SetWindowRgn(g_mainWindow, NULL, FALSE);
        InvalidateRect(g_mainWindow, NULL, TRUE);
        
     
    }
    else
    {
        // Вне зоны - видим только 120×120 по центру внизу
        int zoneLeft = (rc.right - 120) / 2;
        int zoneTop = rc.bottom - 120;
        
        HRGN hRgn = CreateRectRgn(zoneLeft, zoneTop, zoneLeft + 120, rc.bottom);
        SetWindowRgn(g_mainWindow, hRgn, FALSE);
        InvalidateRect(g_mainWindow, NULL, TRUE);
    }
}

// Subclass процедура для Flutter child window
LRESULT CALLBACK FlutterSubclassProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    return CallWindowProc(g_flutterOriginalWndProc, hwnd, msg, wParam, lParam);
}

// Subclass процедура для главного окна
LRESULT CALLBACK MainWindowSubclassProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch (msg)
    {
        case WM_TIMER:
        {
            if (wParam == TIMER_CHECK_MOUSE)
            {
                if (!g_isFullClickable)
                {
                    POINT pt;
                    if (GetCursorPos(&pt))
                    {
                        ScreenToClient(hwnd, &pt);

                        RECT rc;
                        GetClientRect(hwnd, &rc);

                        int zoneLeft = (rc.right - 80) / 2;
                        int zoneTop = rc.bottom - 80;
                        int zoneRight = zoneLeft + 80;
                        int zoneBottom = zoneTop + 80;

                        bool inside = (pt.x >= zoneLeft && pt.x <= zoneRight &&
                                       pt.y >= zoneTop  && pt.y <= zoneBottom);

                        UpdateClickableRegion(inside);
                    }
                    else
                    {
                        UpdateClickableRegion(false);
                    }
                }
                return 0;
            }
            break;
        }
        
        case WM_NCPAINT:
        case WM_NCACTIVATE:
        {
            // Блокируем отрисовку non-client области (рамки)
            return 0;
        }

        case WM_DESTROY:
        {
            KillTimer(hwnd, TIMER_CHECK_MOUSE);
            break;
        }
    }

    return CallWindowProc(g_originalWndProc, hwnd, msg, wParam, lParam);
}

void activateFullClick() {
    g_isFullClickable = true;
    UpdateClickableRegion(true);
}

void returnTo80x80Clickable() {
    g_isFullClickable = false;
    UpdateClickableRegion(false);
}

// Callback для поиска Flutter child window
BOOL CALLBACK EnumChildProc(HWND hwnd, LPARAM lParam)
{
    char className[256];
    GetClassNameA(hwnd, className, sizeof(className));
    
    // Flutter использует класс "FLUTTERVIEW"
    if (strcmp(className, "FLUTTERVIEW") == 0)
    {
        g_flutterWindow = hwnd;
        return FALSE;
    }
    
    return TRUE;
}

void InitializeClickThrough()
{
    if (!g_mainWindow || g_isSubclassInitialized)
        return;

    g_isSubclassInitialized = true;

    // Subclass главного окна
    g_originalWndProc = (WNDPROC)GetWindowLongPtr(g_mainWindow, GWLP_WNDPROC);
    SetWindowLongPtr(g_mainWindow, GWLP_WNDPROC, (LONG_PTR)MainWindowSubclassProc);

    // Ищем Flutter child window
    EnumChildWindows(g_mainWindow, EnumChildProc, 0);

    // Subclass Flutter окна
    if (g_flutterWindow)
    {
        g_flutterOriginalWndProc = (WNDPROC)GetWindowLongPtr(g_flutterWindow, GWLP_WNDPROC);
        SetWindowLongPtr(g_flutterWindow, GWLP_WNDPROC, (LONG_PTR)FlutterSubclassProc);
    }

    // Изначально устанавливаем регион 120×120 по центру, прилипший к низу
    RECT rc;
    GetClientRect(g_mainWindow, &rc);
    int zoneLeft = (rc.right - 120) / 2;
    int zoneTop = rc.bottom - 120;
    
    HRGN hRgn = CreateRectRgn(zoneLeft, zoneTop, zoneLeft + 120, rc.bottom);
    SetWindowRgn(g_mainWindow, hRgn, FALSE);
    
    g_isCurrentlyExpanded = false;

    // Запускаем таймер каждые 100ms
    SetTimer(g_mainWindow, TIMER_CHECK_MOUSE, 100, NULL);
}



static HWND g_flutterHwnd = nullptr;
class FocusInfoHandler {
public:
    static void GetFocusInfo(std::string& result) {
        auto WriteLog = [](const std::string& message) {
            PWSTR documentsPath = nullptr;
            if (SUCCEEDED(SHGetKnownFolderPath(FOLDERID_Documents, 0, NULL, &documentsPath))) {
                char narrowPath[MAX_PATH];
                WideCharToMultiByte(CP_UTF8, 0, documentsPath, -1, narrowPath, MAX_PATH, NULL, NULL);
                
                std::string logPath = std::string(narrowPath) + "\\getselection_log.txt";
                FILE* logFile = nullptr;
                fopen_s(&logFile, logPath.c_str(), "a");
                if (logFile) {
                    fprintf(logFile, "%s\n", message.c_str());
                    fclose(logFile);
                }
                CoTaskMemFree(documentsPath);
            }
            printf("%s\n", message.c_str());
        };

    try {
        HWND foregroundWindow = GetForegroundWindow();
        if (!foregroundWindow) {
            result = "{\"error\": \"No foreground window\"}";
            WriteLog(result);
            return;
        }

        char className[256];
        GetClassNameA(foregroundWindow, className, sizeof(className));
        std::string windowClass = className;
        WriteLog("Foreground window class: " + windowClass);

        // Сначала проверяем рабочий стол
        if (windowClass == "Progman" || windowClass == "WorkerW") {
            std::string desktopFiles = GetSelectedFilesOnDesktop();
            if (!desktopFiles.empty()) {
                result = "{\"isFileSelection\": true, \"isTextSelection\": false, \"selectedPath\": \"" + EscapeJsonString(desktopFiles) + "\"}";
                WriteLog("Desktop file selection detected: " + desktopFiles);
                return;
            } else {
                WriteLog("No desktop files found");
            }
        }

        // Затем проверяем выделенные файлы в проводнике
        std::string filePaths = GetSelectedFilesInExplorer();
        if (!filePaths.empty()) {
            result = "{\"isFileSelection\": true, \"isTextSelection\": false, \"selectedPath\": \"" + EscapeJsonString(filePaths) + "\"}";    
            WriteLog("Explorer file selection detected: " + filePaths);
            return;
        } else {
            WriteLog("No explorer files found");
        }
std::string selectedText = GetSelectedTextAdvanced();

if (!selectedText.empty() && selectedText.length() > 0) {
    WriteLog("Raw selected text length: " + std::to_string(selectedText.length()));
    
    // Проверяем, не является ли текст путем к файлу
    std::wstring wideText = UTF8ToWide(selectedText);
    bool isFile = IsFilePath(wideText);
    WriteLog("IsFilePath result: " + std::string(isFile ? "true" : "false"));
    
    if (!isFile) {
        result = "{\"isFileSelection\": false, \"isTextSelection\": true, \"selectedText\": \"" + EscapeJsonString(selectedText) + "\"}";
        WriteLog("Returning text selection");
        return;
    } else {
        WriteLog("Text is file path, skipping");
    }
}

        result = "{\"isFileSelection\": false, \"isTextSelection\": false}";
        WriteLog("No selection detected - final fallback");
    } catch (const std::exception& e) {
        result = "{\"error\": \"Exception: " + std::string(e.what()) + "\"}";
        WriteLog(result);
    }
}

private:
   static bool IsFilePath(const std::wstring& text) {
    if (text.length() < 3) { // Минимум "C:a"
        return false;
    }
    
    // Регулярные выражения для проверки путей
    std::wregex windowsPathRegex(L"^[A-Za-z]:\\\\[^/:*?\"<>|]+(\\\\[^/:*?\"<>|]+)*$");
   
    std::wregex urlRegex(L"^(https?|ftp)://.*$", std::regex_constants::icase);
    
    // Проверяем Windows путь (C:\folder\file.txt)
    if (std::regex_search(text, windowsPathRegex)) {
        WriteLog("IsFilePath: valid Windows path");
        return true;
    }
    
  
    
    // Проверяем URL (http, https, ftp)
    if (std::regex_search(text, urlRegex)) {
        WriteLog("IsFilePath: URL detected, not a file path");
        return false;
    }
    
    // Проверяем наличие запрещенных символов в путях
    std::wstring forbiddenChars = L"*?\"<>|";
    for (wchar_t c : forbiddenChars) {
        if (text.find(c) != std::wstring::npos) {
            return false;
        }
    }
    
    // Дополнительные проверки
    bool hasDriveLetter = text.length() >= 2 && text[1] == L':' && iswalpha(text[0]);
    bool hasMultipleSlashes = std::count(text.begin(), text.end(), L'\\') > 1;
    bool hasValidExtension = text.find(L".exe") != std::wstring::npos ||
                            text.find(L".dll") != std::wstring::npos ||
                            text.find(L".txt") != std::wstring::npos ||
                            text.find(L".doc") != std::wstring::npos ||
                            text.find(L".pdf") != std::wstring::npos;
    
    // Только если есть буква диска И несколько слешей ИЛИ валидное расширение
    if ((hasDriveLetter && hasMultipleSlashes) || (hasDriveLetter && hasValidExtension)) {
        WriteLog("IsFilePath: complex path check passed");
        return true;
    }
    
    return false;
}

    static std::string EscapeJsonString(const std::string& str) {
        std::stringstream ss;
        for (char c : str) {
            switch (c) {
                case '"': ss << "\\\""; break;
                case '\\': ss << "\\\\"; break;
                case '\b': ss << "\\b"; break;
                case '\f': ss << "\\f"; break;
                case '\n': ss << "\\n"; break;
                case '\r': ss << "\\r"; break;
                case '\t': ss << "\\t"; break;
                default: 
                    if (static_cast<unsigned char>(c) < 32 || c == 127) {
                        // Escape control characters
                        char hex[10];
                        snprintf(hex, sizeof(hex), "\\u%04x", static_cast<unsigned char>(c));
                        ss << hex;
                    } else {
                        ss << c;
                    }
                    break;
            }
        }
        return ss.str();
    }

    static std::string WideToUTF8(const std::wstring& wstr) {
        if (wstr.empty()) return {};
        int sizeNeeded = WideCharToMultiByte(CP_UTF8, 0, wstr.data(), (int)wstr.size(),
                                             nullptr, 0, nullptr, nullptr);
        if (sizeNeeded <= 0) return {};
        std::string strTo(sizeNeeded, 0);
        WideCharToMultiByte(CP_UTF8, 0, wstr.data(), (int)wstr.size(),
                            strTo.data(), sizeNeeded, nullptr, nullptr);
        return strTo;
    }

    static std::wstring UTF8ToWide(const std::string& str) {
        if (str.empty()) return {};
        int sizeNeeded = MultiByteToWideChar(CP_UTF8, 0, str.data(), (int)str.size(),
                                             nullptr, 0);
        if (sizeNeeded <= 0) return {};
        std::wstring wstrTo(sizeNeeded, 0);
        MultiByteToWideChar(CP_UTF8, 0, str.data(), (int)str.size(),
                            wstrTo.data(), sizeNeeded);
        return wstrTo;
    }
static std::string GetSelectedFilesOnDesktop() {
    std::string result;
    
    // Получаем окно рабочего стола
    HWND hDesktop = FindWindowW(L"Progman", nullptr);
    if (!hDesktop) {
        hDesktop = FindWindowW(L"WorkerW", nullptr);
    }
    
    if (hDesktop) {
        WriteLog("Desktop window found");
        
        // Ищем ListView рабочего стола
        HWND hShellView = FindWindowExW(hDesktop, nullptr, L"SHELLDLL_DefView", nullptr);
        if (hShellView) {
            WriteLog("ShellDLL_DefView found");
            
            HWND hListView = FindWindowExW(hShellView, nullptr, L"SysListView32", nullptr);
            if (hListView) {
                WriteLog("SysListView32 found");
                
                // Получаем количество выделенных элементов
                int itemCount = ListView_GetSelectedCount(hListView);
                WriteLog("Selected items count: " + std::to_string(itemCount));
                
                if (itemCount > 0) {
                    // Получаем все выделенные элементы
                    int index = -1;
                    while ((index = ListView_GetNextItem(hListView, index, LVNI_SELECTED)) != -1) {
                        wchar_t buffer[MAX_PATH] = {0};
                        
                        // Пробуем получить текст элемента
                        LVITEMW lvItem = {0};
                        lvItem.mask = LVIF_TEXT;
                        lvItem.iItem = index;
                        lvItem.pszText = buffer;
                        lvItem.cchTextMax = MAX_PATH;
                        
                        if (ListView_GetItem(hListView, &lvItem)) {
                            std::wstring itemText = buffer;
                            if (!itemText.empty()) {
                                WriteLog("Desktop item: " + WideToUTF8(itemText));
                                
                                // Получаем полный путь через Desktop folder
                                std::wstring desktopPath = GetDesktopPath();
                                if (!desktopPath.empty()) {
                                    std::wstring fullPath = desktopPath + L"\\" + itemText;
                                    if (!result.empty()) result += "|";
                                    result += WideToUTF8(fullPath);
                                    WriteLog("Desktop file path: " + WideToUTF8(fullPath));
                                }
                            }
                        }
                    }
                }
            } else {
                WriteLog("SysListView32 not found");
            }
        } else {
            WriteLog("SHELLDLL_DefView not found");
        }
    } else {
        WriteLog("Desktop window not found");
    }
    
    return result;
}

static std::wstring GetDesktopPath() {
    wchar_t path[MAX_PATH];
    if (SUCCEEDED(SHGetFolderPathW(nullptr, CSIDL_DESKTOP, nullptr, 0, path))) {
        return path;
    }
    return L"";
}
static std::string GetSelectedTextAdvanced() {
    std::string result;
    
    // ПРОБУЕМ СНАЧАЛА РАБОТАЮЩИЙ CLIPBOARD METHOD
    result = GetSelectedTextViaClipboard();
    if (!result.empty()) {
        WriteLog("Clipboard method SUCCESS: " + std::to_string(result.length()));
        return result;
    }
    
    // ЕСЛИ CLIPBOARD НЕ СРАБОТАЛ, ПРОБУЕМ ДРУГИЕ МЕТОДЫ
    HWND hForeground = GetForegroundWindow();
    if (!hForeground) return result;
    
    GUITHREADINFO guiInfo = {0};
    guiInfo.cbSize = sizeof(GUITHREADINFO);
    
    DWORD foregroundThreadId = GetWindowThreadProcessId(hForeground, nullptr);
    if (GetGUIThreadInfo(foregroundThreadId, &guiInfo)) {
        HWND hFocused = guiInfo.hwndFocus;
        if (!hFocused) hFocused = hForeground;
        
        char className[256];
        GetClassNameA(hFocused, className, sizeof(className));
        WriteLog("Trying control method, class: " + std::string(className));
        
        result = GetTextFromControl(hFocused, className);
    }
    
    return result;
}

static std::string GetSelectedTextViaClipboard() {
    std::string result;
    
    // Сохраняем оригинальный буфер обмена
    std::string originalClipboard = GetClipboardText();
    WriteLog("CLIPBOARD METHOD START - Original length: " + std::to_string(originalClipboard.length()));
    
    // Пробуем несколько раз с разными задержками (как раньше, когда работало)
    for (int attempt = 0; attempt < 5; attempt++) {
        WriteLog("Clipboard attempt " + std::to_string(attempt + 1));
        
        if (SimulateCopy()) {
            // Увеличиваем задержки для надежности
            if (attempt == 0) Sleep(100);
            else if (attempt == 1) Sleep(150);
            else Sleep(200);
            
            std::string newClipboard = GetClipboardText();
            WriteLog("Attempt " + std::to_string(attempt + 1) + " - New clipboard length: " + std::to_string(newClipboard.length()));
            
            // УСЛОВИЕ ПРОЩЕ: если есть новый текст и он отличается от оригинала
            if (!newClipboard.empty() && newClipboard != originalClipboard) {
                WriteLog("CLIPBOARD CONTENT CHANGED!");
                
                // Минимальная проверка - не слишком длинный текст
                if (newClipboard.length() < 100000) {
                    result = newClipboard;
                    WriteLog("CLIPBOARD SUCCESS - Text captured, length: " + std::to_string(result.length()));
                    break;
                }
            }
        }
        
        // Небольшая пауза между попытками
        if (attempt < 4) Sleep(50);
    }
    
    // ВОССТАНАВЛИВАЕМ ОРИГИНАЛЬНЫЙ БУФЕР
    if (!originalClipboard.empty()) {
        if (SetClipboardText(originalClipboard)) {
            WriteLog("Original clipboard restored");
        } else {
            WriteLog("Failed to restore original clipboard");
        }
    }
    
    return result;
}

// УПРОЩЕННАЯ ФУНКЦИЯ ДЛЯ КОНТРОЛОВ
static std::string GetTextFromControl(HWND hWnd, const std::string& className) {
    std::string result;
    
    // ТОЛЬКО ДЛЯ EDIT КОНТРОЛОВ
    if (className.find("Edit") != std::string::npos) {
        DWORD start = 0, end = 0;
        SendMessageA(hWnd, EM_GETSEL, (WPARAM)&start, (LPARAM)&end);
        
        if (start != end) {
            int textLength = GetWindowTextLengthA(hWnd);
            if (textLength > 0) {
                std::vector<char> buffer(textLength + 1);
                GetWindowTextA(hWnd, buffer.data(), textLength + 1);
                
                if (static_cast<int>(end) <= textLength) {
                    result = std::string(buffer.data() + start, end - start);
                    WriteLog("Edit control selection found: " + std::to_string(result.length()));
                }
            }
        }
    }
    
    return result;
}
static std::string GetSelectedTextImproved() {
    std::string result;
    
    // Сохраняем оригинальное содержимое буфера обмена
    std::string originalClipboard = GetClipboardText();
    WriteLog("Original clipboard length: " + std::to_string(originalClipboard.length()));
    
    // Пробуем несколько раз скопировать с небольшими задержками
    for (int attempt = 0; attempt < 3; attempt++) {
        if (SimulateCopy()) {
            Sleep(100); // Увеличиваем задержку
            
            std::string newClipboard = GetClipboardText();
            WriteLog("Attempt " + std::to_string(attempt + 1) + " clipboard length: " + std::to_string(newClipboard.length()));
            
            // Если текст изменился и не пустой - это выделенный текст
            if (!newClipboard.empty() && newClipboard != originalClipboard) {
                // Проверяем, что это не случайный мусор
                if (newClipboard.length() > 0 && newClipboard.length() < 10000) {
                    result = newClipboard;
                    WriteLog("Text selection found, length: " + std::to_string(result.length()));
                    break;
                }
            }
        }
        Sleep(50);
    }
    
    // Восстанавливаем оригинальное содержимое буфера обмена
    if (!originalClipboard.empty()) {
        SetClipboardText(originalClipboard);
    }
    
    return result;
}

// Простой метод через SendMessage для текстовых полей
static std::string GetSelectedTextFromEdit() {
    std::string result;
    
    HWND hForeground = GetForegroundWindow();
    if (!hForeground) return result;
    
    // Получаем focused control
    GUITHREADINFO guiInfo = {0};
    guiInfo.cbSize = sizeof(GUITHREADINFO);
    
    if (GetGUIThreadInfo(GetWindowThreadProcessId(hForeground, nullptr), &guiInfo)) {
        HWND hFocused = guiInfo.hwndFocus;
        if (!hFocused) return result;
        
        char className[256];
        GetClassNameA(hFocused, className, sizeof(className));
        WriteLog("Focused control class: " + std::string(className));
        
        // Для Edit и RichEdit controls
        if (strstr(className, "Edit") || strstr(className, "RichEdit")) {
            // Получаем позиции выделения
            DWORD start = 0, end = 0;
            SendMessageA(hFocused, EM_GETSEL, (WPARAM)&start, (LPARAM)&end);
            
            if (start != end) {
                // Есть выделение
                int textLength = GetWindowTextLengthA(hFocused);
                if (textLength > 0) {
                    std::vector<char> buffer(textLength + 1);
                    GetWindowTextA(hFocused, buffer.data(), textLength + 1);
                    
                    // Исправляем сравнение типов
                    if (static_cast<int>(end) <= textLength) {
                        result = std::string(buffer.data() + start, end - start);
                        WriteLog("Edit selection found, length: " + std::to_string(result.length()));
                    }
                }
            }
        }
    }
    
    return result;
}

// Альтернативный метод через WM_GETTEXT
static std::string GetSelectedTextAlternative() {
    std::string result;
    
    HWND hForeground = GetForegroundWindow();
    if (!hForeground) return result;
    
    // Получаем focused control
    HWND hFocused = GetFocus();
    if (!hFocused) hFocused = hForeground;
    
    // Пробуем получить выделенный текст через EM_GETSELTEXT для edit controls
    char textBuffer[4096] = {0};
    
    // Для Edit controls
    LRESULT textLength = SendMessageA(hFocused, EM_GETSEL, 0, (LPARAM)textBuffer);
    if (textLength > 0) {
        result = std::string(textBuffer, textLength);
        WriteLog("EM_GETSELTEXT found: " + result);
        return result;
    }
    
    // Пробуем WM_GETTEXT
    textLength = SendMessageA(hFocused, WM_GETTEXT, sizeof(textBuffer), (LPARAM)textBuffer);
    if (textLength > 0) {
        // Это весь текст, но может быть полезно для отладки
        WriteLog("WM_GETTEXT: " + std::string(textBuffer, textLength));
    }
    
    return result;
}

    static std::string GetSelectedFilesInExplorer() {
        std::string result;
        CoInitialize(NULL);

        IShellWindows* shellWindows = nullptr;
        if (SUCCEEDED(CoCreateInstance(CLSID_ShellWindows, NULL, CLSCTX_ALL,
                                       IID_IShellWindows, (void**)&shellWindows))) {
            IDispatch* dispatch = nullptr;
            VARIANT v;
            VariantInit(&v);
            V_VT(&v) = VT_I4;

            long count = 0;
            shellWindows->get_Count(&count);
            
            HWND foregroundWindow = GetForegroundWindow();
            
            for (long i = 0; i < count; i++) {
                V_I4(&v) = i;
                if (SUCCEEDED(shellWindows->Item(v, &dispatch)) && dispatch) {
                    IWebBrowserApp* browser = nullptr;
                    if (SUCCEEDED(dispatch->QueryInterface(IID_IWebBrowserApp, (void**)&browser))) {
                        HWND hwnd;
                        if (SUCCEEDED(browser->get_HWND((LONG_PTR*)&hwnd))) {
                            if (hwnd == foregroundWindow) {
                                IDispatch* pDisp = nullptr;
                                if (SUCCEEDED(browser->get_Document(&pDisp)) && pDisp) {
                                    IShellFolderViewDual* folderView = nullptr;
                                    if (SUCCEEDED(pDisp->QueryInterface(IID_IShellFolderViewDual, (void**)&folderView))) {
                                        FolderItems* items = nullptr;
                                        if (SUCCEEDED(folderView->SelectedItems(&items)) && items) {
                                            long itemCount = 0;
                                            items->get_Count(&itemCount);
                                            for (long j = 0; j < itemCount; j++) {
                                                VARIANT index;
                                                VariantInit(&index);
                                                V_VT(&index) = VT_I4;
                                                V_I4(&index) = j;

                                                FolderItem* item = nullptr;
                                                if (SUCCEEDED(items->Item(index, &item)) && item) {
                                                    BSTR path;
                                                    if (SUCCEEDED(item->get_Path(&path))) {
                                                        if (!result.empty()) result += "|";
                                                        std::wstring wpath(path, SysStringLen(path));
                                                        result += WideToUTF8(wpath);
                                                        SysFreeString(path);
                                                    }
                                                    item->Release();
                                                }
                                            }
                                            items->Release();
                                        }
                                        folderView->Release();
                                    }
                                    pDisp->Release();
                                }
                            }
                            browser->Release();
                        }
                    }
                    dispatch->Release();
                }
            }
            shellWindows->Release();
        }

        CoUninitialize();
        return result;
    }

  
    static std::string GetClipboardText() {
        std::string result;
        
        if (OpenClipboard(nullptr)) {
            HANDLE hData = GetClipboardData(CF_UNICODETEXT);
            if (hData) {
                wchar_t* text = static_cast<wchar_t*>(GlobalLock(hData));
                if (text) {
                    result = WideToUTF8(text);
                    GlobalUnlock(hData);
                }
            }
            CloseClipboard();
        }
        
        return result;
    }

    static bool SetClipboardText(const std::string& text) {
        if (OpenClipboard(nullptr)) {
            EmptyClipboard();
            
            std::wstring wideText = UTF8ToWide(text);
            HGLOBAL hGlobal = GlobalAlloc(GMEM_MOVEABLE, (wideText.length() + 1) * sizeof(wchar_t));
            if (hGlobal) {
                wchar_t* pGlobal = static_cast<wchar_t*>(GlobalLock(hGlobal));
                wcscpy_s(pGlobal, wideText.length() + 1, wideText.c_str());
                GlobalUnlock(hGlobal);
                
                SetClipboardData(CF_UNICODETEXT, hGlobal);
            }
            
            CloseClipboard();
            return true;
        }
        return false;
    }

    static bool SimulateCopy() {
        // Имитируем нажатие Ctrl+C
        INPUT inputs[4] = {};
        
        // Нажимаем Ctrl
        inputs[0].type = INPUT_KEYBOARD;
        inputs[0].ki.wVk = VK_CONTROL;
        
        // Нажимаем C
        inputs[1].type = INPUT_KEYBOARD;
        inputs[1].ki.wVk = 'C';
        
        // Отпускаем C
        inputs[2].type = INPUT_KEYBOARD;
        inputs[2].ki.wVk = 'C';
        inputs[2].ki.dwFlags = KEYEVENTF_KEYUP;
        
        // Отпускаем Ctrl
        inputs[3].type = INPUT_KEYBOARD;
        inputs[3].ki.wVk = VK_CONTROL;
        inputs[3].ki.dwFlags = KEYEVENTF_KEYUP;
        
        UINT sent = SendInput(4, inputs, sizeof(INPUT));
        return sent == 4;
    }

    static void WriteLog(const std::string& message) {
        // Простая реализация WriteLog для использования в приватных методах
        PWSTR documentsPath = nullptr;
        if (SUCCEEDED(SHGetKnownFolderPath(FOLDERID_Documents, 0, NULL, &documentsPath))) {
            char narrowPath[MAX_PATH];
            WideCharToMultiByte(CP_UTF8, 0, documentsPath, -1, narrowPath, MAX_PATH, NULL, NULL);
            
            std::string logPath = std::string(narrowPath) + "\\getselection_log.txt";
            FILE* logFile = nullptr;
            fopen_s(&logFile, logPath.c_str(), "a");
            if (logFile) {
                fprintf(logFile, "%s\n", message.c_str());
                fclose(logFile);
            }
            CoTaskMemFree(documentsPath);
        }
        printf("%s\n", message.c_str());
    }
};

bool DebugGlobalInit() {
    FILE* f;
    fopen_s(&f, "global_init.txt", "w");
    if (f) {
        fprintf(f, "Global init completed\n");
        fclose(f);
    }
    return true;
}
bool global_test = DebugGlobalInit();
// Вспомогательная функция для получения CLSID encoder'а
int GetEncoderClsid(const WCHAR* format, CLSID* pClsid) {
    UINT num = 0, size = 0;
    GetImageEncodersSize(&num, &size);
    if (size == 0) return -1;

    ImageCodecInfo* pImageCodecInfo = (ImageCodecInfo*)malloc(size);
    if (!pImageCodecInfo) return -1;

    GetImageEncoders(num, size, pImageCodecInfo);

    for (UINT i = 0; i < num; ++i) {
        if (wcscmp(pImageCodecInfo[i].MimeType, format) == 0) {
            *pClsid = pImageCodecInfo[i].Clsid;
            free(pImageCodecInfo);
            return i;
        }
    }

    free(pImageCodecInfo);
    return -1;
}

// Конвертация HICON в PNG
std::vector<uint8_t> IconToPngBytes(HICON hIcon) {
    std::vector<uint8_t> pngData;
    
    ICONINFO iconInfo;
    if (GetIconInfo(hIcon, &iconInfo)) {
        BITMAP bmpColor;
        GetObject(iconInfo.hbmColor, sizeof(BITMAP), &bmpColor);
        
        // Создаем GDI+ Bitmap из HBITMAP
        Bitmap bitmap(iconInfo.hbmColor, nullptr);
        
        // Конвертируем в PNG
        IStream* stream = nullptr;
        CreateStreamOnHGlobal(NULL, TRUE, &stream);
        
        CLSID pngClsid;
        GetEncoderClsid(L"image/png", &pngClsid);
        
        if (bitmap.Save(stream, &pngClsid, nullptr) == Ok) {
            HGLOBAL hGlobal = NULL;
            GetHGlobalFromStream(stream, &hGlobal);
            SIZE_T dataSize = GlobalSize(hGlobal);
            void* pData = GlobalLock(hGlobal);
            
            if (pData && dataSize > 0) {
                pngData.resize(static_cast<size_t>(dataSize)); // Явное преобразование
                memcpy(pngData.data(), pData, static_cast<size_t>(dataSize)); // Явное преобразование
            }
            
            GlobalUnlock(hGlobal);
        }
        
        if (stream) stream->Release();
        
        // Освобождаем ресурсы
        DeleteObject(iconInfo.hbmColor);
        DeleteObject(iconInfo.hbmMask);
    }
    
    return pngData;
}
// Метод для получения иконки файла
std::vector<uint8_t> GetFileIcon(const std::string& filePath) {
    std::vector<uint8_t> iconData;
    
    // Конвертируем string в wstring
    std::wstring widePath(filePath.begin(), filePath.end());
    
    SHFILEINFO fileInfo = {0};
    SHGetFileInfo(
        widePath.c_str(),
        0,
        &fileInfo,
        sizeof(fileInfo),
        SHGFI_ICON | SHGFI_LARGEICON
    );
    
    if (fileInfo.hIcon) {
        // Конвертируем HICON в PNG bytes
        iconData = IconToPngBytes(fileInfo.hIcon);
        DestroyIcon(fileInfo.hIcon);
    }
    
    return iconData;
}

// Функция для очистки распознанного текста
std::string CleanRecognizedText(const std::string& text) {
    if (text.empty()) return text;
    
    std::string cleaned = text;
    
    // Удаляем лишние пробелы в начале и конце
    size_t start = cleaned.find_first_not_of(" \n\r\t");
    size_t end = cleaned.find_last_not_of(" \n\r\t");
    
    if (start != std::string::npos && end != std::string::npos) {
        cleaned = cleaned.substr(start, end - start + 1);
    }
    
    // Заменяем множественные пробелы на одинарные
    std::string::iterator new_end = std::unique(cleaned.begin(), cleaned.end(),
        [](char a, char b) { return a == ' ' && b == ' '; });
    cleaned.erase(new_end, cleaned.end());
    
    return cleaned;
}

// ---------- PNG из Bitmap ----------
std::vector<uint8_t> BitmapToPngBytes(HBITMAP hBitmap) {
    std::vector<uint8_t> pngData;
    Bitmap bitmap(hBitmap, nullptr);

    IStream* stream = nullptr;
    CreateStreamOnHGlobal(NULL, TRUE, &stream);

    CLSID pngClsid;
    UINT num = 0, size = 0;
    Gdiplus::GetImageEncodersSize(&num, &size);
    if (size == 0) return pngData;

    auto* pImageCodecInfo = (ImageCodecInfo*)malloc(size);
    if (!pImageCodecInfo) return pngData;

    Gdiplus::GetImageEncoders(num, size, pImageCodecInfo);
    bool found = false;
    for (UINT j = 0; j < num; ++j) {
        if (wcscmp(pImageCodecInfo[j].MimeType, L"image/png") == 0) {
            pngClsid = pImageCodecInfo[j].Clsid;
            found = true;
            break;
        }
    }
    free(pImageCodecInfo);
    if (!found) return pngData;

    if (bitmap.Save(stream, &pngClsid, nullptr) == Ok) {
        HGLOBAL hGlobal = NULL;
        GetHGlobalFromStream(stream, &hGlobal);
        SIZE_T dataSize = GlobalSize(hGlobal);
        void* pData = GlobalLock(hGlobal);
        if (pData && dataSize > 0) {
            pngData.resize(static_cast<size_t>(dataSize)); // Явное преобразование
            memcpy(pngData.data(), pData, static_cast<size_t>(dataSize)); // Явное преобразование
        }
        GlobalUnlock(hGlobal);
    }

    if (stream) stream->Release();
    return pngData;
}
// ---------- Скриншот ----------
std::vector<uint8_t> TakeScreenshotRaw() {
    int screenX = GetSystemMetrics(SM_CXSCREEN);
    int screenY = GetSystemMetrics(SM_CYSCREEN);

    HDC hScreenDC = GetDC(NULL);
    HDC hMemoryDC = CreateCompatibleDC(hScreenDC);

    HBITMAP hBitmap = CreateCompatibleBitmap(hScreenDC, screenX, screenY);
    SelectObject(hMemoryDC, hBitmap);
    BitBlt(hMemoryDC, 0, 0, screenX, screenY, hScreenDC, 0, 0, SRCCOPY);

    GdiplusStartupInput gdiplusStartupInput;
    ULONG_PTR gdiplusToken;
    GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, nullptr);

    auto pngBytes = BitmapToPngBytes(hBitmap);

    DeleteObject(hBitmap);
    DeleteDC(hMemoryDC);
    ReleaseDC(NULL, hScreenDC);
    GdiplusShutdown(gdiplusToken);

    return pngBytes;
}

std::string ExecuteTesseract(const std::string& image_path) {
    auto WriteLog = [](const char* message) {
        PWSTR documentsPath = nullptr;
        if (SUCCEEDED(SHGetKnownFolderPath(FOLDERID_Documents, 0, NULL, &documentsPath))) {
            char narrowPath[MAX_PATH];
            WideCharToMultiByte(CP_UTF8, 0, documentsPath, -1, narrowPath, MAX_PATH, NULL, NULL);
            
            std::string logPath = std::string(narrowPath) + "\\getselection_log.txt";
            FILE* logFile = nullptr;
            fopen_s(&logFile, logPath.c_str(), "a");
            if (logFile) {
                fprintf(logFile, "%s\n", message);
                fclose(logFile);
            }
            CoTaskMemFree(documentsPath);
        }
        printf("%s\n", message);
    };

    WriteLog("=== Starting Tesseract OCR ===");

    try {
        // Подготавливаем команду tesseract
        std::string command = "tesseract \"" + image_path + "\" stdout -l rus+eng --psm 6 --oem 3";
        
        WriteLog(("Command: " + command).c_str());

        // Запускаем процесс
        std::array<char, 128> buffer;
        std::string result;
        
        // Используем _popen для Windows
        std::unique_ptr<FILE, decltype(&_pclose)> pipe(_popen(command.c_str(), "r"), _pclose);
        
        if (!pipe) {
            WriteLog("Error: Failed to start Tesseract process");
            return "Error: Failed to start Tesseract process";
        }

        // Читаем вывод
        while (fgets(buffer.data(), static_cast<int>(buffer.size()), pipe.get()) != nullptr) {
    result += buffer.data();
}

        // Получаем код возврата
        int exitCode = _pclose(pipe.release());
        
        WriteLog(("Tesseract exit code: " + std::to_string(exitCode)).c_str());
        WriteLog(("Recognized text length: " + std::to_string(static_cast<int>(result.length()))).c_str()); // Явное преобразование
        WriteLog(("Text: \"" + result + "\"").c_str());

        if (exitCode == 0) {
            // Очищаем результат
            result.erase(std::remove(result.begin(), result.end(), '\r'), result.end());
            result.erase(std::remove(result.begin(), result.end(), '\n'), result.end());
            
            if (!result.empty()) {
                WriteLog("Tesseract OCR completed successfully");
                return result;
            } else {
                WriteLog("Tesseract returned empty result");
                return "Текст не распознан. Попробуйте выделить область с более четким текстом.";
            }
        } else {
            WriteLog("Tesseract process failed");
            return "Ошибка Tesseract: код возврата " + std::to_string(exitCode);
        }

    } catch (const std::exception& e) {
        WriteLog(("Exception in Tesseract: " + std::string(e.what())).c_str());
        return "Ошибка вызова Tesseract: " + std::string(e.what());
    }
}
std::string ExtractTextFromImage(const std::vector<uint8_t>& image_data) {
    auto WriteLog = [](const char* message) {
        PWSTR documentsPath = nullptr;
        if (SUCCEEDED(SHGetKnownFolderPath(FOLDERID_Documents, 0, NULL, &documentsPath))) {
            char narrowPath[MAX_PATH];
            WideCharToMultiByte(CP_UTF8, 0, documentsPath, -1, narrowPath, MAX_PATH, NULL, NULL);
            
            std::string logPath = std::string(narrowPath) + "\\tesseract_log.txt";
            FILE* logFile = nullptr;
            fopen_s(&logFile, logPath.c_str(), "a");
            if (logFile) {
                fprintf(logFile, "%s\n", message);
                fclose(logFile);
            }
            CoTaskMemFree(documentsPath);
        }
        printf("%s\n", message);
    };

    WriteLog("=== ExtractTextFromImage started ===");

    try {
        // Создаем временный файл для изображения
        char tempPath[MAX_PATH];
        GetTempPathA(MAX_PATH, tempPath);
        std::string tempFile = std::string(tempPath) + "ocr_input_" + 
                              std::to_string(std::chrono::duration_cast<std::chrono::milliseconds>(
                                  std::chrono::system_clock::now().time_since_epoch()).count()) + 
                              ".png";
        
        // Сохраняем изображение во временный файл
        FILE* file = nullptr;
        fopen_s(&file, tempFile.c_str(), "wb");
        if (!file) {
            WriteLog("Error: Failed to create temporary file for OCR");
            return "Error: Failed to create temporary file";
        }
        
        fwrite(image_data.data(), 1, image_data.size(), file);
        fclose(file);
        
        WriteLog(("Temporary image created: " + tempFile).c_str());

        // Запускаем Tesseract
        std::string result = ExecuteTesseract(tempFile);

        // Удаляем временный файл
        remove(tempFile.c_str());
        
        WriteLog("=== ExtractTextFromImage completed ===");
        return result;

    } catch (const std::exception& e) {
        WriteLog(("Exception in ExtractTextFromImage: " + std::string(e.what())).c_str());
        return "Ошибка обработки изображения: " + std::string(e.what());
    }
}

// ---------- Декодирование PNG в raw пиксели ----------
bool DecodePngToRGB(const std::vector<uint8_t>& pngData, 
                   std::vector<uint8_t>& rgbData, 
                   int& width, int& height) {
    
    auto WriteLog = [](const char* message) {
        PWSTR documentsPath = nullptr;
        if (SUCCEEDED(SHGetKnownFolderPath(FOLDERID_Documents, 0, NULL, &documentsPath))) {
            char narrowPath[MAX_PATH];
            WideCharToMultiByte(CP_UTF8, 0, documentsPath, -1, narrowPath, MAX_PATH, NULL, NULL);
            
            std::string logPath = std::string(narrowPath) + "\\log_debug.txt";
            FILE* logFile = nullptr;
            fopen_s(&logFile, logPath.c_str(), "a");
            if (logFile) {
                fprintf(logFile, "%s\n", message);
                fclose(logFile);
            }
            CoTaskMemFree(documentsPath);
        }
        printf("%s\n", message);
    };

    WriteLog("=== DecodePngToRGB started ===");

    // Сохраним PNG во временный файл и загрузим оттуда
    char tempPath[MAX_PATH];
    GetTempPathA(MAX_PATH, tempPath);
    std::string tempFile = std::string(tempPath) + "temp_qr.png";
    
    FILE* temp = nullptr;
    fopen_s(&temp, tempFile.c_str(), "wb");
    if (!temp) {
        WriteLog("Error: Failed to create temp file");
        return false;
    }
    fwrite(pngData.data(), 1, pngData.size(), temp);
    fclose(temp);
    
    WriteLog("Temporary PNG file created");

    // Загружаем из файла
    std::wstring wtempFile(tempFile.begin(), tempFile.end());
    Bitmap* bitmap = Bitmap::FromFile(wtempFile.c_str());
    
    if (!bitmap) {
        WriteLog("Error: Bitmap::FromFile returned null");
        return false;
    }

    Status status = bitmap->GetLastStatus();
    if (status != Ok) {
        WriteLog("Error: Bitmap status failed");
        delete bitmap;
        return false;
    }

    width = bitmap->GetWidth();
    height = bitmap->GetHeight();
    
    char dimMsg[100];
    sprintf_s(dimMsg, "Bitmap loaded: %d x %d", width, height);
    WriteLog(dimMsg);

    // Конвертируем в RGB
    rgbData.resize(width * height * 3);
    
    int successPixels = 0;
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            Color color;
            if (bitmap->GetPixel(x, y, &color) == Ok) {
                int index = (y * width + x) * 3;
                rgbData[index] = color.GetR();
                rgbData[index + 1] = color.GetG();
                rgbData[index + 2] = color.GetB();
                successPixels++;
            }
        }
    }

    delete bitmap;
    
    // Удаляем временный файл
    remove(tempFile.c_str());
    
    bool result = successPixels > 0;
    WriteLog(result ? "DecodePngToRGB result: SUCCESS" : "DecodePngToRGB result: FAILED");
    
    return result;
}
static bool SimulatePaste() {
    HWND hWnd = GetForegroundWindow();
    if (!hWnd) return false;
    
    // Пробуем получить focused control через GUI thread info
    GUITHREADINFO guiInfo = {0};
    guiInfo.cbSize = sizeof(GUITHREADINFO);
    
    DWORD threadId = GetWindowThreadProcessId(hWnd, nullptr);
    if (GetGUIThreadInfo(threadId, &guiInfo)) {
        HWND hFocus = guiInfo.hwndFocus;
        if (!hFocus) hFocus = hWnd;
        
        // Пробуем разные методы
        SendMessage(hFocus, WM_PASTE, 0, 0);
        PostMessage(hFocus, WM_PASTE, 0, 0);
        
        return true;
    }
    
    // Fallback: отправляем в главное окно
    SendMessage(hWnd, WM_PASTE, 0, 0);
    return true;
}

std::string DecodeQRCode(const std::vector<uint8_t>& imageData) {
    using namespace ZXing;
     auto WriteLog = [](const char* message) {
        PWSTR documentsPath = nullptr;
        if (SUCCEEDED(SHGetKnownFolderPath(FOLDERID_Documents, 0, NULL, &documentsPath))) {
            char narrowPath[MAX_PATH];
            WideCharToMultiByte(CP_UTF8, 0, documentsPath, -1, narrowPath, MAX_PATH, NULL, NULL);
            
            std::string logPath = std::string(narrowPath) + "\\log_debug.txt";
            FILE* logFile = nullptr;
            fopen_s(&logFile, logPath.c_str(), "a");
            if (logFile) {
                fprintf(logFile, "%s\n", message);
                fclose(logFile);
            }
            CoTaskMemFree(documentsPath);
        }
        printf("%s\n", message);
    };

    WriteLog("=== 1 started ===");
    try {
        // Создаем временный файл с PNG и пробуем загрузить через GDI+ еще раз
        // но с лучшей обработкой ошибок
        char tempPath[MAX_PATH];
        GetTempPathA(MAX_PATH, tempPath);
        std::string tempFile = std::string(tempPath) + "debug_qr.png";
        
        FILE* temp = nullptr;
        fopen_s(&temp, tempFile.c_str(), "wb");
        if (temp) {
            fwrite(imageData.data(), 1, imageData.size(), temp);
            fclose(temp);
        }
    WriteLog("=== 2 started ===");
        // Пробуем загрузить через GDI+ с детальной диагностикой
        Gdiplus::GdiplusStartupInput gdiplusStartupInput;
        ULONG_PTR gdiplusToken;
        Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);

        std::wstring wtempFile(tempFile.begin(), tempFile.end());
        Gdiplus::Bitmap* bitmap = Gdiplus::Bitmap::FromFile(wtempFile.c_str());
            WriteLog("=== 3 started ===");
        if (!bitmap) {
            Gdiplus::GdiplusShutdown(gdiplusToken);
            remove(tempFile.c_str());
            return "Error: Bitmap::FromFile failed";
        }
    WriteLog("=== 4 started ===");
        Gdiplus::Status status = bitmap->GetLastStatus();
        if (status != Gdiplus::Ok) {
            delete bitmap;
            Gdiplus::GdiplusShutdown(gdiplusToken);
            remove(tempFile.c_str());
            return "Error: Bitmap status: " + std::to_string(status);
        }
    WriteLog("=== 5 started ===");
        int width = bitmap->GetWidth();
        int height = bitmap->GetHeight();
        
        if (width <= 0 || height <= 0) {
            delete bitmap;
            Gdiplus::GdiplusShutdown(gdiplusToken);
            remove(tempFile.c_str());
            return "Error: Invalid dimensions: " + std::to_string(width) + "x" + std::to_string(height);
        }
    WriteLog("=== 6 started ===");
        // Конвертируем в RGB
        std::vector<uint8_t> rgbData(width * height * 3);
        
        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                Gdiplus::Color color;
                if (bitmap->GetPixel(x, y, &color) == Gdiplus::Ok) {
                    int index = (y * width + x) * 3;
                    rgbData[index] = color.GetR();
                    rgbData[index + 1] = color.GetG();
                    rgbData[index + 2] = color.GetB();
                }
            }
        }
    WriteLog("=== 7 started ===");
        delete bitmap;
        Gdiplus::GdiplusShutdown(gdiplusToken);
        remove(tempFile.c_str());
    WriteLog("=== 8 started ===");
        // Теперь используем правильный конструктор ImageView
        ImageView image(
            rgbData.data(), 
            width, 
            height, 
            ImageFormat::RGB  // 4 аргумента: данные, ширина, высота, формат
        );
            WriteLog("=== 9 started ===");
        ReaderOptions options;
        options.setFormats(BarcodeFormat::QRCode);
        options.setTryHarder(true);
        options.setTryRotate(true);
        
        auto results = ReadBarcodes(image, options);
        
        if (!results.empty()) {
            return results[0].text();
        }
            WriteLog("=== 10 started ===");
        return "";
        
    } catch (const std::exception& e) {
        return "Exception: " + std::string(e.what());
    }
}

// ---------- Декодирование из Bitmap (альтернативный метод) ----------
std::string DecodeQRFromBitmap(HBITMAP hBitmap) {
    using namespace ZXing;
    
    try {
        Bitmap bitmap(hBitmap, nullptr);
        
        int width = bitmap.GetWidth();
        int height = bitmap.GetHeight();
        
        // Конвертируем Bitmap в raw данные
        std::vector<uint8_t> imageData(width * height * 3); // RGB
        
        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                Color color;
                bitmap.GetPixel(x, y, &color);
                
                int index = (y * width + x) * 3;
                imageData[index] = color.GetR();     // R
                imageData[index + 1] = color.GetG(); // G
                imageData[index + 2] = color.GetB(); // B
            }
        }
        
        // Создаем ImageView
        ImageView image(
            imageData.data(), 
            width, 
            height, 
            ImageFormat::RGB
        );
        
        // Используем ReaderOptions вместо устаревшего DecodeHints
        ReaderOptions options;
        options.setFormats(BarcodeFormat::QRCode);
        
        auto results = ReadBarcodes(image, options);
        
        if (!results.empty()) {
            return results[0].text();
        }
        
        return "";
        
    } catch (const std::exception& e) {
        return "Error: " + std::string(e.what());
    }
}

// Упрощенная версия копирования изображения в буфер обмена
bool CopyImageToClipboardSimple(const std::vector<uint8_t>& imageData) {
    if (!OpenClipboard(NULL)) {
        return false;
    }
    
    EmptyClipboard();
    
    // Создаем глобальную память для данных PNG
    HGLOBAL hGlobal = GlobalAlloc(GMEM_MOVEABLE, static_cast<SIZE_T>(imageData.size())); // Явное преобразование
    if (!hGlobal) {
        CloseClipboard();
        return false;
    }
    
    // Копируем данные
    void* pData = GlobalLock(hGlobal);
    if (!pData) {
        GlobalFree(hGlobal);
        CloseClipboard();
        return false;
    }
    
    memcpy(pData, imageData.data(), static_cast<SIZE_T>(imageData.size())); // Явное преобразование
    GlobalUnlock(hGlobal);
    
    // Регистрируем и устанавливаем формат PNG
    UINT pngFormat = RegisterClipboardFormatA("PNG");
    if (pngFormat == 0) {
        GlobalFree(hGlobal);
        CloseClipboard();
        return false;
    }
    
    bool success = (SetClipboardData(pngFormat, hGlobal) != NULL);
    
    if (!success) {
        GlobalFree(hGlobal);
    }
    
    CloseClipboard();
    return success;
}


bool CopyImageToClipboard(const std::vector<uint8_t>& imageData) {
    // Сначала пробуем простой метод с PNG
    if (CopyImageToClipboardSimple(imageData)) {
        return true;
    }
    
    // Если не получилось, пробуем через GDI+ для конвертации в BITMAP
    Gdiplus::GdiplusStartupInput gdiplusStartupInput;
    ULONG_PTR gdiplusToken;
    Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);
    
    bool success = false;
    
    // Создаем поток из данных изображения
    IStream* stream = nullptr;
    HGLOBAL hGlobal = GlobalAlloc(GMEM_MOVEABLE, imageData.size());
    if (hGlobal) {
        void* pData = GlobalLock(hGlobal);
        if (pData) {
            memcpy(pData, imageData.data(), imageData.size());
            GlobalUnlock(hGlobal);
            
            if (CreateStreamOnHGlobal(hGlobal, FALSE, &stream) == S_OK) {
                // Загружаем изображение из потока
                Gdiplus::Bitmap* bitmap = Gdiplus::Bitmap::FromStream(stream);
                if (bitmap && bitmap->GetLastStatus() == Gdiplus::Ok) {
                    // Конвертируем в HBITMAP
                    HBITMAP hBitmap = NULL;
                    Gdiplus::Color backgroundColor(255, 255, 255); // Белый фон
                    if (bitmap->GetHBITMAP(backgroundColor, &hBitmap) == Gdiplus::Ok) {
                        // Открываем буфер обмена
                        if (OpenClipboard(NULL)) {
                            EmptyClipboard();
                            
                            // Устанавливаем BITMAP в буфер обмена
                            if (SetClipboardData(CF_BITMAP, hBitmap)) {
                                success = true;
                                // Не удаляем hBitmap - он теперь принадлежит буферу обмена
                            } else {
                                DeleteObject(hBitmap);
                            }
                            CloseClipboard();
                        } else {
                            DeleteObject(hBitmap);
                        }
                    }
                    delete bitmap;
                }
                stream->Release();
            }
            // GlobalFree будет вызван автоматически при Release stream
        } else {
            GlobalFree(hGlobal);
        }
    }
    
    Gdiplus::GdiplusShutdown(gdiplusToken);
    return success;
}


/*
class BLIPModel {
private:
    Ort::Env env;
    Ort::Session session{nullptr};
    Ort::MemoryInfo memory_info{nullptr};
    std::vector<const char*> input_names;
    std::vector<const char*> output_names;
    std::mutex model_mutex;
    
public:
    bool Initialize(const std::string& model_path) {
        try {
            env = Ort::Env(ORT_LOGGING_LEVEL_WARNING, "BLIP");
            Ort::SessionOptions session_options;
            
            // Настройки для лучшей производительности
            session_options.SetIntraOpNumThreads(1);
            session_options.SetGraphOptimizationLevel(GraphOptimizationLevel::ORT_ENABLE_ALL);
            
            // Загружаем модель
            session = Ort::Session(env, std::wstring(model_path.begin(), model_path.end()).c_str(), session_options);
            
            // Получаем информацию о входах/выходах
            size_t num_input_nodes = session.GetInputCount();
            size_t num_output_nodes = session.GetOutputCount();
            
            input_names.clear();
            output_names.clear();
            
            Ort::AllocatorWithDefaultOptions allocator;
            
            for (size_t i = 0; i < num_input_nodes; i++) {
                input_names.push_back(session.GetInputNameAllocated(i, allocator).get());
            }
            
            for (size_t i = 0; i < num_output_nodes; i++) {
                output_names.push_back(session.GetOutputNameAllocated(i, allocator).get());
            }
            
            memory_info = Ort::MemoryInfo::CreateCpu(OrtDeviceAllocator, OrtMemTypeCPU);
            
            return true;
            
        } catch (const std::exception& ) {
            return false;
        }
    }
    
   std::string ProcessImage(const std::vector<uint8_t>& image_data, const std::string& prompt = "describe this image") {
    std::lock_guard<std::mutex> lock(model_mutex);
    
    try {
        // Декодируем PNG в OpenCV Mat
        cv::Mat image = cv::imdecode(image_data, cv::IMREAD_COLOR);
        if (image.empty()) {
            return "Error: Failed to decode image";
        }
        
        // Препроцессинг изображения для BLIP
        cv::Mat resized_image;
        cv::resize(image, resized_image, cv::Size(224, 224));
        
        // Конвертируем BGR -> RGB и нормализуем
        cv::cvtColor(resized_image, resized_image, cv::COLOR_BGR2RGB);
        resized_image.convertTo(resized_image, CV_32F, 1.0/255.0);
        
        // Подготавливаем тензоры для модели
        std::vector<float> input_tensor_data;
        size_t data_size = resized_image.rows * resized_image.cols * resized_image.channels();
        input_tensor_data.assign(resized_image.ptr<float>(), resized_image.ptr<float>() + data_size);
        
        std::vector<int64_t> input_shape = {1, 224, 224, 3};
        
        Ort::Value input_tensor = Ort::Value::CreateTensor<float>(
            memory_info, 
            input_tensor_data.data(), 
            input_tensor_data.size(), 
            input_shape.data(), 
            input_shape.size()
        );
        
        // Запускаем инференс
        auto output_tensors = session.Run(
            Ort::RunOptions{nullptr}, 
            input_names.data(), 
            &input_tensor, 
            input_names.size(), 
            output_names.data(), 
            output_names.size()
        );
        
        // Обрабатываем результат (упрощенно)
        // В реальности здесь будет сложная логика обработки выходов BLIP
        
        return "Image processed successfully"; // Заглушка
        
    } catch (const std::exception& e) {
        return "Error processing image: " + std::string(e.what());
    }
}
};

class ScreenAnalysisPipeline {
private:
    BLIPModel blip_model;
    std::atomic<bool> is_running{false};
    std::thread analysis_thread;
    std::mutex data_mutex;
    flutter::MethodChannel<flutter::EncodableValue>* method_channel = nullptr;
    
public:
    void SetMethodChannel(flutter::MethodChannel<flutter::EncodableValue>* channel) {
        method_channel = channel;
    }
    
    bool Initialize() {
        // Инициализируем модель
        if (!blip_model.Initialize("models/blip2/model.onnx")) {
            return false;
        }
        return true;
    }
 void StartAnalysis() {
    if (is_running) return;
    
    is_running = true;
    analysis_thread = std::thread([this]() {
        while (is_running) {
            try {
                // Ждем 30 секунд
                std::this_thread::sleep_for(std::chrono::seconds(30));
                
                if (!is_running) break;
                
                // Делаем скриншот
                auto screenshot_data = TakeScreenshotRaw();
                if (screenshot_data.empty()) {
                    continue;
                }
                
                // Получаем текст с изображения (уже есть через Tesseract)
                std::string extracted_text = ExtractTextFromImage(screenshot_data);
                
                // Анализируем изображение через BLIP
                std::string image_description = blip_model.ProcessImage(screenshot_data, "describe what is happening in this image");
                
                // Форматируем результат
                std::string formatted_result = FormatAnalysisResult(image_description, extracted_text);
                
                // Можно отправить результат обратно в Flutter
                SendResultToFlutter(formatted_result);
                
            } catch (const std::exception&) {
                // Логируем ошибку, но продолжаем работу
            }
        }
    });
}
    
    void StopAnalysis() {
        if (is_running == false) return;
        is_running = false;
        if (analysis_thread.joinable()) {
            analysis_thread.join();
        }
    }
    
private:
    std::string FormatAnalysisResult(const std::string& image_description, const std::string& extracted_text) {
        std::stringstream result;
        
        result << "<screen_analysis>\n";
        result << "<timestamp>" << std::chrono::system_clock::now().time_since_epoch().count() << "</timestamp>\n";
        result << "<visual_description>\n" << image_description << "\n</visual_description>\n";
        result << "<extracted_text>\n" << extracted_text << "\n</extracted_text>\n";
        result << "<prompt_template>\n";
        result << "Based on the screen analysis:\n";
        result << "Visual content: " << image_description << "\n";
        result << "Text content: " << extracted_text << "\n";
        result << "Describe what is happening on the screen and provide context.\n";
        result << "</prompt_template>\n";
        result << "</screen_analysis>";
        
        return result.str();
    }
    void SendResultToFlutter(const std::string& result) {
    if (!method_channel) return;
    
    try {
        // Отправляем результат через MethodChannel
        method_channel->InvokeMethod("onScreenAnalysisResult", 
            std::make_unique<flutter::EncodableValue>(result));
            
    } catch (const std::exception& ) { // Комментируем неиспользуемую переменную
        // Логируем ошибку отправки
        auto WriteLog = [](const char* message) {
            PWSTR documentsPath = nullptr;
            if (SUCCEEDED(SHGetKnownFolderPath(FOLDERID_Documents, 0, NULL, &documentsPath))) {
                char narrowPath[MAX_PATH];
                WideCharToMultiByte(CP_UTF8, 0, documentsPath, -1, narrowPath, MAX_PATH, NULL, NULL);
                
                std::string logPath = std::string(narrowPath) + "\\analysis_log.txt";
                FILE* logFile = nullptr;
                fopen_s(&logFile, logPath.c_str(), "a");
                if (logFile) {
                    fprintf(logFile, "%s\n", message);
                    fclose(logFile);
                }
                CoTaskMemFree(documentsPath);
            }
        };
        
        WriteLog("Error sending analysis result to Flutter");
    }
}
};
*/
// Скрываем консоль
void HideConsole() {
    ::ShowWindow(::GetConsoleWindow(), SW_HIDE);
}
void BringToFront(HWND hwnd) {
    if (!IsWindow(hwnd)) {
        return;
    }
    
    // Получаем thread ID нашего окна и текущего активного окна
    DWORD ourThreadId = GetWindowThreadProcessId(hwnd, NULL);
    DWORD foregroundThreadId = GetWindowThreadProcessId(GetForegroundWindow(), NULL);
    
    // Если потоки разные, прикрепляем вход
    if (ourThreadId != foregroundThreadId) {
        AttachThreadInput(foregroundThreadId, ourThreadId, TRUE);
    }
    
    // Восстанавливаем если свернуто
    if (IsIconic(hwnd)) {
        ShowWindow(hwnd, SW_RESTORE);
    }
    
    // Активируем окно
    SetForegroundWindow(hwnd);
    SetActiveWindow(hwnd);
    SetFocus(hwnd);
    
    // Поднимаем наверх
    SetWindowPos(hwnd, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
    
    // Открепляем вход если прикрепляли
    if (ourThreadId != foregroundThreadId) {
        AttachThreadInput(foregroundThreadId, ourThreadId, FALSE);
    }
    
    // Мигание в taskbar
    FlashWindow(hwnd, TRUE);
}
Win32Window::Size GetScreenSize() {
    int screenWidth = GetSystemMetrics(SM_CXSCREEN);
    int screenHeight = GetSystemMetrics(SM_CYSCREEN);
    return Win32Window::Size(screenWidth, screenHeight);
}

/*std::unique_ptr<ScreenAnalysisPipeline> analysis_pipeline;*/
int APIENTRY wWinMain(HINSTANCE instance, HINSTANCE prev, LPWSTR cmd, int showCmd) {
    //HideConsole();
     
    // 3. Создаем лог файл в текущей директории (не в C:\) 
    FILE* logFile;
    fopen_s(&logFile, "debug_log.txt", "w");
    
    if (logFile) fprintf(logFile, "Before GDI+ StartupInput\n");
    
    if (logFile) fprintf(logFile, "Before GDI+ StartupInput\n");
    Gdiplus::GdiplusStartupInput gdiplusStartupInput;
    if (logFile) fprintf(logFile, "Before GDI+ Token\n");
    ULONG_PTR gdiplusToken;
    if (logFile) fprintf(logFile, "Before GDI+ Startup call\n");
    
    Gdiplus::Status gdiStatus;
    try {
        gdiStatus = Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);
        if (logFile) fprintf(logFile, "GDI+ Status: %d\n", gdiStatus);
    } catch (...) {
        if (logFile) {
            fprintf(logFile, "GDI+ Startup EXCEPTION!\n");
            fclose(logFile);
        }
        return EXIT_FAILURE;
    }
    if (logFile) fprintf(logFile, "After GDI+ Startup\n");

    if (logFile) fprintf(logFile, "After GDI+ Startup\n");
    if (logFile) fprintf(logFile, "GDI+ initialized\n");
    if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
        CreateAndAttachConsole();
    }

    HRESULT hr = ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
    if (logFile) fprintf(logFile, "COM initialized: %d\n", hr);
    
    flutter::DartProject project(L"data");
    std::vector<std::string> args = GetCommandLineArguments();
    project.set_dart_entrypoint_arguments(std::move(args));

    FlutterWindow window(project);
    Win32Window::Point origin(10, 10);
    Win32Window::Size size = GetScreenSize();

    if (!window.Create(L"imeyou_pet", origin, size)) {
        return EXIT_FAILURE;
    }
    window.SetQuitOnClose(true);
    g_flutterHwnd = window.GetHandle();
   g_mainWindow = window.GetHandle();// или = window; в зависимости от твоего кода

        InitializeClickThrough();
    
    // Устанавливаем начальное состояние - только зона 80x80
    activateFullClick();
    // Регистрируем плагин hotkey после создания окна
auto* flutterViewController = window.controller();
if (flutterViewController) {
    auto plugin_registrar_ref = flutterViewController->engine()->GetRegistrarForPlugin("HotkeyPlugin");
    if (plugin_registrar_ref) {
        auto registrar = flutter::PluginRegistrarManager::GetInstance()
            ->GetRegistrar<flutter::PluginRegistrarWindows>(plugin_registrar_ref);
        HotkeyPlugin::RegisterWithRegistrar(registrar);
    }
}
auto* flutter_controller = window.controller();
if (flutter_controller) {
    auto plugin_registrar_ref = flutter_controller->engine()->GetRegistrarForPlugin("FileDragDropPlugin");
    if (plugin_registrar_ref) {
        FileDragDropPlugin::RegisterWithRegistrar(
            flutter::PluginRegistrarManager::GetInstance()
                ->GetRegistrar<flutter::PluginRegistrarWindows>(plugin_registrar_ref));
    }
}
    // Остальной код остается без изменений...
    flutter::FlutterViewController* controller = window.controller();
    if (controller) {
        auto messenger = controller->engine()->messenger();
        
        // Инициализируем пайплайн анализа
        /*analysis_pipeline = std::make_unique<ScreenAnalysisPipeline>();*/
        
        // Screenshot channel
        auto screenshotChannel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            messenger, "screenshot_channel", &flutter::StandardMethodCodec::GetInstance());
        auto screenshotChannel1 = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            messenger, "screenshot_channel1", &flutter::StandardMethodCodec::GetInstance());
        // Устанавливаем method channel для пайплайна анализа
        /*analysis_pipeline->SetMethodChannel(screenshotChannel.get());*/



         screenshotChannel1->SetMethodCallHandler(
            [](const flutter::MethodCall<flutter::EncodableValue>& call,
               std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
                 if (call.method_name() == "getFileIcon") {
            const auto* filePath = std::get_if<std::string>(call.arguments());
            if (filePath) {
                auto iconData = GetFileIcon(*filePath);
                if (!iconData.empty()) {
                    result->Success(flutter::EncodableValue(iconData));
                } else {
                    result->Error("ICON_EXTRACTION_FAILED", "Failed to extract file icon");
                }
            } else {
                result->Error("INVALID_ARGUMENTS", "File path is required");
            }
        } else       if (call.method_name() == "setClipboardData") {
    const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
    if (!arguments) {
        result->Error("INVALID_ARGS", "Arguments must be a map");
        return;
    }

    try {
        // Безопасное извлечение данных
        auto data_iter = arguments->find(flutter::EncodableValue("data"));
        auto format_iter = arguments->find(flutter::EncodableValue("format"));
        
        if (data_iter == arguments->end() || format_iter == arguments->end()) {
            result->Error("INVALID_ARGS", "Missing required arguments: data and format");
            return;
        }
        
        const auto* data_ptr = std::get_if<std::vector<uint8_t>>(&data_iter->second);
        const auto* format_ptr = std::get_if<std::string>(&format_iter->second);
        
        if (!data_ptr || !format_ptr) {
            result->Error("INVALID_ARGS", "Invalid argument types");
            return;
        }
        
        const auto& data = *data_ptr;
        const auto& formatStr = *format_ptr;
        
        // ВАЛИДАЦИЯ РАЗМЕРА ДАННЫХ
        const size_t MAX_CLIPBOARD_SIZE = 10 * 1024 * 1024; // 10MB лимит
        if (data.empty() || data.size() > MAX_CLIPBOARD_SIZE) {
            result->Error("INVALID_DATA", "Data size must be between 1 and 10MB");
            return;
        }
        
        // ОПРЕДЕЛЕНИЕ ФОРМАТА
        UINT format = 0;
        if (formatStr == "text" || formatStr == "CF_TEXT") {
            format = CF_TEXT;
        } else if (formatStr == "unicode" || formatStr == "CF_UNICODETEXT") {
            format = CF_UNICODETEXT;
        } else if (formatStr == "bitmap" || formatStr == "CF_BITMAP") {
            format = CF_BITMAP;
        } else {
            // Только предварительно зарегистрированные кастомные форматы
            static std::unordered_map<std::string, UINT> allowedCustomFormats = {
                {"HTML", RegisterClipboardFormat(L"HTML Format")},
                {"RTF", RegisterClipboardFormat(L"Rich Text Format")},
                {"PNG", RegisterClipboardFormat(L"PNG")}
            };
            
            auto it = allowedCustomFormats.find(formatStr);
            if (it != allowedCustomFormats.end()) {
                format = it->second;
            } else {
                result->Error("UNSUPPORTED_FORMAT", "Format not supported");
                return;
            }
        }
        
        if (!format) {
            result->Error("INVALID_FORMAT", "Invalid format specified");
            return;
        }
        
        // БЕЗОПАСНАЯ РАБОТА С БУФЕРОМ ОБМЕНА
        if (!OpenClipboard(nullptr)) {
            result->Error("CLIPBOARD_FAILED", "Failed to open clipboard");
            return;
        }
        
        // Освобождаем только наш формат, а не весь буфер
        EmptyClipboard();
        
        HGLOBAL hGlobal = GlobalAlloc(GMEM_MOVEABLE, data.size());
        if (!hGlobal) {
            CloseClipboard();
            result->Error("ALLOC_FAILED", "Failed to allocate memory");
            return;
        }
        
        LPVOID pData = GlobalLock(hGlobal);
        if (!pData) {
            GlobalFree(hGlobal);
            CloseClipboard();
            result->Error("LOCK_FAILED", "Failed to lock memory");
            return;
        }
        
        // Безопасное копирование
        memcpy(pData, data.data(), data.size());
        GlobalUnlock(hGlobal);
        
        // Устанавливаем только ОДИН формат
        if (!SetClipboardData(format, hGlobal)) {
            GlobalFree(hGlobal);
            CloseClipboard();
            result->Error("SET_DATA_FAILED", "Failed to set clipboard data");
            return;
        }
        
        CloseClipboard();
        result->Success(flutter::EncodableValue(true));
        
    } catch (const std::exception& e) {
        result->Error("EXCEPTION", e.what());
    }
}else  if (call.method_name() == "getClipboardData") {
    if (OpenClipboard(nullptr)) {
        flutter::EncodableMap response;
        
        // БЕЗОПАСНОЕ ПОЛУЧЕНИЕ ДАННЫХ ИЗ БУФЕРА
        std::vector<UINT> formatsToCheck = {
            CF_TEXT, CF_UNICODETEXT, CF_HDROP, CF_DIB, CF_BITMAP
        };
        
        for (UINT format : formatsToCheck) {
            HANDLE hData = GetClipboardData(format);
            if (hData) {
                LPVOID pData = GlobalLock(hData);
                if (pData) {
                    SIZE_T size = GlobalSize(hData);
                    if (size > 0 && size < 100 * 1024 * 1024) { // Ограничение 100MB
                        std::vector<uint8_t> data(static_cast<size_t>(size));
                        memcpy(data.data(), pData, static_cast<size_t>(size));
                        GlobalUnlock(hData);
                        
                        // Добавляем данные в ответ
                        response[flutter::EncodableValue("data")] = flutter::EncodableValue(data);
                        response[flutter::EncodableValue("formatId")] = flutter::EncodableValue(static_cast<int32_t>(format));
                        
                        // Получаем имя формата
                        wchar_t formatName[256] = {0};
                        if (GetClipboardFormatName(format, formatName, 255)) {
                            int bufferSize = WideCharToMultiByte(CP_UTF8, 0, formatName, -1, nullptr, 0, nullptr, nullptr);
                            if (bufferSize > 0) {
                                std::string formatNameStr(bufferSize, 0);
                                WideCharToMultiByte(CP_UTF8, 0, formatName, -1, &formatNameStr[0], bufferSize, nullptr, nullptr);
                                formatNameStr.pop_back();
                                response[flutter::EncodableValue("formatName")] = flutter::EncodableValue(formatNameStr);
                            }
                        } else {
                            response[flutter::EncodableValue("formatName")] = flutter::EncodableValue("standard");
                        }
                        
                        CloseClipboard();
                        result->Success(flutter::EncodableValue(response));
                        return;
                    }
                    GlobalUnlock(hData);
                }
            }
        }
        
        CloseClipboard();
        result->Success(); // Пустой результат если ничего не найдено
        
    } else {
        result->Error("CLIPBOARD_FAILED", "Failed to open clipboard");
    }
}else
                 if (call.method_name() == "copyImageToClipboard") {
                    const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
                    if (arguments) {
                        auto image_data_it = arguments->find(flutter::EncodableValue("imageData"));
                        if (image_data_it != arguments->end()) {
                            const auto* image_data = std::get_if<std::vector<uint8_t>>(&image_data_it->second);
                            if (image_data) {
                                bool success = CopyImageToClipboard(*image_data);
                                // Если первая попытка не удалась, пробуем упрощенный метод
                                if (!success) {
                                    success = CopyImageToClipboardSimple(*image_data);
                                }
                                
                                if (success) {
                                    result->Success(flutter::EncodableValue(true));
                                } else {
                                    result->Error("COPY_FAILED", "Failed to copy image to clipboard");
                                }
                                return;
                            }
                        }
                    }
                    result->Error("INVALID_ARGUMENTS", "Invalid arguments for copyImageToClipboard");
                }  else
               if (call.method_name() == "getFocus") {
                    
               
                            // Используйте прямую функцию вместо this->
                            BringToFront(g_flutterHwnd);
                            result->Success();
                }
                else if (call.method_name() == "stopScreenAnalysis") {
                   /* if (analysis_pipeline) {
                        analysis_pipeline->StopAnalysis();
                        result->Success(flutter::EncodableValue(true));
                    } else {
                        result->Error("ANALYSIS_NOT_INITIALIZED", "Analysis pipeline not initialized");
                    }*/
                }else if (call.method_name() == "simulatePaste") {
                    bool success = SimulatePaste();
                    result->Success(flutter::EncodableValue(success));
                }else if (call.method_name() == "getFocusInfo") {
                    std::string focusInfo;
                    FocusInfoHandler::GetFocusInfo(focusInfo);
                    result->Success(focusInfo);
                }else
                if (call.method_name() == "takeScreenshot") {
                    auto pngBytes = TakeScreenshotRaw();
                    if (!pngBytes.empty())
                        result->Success(flutter::EncodableValue(pngBytes));
                    else
                        result->Error("SCREENSHOT_FAILED", "Failed to capture screenshot.");
                } else if (call.method_name() == "scanQRCode") {
                    auto args = std::get<flutter::EncodableMap>(*call.arguments());
                    auto dataEnc = args.find(flutter::EncodableValue("imageData"));
                    
                    if (dataEnc != args.end() && std::holds_alternative<std::vector<uint8_t>>(dataEnc->second)) {
                        auto imageData = std::get<std::vector<uint8_t>>(dataEnc->second);
                        std::string qrText = DecodeQRCode(imageData);
                        result->Success(flutter::EncodableValue(qrText));
                    } else {
                        result->Error("INVALID_ARGUMENTS", "imageData is required and must be Uint8List");
                    }
                } else {
                    result->NotImplemented();
                }
            });
        screenshotChannel->SetMethodCallHandler(
            [](const flutter::MethodCall<flutter::EncodableValue>& call,
               std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
                 if (call.method_name() == "getFileIcon") {
            const auto* filePath = std::get_if<std::string>(call.arguments());
            if (filePath) {
                auto iconData = GetFileIcon(*filePath);
                if (!iconData.empty()) {
                    result->Success(flutter::EncodableValue(iconData));
                } else {
                    result->Error("ICON_EXTRACTION_FAILED", "Failed to extract file icon");
                }
            } else {
                result->Error("INVALID_ARGUMENTS", "File path is required");
            }
        } else       if (call.method_name() == "setClipboardData") {
    const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
    if (!arguments) {
        result->Error("INVALID_ARGS", "Arguments must be a map");
        return;
    }

    try {
        // Безопасное извлечение данных
        auto data_iter = arguments->find(flutter::EncodableValue("data"));
        auto format_iter = arguments->find(flutter::EncodableValue("format"));
        
        if (data_iter == arguments->end() || format_iter == arguments->end()) {
            result->Error("INVALID_ARGS", "Missing required arguments: data and format");
            return;
        }
        
        const auto* data_ptr = std::get_if<std::vector<uint8_t>>(&data_iter->second);
        const auto* format_ptr = std::get_if<std::string>(&format_iter->second);
        
        if (!data_ptr || !format_ptr) {
            result->Error("INVALID_ARGS", "Invalid argument types");
            return;
        }
        
        const auto& data = *data_ptr;
        const auto& formatStr = *format_ptr;
        
        // ВАЛИДАЦИЯ РАЗМЕРА ДАННЫХ
        const size_t MAX_CLIPBOARD_SIZE = 10 * 1024 * 1024; // 10MB лимит
        if (data.empty() || data.size() > MAX_CLIPBOARD_SIZE) {
            result->Error("INVALID_DATA", "Data size must be between 1 and 10MB");
            return;
        }
        
        // ОПРЕДЕЛЕНИЕ ФОРМАТА
        UINT format = 0;
        if (formatStr == "text" || formatStr == "CF_TEXT") {
            format = CF_TEXT;
        } else if (formatStr == "unicode" || formatStr == "CF_UNICODETEXT") {
            format = CF_UNICODETEXT;
        } else if (formatStr == "bitmap" || formatStr == "CF_BITMAP") {
            format = CF_BITMAP;
        } else {
            // Только предварительно зарегистрированные кастомные форматы
            static std::unordered_map<std::string, UINT> allowedCustomFormats = {
                {"HTML", RegisterClipboardFormat(L"HTML Format")},
                {"RTF", RegisterClipboardFormat(L"Rich Text Format")},
                {"PNG", RegisterClipboardFormat(L"PNG")}
            };
            
            auto it = allowedCustomFormats.find(formatStr);
            if (it != allowedCustomFormats.end()) {
                format = it->second;
            } else {
                result->Error("UNSUPPORTED_FORMAT", "Format not supported");
                return;
            }
        }
        
        if (!format) {
            result->Error("INVALID_FORMAT", "Invalid format specified");
            return;
        }
        
        // БЕЗОПАСНАЯ РАБОТА С БУФЕРОМ ОБМЕНА
        if (!OpenClipboard(nullptr)) {
            result->Error("CLIPBOARD_FAILED", "Failed to open clipboard");
            return;
        }
        
        // Освобождаем только наш формат, а не весь буфер
        EmptyClipboard();
        
        HGLOBAL hGlobal = GlobalAlloc(GMEM_MOVEABLE, data.size());
        if (!hGlobal) {
            CloseClipboard();
            result->Error("ALLOC_FAILED", "Failed to allocate memory");
            return;
        }
        
        LPVOID pData = GlobalLock(hGlobal);
        if (!pData) {
            GlobalFree(hGlobal);
            CloseClipboard();
            result->Error("LOCK_FAILED", "Failed to lock memory");
            return;
        }
        
        // Безопасное копирование
        memcpy(pData, data.data(), data.size());
        GlobalUnlock(hGlobal);
        
        // Устанавливаем только ОДИН формат
        if (!SetClipboardData(format, hGlobal)) {
            GlobalFree(hGlobal);
            CloseClipboard();
            result->Error("SET_DATA_FAILED", "Failed to set clipboard data");
            return;
        }
        
        CloseClipboard();
        result->Success(flutter::EncodableValue(true));
        
    } catch (const std::exception& e) {
        result->Error("EXCEPTION", e.what());
    }
}else  if (call.method_name() == "getClipboardData") {
    if (OpenClipboard(nullptr)) {
        flutter::EncodableMap response;
        
        // БЕЗОПАСНОЕ ПОЛУЧЕНИЕ ДАННЫХ ИЗ БУФЕРА
        std::vector<UINT> formatsToCheck = {
            CF_TEXT, CF_UNICODETEXT, CF_HDROP, CF_DIB, CF_BITMAP
        };
        
        for (UINT format : formatsToCheck) {
            HANDLE hData = GetClipboardData(format);
            if (hData) {
                LPVOID pData = GlobalLock(hData);
                if (pData) {
                    SIZE_T size = GlobalSize(hData);
                    if (size > 0 && size < 100 * 1024 * 1024) { // Ограничение 100MB
                        std::vector<uint8_t> data(static_cast<size_t>(size));
                        memcpy(data.data(), pData, static_cast<size_t>(size));
                        GlobalUnlock(hData);
                        
                        // Добавляем данные в ответ
                        response[flutter::EncodableValue("data")] = flutter::EncodableValue(data);
                        response[flutter::EncodableValue("formatId")] = flutter::EncodableValue(static_cast<int32_t>(format));
                        
                        // Получаем имя формата
                        wchar_t formatName[256] = {0};
                        if (GetClipboardFormatName(format, formatName, 255)) {
                            int bufferSize = WideCharToMultiByte(CP_UTF8, 0, formatName, -1, nullptr, 0, nullptr, nullptr);
                            if (bufferSize > 0) {
                                std::string formatNameStr(bufferSize, 0);
                                WideCharToMultiByte(CP_UTF8, 0, formatName, -1, &formatNameStr[0], bufferSize, nullptr, nullptr);
                                formatNameStr.pop_back();
                                response[flutter::EncodableValue("formatName")] = flutter::EncodableValue(formatNameStr);
                            }
                        } else {
                            response[flutter::EncodableValue("formatName")] = flutter::EncodableValue("standard");
                        }
                        
                        CloseClipboard();
                        result->Success(flutter::EncodableValue(response));
                        return;
                    }
                    GlobalUnlock(hData);
                }
            }
        }
        
        CloseClipboard();
        result->Success(); // Пустой результат если ничего не найдено
        
    } else {
        result->Error("CLIPBOARD_FAILED", "Failed to open clipboard");
    }
}else
                 if (call.method_name() == "copyImageToClipboard") {
                    const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
                    if (arguments) {
                        auto image_data_it = arguments->find(flutter::EncodableValue("imageData"));
                        if (image_data_it != arguments->end()) {
                            const auto* image_data = std::get_if<std::vector<uint8_t>>(&image_data_it->second);
                            if (image_data) {
                                bool success = CopyImageToClipboard(*image_data);
                                // Если первая попытка не удалась, пробуем упрощенный метод
                                if (!success) {
                                    success = CopyImageToClipboardSimple(*image_data);
                                }
                                
                                if (success) {
                                    result->Success(flutter::EncodableValue(true));
                                } else {
                                    result->Error("COPY_FAILED", "Failed to copy image to clipboard");
                                }
                                return;
                            }
                        }
                    }
                    result->Error("INVALID_ARGUMENTS", "Invalid arguments for copyImageToClipboard");
                }  else
               if (call.method_name() == "getFocus") {
                    
               
                            // Используйте прямую функцию вместо this->
                            BringToFront(g_flutterHwnd);
                            result->Success();
                }
                else if (call.method_name() == "activateFullClick") {
                        if (g_mainWindow) {
                            activateFullClick();
                            result->Success(flutter::EncodableValue(true));
                        } else {
                            result->Error("NO_WINDOW", "Main window not found");
                        }
                    } else if (call.method_name() == "returnTo80x80Clickable") {
                        if (g_mainWindow) {
                            returnTo80x80Clickable();
                            result->Success(flutter::EncodableValue(true));
                        } else {
                            result->Error("NO_WINDOW", "Main window not found");
                        }
                    }else if (call.method_name() == "stopScreenAnalysis") {
                   /* if (analysis_pipeline) {
                        analysis_pipeline->StopAnalysis();
                        result->Success(flutter::EncodableValue(true));
                    } else {
                        result->Error("ANALYSIS_NOT_INITIALIZED", "Analysis pipeline not initialized");
                    }*/
                }else if (call.method_name() == "simulatePaste") {
                    bool success = SimulatePaste();
                    result->Success(flutter::EncodableValue(success));
                }else if (call.method_name() == "getFocusInfo") {
                    std::string focusInfo;
                    FocusInfoHandler::GetFocusInfo(focusInfo);
                    result->Success(focusInfo);
                }else
                if (call.method_name() == "takeScreenshot") {
                    auto pngBytes = TakeScreenshotRaw();
                    if (!pngBytes.empty())
                        result->Success(flutter::EncodableValue(pngBytes));
                    else
                        result->Error("SCREENSHOT_FAILED", "Failed to capture screenshot.");
                } else if (call.method_name() == "scanQRCode") {
                    auto args = std::get<flutter::EncodableMap>(*call.arguments());
                    auto dataEnc = args.find(flutter::EncodableValue("imageData"));
                    
                    if (dataEnc != args.end() && std::holds_alternative<std::vector<uint8_t>>(dataEnc->second)) {
                        auto imageData = std::get<std::vector<uint8_t>>(dataEnc->second);
                        std::string qrText = DecodeQRCode(imageData);
                        result->Success(flutter::EncodableValue(qrText));
                    } else {
                        result->Error("INVALID_ARGUMENTS", "imageData is required and must be Uint8List");
                    }
                } else {
                    result->NotImplemented();
                }
            });
    }

    MSG msg;
    while (GetMessage(&msg, nullptr, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

Gdiplus::GdiplusShutdown(gdiplusToken);
    ::CoUninitialize();
    return EXIT_SUCCESS;
}