# Файл проверки зависимостей
message(STATUS "=== Checking Dependencies ===")

# Проверка OpenCV
if(USE_OPENCV)
    message(STATUS "✓ OpenCV: ENABLED")
else()
    message(STATUS "✗ OpenCV: DISABLED (using GDI+ fallback)")
endif()

# Проверка ZXing
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/3dparty/zxing/ZXing.lib")
    message(STATUS "✓ ZXing: FOUND")
else()
    message(WARNING "✗ ZXing: NOT FOUND")
endif()

# Проверка ONNX Runtime
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/3dparty/onnxruntime")
    message(STATUS "✓ ONNX Runtime: FOUND")
else()
    message(STATUS "✗ ONNX Runtime: NOT FOUND")
endif()

message(STATUS "=== Dependencies Check Complete ===")