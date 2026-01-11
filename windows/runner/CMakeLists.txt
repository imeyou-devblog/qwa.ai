cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Установка стандарта C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Define the application target
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
    # ============ ДОБАВЬТЕ ЭТИ ДВЕ СТРОКИ ============
  #"file_drag_drop_plugin.cpp"
  #"file_drag_drop_plugin.h"
  "mouse_tracker.cpp"  # ← ДОБАВЬТЕ ЭТУ СТРОКУ
  # ==================================================
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Apply the standard set of build settings
apply_standard_settings(${BINARY_NAME})

# =============================
# ZXing Configuration
# =============================

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/3dparty/zxing/ZXing.lib")
    add_library(zxing STATIC IMPORTED)
    set_target_properties(zxing PROPERTIES
        IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/3dparty/zxing/ZXing.lib"
    )
    target_include_directories(${BINARY_NAME} PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/3dparty/zxing"
    )
    target_link_libraries(${BINARY_NAME} PRIVATE zxing)
    message(STATUS "ZXing library linked")
else()
    message(WARNING "ZXing library not found - QR code functionality will be limited")
endif()

# =============================
# Core Dependencies
# =============================

# Flutter version info
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")

# Windows configuration
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Flutter dependencies
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)

# System libraries
target_link_libraries(${BINARY_NAME} PRIVATE 
    "dwmapi.lib"
    gdiplus.lib
    comctl32.lib
    ole32.lib
    shell32.lib
    shlwapi.lib
    advapi32.lib
)

# Include directories
target_include_directories(${BINARY_NAME} PRIVATE 
    "${CMAKE_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/3dparty/zxing"
)

# Required Flutter dependency
add_dependencies(${BINARY_NAME} flutter_assemble)

# =============================
# Dependency Summary
# =============================

message(STATUS " ")
message(STATUS "=== Dependency Summary ===")
message(STATUS "ZXing: ${CMAKE_CURRENT_SOURCE_DIR}/3dparty/zxing/ZXing.lib")
message(STATUS "OpenCV: DISABLED")
message(STATUS "ONNX Runtime: DISABLED")
message(STATUS "==========================")
message(STATUS " ")