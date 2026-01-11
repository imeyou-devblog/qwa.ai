import 'package:flutter/services.dart';

class FileDragDropService {
  static const MethodChannel _channel = MethodChannel('file_drag_drop');
  
  static Function()? onDragStart;
  static Function()? onDragEnd;
  
  static void initialize() {
    print('FileDragDropService: Initializing...');
    _channel.setMethodCallHandler(_handleMethodCall);
    print('FileDragDropService: Initialized successfully');
  }
  
  static void dispose() {
    print('FileDragDropService: Disposing...');
    _channel.setMethodCallHandler(null);
    onDragStart = null;
    onDragEnd = null;
  }
  
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    print('FileDragDropService: Method call received: ${call.method}');
    
    switch (call.method) {
      case 'onDragStart':
        print('FileDragDropService: Calling onDragStart callback');
        onDragStart?.call();
        break;
      case 'onDragEnd':
        print('FileDragDropService: Calling onDragEnd callback');
        onDragEnd?.call();
        break;
      default:
        print('FileDragDropService: Unknown method: ${call.method}');
    }
  }
}