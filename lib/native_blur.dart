import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

// Константы
const ACCENT_ENABLE_BLURBEHIND = 3;
const ACCENT_ENABLE_ACRYLICBLURBEHIND = 4;
const WCA_ACCENT_POLICY = 19;

// Структуры
final class ACCENT_POLICY extends Struct {
  @Int32()
  external int AccentState;
  
  @Int32()
  external int AccentFlags;
  
  @Int32()
  external int GradientColor;
  
  @Int32()
  external int AnimationId;
}

final class WINDOWCOMPOSITIONATTRIBDATA extends Struct {
  @Int32()
  external int Attrib;
  
  external Pointer<Void> pvData;
  
  @Int32()
  external int cbData;
}

// Тип функции
typedef SetWindowCompositionAttributeNative = Int32 Function(
  IntPtr hWnd,
  Pointer<WINDOWCOMPOSITIONATTRIBDATA> data,
);

typedef SetWindowCompositionAttributeDart = int Function(
  int hWnd,
  Pointer<WINDOWCOMPOSITIONATTRIBDATA> data,
);

// Получение функции
final SetWindowCompositionAttributeDart SetWindowCompositionAttribute = 
  _getSetWindowCompositionAttribute();

SetWindowCompositionAttributeDart _getSetWindowCompositionAttribute() {
  final user32 = DynamicLibrary.open('user32.dll');
  final nativeFunction = user32.lookupFunction<
    SetWindowCompositionAttributeNative,
    SetWindowCompositionAttributeDart
  >('SetWindowCompositionAttribute');
  return nativeFunction;
}

class NativeBlur {
  static void enableBlur(int hwnd) {
    final accent = calloc<ACCENT_POLICY>();
    accent.ref.AccentState = ACCENT_ENABLE_BLURBEHIND;
    accent.ref.AccentFlags = 2;
    accent.ref.GradientColor = 0;
    accent.ref.AnimationId = 0;

    final data = calloc<WINDOWCOMPOSITIONATTRIBDATA>();
    data.ref.Attrib = WCA_ACCENT_POLICY;
    data.ref.pvData = accent.cast();
    data.ref.cbData = sizeOf<ACCENT_POLICY>();

    try {
      final result = SetWindowCompositionAttribute(hwnd, data);
      if (result == 0) {
        print('Failed to set blur effect: ${GetLastError()}');
      }
    } finally {
      free(accent);
      free(data);
    }
  }

  static void enableAcrylic(int hwnd) {
    final accent = calloc<ACCENT_POLICY>();
    accent.ref.AccentState = ACCENT_ENABLE_ACRYLICBLURBEHIND;
    accent.ref.AccentFlags = 2;
    accent.ref.GradientColor = 0x99000000; // Полупрозрачный черный
    accent.ref.AnimationId = 0;

    final data = calloc<WINDOWCOMPOSITIONATTRIBDATA>();
    data.ref.Attrib = WCA_ACCENT_POLICY;
    data.ref.pvData = accent.cast();
    data.ref.cbData = sizeOf<ACCENT_POLICY>();

    try {
      final result = SetWindowCompositionAttribute(hwnd, data);
      if (result == 0) {
        print('Failed to set acrylic effect: ${GetLastError()}');
      }
    } finally {
      free(accent);
      free(data);
    }
  }
}