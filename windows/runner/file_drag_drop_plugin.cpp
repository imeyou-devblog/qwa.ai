#include "file_drag_drop_plugin.h"
#include <windows.h>
#include <memory>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <iostream>
#include <fstream>
#include <thread>
#include <atomic>

namespace {

using namespace flutter;

FileDragDropPlugin* g_plugin_instance = nullptr;
std::atomic<bool> g_monitoring_active{false};
std::thread g_monitoring_thread;

// Функция для логирования
void WriteLog(const std::string& message) {
    std::ofstream logfile("C:\\games\\drag_drop_log.txt", std::ios::app);
    if (logfile.is_open()) {
        logfile << message << std::endl;
        logfile.close();
    }
    OutputDebugStringA(message.c_str());
}

// ПРОСТАЯ и НАДЕЖНАЯ проверка: отслеживаем ТОЛЬКО drag из проводника
bool IsExplorerFileDrag() {
    // Ключевая идея: файловый drag ВСЕГДА происходит из проводника или рабочего стола
    HWND foregroundWindow = GetForegroundWindow();
    if (!foregroundWindow) return false;
    
    char className[256];
    GetClassNameA(foregroundWindow, className, sizeof(className));
    std::string windowClass = className;
    
    WriteLog("IsExplorerFileDrag: Window class: " + windowClass);
    
    // ТОЛЬКО эти окна могут инициировать файловый drag
    bool isFileSource = (windowClass == "CabinetWClass") ||  // Проводник Windows
                       (windowClass == "Progman") ||         // Рабочий стол
                       (windowClass == "WorkerW");           // Рабочий стол (альтернативный)
    
    if (!isFileSource) {
        WriteLog("IsExplorerFileDrag: Not a file source - IGNORING");
        return false;
    }
    
    WriteLog("IsExplorerFileDrag: File source confirmed - potential drag");
    return true;
}

// СУПЕР-ПРОСТОЙ мониторинг: только drag из проводника + движение
void DragMonitoringThread() {
    WriteLog("DragMonitoringThread: Started - SIMPLE EXPLORER-ONLY DETECTION");
    
    POINT last_mouse_pos = {0, 0};
    bool is_dragging = false;
    bool was_in_explorer = false;
    
    while (g_monitoring_active) {
        // Получаем текущую позицию мыши
        POINT current_mouse_pos;
        GetCursorPos(&current_mouse_pos);
        
        // Проверяем, нажата ли левая кнопка мыши
        bool is_button_down = (GetAsyncKeyState(VK_LBUTTON) & 0x8000) != 0;
        
        // Вычисляем расстояние движения мыши
        int movement_distance = abs(current_mouse_pos.x - last_mouse_pos.x) + 
                               abs(current_mouse_pos.y - last_mouse_pos.y);
        
        // ОСНОВНАЯ ЛОГИКА:
        // 1. Кнопка нажата + движение > 20px + окно проводника = ВОЗМОЖНЫЙ DRAG
        // 2. Любое другое сочетание = НЕ DRAG
        
        if (is_button_down && movement_distance > 20) {
            bool in_explorer_now = IsExplorerFileDrag();
            
            if (in_explorer_now && !was_in_explorer) {
                WriteLog("DragMonitoringThread: Movement in explorer - POTENTIAL FILE DRAG");
                was_in_explorer = true;
            }
            
            // Если движение продолжается в проводнике - это вероятно файловый drag
            if (in_explorer_now && movement_distance > 50 && !is_dragging) {
                WriteLog("DragMonitoringThread: *** FILE DRAG START (Explorer + Movement) ***");
                if (g_plugin_instance && !g_plugin_instance->is_dragging_) {
                    g_plugin_instance->is_dragging_ = true;
                    g_plugin_instance->HandleDragStart();
                    is_dragging = true;
                }
            }
        } else {
            was_in_explorer = false;
        }
        
        // Конец drag: кнопка отпущена И был активный drag
        if (!is_button_down && is_dragging) {
            WriteLog("DragMonitoringThread: *** FILE DRAG END ***");
            if (g_plugin_instance && g_plugin_instance->is_dragging_) {
                g_plugin_instance->is_dragging_ = false;
                g_plugin_instance->HandleDragEnd();
            }
            is_dragging = false;
            was_in_explorer = false;
        }
        
        // Сбрасываем все если кнопка отпущена
        if (!is_button_down) {
            was_in_explorer = false;
            is_dragging = false;
        }
        
        last_mouse_pos = current_mouse_pos;
        
        // Задержка
        std::this_thread::sleep_for(std::chrono::milliseconds(30));
    }
    
    WriteLog("DragMonitoringThread: Stopped");
}

}  // namespace

void FileDragDropPlugin::RegisterWithRegistrar(PluginRegistrarWindows* registrar) {
    WriteLog("FileDragDropPlugin: Registering plugin...");
    auto plugin = std::make_unique<FileDragDropPlugin>(registrar);
    g_plugin_instance = plugin.get();
    registrar->AddPlugin(std::move(plugin));
    WriteLog("FileDragDropPlugin: Registered successfully");
}

FileDragDropPlugin::FileDragDropPlugin(flutter::PluginRegistrarWindows* registrar) 
    : registrar_(registrar) {
    WriteLog("FileDragDropPlugin: Constructor called");
    
    channel_ = std::make_unique<MethodChannel<>>(
        registrar->messenger(), "file_drag_drop",
        &StandardMethodCodec::GetInstance());
    
    StartDragMonitoring();
}

FileDragDropPlugin::~FileDragDropPlugin() {
    WriteLog("FileDragDropPlugin: Destructor called");
    StopDragMonitoring();
    g_plugin_instance = nullptr;
}

void FileDragDropPlugin::StartDragMonitoring() {
    WriteLog("FileDragDropPlugin: Starting SIMPLE EXPLORER-ONLY monitoring");
    
    if (!g_monitoring_active) {
        g_monitoring_active = true;
        g_monitoring_thread = std::thread(DragMonitoringThread);
        WriteLog("FileDragDropPlugin: Drag monitoring started");
    }
}

void FileDragDropPlugin::StopDragMonitoring() {
    WriteLog("FileDragDropPlugin: Stopping drag monitoring");
    
    if (g_monitoring_active) {
        g_monitoring_active = false;
        if (g_monitoring_thread.joinable()) {
            g_monitoring_thread.join();
        }
        WriteLog("FileDragDropPlugin: Drag monitoring stopped");
    }
}

void FileDragDropPlugin::HandleDragStart() {
    WriteLog("FileDragDropPlugin: HandleDragStart called");
    try {
        channel_->InvokeMethod("onDragStart", std::make_unique<EncodableValue>(nullptr));
        WriteLog("FileDragDropPlugin: onDragStart invoked successfully");
    } catch (const std::exception& e) {
        WriteLog(std::string("FileDragDropPlugin: Error invoking onDragStart: ") + e.what());
    }
}

void FileDragDropPlugin::HandleDragEnd() {
    WriteLog("FileDragDropPlugin: HandleDragEnd called");
    try {
        channel_->InvokeMethod("onDragEnd", std::make_unique<EncodableValue>(nullptr));
        WriteLog("FileDragDropPlugin: onDragEnd invoked successfully");
    } catch (const std::exception& e) {
        WriteLog(std::string("FileDragDropPlugin: Error invoking onDragEnd: ") + e.what());
    }
}

// Неиспользуемые методы
HWND FileDragDropPlugin::GetMainWindow() {
    return nullptr;
}

void FileDragDropPlugin::SetupWindowHooks() {
}

LRESULT CALLBACK FileDragDropPlugin::WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}