#include "hotkey_plugin.h"
#include "hotkey_handler.h"
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter/plugin_registrar_windows.h>
#include <memory>
#include <map>

// Коды модификаторов
#define MOD_ALT 0x0001
#define MOD_CONTROL 0x0002
#define MOD_SHIFT 0x0004
#define MOD_WIN 0x0008

// Коды клавиш
std::map<std::string, UINT> keyCodes = {
    {"z", 0x5A}, {"x", 0x58}, {"c", 0x43}, {"v", 0x56}, {"s", 0x53},
    {"a", 0x41}, {"d", 0x44}, {"q", 0x51}, {"w", 0x57}, {"e", 0x45},
    {"r", 0x52}, {"f", 0x46}, {"t", 0x54}, {"g", 0x47}, {"y", 0x59},
    {"h", 0x48}, {"u", 0x55}, {"j", 0x4A}, {"i", 0x49}, {"k", 0x4B},
    {"o", 0x4F}, {"l", 0x4C}, {"p", 0x50}, {"1", 0x31}, {"2", 0x32},
    {"3", 0x33}, {"4", 0x34}, {"5", 0x35}, {"6", 0x36}, {"7", 0x37},
    {"8", 0x38}, {"9", 0x39}, {"0", 0x30}
};

// Глобальный channel для отправки сообщений
static std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> g_channel;

void HotkeyPlugin::OnHotkeyPressed(int id) {
    if (g_channel) {
        g_channel->InvokeMethod("onHotkeyPressed", 
            std::make_unique<flutter::EncodableValue>(id));
    }
}

void HotkeyPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
    g_channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        registrar->messenger(), "hotkey_plugin",
        &flutter::StandardMethodCodec::GetInstance());

    // Устанавливаем callback для горячих клавиш
    HotkeyHandler::GetInstance()->SetHotkeyCallback(OnHotkeyPressed);

    auto plugin = std::make_unique<HotkeyPlugin>();

    g_channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto& call, auto result) {
            // Простая обработка вызовов
            if (call.method_name() == "registerHotkey") {
                const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
                if (!arguments) {
                    result->Error("INVALID_ARGUMENTS", "Expected map arguments");
                    return;
                }

                try {
                    auto id = std::get<int>(arguments->at(flutter::EncodableValue("id")));
                    auto modifier = std::get<std::string>(arguments->at(flutter::EncodableValue("modifier")));
                    auto key = std::get<std::string>(arguments->at(flutter::EncodableValue("key")));

                    // Конвертируем модификатор
                    UINT winModifier = 0;
                    if (modifier == "alt") winModifier = MOD_ALT;
                    else if (modifier == "ctrl") winModifier = MOD_CONTROL;
                    else if (modifier == "shift") winModifier = MOD_SHIFT;
                    else if (modifier == "win") winModifier = MOD_WIN;
                    else {
                        result->Error("INVALID_MODIFIER", "Unsupported modifier");
                        return;
                    }

                    // Конвертируем клавишу
                    if (keyCodes.find(key) == keyCodes.end()) {
                        result->Error("INVALID_KEY", "Unsupported key");
                        return;
                    }
                    UINT winKey = keyCodes[key];

                    bool success = HotkeyHandler::GetInstance()->RegisterHotKey(id, winModifier, winKey);
                    result->Success(flutter::EncodableValue(success));

                } catch (const std::exception& e) {
                    result->Error("ARGUMENT_ERROR", e.what());
                }
            }
            else if (call.method_name() == "unregisterHotkey") {
                const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
                if (!arguments) {
                    result->Error("INVALID_ARGUMENTS", "Expected map arguments");
                    return;
                }

                try {
                    auto id = std::get<int>(arguments->at(flutter::EncodableValue("id")));
                    HotkeyHandler::GetInstance()->UnregisterHotKey(id);
                    result->Success();
                } catch (const std::exception& e) {
                    result->Error("ARGUMENT_ERROR", e.what());
                }
            }
            else if (call.method_name() == "unregisterAll") {
                HotkeyHandler::GetInstance()->UnregisterAll();
                result->Success();
            }
            else {
                result->NotImplemented();
            }
        });

    registrar->AddPlugin(std::move(plugin));
}

HotkeyPlugin::HotkeyPlugin() {}

HotkeyPlugin::~HotkeyPlugin() {
    HotkeyHandler::GetInstance()->UnregisterAll();
}