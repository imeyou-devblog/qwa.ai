#pragma once

#include <flutter/plugin_registrar_windows.h>

class HotkeyPlugin : public flutter::Plugin {
public:
    static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

    HotkeyPlugin();
    ~HotkeyPlugin();

private:
    // Обработчик нажатия горячих клавиш
    static void OnHotkeyPressed(int id);
};