import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

final DynamicLibrary nativeAudioLib = DynamicLibrary.open('audio_checker.dll');

typedef IsAudioPlayingFunc = Int32 Function();
typedef IsAudioPlaying = int Function();

class WindowsAudioChecker {
  static const MethodChannel _channel = MethodChannel('windows_audio_checker');

  static Future<bool> isAudioPlaying() async {
    try {
      final bool result = await _channel.invokeMethod('isAudioPlaying');
      return result;
    } on PlatformException {
      return false;
    }
  }
}