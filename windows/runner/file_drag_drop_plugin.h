#pragma once

#include <flutter/plugin_registrar_windows.h>
#include <flutter/method_channel.h>
#include <memory>
#include <windows.h>

class FileDragDropPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);
  FileDragDropPlugin(flutter::PluginRegistrarWindows* registrar);
  ~FileDragDropPlugin();

  // Публичные методы, вызываемые из WinEventHook
  void HandleDragStart();
  void HandleDragEnd();

  bool is_dragging_ = false;

 private:
  flutter::PluginRegistrarWindows* registrar_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;

  // --- Новый раздел: функции мониторинга ---
  void StartDragMonitoring();
  void StopDragMonitoring();

  // --- Старые методы для совместимости ---
  HWND GetMainWindow();
  void SetupWindowHooks();
  static LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
};
