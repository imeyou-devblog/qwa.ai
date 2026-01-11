import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef NativeListener = Void Function(Pointer<Utf8>);
typedef DartListener = void Function(Pointer<Utf8>);

class FileListenerWindows {
  final DynamicLibrary _library;
  final Pointer<NativeFunction<NativeListener>> _callback;

  final StreamController<String> _fileOpenedController =
      StreamController<String>.broadcast();

  Stream<String> get onFileOpened => _fileOpenedController.stream;

  static DartListener? _dartCallback;
  static FileListenerWindows? _instance;

  FileListenerWindows()
      : _library = DynamicLibrary.open('file_listener_plugin.dll'),
        _callback = Pointer.fromFunction<NativeListener>(_onFileOpenedStatic) {
    _instance = this;
  }

  void startListening() {
    final startFunc =
        _library.lookup<NativeFunction<Void Function()>>('startListening');
    startFunc.asFunction<void Function()>()();
  }

  void stopListening() {
    final stopFunc =
        _library.lookup<NativeFunction<Void Function()>>('stopListening');
    stopFunc.asFunction<void Function()>()();
  }

  void setCallback(DartListener callback) {
    _dartCallback = callback;
    final setCallbackFunc = _library.lookup<
        NativeFunction<Void Function(Pointer<NativeFunction<NativeListener>>)>>(
        'setCallback');
    setCallbackFunc
        .asFunction<void Function(Pointer<NativeFunction<NativeListener>>)>()
        (_callback);
  }

  static void _onFileOpenedStatic(Pointer<Utf8> filePath) {
    final path = filePath.toDartString();
    print('File opened (native callback): $path');

    _instance?._fileOpenedController.add(path);
    _dartCallback?.call(filePath);
  }
}
