import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef StartMouseTrackingNative = Void Function();
typedef StopMouseTrackingNative = Void Function();
typedef GetCursorPositionNative = Int32 Function(Pointer<Int32> x, Pointer<Int32> y);
typedef SimulateMouseClickNative = Void Function(Int32 x, Int32 y);
typedef SimulateKeyPressNative = Void Function(Pointer<Utf8> keys);

// Dart типы для функций
typedef StartMouseTracking = void Function();
typedef StopMouseTracking = void Function();
typedef GetCursorPosition = int Function(Pointer<Int32> x, Pointer<Int32> y);
typedef SimulateMouseClick = void Function(int x, int y);
typedef SimulateKeyPress = void Function(Pointer<Utf8> keys);

class NativeMouseService {
  static final NativeMouseService _instance = NativeMouseService._internal();
  factory NativeMouseService() => _instance;
  
  late final DynamicLibrary _nativeLib;
  late final StartMouseTracking _startMouseTracking;
  late final StopMouseTracking _stopMouseTracking;
  late final GetCursorPosition _getCursorPosition;
  late final SimulateMouseClick _simulateMouseClick;
  late final SimulateKeyPress _simulateKeyPress;

  NativeMouseService._internal() {
    try {
      _nativeLib = DynamicLibrary.open('imeyou_pet.exe'); // или 'mouse_tracker.dll'
      
      final startMouseTrackingPtr = _nativeLib.lookup<NativeFunction<StartMouseTrackingNative>>('StartMouseTracking');
      final stopMouseTrackingPtr = _nativeLib.lookup<NativeFunction<StopMouseTrackingNative>>('StopMouseTracking');
      final getCursorPositionPtr = _nativeLib.lookup<NativeFunction<GetCursorPositionNative>>('GetCursorPosition');
      final simulateMouseClickPtr = _nativeLib.lookup<NativeFunction<SimulateMouseClickNative>>('SimulateMouseClick');
      final simulateKeyPressPtr = _nativeLib.lookup<NativeFunction<SimulateKeyPressNative>>('SimulateKeyPress');
      
      _startMouseTracking = startMouseTrackingPtr.asFunction<StartMouseTracking>();
      _stopMouseTracking = stopMouseTrackingPtr.asFunction<StopMouseTracking>();
      _getCursorPosition = getCursorPositionPtr.asFunction<GetCursorPosition>();
      _simulateMouseClick = simulateMouseClickPtr.asFunction<SimulateMouseClick>();
      _simulateKeyPress = simulateKeyPressPtr.asFunction<SimulateKeyPress>();
    } catch (e) {
      print('Error loading native library: $e');
      // Fallback реализации
      _startMouseTracking = () {};
      _stopMouseTracking = () {};
      _getCursorPosition = (x, y) => 0;
      _simulateMouseClick = (x, y) {};
      _simulateKeyPress = (keys) {};
    }
  }

  void startMouseTracking() {
    _startMouseTracking();
  }

  void stopMouseTracking() {
    _stopMouseTracking();
  }

  ({int x, int y}) getCursorPosition() {
    final x = calloc<Int32>();
    final y = calloc<Int32>();
    
    try {
      final result = _getCursorPosition(x, y);
      if (result == 1) {
        return (x: x.value, y: y.value);
      }
      return (x: 0, y: 0);
    } finally {
      calloc.free(x);
      calloc.free(y);
    }
  }

  void simulateMouseClick(int x, int y) {
    _simulateMouseClick(x, y);
  }

  void simulateKeyPress(String keys) {
    final keysNative = keys.toNativeUtf8();
    try {
      _simulateKeyPress(keysNative);
    } finally {
      calloc.free(keysNative);
    }
  }
}