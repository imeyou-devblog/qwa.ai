#include "hotkey_plugin.h"
#include <flutter/plugin_registrar_windows.h>

void HotkeyPluginRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar) {
    HotkeyPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
            ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}