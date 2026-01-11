#include "hotkey_plugin.h"
#include "hotkey_handler.h"
#include <iostream>

// Коды модификаторов
const UINT MOD_ALT = 0x0001;
const UINT MOD_CONTROL = 0x0002;
const UINT MOD_SHIFT = 0x0004;
const UINT MOD_WIN = 0x0008;

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

void HotkeyPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
    auto channel = std::make_unique<flutter::MethodChannel<>>(
        registrar->messenger(), "hotkey_plugin",
        &flutter::StandardMethodCodec::GetInstance()
    );

    auto plugin = std::make_unique<HotkeyPlugin>(std::move(channel));
    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto& call, auto result) {
            plugin_pointer->HandleMethodCall(call, std::move(result));
        }
    );

    registrar->AddPlugin(std::move(plugin));
}

HotkeyPlugin::HotkeyPlugin(std::unique_ptr<flutter::MethodChannel<>> channel)
    : channel_(std::move(channel)) {
    
    // Инициализируем хоткей хендлер
    HotkeyHandler::GetInstance()->Initialize(std::move(channel_));
}

HotkeyPlugin::~HotkeyPlugin() {
    HotkeyHandler::GetInstance()->UnregisterAll();
}

void HotkeyPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    
    if (method_call.method_name().compare("registerHotkey") == 0) {
        const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        if (!arguments) {
            result->Error("INVALID_ARGUMENTS", "Expected map arguments");
            return;
        }

        try {
            int id = std::get<int>(arguments->at(flutter::EncodableValue("id")));
            std::string modifier = std::get<std::string>(arguments->at(flutter::EncodableValue("modifier")));
            std::string key = std::get<std::string>(arguments->at(flutter::EncodableValue("key")));

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

    } else if (method_call.method_name().compare("unregisterHotkey") == 0) {
        const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
        if (!arguments) {
            result->Error("INVALID_ARGUMENTS", "Expected map arguments");
            return;
        }

        int id = std::get<int>(arguments->at(flutter::EncodableValue("id")));
        HotkeyHandler::GetInstance()->UnregisterHotKey(id);
        result->Success();

    } else if (method_call.method_name().compare("unregisterAll") == 0) {
        HotkeyHandler::GetInstance()->UnregisterAll();
        result->Success();

    } else {
        result->NotImplemented();
    }
}