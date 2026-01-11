import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
// Загружаем нашу Rust библиотеку
final DynamicLibrary _smtcLib = Platform.isWindows
    ? DynamicLibrary.open(path.join(
        Directory.current.path, 
         'windows', 'runner', 'Release', 'smtc_ffi.dll'
      ))
    : DynamicLibrary.process();

// Объявляем нативные функции с Dart типами для asFunction
typedef InitializeSmtcFunc = int Function();
typedef GetCurrentMediaInfoFunc = Pointer<Utf8> Function();
typedef FreeStringFunc = void Function(Pointer<Utf8>);
typedef GetPlaybackStateFunc = int Function();
typedef SendMediaCommandFunc = int Function(int);
typedef CleanupSmtcFunc = void Function();
class AppLogger {
  static Future<void> writeLog(String message) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/music_listener.log');
      final timestamp = DateTime.now().toString();
      final logMessage = '[$timestamp] $message\n';
      await logFile.writeAsString(logMessage, mode: FileMode.append);
      
      print('QUANTUM LOG: $message');
    } catch (e) {
      print('ERROR WRITING LOG: $e');
    }
  }
}
class NativeSMTC {
  late final InitializeSmtcFunc _initialize;
  late final GetCurrentMediaInfoFunc _getCurrentMediaInfo;
  late final FreeStringFunc _freeString;
  late final GetPlaybackStateFunc _getPlaybackState;
  late final SendMediaCommandFunc _sendMediaCommand;
  late final CleanupSmtcFunc _cleanup;

  NativeSMTC() {
    _initialize = _smtcLib
        .lookup<NativeFunction<Int32 Function()>>('initialize_smtc')
        .asFunction<InitializeSmtcFunc>();
    _getCurrentMediaInfo = _smtcLib
        .lookup<NativeFunction<Pointer<Utf8> Function()>>('get_current_media_info')
        .asFunction<GetCurrentMediaInfoFunc>();
    _freeString = _smtcLib
        .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>('free_string')
        .asFunction<FreeStringFunc>();
    _getPlaybackState = _smtcLib
        .lookup<NativeFunction<Int32 Function()>>('get_playback_state')
        .asFunction<GetPlaybackStateFunc>();
    _sendMediaCommand = _smtcLib
        .lookup<NativeFunction<Int32 Function(Int32)>>('send_media_command')
        .asFunction<SendMediaCommandFunc>();
    _cleanup = _smtcLib
        .lookup<NativeFunction<Void Function()>>('cleanup_smtc')
        .asFunction<CleanupSmtcFunc>();

    // Инициализируем SMTC
    final initResult = _initialize();
    AppLogger.writeLog('SMTC инициализирован: $initResult');
  }

 MediaInfo getCurrentMediaInfo() {
    try {
      final ptr = _getCurrentMediaInfo();
      final info = ptr.toDartString();
      _freeString(ptr);

      AppLogger.writeLog('Raw media info from native: "$info"');

      final parts = info.split('|');
      final mediaInfo = MediaInfo(
        title: parts.isNotEmpty ? parts[0] : '',
        artist: parts.length > 1 ? parts[1] : '',
        album: parts.length > 2 ? parts[2] : '',
      );

      AppLogger.writeLog('Parsed media info: $mediaInfo');
      return mediaInfo;
    } catch (e) {
      AppLogger.writeLog('Error getting media info: $e');
      return MediaInfo(title: '', artist: '', album: '');
    }
  }


  PlaybackState getPlaybackState() {
    try {
      final state = _getPlaybackState();
      AppLogger.writeLog('Raw playback state: $state');
      
      switch (state) {
        case 0: 
          AppLogger.writeLog('Playback state: PLAYING');
          return PlaybackState.playing;
        case 1: 
          AppLogger.writeLog('Playback state: PAUSED');
          return PlaybackState.paused;
        case 2: 
          AppLogger.writeLog('Playback state: STOPPED');
          return PlaybackState.stopped;
        default: 
          AppLogger.writeLog('Playback state: UNKNOWN ($state)');
          return PlaybackState.unknown;
      }
    } catch (e) {
      AppLogger.writeLog('Error getting playback state: $e');
      return PlaybackState.unknown;
    }
  }


  bool play() => _sendMediaCommand(0) == 1;
  bool pause() => _sendMediaCommand(1) == 1;
  bool next() => _sendMediaCommand(2) == 1;
  bool previous() => _sendMediaCommand(3) == 1;

  void dispose() {
    _cleanup();
  }
}

class MediaInfo {
  final String title;
  final String artist;
  final String album;

  MediaInfo({
    required this.title,
    required this.artist,
    required this.album,
  });

  @override
  String toString() {
    return 'MediaInfo{title: $title, artist: $artist, album: $album}';
  }
}

enum PlaybackState { playing, paused, stopped, unknown }