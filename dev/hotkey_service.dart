import 'package:flutter/services.dart';

class HotkeyService {
  static const MethodChannel _channel = MethodChannel('hotkey_plugin');
  static final HotkeyService _instance = HotkeyService._internal();
  
  factory HotkeyService() => _instance;
  HotkeyService._internal() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }
  
  final Map<int, VoidCallback> _callbacks = {};
  int _nextId = 1;
  
  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onHotkeyPressed':
        final int id = call.arguments;
        _callbacks[id]?.call();
        break;
    }
  }
  
  Future<bool> registerHotkey({
    required String modifier, // 'alt', 'ctrl', 'shift', 'win'
    required String key, // 'z', 'x', 'c', 'v', 's', etc.
    required VoidCallback onPressed,
  }) async {
    final int id = _nextId++;
    _callbacks[id] = onPressed;
    
    try {
      final bool success = await _channel.invokeMethod('registerHotkey', {
        'id': id,
        'modifier': modifier,
        'key': key,
      });
      
      if (!success) {
        _callbacks.remove(id);
      }
      
      return success;
    } on PlatformException catch (e) {
      print('Failed to register hotkey: ${e.message}');
      _callbacks.remove(id);
      return false;
    }
  }
  
  Future<void> unregisterHotkey(int id) async {
    _callbacks.remove(id);
    try {
      await _channel.invokeMethod('unregisterHotkey', {'id': id});
    } on PlatformException catch (e) {
      print('Failed to unregister hotkey: ${e.message}');
    }
  }
  
  Future<void> unregisterAll() async {
    _callbacks.clear();
    try {
      await _channel.invokeMethod('unregisterAll');
    } on PlatformException catch (e) {
      print('Failed to unregister all hotkeys: ${e.message}');
    }
  }
  
  void dispose() {
    unregisterAll();
  }
}