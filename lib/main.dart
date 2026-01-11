// main.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Directory;
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;
import 'package:screen_retriever/screen_retriever.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'audio_checker.dart';
import 'package:file_icon/file_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:system_theme/system_theme.dart';
import 'native_blur.dart'; // Путь к вашему файлу
import 'package:flutter/foundation.dart';

import 'package:clipboard/clipboard.dart';
//import 'file_drag_drop_service.dart';
import 'package:flutter/painting.dart';
import 'dart:isolate';
import 'dart:collection'; // Добавляем этот импорт
import 'package:html/parser.dart' as html_parser;
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/rendering.dart';

import 'package:cross_file/cross_file.dart';

// Add this import for DateFormat
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'hotkey_service.dart';
// Стоп-слова
// Стоп-слова

import 'package:cached_network_image/cached_network_image.dart';


import 'dart:convert';

import 'native_smtc.dart';

import 'native_mouse_service.dart';

import 'package:math_expressions/math_expressions.dart';

import 'package:universal_io/io.dart';

import 'package:path/path.dart' as p;

import 'package:process_run/process_run.dart';


import 'package:crypto/crypto.dart';
import 'package:webview_windows/webview_windows.dart';

import 'package:encrypt/encrypt.dart' as encrypt;

import 'dart:ffi' as ffi;



//import 'package:flutter_cube/flutter_cube.dart' hide Material;


class Localization{


 void init(){

  _currentLocalization=_en;
 }

 String get(String key){

  if (_currentLocalization.containsKey(key)){
    return _currentLocalization[key]!;
  }
  return _currentLocalization['error_no_found']!;
 }
 static const String defaultLanguage = 'en';
static String currentLanguage = defaultLanguage;
Map<String,String> _currentLocalization = {};
// Дефолтные тексты (английский)
static const Map<String, String> _en = {
  // Общие
  'error_no_found': 'not_found_404',
  'app_title': 'Qwa.ai',
  'save': 'Save',
  'cancel': 'Cancel',
  'delete': 'Delete',
  'edit': 'Edit',
  'ok': 'OK',
  'add': 'Add',
  'yes': 'Yes',
  'select': 'Select',
  'no': 'No',
  'error_open_file': 'Error opening file',
  'error_open_link': 'Error opening link',
  'activated': 'Activated',
  'document': 'Document',
  'copy': 'Copy',
  'close': 'Close',
  'star': 'Star',
  'unstar': 'Unstar',
  'location': 'Location',
  'guide': 'Guide',
  'selectArea': 'Select area with text or QR-Code',
  'autoRecognition': 'Recognition will apply automatically',
  'sendToAIg': 'Press "Send to AI"',
  'keysTranslate': 'CTRL+W - Translate to English\nCTRL+Q - Translate to System Language',
  
  // Кнопки
  'login': 'Login',
  'logout': 'Logout',
  'register': 'Register',
  'submit': 'Submit',
  'back': 'Back',
  'next': 'Next',
  'skip': 'Skip',
  'elementDelete': 'Element deletion',
  'ensureDeletion': 'Are you sure, you want to delete ',
  'text': 'Text',
  'keyboard': 'Keyboard',
  'screenshot': 'Screenshot',
  'files': 'Files',
  'AIChat': 'AI Chat',
  'settings01': 'Settings',
  'virtualKeyboard': 'Virtual keyboard',
  
  // Сообщения
  'loading': 'Loading...',
  'error': 'Error',
  'success': 'Success',
  'warning': 'Warning',
  'all': 'All',
  'notFoundTextForCopy': 'Not found text for copy',
  'noTextForTranslate': 'Not found text for translate',
  'textAlreadyTranslated': 'Text already on target language',
  'textTranslated': 'Text translated',
  'translationError': 'Translation error',
  'addTextForAI': 'Add prompt for AI',
  'addSomeText': 'Add or edit text',
  
  // Поля форм
  'email': 'Email',
  'processing': 'Processing',
  'userInput': 'User input',
  'password': 'Password',
  'name': 'Name',
  'phone': 'Phone',
  'QRCodeDone': 'QR-Code recognized',
  'textDone': 'Text recognized',
  'loadingHistory': 'Loading history',
  'TesseractError': 'Tesseract not installed. Please download Tesseract from https://github.com/UB-Mannheim/tesseract/wiki\nInstall it with "Add Tesseract to the system PATH" and restart application',
  'clipboard01':'Clipboard',
  // Ошибки
  'required_field': 'This field is required',
  'invalid_email': 'Invalid email format',
  'weak_password': 'Password is too weak',
  'notification': 'Notification',
  'emptyHistory': 'Empty history',
  'copySomeText': 'Copy text to clipboard',
  'changeSearch': 'Try to change search prompt',
  'noFavElements': 'No favorite elements',
  'nothingFound': 'Nothing found',
  'fileAnalyzeAnswerP1': 'Analyze of the file',
  'isFileOfType': 'Is file of type',
  
  // Меню
  'home': 'Home',
  'probably': 'Probably',
  'settings': 'Settings',
  'profile': 'Profile',
  'notifications': 'Notifications',
  'path': 'Path',
  'searchResult': 'Search result',
  'size': 'Size',
  'chatLocked': 'Chat is closed',
  
  // Диалоги
  'confirm_delete': 'Are you sure you want to delete?',
  'logout_confirm': 'Do you really want to logout?',
  'shortcut': 'Shortcut',
  'file': 'File',
  'removedElementsP1': 'Removed elements: ',
  'savedFavsP2': 'Saved favorites: ',
  'promptForAnalyze': 'If you are familiar with name or path or can guess what kind of file is this - give a brief answer, of what is this. If file is not familiar respond "unknown file"',
  
  // Прочее
  'version': 'Version',
  'viewCode': 'View code',
  'fullText': 'Full text',
  'zipDone': 'ZIP Created',
  'unableToArchive': 'Unable to compose ZIP',
  'htmlExported': 'HTML exported',
  'imageMadeButNotCopied': 'Image made, but not copied to clipboard',
  'textExported': 'Text exported',
  'noElementsToArchive': 'No elements to archive',
  'filesExported': 'Files exported',
  'noImagesToExport': 'No images to export',
  'unableToLoadImage': 'Unable to load image',
  'collageDone': 'Collage done',
  'copyright': 'Copyright',
  'copied': 'Copied',
  'elementCopiedP1': 'Copied element',
  'fromVisible': 'from visible',
  'element': 'Element',
  'notVisible': 'not visible',
  'elementRemoved': 'Element removed',
  'promptAnalyzeFile': 'analyze file',
  
  // Мои тексты
  'dateNotSet': 'Date not set',
  'satiety': 'Satiety',
  'mood': 'Mood',
  'pickFile': 'Pick file',
  'search': 'Search...',
  'nothing_found': 'Nothing found',
  'essentials': 'Essentials',
  'pickColor': 'Pick color',
  'addEssential': 'Add Essential',
  'editEssential': 'Edit Essential',
  'widgetColor': 'Widget color',
  'textColor': 'Text color',
  'newElement': 'New element',
  'comment': 'Comment',
  'noImage': 'No image',
  'imageSet': 'Image set',
  'selectImage': 'Select image',
  'createNotify': 'Create notification',
  'setDate': 'Set date',
  'musicFile': 'Music file',
  'timeNotSet': 'Time not set',
  'setTime': 'Set time',
  'noElements': 'No elements',
  'clipboardHistory': 'Clipboard History',
  'symbols': 'symbols',
  'enterPath': 'Enter URL or filepath...',
  'code': 'Code',
  'link': 'Link',
  'image': 'Image',
  'favorite': 'Favorite',
  'filters': 'Filters',
  'domains': 'Domains: ',
  'eaten': 'Eaten Files',
  'recent': 'Recent',
  'addFile': 'Add file',
  'eatenFilesNum': 'Eaten Files',
  'before': 'Before',
  'noFiles': 'No files',
  'thisMonth': 'This month',
  'dataSaved': 'Data saved',
  'noFilteredFiles': 'No files with such filter',
  'extensions': 'Extensions',
  'noExtension': 'No extension',
  'linkSaved': 'Link to file saved',
  'clearFilter': 'Clear Filters',
  'smallTalk': 'Small talk',
  'wikiOutput': 'Wikipedia summary: ',
  'chatErrorCheckTokens': 'Sorry, there is a trouble connecting to AI Service. Please check your internet connection, API Key and tokens.',
  'allMessages': 'All messages',
  'enterMessage': 'Enter message..',
  'searchWeb': 'search web',
  'searchImages': 'search images',
  'searchWiki': 'search wiki',
  'chooseKey': 'Select key',
  'searchChatHistory': 'Search chat history',
  'clearChat': 'Clear chat',
  'noMessages': 'Chat is empty',
  'searchGoogle': 'Search in Google',
  'modificator': 'Modificator',
  'key': 'Key',
  'icon': 'Icon',
  'pickIcon': 'Select icon',
  'iconSelected': 'Icon selected',
  'hint': 'Hint',
  'selectKey': 'Select key',
  'bindDescription': 'Enter bind description',
  'contentType': 'Content type',
  'typeText': 'Text',
  'typeTextDescription': 'Text entry',
  'toBuffer': 'Copy to Clipboard',
  'toForeground': 'Paste to app',
  'typeFile': 'Shortcut/File',
  'pathToFile': 'Path to file',
  'pickFile2': 'Select File',
  'toOpen': 'Open File',
  'toPath': 'Open in Explorer',
  'toRun': 'Run',
  'urlType': 'URL Entry',
  'typeBuffer': 'Clipboard item',
  'capture': 'Capture',
  'actions': 'Actions',
  'dataStored': 'Data\nStored',
  'paste': 'Paste',
  'macrosActions': 'Macros actions',
  'typeMacro': 'Macros',
  'addMacroAction': 'Add action',
  'actionType': 'Action type',
  'delay': 'Delay',
  'clear': 'Clear',
  'delayTo': 'Delay: ',
  'mouseClick': 'Mouse click',
  'dropImage': 'Drop\nImage',
  'recordMouse': 'Record mouse click',
  'cursorPos': 'Cursor position',
  'startRecord': 'Start record',
  'putKeys': 'Put keys',
  'recordMouseClick': 'Record mouse click',
  'stopRecord': 'Stop record',
  'pressSpaceToRecord': 'Press SPACE to record',
  'stopMouseRecord': 'Stop mouse record',
  'hotkeyMacro': 'Hotkey',
  'keyCombination': 'Key combination',
  'stopKeyRecord': 'Stop recording',
  'actionRun': 'Run File/URL',
  'pathToRun': 'Path to file or url',
  'loop': 'Loop',
  'positionRecorded': 'Position recorded',
  'addedToFav': 'Item added to favorites',
  'removedFromFav': 'Item removed from favorites',
  'copiedToClipboard': 'Copied to clipboard',
  'copiedToClipboard_file': 'File is copied to clipboard',
  'pathCopiedToClipboard': 'Path to file copied to clipboard',
  'newChat': 'New chat',
};
}


class SimpleMutex {
    static ServerSocket? _serverSocket;
  
  /// Проверка через локальный порт - самый надежный способ
   static Future<bool> checkMainInstance({List<String> args = const []}) async {
    // Проверяем аргументы, переданные в метод, а не Platform.executableArguments
    if (args.contains('--subprocess') || Platform.executableArguments.contains('--subprocess')) {
      print('Subprocess detected, skipping mutex check');
      return true;
    }
    final port = 61052; // Фиксированный порт для нашего приложения
    
    try {
      // Пытаемся занять порт
      _serverSocket = await ServerSocket.bind('127.0.0.1', port);
      
      print('✓ Port $port acquired - main instance');
      
      // Обработчик для приветствия вторых инстанций
      _serverSocket!.listen((socket) {
        socket.write('EXISTS'); // Говорим, что приложение уже запущено
        socket.close();
      });
      
      // При выходе освобождаем порт
      _setupCleanup();
      
      return true;
    } on SocketException catch (e) {
      // Порт занят - пробуем подключиться к существующему
      try {
        final socket = await Socket.connect('127.0.0.1', port, timeout: Duration(seconds: 1));
        
        // Читаем ответ
 final response = await utf8.decoder.bind(socket).first;
        socket.close();
        
        if (response == 'EXISTS') {
          print('⚠ App already running on port $port');
          
          // Можно показать сообщение пользователю
          _showAlreadyRunningMessage();
          
          exit(0);
        }
      } catch (e) {
        // Не удалось подключиться - возможно старый процесс умер
        print('⚠ Could not connect to port $port, but it seems busy');
        print('⚠ This might be a stale lock. Trying to start anyway...');
        
        // Для Windows можно попробовать убить процесс на этом порту
        if (Platform.isWindows) {
          _killProcessOnPort(port);
        }
        
        // Пробуем снова через секунду
        await Future.delayed(Duration(seconds: 1));
        return checkMainInstance();
      }
      
      exit(0);
    } catch (e) {
      print('✗ Error: $e');
      // В случае ошибки все равно запускаем
      return true;
    }
  }
  
  static void _showAlreadyRunningMessage() {
    // Можно показать всплывающее окно
    if (Platform.isWindows) {
      Process.run('msg', ['*', 'Приложение уже запущено!']);
    }
  }
  
  static void _killProcessOnPort(int port) {
    if (Platform.isWindows) {
      try {
        // Используем netstat чтобы найти PID процесса на порту
        final result = Process.runSync('netstat', ['-ano']);
        final lines = result.stdout.toString().split('\n');
        
        for (final line in lines) {
          if (line.contains(':$port')) {
            final parts = line.trim().split(RegExp('\\s+'));
            if (parts.length >= 5) {
              final pid = parts[4];
              Process.run('taskkill', ['/pid', pid, '/f']);
              print('⚠ Killed stale process $pid on port $port');
            }
          }
        }
      } catch (e) {
        print('⚠ Could not kill process on port: $e');
      }
    }
  }
  
  static void _setupCleanup() {
    if (_serverSocket != null) {
      ProcessSignal.sigint.watch().listen((_) => _cleanup());
      ProcessSignal.sigterm.watch().listen((_) => _cleanup());
    }
  }
  
  static void _cleanup() async {
    if (_serverSocket != null) {
      await _serverSocket!.close();
      _serverSocket = null;
      print('✓ Port released');
    }
  }
}




class EncryptionService1 {
  static const int _keyLength = 32; // 256 бит для AES-256
  static const int _ivLength = 16; // 128 бит для IV
  static const String _keyFileName = 'secure_key.dat';
  static const String _saltFileName = 'key_salt.dat';
  
  late Directory _appDocDir;
  late File _keyFile;
  late File _saltFile;
  encrypt.IV? _currentIV;
  
  // Приватный конструктор
  EncryptionService1._internal();
  
  // Фабричный метод
  static Future<EncryptionService1> create() async {
    final instance = EncryptionService1._internal();
    await instance._initialize();
    return instance;
  }
  
  // Инициализация
  Future<void> _initialize() async {
    _appDocDir = await getApplicationDocumentsDirectory();
    _keyFile = File('${_appDocDir.path}/$_keyFileName');
    _saltFile = File('${_appDocDir.path}/$_saltFileName');
    
    await _ensureKeyExists();
    await _generateNewIV();
  }
  
  // Проверка и создание ключа
  Future<void> _ensureKeyExists() async {
    if (!await _keyFile.exists()) {
      await _generateAndStoreKey();
    }
  }
  
  // Генерация ключа на основе пароля и соли
  Future<void> _generateAndStoreKey() async {
    final random = Random.secure();
    
    // Генерируем соль
    final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
    await _saltFile.writeAsBytes(saltBytes);
    
    // Используем фиксированный пароль + соль для генерации ключа
    // В реальном приложении используйте более безопасный метод!
    final password = 'your_app_specific_password_${_getDeviceId()}';
    final saltWithPassword = utf8.encode(password) + saltBytes;
    
    // Генерируем ключ с помощью PBKDF2
    final keyBytes = _generatePbkdf2Key(saltWithPassword);
    await _keyFile.writeAsBytes(keyBytes);
  }
  
  // Упрощенная генерация ключа (для примера)
  List<int> _generatePbkdf2Key(List<int> salt) {
    // Используем SHA-256 для генерации ключа
    final key = sha256.convert(salt).bytes;
    
    // Увеличиваем до нужного размера
    final random = Random.secure();
    while (key.length < _keyLength) {
      key.add(random.nextInt(256));
    }
    
    return key.sublist(0, _keyLength);
  }
  
  // Получение уникального идентификатора устройства/приложения
  String _getDeviceId() {
    // Используем путь к приложению как часть идентификатора
    final appPath = Platform.resolvedExecutable;
    final appHash = sha256.convert(utf8.encode(appPath)).bytes;
    return base64Encode(appHash.sublist(0, 8));
  }
  
  // Генерация IV
  Future<void> _generateNewIV() async {
    final random = Random.secure();
    final ivBytes = List<int>.generate(_ivLength, (_) => random.nextInt(256));
    _currentIV = encrypt.IV(Uint8List.fromList(ivBytes));
  }
  
  // Получение ключа из файла
  Future<encrypt.Key> _getKey() async {
    if (!await _keyFile.exists()) {
      throw Exception('Ключ шифрования не найден');
    }
    
    final keyBytes = await _keyFile.readAsBytes();
    return encrypt.Key(Uint8List.fromList(keyBytes));
  }
  
  // Шифрование данных
  Future<String> encryptData(String plainText) async {
    try {
      final key = await _getKey();
      
      if (_currentIV == null) {
        await _generateNewIV();
      }
      
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7')
      );
      
      final encrypted = encrypter.encrypt(plainText, iv: _currentIV!);
      
      // Объединяем IV и зашифрованные данные
      final ivBase64 = base64Encode(_currentIV!.bytes);
      final encryptedBase64 = base64Encode(encrypted.bytes);
      
      return '$ivBase64:$encryptedBase64';
    } catch (e) {
      throw Exception('Ошибка шифрования: $e');
    }
  }
  
  // Расшифрование данных
  Future<String> decryptData(String encryptedText) async {
    try {
      final key = await _getKey();
      
      final parts = encryptedText.split(':');
      if (parts.length != 2) {
        throw Exception('Неверный формат зашифрованных данных');
      }
      
      final ivBytes = base64Decode(parts[0]);
      final encryptedBytes = base64Decode(parts[1]);
      
      final iv = encrypt.IV(ivBytes);
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7')
      );
      
      final encrypted = encrypt.Encrypted(encryptedBytes);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      
      return decrypted;
    } catch (e) {
      throw Exception('Ошибка расшифрования: $e');
    }
  }
  
  // Шифрование бинарных данных
  Future<String> encryptBytes(List<int> data) async {
    final dataBase64 = base64Encode(data);
    return await encryptData(dataBase64);
  }
  
  // Расшифрование бинарных данных
  Future<List<int>> decryptBytes(String encryptedText) async {
    final decryptedBase64 = await decryptData(encryptedText);
    return base64Decode(decryptedBase64);
  }
  
  // Перегенерировать ключ
  Future<void> regenerateKey() async {
    await _keyFile.delete();
    await _saltFile.delete();
    await _generateAndStoreKey();
    await _generateNewIV();
  }
  
  // Проверка наличия ключа
  Future<bool> hasKey() async {
    return await _keyFile.exists();
  }
  
  // Очистка ключа
  Future<void> clearKey() async {
    if (await _keyFile.exists()) {
      await _keyFile.delete();
    }
    if (await _saltFile.exists()) {
      await _saltFile.delete();
    }
    _currentIV = null;
  }
}


class EncryptionManager {
  static EncryptionService1? _instance;
  
  // Получение экземпляра синглтона
  static Future<EncryptionService1> get instance async {
    if (_instance == null) {
      _instance = await EncryptionService1.create();
    }
    return _instance!;
  }
  
  // Шифрование строки
  static Future<String> encrypt(String plainText) async {
    final service = await instance;
    return await service.encryptData(plainText);
  }
  
  // Расшифрование строки
  static Future<String> decrypt(String encryptedText) async {
    final service = await instance;
    return await service.decryptData(encryptedText);
  }
  
  // Шифрование бинарных данных
  static Future<String> encryptBytes(List<int> data) async {
    final service = await instance;
    return await service.encryptBytes(data);
  }
  
  // Расшифрование бинарных данных
  static Future<List<int>> decryptBytes(String encryptedText) async {
    final service = await instance;
    return await service.decryptBytes(encryptedText);
  }
}


















  // ==================== ENUMS ====================

  enum KeyContentType { image, text, url, windowsShortcut, macros, clipboard }
  enum KeyAction { copyToClipboard, pasteToForeground, open, openInExplorer, run }
  enum MacroActionType { hotkey, click, delay, runPath }

  // ==================== MACRO ACTION ====================

  class MacroAction {
    final MacroActionType type;
    final String value;
    final int? x, y, x1, y1, delay;

    MacroAction({
      required this.type,
      required this.value,
      this.x, this.y, this.x1, this.y1, this.delay,
    });

    Map<String, dynamic> toJson() => {
      'type': type.index, 'value': value,
      'x': x, 'y': y, 'x1': x1, 'y1': y1, 'delay': delay,
    };

    factory MacroAction.fromJson(Map<String, dynamic> json) => MacroAction(
      type: MacroActionType.values[json['type'] ?? 0],
      value: json['value'] ?? '',
      x: json['x'], y: json['y'], x1: json['x1'], y1: json['y1'], delay: json['delay'],
    );

    String toScript() {
      switch (type) {
        case MacroActionType.hotkey: return 'HOTKEY: $value';
        case MacroActionType.click: return 'CLICK: ($x,$y) → ($x1,$y1)';
        case MacroActionType.delay: return 'DELAY: ${delay}ms';
        case MacroActionType.runPath: return 'RUN: $value';
      }
    }

    IconData get icon {
      switch (type) {
        case MacroActionType.hotkey: return Icons.keyboard;
        case MacroActionType.click: return Icons.mouse;
        case MacroActionType.delay: return Icons.timer;
        case MacroActionType.runPath: return Icons.play_arrow;
      }
    }

    String get displayName {
      switch (type) {
        case MacroActionType.hotkey: return value;
        case MacroActionType.click: return 'Click';
        case MacroActionType.delay: return '${delay}ms';
        case MacroActionType.runPath: return p.basename(value);
      }
    }
  }

  // ==================== MACRO ====================

  class Macro {
    List<MacroAction> actions;
    int loopAmount;
    
    Macro({required this.actions, this.loopAmount = 1});

    Map<String, dynamic> toJson() => {
      'actions': actions.map((a) => a.toJson()).toList(),
      'loopAmount': loopAmount,
    };
    
    factory Macro.fromJson(Map<String, dynamic> json) => Macro(
      actions: (json['actions'] as List? ?? []).map((a) => MacroAction.fromJson(a)).toList(),
      loopAmount: json['loopAmount'] ?? 1,
    );
    
    String toScript() => 'LOOP: $loopAmount\n${actions.map((a) => a.toScript()).join('\n')}';
  }

  // ==================== KEY BIND ====================

  class KeyBind {
    final String key;
    String name, hint, description, combination;
    KeyContentType type;
    String? imagePath, filePath, textContent, url;
    Macro? macro;
    List<KeyAction> actions;
    IconData? icon;
    Uint8List? fileIcon;

    KeyBind({
      required this.key, required this.name, required this.hint,
      required this.description, required this.type, required this.combination,
      required this.actions, this.imagePath, this.filePath, this.textContent,
      this.url, this.macro, this.icon, this.fileIcon,
    });

    Map<String, dynamic> toJson() => {
      'key': key, 'name': name, 'hint': hint, 'description': description,
      'type': type.index, 'imagePath': imagePath, 'filePath': filePath,
      'textContent': textContent, 'url': url, 'macro': macro?.toJson(),
      'combination': combination, 'actions': actions.map((a) => a.index).toList(),
      'icon': icon?.codePoint,
    };

    factory KeyBind.fromJson(Map<String, dynamic> json) => KeyBind(
      key: json['key'] ?? '', name: json['name'] ?? '', hint: json['hint'] ?? '',
      description: json['description'] ?? '', type: KeyContentType.values[json['type'] ?? 0],
      imagePath: json['imagePath'], filePath: json['filePath'],
      textContent: json['textContent'], url: json['url'],
      macro: json['macro'] != null ? Macro.fromJson(json['macro']) : null,
      combination: json['combination'] ?? '',
      actions: (json['actions'] as List? ?? [0]).map((a) => KeyAction.values[a]).toList(),
      icon: json['icon'] != null ? IconData(json['icon'], fontFamily: 'MaterialIcons') : null,
    );
  }

  // ==================== СЕРВИС ШИФРОВАНИЯ ====================

  class EncryptionService {
    static final EncryptionService _instance = EncryptionService._internal();
    factory EncryptionService() => _instance;
    EncryptionService._internal();

    bool _initialized = false;
    late Uint8List _key;

    Future<void> initialize() async {
      if (_initialized) return;
      final prefs = await SharedPreferences.getInstance();
      String? keyString = prefs.getString('encryption_key');
      if (keyString == null) {
        final random = Random.secure();
        _key = Uint8List.fromList(List<int>.generate(32, (i) => random.nextInt(256)));
        await prefs.setString('encryption_key', base64.encode(_key));
      } else {
        _key = base64.decode(keyString);
      }
      _initialized = true;
    }

    String encrypt(String plainText) {
      if (!_initialized) throw Exception('EncryptionService not initialized');
      final plainBytes = utf8.encode(plainText);
      final encryptedBytes = Uint8List(plainBytes.length);
      for (int i = 0; i < plainBytes.length; i++) {
        encryptedBytes[i] = plainBytes[i] ^ _key[i % _key.length];
      }
      return base64.encode(encryptedBytes);
    }

    String decrypt(String encryptedText) {
      if (!_initialized) throw Exception('EncryptionService not initialized');
      final encryptedBytes = base64.decode(encryptedText);
      final decryptedBytes = Uint8List(encryptedBytes.length);
      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes[i] = encryptedBytes[i] ^ _key[i % _key.length];
      }
      return utf8.decode(decryptedBytes);
    }
  }

  // ==================== ХРАНИЛИЩЕ ====================

  class KeyBindStorage {
    static final KeyBindStorage _instance = KeyBindStorage._internal();
    factory KeyBindStorage() => _instance;
    KeyBindStorage._internal();
    String?  _filePath, _textContent;
    final Map<String, KeyBind> _keyBinds = {};
    bool _loaded = false;
    late TextEditingController _nameCtrl, _hintCtrl, _descCtrl;
    Future<void> loadKeyBinds() async {
      if (_loaded) return;
      try {
        await EncryptionService().initialize();
        final prefs = await SharedPreferences.getInstance();
        final encryptedData = prefs.getString('key_binds_encrypted');
        if (encryptedData != null) {
          final jsonData = EncryptionService().decrypt(encryptedData);
          final Map<String, dynamic> data = json.decode(jsonData);
          _keyBinds.clear();
          data.forEach((key, value) {
            try {
              _keyBinds[key] = KeyBind.fromJson(value);
            } catch (e) {
              print('Error loading keybind $key: $e');
            }
          });
        }
        _loaded = true;
      } catch (e) {
        print('Error loading key binds: $e');
        _keyBinds.clear();
        _loaded = true;
      }
    }

    Future<void> saveKeyBinds() async {
      try {
        final data = <String, dynamic>{};
        _keyBinds.forEach((key, value) => data[key] = value.toJson());
        final jsonData = json.encode(data);
        final encryptedData = EncryptionService().encrypt(jsonData);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('key_binds_encrypted', encryptedData);
      } catch (e) {
        print('Error saving key binds: $e');
      }
    }

    KeyBind? getKeyBind(String key) => _keyBinds[key];
    void setKeyBind(String key, KeyBind keyBind) {
      _keyBinds[key] = keyBind;
      saveKeyBinds();
    }
    void removeKeyBind(String key) {
      _keyBinds.remove(key);
      saveKeyBinds();
    }
    bool hasKeyBind(String key) => _keyBinds.containsKey(key);
    List<String> getAllKeys() => _keyBinds.keys.toList();
  }





  // ==================== СЕРВИС ВЫПОЛНЕНИЯ ДЕЙСТВИЙ ====================

  class ActionService {
    static final ActionService _instance = ActionService._internal();
    factory ActionService() => _instance;
    ActionService._internal();
  final NativeMouseService _mouseService = NativeMouseService();
    Future<void> executeKeyBind(KeyBind keyBind) async {
      try {
        for (final action in keyBind.actions) {
          await _executeAction(keyBind, action);
        }
      } catch (e) {
        print('Error executing keybind: $e');
      }
    }

    Future<void> _executeAction(KeyBind keyBind, KeyAction action) async {
  switch (action) {
    case KeyAction.copyToClipboard:
      await _copyToClipboard(keyBind);
      break;
    case KeyAction.pasteToForeground:
      await _pasteToForeground(keyBind);
      break;
    case KeyAction.open:
      await _open(keyBind);
      break;
    case KeyAction.openInExplorer:
      await _openInExplorer(keyBind);
      break;
    case KeyAction.run:
      await _run(keyBind);
      break;
  }
}

Future<void> _pasteClipboardData(KeyBind keyBind) async {
  if (keyBind.filePath != null && File(keyBind.filePath!).existsSync()) {
    try {
      final file = File(keyBind.filePath!);
      final data = await file.readAsBytes();
      
      const MethodChannel clipboardChannel = MethodChannel('screenshot_channel');
      
      final Map<String, dynamic> arguments = {
        'data': data,
        'format': keyBind.textContent ?? 'unknown',
      };
      
      // Если у нас есть ID формата, передаем его тоже
      if (keyBind.textContent?.startsWith('custom/') == true) {
        final formatId = int.tryParse(keyBind.textContent!.replaceFirst('custom/', ''));
        if (formatId != null) {
          arguments['formatId'] = formatId;
        }
      }
      
      final success = await clipboardChannel.invokeMethod('setClipboardData', arguments);
      
      if (success == true) {
        print('Clipboard data pasted successfully');
        // Можно добавить уведомление если нужно
      } else {
        print('Failed to paste clipboard data');
      }
    } catch (e) {
      print('Error pasting clipboard data: $e');
    }
  } else if (keyBind.textContent != null) {
    // Fallback для текста
    await Clipboard.setData(ClipboardData(text: keyBind.textContent!));
  }
}

Future<void> _copyToClipboard(KeyBind keyBind) async {
  switch (keyBind.type) {
    case KeyContentType.text:
      if (keyBind.textContent != null) {
        await Clipboard.setData(ClipboardData(text: keyBind.textContent!));
      }
      break;
    case KeyContentType.image:
      if (keyBind.imagePath != null) {
        final file = File(keyBind.imagePath!);
        if (file.existsSync()) {
          final imageBytes = await file.readAsBytes();
          try {
            const MethodChannel clipboardChannel = MethodChannel('screenshot_channel');
            await clipboardChannel.invokeMethod('copyImageToClipboard', {
              'imageData': imageBytes,
            });
          } catch (e) {
            print('Error copying image to clipboard: $e');
            await Clipboard.setData(ClipboardData(text: keyBind.imagePath!));
          }
        }
      }
      break;
    case KeyContentType.url:
      if (keyBind.url != null) {
        await Clipboard.setData(ClipboardData(text: keyBind.url!));
      }
      break;
    case KeyContentType.windowsShortcut:
      if (keyBind.filePath != null) {
        final file = File(keyBind.filePath!);
        if (file.existsSync()) {
          try {
            final content = await file.readAsBytes();
            const MethodChannel clipboardChannel = MethodChannel('screenshot_channel');
            await clipboardChannel.invokeMethod('copyFileToClipboard', {
              'filePath': keyBind.filePath,
              'fileBytes': content,
            });
          } catch (e) {
            print('Error copying file to clipboard: $e');
            await Clipboard.setData(ClipboardData(text: keyBind.filePath!));
          }
        } else {
          await Clipboard.setData(ClipboardData(text: keyBind.filePath!));
        }
      }
      break;
   case KeyContentType.clipboard:
      await _pasteClipboardData(keyBind);
      break;
    case KeyContentType.macros:
      print('Cannot copy macro to clipboard');
      break;
  }
}

    Future<void> _pasteToForeground(KeyBind keyBind) async {
      await _copyToClipboard(keyBind);
      print('Pasting to foreground: ${keyBind.name}');
    }

    Future<void> _open(KeyBind keyBind) async {
      switch (keyBind.type) {
        case KeyContentType.url:
          if (keyBind.url != null) {
            await Process.run('start', [keyBind.url!], runInShell: true);
          }
          break;
        case KeyContentType.windowsShortcut:
          if (keyBind.filePath != null) {
            await Process.run('cmd', ['/c', 'start', '', keyBind.filePath!], runInShell: true);
          }
          break;
        default:
          print('Cannot open this content type');
      }
    }

    Future<void> _openInExplorer(KeyBind keyBind) async {
      if (keyBind.filePath != null) {
        final directory = p.dirname(keyBind.filePath!);
        await Process.run('explorer', [directory]);
      }
    }

    Future<void> _run(KeyBind keyBind) async {
      if (keyBind.type == KeyContentType.macros && keyBind.macro != null) {
        await _executeMacro(keyBind.macro!);
      } else if (keyBind.filePath != null) {
        await Process.run(keyBind.filePath!, [], runInShell: true);
      }
    }

    Future<void> _executeMacro(Macro macro) async {
    for (int i = 0; i < macro.loopAmount; i++) {
      for (final action in macro.actions) {
        await _executeMacroAction(action);
        // Убрал дублирующую задержку здесь, так как она теперь в _executeMacroAction
      }
    }
  }
  Future<void> _executeMacroAction(MacroAction action) async {
    switch (action.type) {
      case MacroActionType.hotkey:
        await _simulateHotkey(action.value);
        break;
      case MacroActionType.click:
        await _simulateClick(action.x!, action.y!);
        break;
      case MacroActionType.delay:
        await Future.delayed(Duration(milliseconds: action.delay ?? 1000));
        print('Delayed for ${action.delay}ms');
        break;
      case MacroActionType.runPath:
        if (action.value.isNotEmpty) {
          await Process.run(action.value, [], runInShell: true);
        }
        break;
    }
  }

  Future<void> _simulateHotkey(String hotkey) async {
    try {
      _mouseService.simulateKeyPress(hotkey);
    } catch (e) {
      print('Error simulating hotkey: $e');
    }
  }



  String _convertHotkeyToSendKeys(String hotkey) {
    // Конвертируем наш формат хоткеев в формат SendKeys
    return hotkey
        .replaceAll('Ctrl+', '^')
        .replaceAll('Alt+', '%')
        .replaceAll('Shift+', '+')
        .replaceAll('Win+', '#');
  }

  Future<void> _simulateClick(int x, int y) async {
    try {
      _mouseService.simulateMouseClick(x, y);
    } catch (e) {
      print('Error simulating click: $e');
    }
  }
  }

  // ==================== ГЛАВНОЕ ПРИЛОЖЕНИЕ ====================

  class VirtualKeyboardApp extends StatelessWidget {
    const VirtualKeyboardApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Virtual Keyboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.transparent,
          colorScheme: ColorScheme.dark(
            primary: Colors.blue,
            secondary: Colors.blueAccent,
          ),
        ),
        home: const VirtualKeyboardScreen(),
      );
    }
  }

  // ==================== ГЛАВНЫЙ ЭКРАН ====================

  class VirtualKeyboardScreen extends StatefulWidget {
    const VirtualKeyboardScreen({Key? key}) : super(key: key);

    @override
    State<VirtualKeyboardScreen> createState() => _VirtualKeyboardScreenState();
  }

  class _VirtualKeyboardScreenState extends State<VirtualKeyboardScreen> with WindowListener {
    final KeyBindStorage _storage = KeyBindStorage();
    final ActionService _actionService = ActionService();
    bool _isLoading = true;
    bool _isEditing = false;
    bool _isMinimized = false;
    final FocusNode _focusNode = FocusNode();
    bool _isDragging = false;
    Offset _dragOffset = Offset.zero;
    Localization _locale = Localization();
  final List<List<String>> _keyboardLayout = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M', 'ADD'],
  ];

 // Добавьте эти переменные:
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = true;



  // Метод для обработки поискового запроса
  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    // 1. Проверка на математическую формулу
    final mathResult = _evaluateMathExpression(query);
    if (mathResult != null) {
      setState(() {
        _searchController.text = mathResult;
      });
      return;
    }

    // 2. Проверка на URL
    if (_isUrl(query)) {
      _launchUrl(query);
      return;
    }

    // 3. Проверка на файловый путь
    if (_isFilePath(query)) {
      _openFile(query);
      return;
    }

    // 4. Обычный поисковый запрос
    _performGoogleSearch(query);

    _animateWindowFadeOutToBottomToClose();
  }

  // Проверка и вычисление математических выражений
  String? _evaluateMathExpression(String expression) {
    try {
      // Убираем пробелы и проверяем на математические символы
      final cleanExpression = expression.replaceAll(' ', '');
      
      // Проверяем, содержит ли выражение математические операторы
      final hasMathOperators = RegExp(r'[+\-*/^√πe()]|sin|cos|tan|log|ln').hasMatch(cleanExpression);
      final hasNumbers = RegExp(r'\d').hasMatch(cleanExpression);
      
      if (!hasMathOperators || !hasNumbers) {
        return null;
      }

      // Заменяем распространенные математические символы
      String mathExpression = cleanExpression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('^', '**')
          .replaceAll('√', 'sqrt')
          .replaceAll('π', 'pi')
          .replaceAll('e', 'e');

      // Парсим и вычисляем выражение
      Parser p = Parser();
      Expression exp = p.parse(mathExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Форматируем результат
      if (eval == eval.floor()) {
        return eval.floor().toString();
      } else {
        return eval.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      return null;
    }
  }

  // Проверка на URL
  bool _isUrl(String text) {
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    return urlPattern.hasMatch(text) || text.startsWith('http://') || text.startsWith('https://');
  }

  // Проверка на файловый путь
  bool _isFilePath(String text) {
    if (text.length < 3) return false;
    
    // Проверка на абсолютный путь Windows (C:\...)
    if (RegExp(r'^[A-Za-z]:\\').hasMatch(text)) {
      return File(text).existsSync();
    }
    
    // Проверка на абсолютный путь Unix (/home/...)
    if (text.startsWith('/') || text.startsWith('~/')) {
      return File(text.replaceFirst('~', p.dirname(Platform.resolvedExecutable))).existsSync();
    }
    
    // Проверка на относительный путь
    final currentDir = Directory.current.path;
    return File(p.join(currentDir, text)).existsSync();
  }

  // Запуск URL
  Future<void> _launchUrl(String url) async {
    String formattedUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      formattedUrl = 'https://$url';
    }
    
    final uri = Uri.parse(formattedUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('Не удалось открыть URL: $url');
    }
  }

  // Открытие файла
  Future<void> _openFile(String filePath) async {
    try {
      String actualPath = filePath;
      
      // Обработка домашней директории
      if (filePath.startsWith('~/')) {
        final homeDir = p.dirname(Platform.resolvedExecutable);
        actualPath = p.join(homeDir, filePath.substring(2));
      }
      
      final file = File(actualPath);
      if (await file.exists()) {
        await Process.run('cmd', ['/c', 'start', '', actualPath], runInShell: true);
      } else {
        _showError('Файл не найден: $actualPath');
      }
    } catch (e) {
      _showError('Ошибка при открытии файла: $e');
    }
  }

  // Выполнение поиска в Google
  Future<void> _performGoogleSearch(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final searchUrl = 'https://www.google.com/search?q=$encodedQuery';
    final uri = Uri.parse(searchUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('Не удалось выполнить поиск');
    }
  }

  // Показать ошибку
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Обработчик нажатия клавиш в поисковой строке
  void _handleSearchKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _handleSearch();
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        _searchFocusNode.unfocus();
        _focusNode.requestFocus();
      }
    }
  }

    @override
    void initState() {
      super.initState();
      _locale.init();
      windowManager.addListener(this);
      _initialize();
       // Автофокус на поисковую строку после загрузки
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });*/

     _searchController.addListener(() {
    if (mounted) setState(() {});
  });
    }

    @override
    void dispose() {
         _searchController.dispose();
    _searchFocusNode.dispose();
      windowManager.removeListener(this);
      _focusNode.dispose();
      super.dispose();
    }

    Future<void> _initialize() async {
      await windowManager.ensureInitialized();
        final primaryDisplay = await screenRetriever.getPrimaryDisplay();
      final screenSize = primaryDisplay.size;
      final windowHeight = screenSize.height * 0.35;
      final windowWidth = screenSize.width * 0.55;
      WindowOptions windowOptions = WindowOptions(
        size:  Size(windowWidth, windowHeight),
        minimumSize:  Size(windowWidth, windowHeight),
        center: false,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
        title: 'Virtual Keyboard',
      );

      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        try {
        await windowManager.setAsFrameless();
      } catch (e) {
        print('Error setting frameless: $e');
      }

      try {
        await windowManager.setHasShadow(false);
      } catch (e) {
        print('Error disabling shadow: $e');
      }
      
      await windowManager.show();
        await _setWindowPosition();
        await windowManager.focus();
      });

      await _storage.loadKeyBinds();
      if (mounted) setState(() => _isLoading = false);
      
        WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      _searchFocusNode.requestFocus();
      setState(() {
        _isSearchFocused = true;
      });
    }
  });
    }

    Future<void> _setWindowPosition() async {
      final primaryDisplay = await screenRetriever.getPrimaryDisplay();
      final screenSize = primaryDisplay.size;
      
      if (_isMinimized) {
        await windowManager.setPosition(const Offset(0, 25));
      } else {
        final windowHeight = screenSize.height * 0.32;
        final windowWidth = screenSize.width * 0.55;
        final yPosition = screenSize.height - windowHeight - 50;
        await windowManager.setPosition(Offset( (screenSize.width - windowWidth )/2, yPosition));
      }
    }

    Future<void> _toggleMinimize() async {
      setState(() => _isMinimized = !_isMinimized);
      final primaryDisplay = await screenRetriever.getPrimaryDisplay();
      final screenSize = primaryDisplay.size;
      if (_isMinimized) {
        await windowManager.setSize( Size(550, 300));
        await windowManager.setPosition( Offset(50, 150));
      } else {
            final windowHeight = screenSize.height * 0.32;
        final windowWidth = screenSize.width * 0.55;
        await windowManager.setSize( Size(windowWidth, windowHeight));
        await _setWindowPosition();
      }
    }

    void _onKeyPressed(String key) {
      if (_isEditing) return;
      
      if (key == 'ADD') {
        _showAddDialog();
        return;
      }

      final keyBind = _storage.getKeyBind(key);
      if (keyBind != null) {
        _actionService.executeKeyBind(keyBind);
      }
    }

    void _onKeySecondaryTap(String key) {
      _showKeyEditor(key);
    }

    void _onKeyLongPressed(String key) {
      _showKeyEditor(key);
    }

 
void _handleKeyEvent(RawKeyEvent event) {
    if (_searchFocusNode.hasFocus) return;
  if (event is RawKeyDownEvent && !_isEditing) {
    final logicalKey = event.logicalKey;
    
    // ESC переключает фокус между поиском и клавиатурой
    if (logicalKey == LogicalKeyboardKey.escape) {
      if (_searchFocusNode.hasFocus) {
        _searchFocusNode.unfocus();
        _focusNode.requestFocus();
        setState(() {
          _isSearchFocused = false;
        });
      } else {
        _searchFocusNode.requestFocus();
        setState(() {
          _isSearchFocused = true;
        });
      }
      return;
    }
    
    // Caps Lock закрывает приложение
    if (logicalKey == LogicalKeyboardKey.capsLock) {
      _animateWindowFadeOutToBottomToClose();
      return;
    }
    
    // Обработка хоткеев для привязанных клавиш
    _handleKeyBinds(event);
  }
}



void _handleKeyEventEsc(RawKeyEvent event) {
  
  if (event is RawKeyDownEvent && !_isEditing) {
    final logicalKey = event.logicalKey;
    
    // ESC переключает фокус между поиском и клавиатурой
    if (logicalKey == LogicalKeyboardKey.escape) {
      if (_searchFocusNode.hasFocus) {
        _searchFocusNode.unfocus();
        _focusNode.requestFocus();
        setState(() {
          _isSearchFocused = false;
        });
      } else {
        _searchFocusNode.requestFocus();
        setState(() {
          _isSearchFocused = true;
        });
      }
      return;
    }
    
    // Caps Lock закрывает приложение
    if (logicalKey == LogicalKeyboardKey.capsLock) {
      _animateWindowFadeOutToBottomToClose();
      return;
    }
    
  }
}

void _handleKeyBinds(RawKeyEvent event) {
  final pressedKeys = RawKeyboard.instance.keysPressed;
  
  for (final key in _storage.getAllKeys()) {
    final keyBind = _storage.getKeyBind(key);
    if (keyBind != null) {
      final parts = keyBind.combination.split('+');
      if (parts.length == 2) {
        final modifier = parts[0];
        final keyChar = parts[1];
        
        // Проверяем модификатор
        bool modifierPressed = false;
        if (modifier == 'CTRL') {
          modifierPressed = pressedKeys.contains(LogicalKeyboardKey.controlLeft) || 
                           pressedKeys.contains(LogicalKeyboardKey.controlRight);
        } else if (modifier == 'SHIFT') {
          modifierPressed = pressedKeys.contains(LogicalKeyboardKey.shiftLeft) || 
                           pressedKeys.contains(LogicalKeyboardKey.shiftRight);
        } else if (modifier == 'ALT') {
          modifierPressed = pressedKeys.contains(LogicalKeyboardKey.altLeft) || 
                           pressedKeys.contains(LogicalKeyboardKey.altRight);
        }
        
        // Проверяем основную клавишу
        bool keyPressed = _isKeyPressed(keyChar, pressedKeys);
        
        if (modifierPressed && keyPressed) {
          _actionService.executeKeyBind(keyBind);
          break;
        }
      }
    }
  }
}

bool _isKeyPressed(String keyChar, Set<LogicalKeyboardKey> pressedKeys) {
  final keyMap = {
    'Q': LogicalKeyboardKey.keyQ,
    'W': LogicalKeyboardKey.keyW,
    'E': LogicalKeyboardKey.keyE,
    'R': LogicalKeyboardKey.keyR,
    'T': LogicalKeyboardKey.keyT,
    'Y': LogicalKeyboardKey.keyY,
    'U': LogicalKeyboardKey.keyU,
    'I': LogicalKeyboardKey.keyI,
    'O': LogicalKeyboardKey.keyO,
    'P': LogicalKeyboardKey.keyP,
    'A': LogicalKeyboardKey.keyA,
    'S': LogicalKeyboardKey.keyS,
    'D': LogicalKeyboardKey.keyD,
    'F': LogicalKeyboardKey.keyF,
    'G': LogicalKeyboardKey.keyG,
    'H': LogicalKeyboardKey.keyH,
    'J': LogicalKeyboardKey.keyJ,
    'K': LogicalKeyboardKey.keyK,
    'L': LogicalKeyboardKey.keyL,
    'Z': LogicalKeyboardKey.keyZ,
    'X': LogicalKeyboardKey.keyX,
    'C': LogicalKeyboardKey.keyC,
    'V': LogicalKeyboardKey.keyV,
    'B': LogicalKeyboardKey.keyB,
    'N': LogicalKeyboardKey.keyN,
    'M': LogicalKeyboardKey.keyM,
  };
  
  final targetKey = keyMap[keyChar];
  return targetKey != null && pressedKeys.contains(targetKey);
}
bool _physicalKeyMatchesCharacter(PhysicalKeyboardKey physicalKey, String character) {
  // Маппинг физических клавиш к символам в английской раскладке
  const keyMap = {
    'Q': PhysicalKeyboardKey.keyQ,
    'W': PhysicalKeyboardKey.keyW,
    'E': PhysicalKeyboardKey.keyE,
    'R': PhysicalKeyboardKey.keyR,
    'T': PhysicalKeyboardKey.keyT,
    'Y': PhysicalKeyboardKey.keyY,
    'U': PhysicalKeyboardKey.keyU,
    'I': PhysicalKeyboardKey.keyI,
    'O': PhysicalKeyboardKey.keyO,
    'P': PhysicalKeyboardKey.keyP,
    'A': PhysicalKeyboardKey.keyA,
    'S': PhysicalKeyboardKey.keyS,
    'D': PhysicalKeyboardKey.keyD,
    'F': PhysicalKeyboardKey.keyF,
    'G': PhysicalKeyboardKey.keyG,
    'H': PhysicalKeyboardKey.keyH,
    'J': PhysicalKeyboardKey.keyJ,
    'K': PhysicalKeyboardKey.keyK,
    'L': PhysicalKeyboardKey.keyL,
    'Z': PhysicalKeyboardKey.keyZ,
    'X': PhysicalKeyboardKey.keyX,
    'C': PhysicalKeyboardKey.keyC,
    'V': PhysicalKeyboardKey.keyV,
    'B': PhysicalKeyboardKey.keyB,
    'N': PhysicalKeyboardKey.keyN,
    'M': PhysicalKeyboardKey.keyM,
  };
  
  return keyMap[character] == physicalKey;
}

  Future<void> _animateWindowFadeOutToBottomToClose() async {

    final primaryDisplay = await screenRetriever.getPrimaryDisplay();
      final screenSize = primaryDisplay.size;
      final windowHeight = screenSize.height * 0.32;
      final windowWidth = screenSize.width * 0.55;
      // Устанавливаем точный размер
      await windowManager.setSize(Size(windowWidth, windowHeight));

      // Начальная позиция (за пределами экрана справа)
      final endPosition = Offset(
        (screenSize.width - windowWidth)/2, // Полностью за правым краем
        (screenSize.height ) ,
      );

      // Конечная позиция
      final startPosition = Offset(
    (screenSize.width - windowWidth )/2, // Правый край
        (screenSize.height - windowHeight) - 50,
      );

      // Устанавливаем начальную позицию (невидимо за экраном)
      await windowManager.setPosition(startPosition);

    const duration = Duration(milliseconds: 390);
    const steps = 60;
    final stepDuration = duration ~/ steps;

    for (int i = 0; i <= steps; i++) {
      final progress = i / steps;
      
      // Используем кривую для более естественной анимации
      final curvedProgress = Curves.easeOutCubic.transform(progress);
      
      final currentY = startPosition.dy + (endPosition.dy - startPosition.dy) * curvedProgress;
      final currentPosition = Offset(startPosition.dx,currentY);
      
      // Можно использовать разные кривые для прозрачности и движения
      final fadeProgress = Curves.easeOutCubic.transform(progress);
      final currentOpacity = fadeProgress;

      await windowManager.setPosition(currentPosition);
      await windowManager.setOpacity(1.0-currentOpacity);

      await Future.delayed(stepDuration);
    }

    // Финальные значения
    await windowManager.setPosition(endPosition);
    await windowManager.setOpacity(0.0);
    await windowManager.close();
  }

    void _showKeyEditorWithBind(String key, KeyBind bind) {
      setState(() => _isEditing = true);
      
      showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (context) => KeyBindEditor(
          keyId: key,
          existingBind: bind,
          onSave: (newBind) {
            _storage.setKeyBind(key, newBind);
            setState(() {});
            Navigator.of(context).pop();
            setState(() => _isEditing = false);
          },
          onDelete: _storage.hasKeyBind(key) ? () {
            _storage.removeKeyBind(key);
            setState(() {});
            Navigator.of(context).pop();
            setState(() => _isEditing = false);
          } : null,
        ),
      ).then((_) => setState(() => _isEditing = false));
    }
// Добавьте эту переменную в класс _VirtualKeyboardScreenState
double _searchBarWidth = 300.0;

Widget _buildSearchBar() {
  // Получаем максимальную ширину (80% от ширины экрана)
  final maxWidth = MediaQuery.of(context).size.width * 0.8;
  
  // Вычисляем ширину на основе длины текста
  double calculatedWidth = _searchBarWidth;
  if (_searchController.text.isNotEmpty) {
    final textLength = _searchController.text.length;
    // Увеличиваем ширину пропорционально длине текста, но не больше maxWidth
    calculatedWidth = _searchBarWidth + (textLength * 8.0);
    if (calculatedWidth > maxWidth) {
      calculatedWidth = maxWidth;
    }
  }

  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    curve: Curves.easeInOut,
    width: calculatedWidth,
    margin: const EdgeInsets.all(5),
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.8),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: _isSearchFocused ? Colors.blue : Colors.white24,
        width: 1.5,
      ),
    ),
    child: TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: '${_locale.get("searchGoogle")}...',
        hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search, color: _isSearchFocused ? Colors.blue : Colors.white54),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                onPressed: _handleSearch,
                tooltip: '${_locale.get("run")}',
              )
            : null,
      ),
      onTap: () {
        setState(() {
          _isSearchFocused = true;
        });
      },
      onSubmitted: (value) {
        _handleSearch();
      },
      onChanged: (value) {
        setState(() {
          // Ширина будет автоматически пересчитана при изменении текста
        });
      },
    ),
  );
}


@override
Widget build(BuildContext context) {
  if (_isLoading) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );
  }

  return RepaintBoundary(
    child: Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (node, event) {
        if (event is RawKeyDownEvent && !_isEditing) {
          final logicalKey = event.logicalKey;
          
          // ESC переключает фокус между поиском и клавиатурой
          if (logicalKey == LogicalKeyboardKey.escape || logicalKey == LogicalKeyboardKey.capsLock) {
            _handleKeyEventEsc(event);
            return KeyEventResult.handled;
          }
    }else if(!_searchFocusNode.hasFocus){
          _handleKeyEvent(event);
          return KeyEventResult.handled;}
        return KeyEventResult.ignored;
      },
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Фон, который всегда пропускает клики
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !_isEditing,
                child: Container(color: Colors.transparent),
              ),
            ),
            
            // Область перетаскивания
            _buildDragArea(),
            
            // Основной контент
            Column(
              children: [
                // Поисковая строка
                _buildSearchBar(),
                
                // Клавиатура
                Expanded(child: _buildKeyboard()),
              ],
            ),
            
            // Кнопка сворачивания
            Positioned(
              top: 10,
              right: 10,
              child: IgnorePointer(
                ignoring: false,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    icon: Icon(_isMinimized ? Icons.open_in_full : Icons.minimize, 
                      color: Colors.white70, size: 16),
                    onPressed: _toggleMinimize,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
    Widget _buildDragArea() {
  return Positioned.fill(
    child: IgnorePointer(
      ignoring: _isEditing, // Игнорируем в режиме редактирования
      child: GestureDetector(
        onPanStart: (details) {
          windowManager.startDragging();
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ),
  );
}
  Future<void> _handleFileDrop(String key, List<File> files) async {
    if (files.isEmpty) return;
    
    final file = files.first;
    final path = file.path;
    if (path.isEmpty) return;

    if (_isMinimized) {
      await _toggleMinimize();
    }

    KeyBind newBind;
    
    // Получаем расширение файла из пути
    final extension = p.extension(path).toLowerCase();
    final fileName = p.basename(path);
    final fileNameWithoutExt = p.basenameWithoutExtension(path);
    
    if (extension == '.png' || extension == '.jpg' || extension == '.jpeg') {
      newBind = KeyBind(
        key: key,
        name: fileNameWithoutExt,
        hint: 'Image: $fileName',
        description: 'Dropped image file',
        type: KeyContentType.image,
        combination: 'CTRL+$key',
        actions: [KeyAction.copyToClipboard, KeyAction.open],
        imagePath: path,
      );
    } else if (extension == '.lnk' || extension == '.exe') {
      newBind = KeyBind(
        key: key,
        name: fileNameWithoutExt,
        hint: 'File: $fileName',
        description: 'Dropped file',
        type: KeyContentType.windowsShortcut,
        combination: 'CTRL+$key',
        actions: [KeyAction.open, KeyAction.openInExplorer],
        filePath: path,
      );
    } else if (extension == '.txt') {
      try {
        final content = await file.readAsString();
        newBind = KeyBind(
          key: key,
          name: fileNameWithoutExt,
          hint: 'Text: $fileName',
          description: 'Dropped text file',
          type: KeyContentType.text,
          combination: 'CTRL+$key',
          actions: [KeyAction.copyToClipboard],
          textContent: content,
        );
      } catch (e) {
        // Если не удалось прочитать файл как текст, создаем обычный файловый бинд
        newBind = KeyBind(
          key: key,
          name: fileNameWithoutExt,
          hint: 'File: $fileName',
          description: 'Dropped file',
          type: KeyContentType.windowsShortcut,
          combination: 'CTRL+$key',
          actions: [KeyAction.open, KeyAction.openInExplorer],
          filePath: path,
        );
      }
    } else {
      newBind = KeyBind(
        key: key,
        name: fileNameWithoutExt,
        hint: 'File: $fileName',
        description: 'Dropped file',
        type: KeyContentType.windowsShortcut,
        combination: 'CTRL+$key',
        actions: [KeyAction.open, KeyAction.openInExplorer],
        filePath: path,
      );
    }

    _showKeyEditorWithBind(key, newBind);
  }
    Widget _buildKeyboard() {
  return Container(
    padding: _isMinimized ? const EdgeInsets.all(1) : const EdgeInsets.all(12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _keyboardLayout.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            return Padding(
              padding: _isMinimized ? const EdgeInsets.all(1) : const EdgeInsets.all(3),
              child: _buildKey(key),
            );
          }).toList(),
        );
      }).toList(),
    ),
  );
}
  Widget _buildKey(String key) {
  final hasBind = _storage.hasKeyBind(key);
  final keyBind = _storage.getKeyBind(key);
  final isAddButton = key == 'ADD';
  
  // Определяем цвет в зависимости от типа контента
  Color? backgroundColor;
  if (hasBind && keyBind != null) {
    Color baseColor = _getColorForType(keyBind.type);
    Color darkGray = const Color.fromRGBO(35, 35, 35, 1.0);
    backgroundColor = Color.lerp(baseColor, darkGray, 0.9)!;
  }
  
  return Tooltip(
    message: isAddButton ? 'Add new bind' : (hasBind ? (keyBind?.hint ?? '') : 'Right-click to add bind'),
    waitDuration: const Duration(milliseconds: 500),
    child: DropTarget(
      onDragDone: (detail) async {
        final files = <File>[];
        try {
          final processedPaths = <String>{};
          for (final item in detail.files) {
            final path = item.path;
            if (path != null && path.isNotEmpty && !processedPaths.contains(path)) {
              processedPaths.add(path);
              final file = File(path);
              if (await file.exists()) {
                files.add(file);
                break;
              }
            }
          }
        } catch (e) {
          print('Error in key drop: $e');
        }
        
        if (files.isNotEmpty) {
          _handleFileDrop(key, files);
          if (mounted) {
            setState(() {});
          }
          files.clear();
        }
      },
      child: GestureDetector(
        onTap: () => _onKeyPressed(key),
        onLongPress: isAddButton ? null : () => _onKeyLongPressed(key),
        onSecondaryTap: isAddButton ? null : () => _onKeySecondaryTap(key),
        child: Container(
          width: _isMinimized ? 35 : 70,
          height: _isMinimized ? 35 : 70,
          decoration: BoxDecoration(
            color: isAddButton 
                ? Colors.green.withOpacity(0.3)
                : hasBind 
                    ? backgroundColor ?? const Color(0xFF404040)
                    : const Color.fromRGBO(35, 35, 35, 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isAddButton 
                  ? Colors.green
                  : hasBind 
                      ? _getBorderColorForType(keyBind?.type) ?? Colors.blue.withOpacity(0.5)
                      : Colors.black.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              if (isAddButton)
                Center(
                  child: Icon(Icons.add, color: Colors.green, size: _isMinimized ? 16 : 28),
                )
              else ...[
                Positioned(
                  top: 4,
                  left: 6,
                  child: Text(
                    key,
                    style: TextStyle(
                      color: hasBind ? Colors.white : Colors.white.withOpacity(0.5),
                      fontSize: _isMinimized ? 8 : 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Отображаем выбранную иконку или иконку по умолчанию
                if (hasBind && keyBind != null)
                  Positioned(
                    top: 4,
                    right: 6,
                    child: Icon(
                      keyBind.icon ?? _getTypeIcon(keyBind.type),
                      size: _isMinimized ? 10 : 14,
                      color: Colors.white70,
                    ),
                  ),
                // Для не-изображений показываем иконку в центре
                if (hasBind && keyBind != null && keyBind.type != KeyContentType.image)
                  Center(
                    child: Icon(
                      keyBind.icon ?? _getTypeIcon(keyBind.type),
                      size: _isMinimized ? 16 : 24,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                // Для изображений показываем превью
                if (hasBind && keyBind != null && keyBind.type == KeyContentType.image)
                  Center(child: _buildContentPreview(keyBind, _isMinimized ? 20 : 35)),
                if (hasBind && keyBind != null && keyBind.name.isNotEmpty)
                  Positioned(
                    bottom: 4,
                    left: 4,
                    right: 4,
                    child: Text(
                      keyBind.name.length > (_isMinimized ? 4 : 8) 
                          ? '${keyBind.name.substring(0, _isMinimized ? 4 : 8)}..' 
                          : keyBind.name,
                      style: TextStyle(
                        color: Colors.white70, 
                        fontSize: _isMinimized ? 7 : 10
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

  // Метод для получения цвета фона по типу контента
 Color _getColorForType(KeyContentType type) {
  switch (type) {
    case KeyContentType.image:
      return Colors.purple;
    case KeyContentType.text:
      return Colors.green;
    case KeyContentType.url:
      return Colors.blue;
    case KeyContentType.windowsShortcut:
      return Colors.orange;
    case KeyContentType.macros:
      return Colors.red;
    case KeyContentType.clipboard:
      return Colors.teal;
  }
}
 Color _getBorderColorForType(KeyContentType? type) {
  if (type == null) return Colors.black.withOpacity(0.5);
  
  switch (type) {
    case KeyContentType.image:
      return Colors.purpleAccent.withOpacity(0.7);
    case KeyContentType.text:
      return Colors.greenAccent.withOpacity(0.7);
    case KeyContentType.url:
      return Colors.blueAccent.withOpacity(0.7);
    case KeyContentType.windowsShortcut:
      return Colors.orangeAccent.withOpacity(0.7);
    case KeyContentType.macros:
      return Colors.redAccent.withOpacity(0.7);
    case KeyContentType.clipboard:
      return Colors.tealAccent.withOpacity(0.7);
  }
}

   IconData _getTypeIcon(KeyContentType type) {
  switch (type) {
    case KeyContentType.image: return Icons.image;
    case KeyContentType.text: return Icons.text_fields;
    case KeyContentType.url: return Icons.link;
    case KeyContentType.windowsShortcut: return Icons.insert_drive_file;
    case KeyContentType.macros: return Icons.play_arrow;
    case KeyContentType.clipboard: return Icons.content_paste;
  }
}
    Widget _buildContentPreview(KeyBind keyBind, double size) {
      if (keyBind.type == KeyContentType.image && keyBind.imagePath != null) {
        final file = File(keyBind.imagePath!);
        if (file.existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              file,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.broken_image,
                size: size * 0.5,
                color: Colors.white30,
              ),
            ),
          );
        }
      }
      return const SizedBox.shrink();
    }

    void _showKeyEditor(String key) async {
      if (_isMinimized) {
        await _toggleMinimize();
      }

      setState(() => _isEditing = true);
      
      showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (context) => KeyBindEditor(
          keyId: key,
          existingBind: _storage.getKeyBind(key),
          onSave: (bind) {
            _storage.setKeyBind(key, bind);
            setState(() {});
            Navigator.of(context).pop();
            setState(() => _isEditing = false);
          },
          onDelete: _storage.hasKeyBind(key) ? () {
            _storage.removeKeyBind(key);
            setState(() {});
            Navigator.of(context).pop();
            setState(() => _isEditing = false);
          } : null,
        ),
      ).then((_) => setState(() => _isEditing = false));
    }

   void _showAddDialog() {
  setState(() => _isEditing = true);
  
  String? selectedKey;
  final focusNode = FocusNode();
  
  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => RawKeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          final keyLabel = event.logicalKey.keyLabel;
          // Игнорируем модификаторы и специальные клавиши
          if (keyLabel.length == 1 && keyLabel.toUpperCase() != keyLabel.toLowerCase()) {
            final key = keyLabel.toUpperCase();
            if (_keyboardLayout.any((row) => row.contains(key))) {
              Navigator.pop(context);
              _showKeyEditor(key);
            }
          }
        }
      },
      child: StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          title:  Text('${_locale.get("chooseKey")}', style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: 400,
            height: 200,
            child: GridView.count(
              crossAxisCount: 10,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: _keyboardLayout.expand((row) => row)
                  .where((k) => k != 'ADD')
                  .map((key) {
                return GestureDetector(
                  onTap: () => setState(() => selectedKey = key),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedKey == key ? Colors.blue : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: selectedKey == key ? Colors.blue : Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        key,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _isEditing = false);
              },
              child:  Text('${_locale.get("cancel")}'),
            ),
            ElevatedButton(
              onPressed: selectedKey == null ? null : () {
                Navigator.pop(context);
                _showKeyEditor(selectedKey!);
              },
              child:  Text('${_locale.get("next")}'),
            ),
          ],
        ),
      ),
    ),
  ).then((_) {
    setState(() => _isEditing = false);
    focusNode.dispose();
  });
}}

  // ==================== РЕДАКТОР БИНДОВ ====================

  class KeyBindEditor extends StatefulWidget {
    final String keyId;
    final KeyBind? existingBind;
    final Function(KeyBind) onSave;
    final VoidCallback? onDelete;

    const KeyBindEditor({
      Key? key,
      required this.keyId,
      this.existingBind,
      required this.onSave,
      this.onDelete,
    }) : super(key: key);

    @override
    State<KeyBindEditor> createState() => _KeyBindEditorState();
  }

  class _KeyBindEditorState extends State<KeyBindEditor> {
    late TextEditingController _nameCtrl, _hintCtrl, _descCtrl;
    String _modifier = 'CTRL';
    KeyContentType _type = KeyContentType.text;
    List<KeyAction> _actions = [KeyAction.copyToClipboard];
    String? _imagePath, _filePath, _textContent, _url;
    Macro? _macro;
    IconData? _selectedIcon;
    bool _showIconGrid = false;

    final List<IconData> _icons = [
      Icons.home, Icons.settings, Icons.favorite, Icons.star, Icons.person,
      Icons.email, Icons.phone, Icons.chat, Icons.notifications, Icons.search,
      Icons.menu, Icons.close, Icons.arrow_back, Icons.arrow_forward, Icons.refresh,
      Icons.add, Icons.remove, Icons.create, Icons.delete, Icons.share,
      Icons.download, Icons.upload, Icons.cloud, Icons.wifi, Icons.bluetooth,
      Icons.gps_fixed, Icons.location_on, Icons.map, Icons.navigation, Icons.directions,
      Icons.camera, Icons.image, Icons.music_note, Icons.videocam, Icons.movie,
      Icons.games, Icons.sports_esports, Icons.fitness_center, Icons.beach_access, Icons.work,
      Icons.school, Icons.book, Icons.library_books, Icons.calculate, Icons.code,
      Icons.computer, Icons.phone_android, Icons.tablet, Icons.headset, Icons.keyboard,
      Icons.mouse, Icons.touch_app, Icons.memory, Icons.storage, Icons.usb,
      Icons.battery_std, Icons.power, Icons.lightbulb, Icons.flash_on, Icons.wb_sunny,
      Icons.ac_unit, Icons.whatshot, Icons.local_drink, Icons.restaurant, Icons.local_cafe,
      Icons.shopping_cart, Icons.credit_card, Icons.attach_money, Icons.account_balance,
      Icons.security, Icons.lock, Icons.visibility, Icons.visibility_off, Icons.vpn_key,
      Icons.fingerprint, Icons.face, Icons.verified_user, Icons.admin_panel_settings,
      Icons.warning, Icons.error, Icons.info, Icons.help, Icons.check_circle,
      Icons.cancel, Icons.remove_circle, Icons.add_circle, Icons.play_arrow, Icons.pause,
      Icons.stop, Icons.skip_next, Icons.skip_previous, Icons.fast_forward, Icons.fast_rewind,
      Icons.volume_up, Icons.volume_off, Icons.mic, Icons.mic_off, Icons.headphones,
      Icons.brightness_high, Icons.brightness_low, Icons.palette, Icons.format_paint, Icons.brush,
    ];
    Localization _locale = Localization();
    @override
    void initState() {
      super.initState();
      _locale.init();
      final bind = widget.existingBind;
      _nameCtrl = TextEditingController(text: bind?.name ?? '');
      _hintCtrl = TextEditingController(text: bind?.hint ?? '');
      _descCtrl = TextEditingController(text: bind?.description ?? '');
      _selectedIcon = bind?.icon;
      
      if (bind != null) {
        _type = bind.type;
        _actions = List.from(bind.actions);
        _imagePath = bind.imagePath;
        _filePath = bind.filePath;
        _textContent = bind.textContent;
        _url = bind.url;
        _macro = bind.macro;
        final parts = bind.combination.split('+');
        if (parts.isNotEmpty) _modifier = parts[0];
      }
    }

    @override
    Widget build(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: screenWidth,
          height: 450,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(flex: 1, child: _buildLeftSection()),
              const SizedBox(width: 12),
              Expanded(flex: 1, child: _buildMiddleSection()),
              const SizedBox(width: 12),
              Expanded(flex: 1, child: _buildRightSection()),
            ],
          ),
        ),
      );
    }

    Widget _buildLeftSection() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _modifier,
                    items: ['CTRL', 'SHIFT', 'ALT', 'TAB']
                        .map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(color: Colors.white))))
                        .toList(),
                    onChanged: (v) => setState(() => _modifier = v!),
                    decoration:  InputDecoration(
                      labelText: '${_locale.get("modificator")}',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Color(0xFF1E1E1E),
                    ),
                    dropdownColor: const Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _showKeySelector,
                    child: AbsorbPointer(
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: '${_locale.get("key")}',
                          hintText: widget.keyId,
                          hintStyle: const TextStyle(color: Colors.white),
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildIconSelector(),
            const SizedBox(height: 12),
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration:  InputDecoration(
                labelText: '${_locale.get("name")}',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hintCtrl,
              style: const TextStyle(color: Colors.white),
              decoration:  InputDecoration(
                labelText: '${_locale.get("hint")}',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildIconSelector() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text('${_locale.get("icon")}', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _showIconGrid = !_showIconGrid),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(_selectedIcon ?? Icons.help_outline, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text(
                    _selectedIcon != null ? '${_locale.get("iconSelected")}' : '${_locale.get("pickIcon")}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Spacer(),
                  Icon(_showIconGrid ? Icons.expand_less : Icons.expand_more, color: Colors.white70),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          if (_showIconGrid) ...[
            const SizedBox(height: 8),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24),
              ),
              child: Scrollbar(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: _icons.length,
                  itemBuilder: (context, index) {
                    final icon = _icons[index];
                    final isSelected = _selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedIcon = icon;
                        _showIconGrid = false;
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(icon, color: Colors.white, size: 20),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      );
    }

    void _showKeySelector() {
      String? selectedKey;
      showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.8),
            title:  Text('${_locale.get("selectKey")}', style: TextStyle(color: Colors.white)),
            content: SizedBox(
              width: 400,
              height: 200,
              child: GridView.count(
                crossAxisCount: 10,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: ['Q','W','E','R','T','Y','U','I','O','P','A','S','D','F','G','H','J','K','L','Z','X','C','V','B','N','M']
                    .map((key) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedKey = key),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedKey == key ? Colors.blue : Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: selectedKey == key ? Colors.blue : Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          key,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Text('${_locale.get("cancel")}'),
              ),
              ElevatedButton(
                onPressed: selectedKey == null ? null : () {
                  Navigator.pop(context);
                },
                child:  Text('${_locale.get("select")}'),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildMiddleSection() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  '${_locale.get("comment")}',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Tooltip(
                  message: '${_locale.get("toBuffer")}',
                  child: IconButton(
                    icon: const Icon(Icons.content_copy, size: 18),
                    color: Colors.white70,
                    onPressed: () {
                      if (_descCtrl.text.isNotEmpty) {
                        Clipboard.setData(ClipboardData(text: _descCtrl.text));
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('copiedToClipboard')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _descCtrl,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  hintText: '${_locale.get("bindDescription")}...',
                  hintStyle: TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: Color(0xFF1E1E1E),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildRightSection() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildTypeSelector(),
            const SizedBox(height: 12),
            Expanded(child: _buildContentEditor()),
            const SizedBox(height: 12),
            //_buildActionSelector(),
            const SizedBox(height: 8),
            _buildButtons(),
          ],
        ),
      );
    }

    Widget _buildTypeSelector() {
      return DropdownButtonFormField<KeyContentType>(
        value: _type,
        items: KeyContentType.values.map((t) {
          return DropdownMenuItem(value: t, child: Text(_getTypeName(t), style: const TextStyle(color: Colors.white)));
        }).toList(),
        onChanged: (v) => setState(() {
          _type = v!;
          _actions = _getDefaultActions(v);
        }),
        decoration:  InputDecoration(
          labelText: '${_locale.get("contentType")}',
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Color(0xFF1E1E1E),
        ),
        dropdownColor: const Color(0xFF1E1E1E),
      );
    }

  String _getTypeName(KeyContentType type) {
  switch (type) {
    case KeyContentType.image: return '${_locale.get("image")}';
    case KeyContentType.text: return '${_locale.get("text")}';
    case KeyContentType.url: return 'URL';
    case KeyContentType.windowsShortcut: return '${_locale.get("typeFile")}';
    case KeyContentType.macros: return '${_locale.get("typeMacro")}';
    case KeyContentType.clipboard: return '${_locale.get("typeBuffer")}';
  }
}

   List<KeyAction> _getDefaultActions(KeyContentType type) {
  switch (type) {
    case KeyContentType.image:
    case KeyContentType.text:
    case KeyContentType.url:
    case KeyContentType.clipboard:
      return [KeyAction.copyToClipboard];
    case KeyContentType.windowsShortcut:
      return [KeyAction.open];
    case KeyContentType.macros:
      return [KeyAction.run];
  }
}
Widget _buildClipboardEditor() {
  return Column(
    children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: _filePath != null || _textContent != null
            ?  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 40, color: Colors.green),
                  SizedBox(height: 8),
                  Text('${_locale.get("dataStored")}', 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              )
            :  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.content_paste, size: 40, color: Colors.white30),
                  SizedBox(height: 8),
                  Text('${_locale.get("clipboard01")}', 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white30, fontSize: 12),
                  ),
                ],
              ),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _captureClipboard,
            icon: const Icon(Icons.content_paste),
            label:  Text('${_locale.get("capture")}'),
          ),
          ElevatedButton.icon(
            onPressed: _filePath != null || _textContent != null ? _pasteClipboardData : null,
            icon: const Icon(Icons.content_copy),
            label:  Text('${_locale.get("paste")}'),
          ),
        ],
      ),
      if (_filePath != null || _textContent != null) ...[
        const SizedBox(height: 8),
        Text(
          _filePath != null 
            ? '${_locale.get("dataSaved")} (${_textContent})'
            : '${_locale.get("text")}: ${_textContent != null && _textContent!.length > 20 ? '${_textContent!.substring(0, 20)}...' : _textContent}',
          style: const TextStyle(color: Colors.green, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _filePath = null;
              _textContent = null;
            });
          },
          child:  Text('${_locale.get("clear")}'),
        ),
      ],
    ],
  );
}
Future<void> _captureClipboard() async {
  try {
    const MethodChannel clipboardChannel = MethodChannel('screenshot_channel');
    final result = await clipboardChannel.invokeMethod('getClipboardData');
    
    if (result != null) {
      final data = result['data'] as Uint8List?;
      final format = result['format'] as String? ?? 'unknown';
      final formatId = result['formatId'] as int?;
      final filePath = result['filePath'] as String?;
      final availableFormats = result['availableFormats'] as List<dynamic>?;
      
      print('Available formats: $availableFormats');
      print('Detected format: $format (ID: $formatId)');
      
      if (data != null && data.isNotEmpty) {
        // Сохраняем данные в файл
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'clipboard_${DateTime.now().millisecondsSinceEpoch}.bin';
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(data);
        
        setState(() {
          _filePath = file.path;
          _textContent = format;
          if (_nameCtrl.text.isEmpty) {
            _nameCtrl.text = 'Clipboard Data';
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_locale.get("dataSaved")} (${_locale.get("extension")}: $format)')),
        );
      } else if (filePath != null) {
        // Если получили путь к файлу
        setState(() {
          _filePath = filePath;
          _textContent = 'file/reference';
          if (_nameCtrl.text.isEmpty) {
            _nameCtrl.text = 'File Reference';
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('${_locale.get("linkSaved")}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('${_locale.get("clipboardEmpty")}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('${_locale.get("error")}')),
      );
    }
  } catch (e) {
    print('Error capturing clipboard: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_locale.get("error")}: $e')),
    );
  }
}

Future<void> _pasteClipboardData() async {
  if (_filePath != null && File(_filePath!).existsSync()) {
    try {
      final file = File(_filePath!);
      final data = await file.readAsBytes();
      
      const MethodChannel clipboardChannel = MethodChannel('screenshot_channel');
      
      final Map<String, dynamic> arguments = {
        'data': data,
        'format': _textContent ?? 'unknown',
      };
      
      // Если у нас есть ID формата, передаем его тоже
      if (_textContent?.startsWith('custom/') == true) {
        final formatId = int.tryParse(_textContent!.replaceFirst('custom/', ''));
        if (formatId != null) {
          arguments['formatId'] = formatId;
        }
      }
      
      final success = await clipboardChannel.invokeMethod('setClipboardData', arguments);
      
      if (success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('${_locale.get("copiedToClipboard")}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('${_locale.get("error")}')),
        );
      }
    } catch (e) {
      print('Error pasting clipboard data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_locale.get("error")}: $e')),
      );
    }
  } else if (_textContent != null) {
    // Fallback для текста
    await Clipboard.setData(ClipboardData(text: _textContent!));
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('${_locale.get("copiedToClipboard")}')),
    );
  }
}


Widget _buildContentEditor() {
  switch (_type) {
    case KeyContentType.image: return _buildImageEditor();
    case KeyContentType.text: return _buildTextEditor();
    case KeyContentType.url: return _buildUrlEditor();
    case KeyContentType.windowsShortcut: return _buildFileEditor();
    case KeyContentType.macros: return _buildMacroEditor();
    case KeyContentType.clipboard: return _buildClipboardEditor();
  }
}

  Widget _buildImageEditor() {
  return Column(
    children: [
      DropTarget(
        onDragDone: (detail) async {
          final files = <File>[];
          try {
            final processedPaths = <String>{};
            for (final item in detail.files) {
              final path = item.path;
              if (path != null && path.isNotEmpty && !processedPaths.contains(path)) {
                processedPaths.add(path);
                final file = File(path);
                if (await file.exists()) {
                  files.add(file);
                  break;
                }
              }
            }
          } catch (e) {
            print('Error in image drop: $e');
          }
          
          if (files.isNotEmpty) {
            setState(() {
              _imagePath = files.first.path;
              if (_nameCtrl.text.isEmpty) {
                _nameCtrl.text = p.basenameWithoutExtension(files.first.path);
              }
            });
            files.clear();
          }
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white24,
              width: 1,
            ),
          ),
          child: _imagePath != null && File(_imagePath!).existsSync()
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                )
              :  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 40, color: Colors.white30),
                    SizedBox(height: 8),
                    Text('${_locale.get("dropImage")}', 
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white30, fontSize: 12),
                    ),
                  ],
                ),
        ),
      ),
      const SizedBox(height: 12),
      ElevatedButton.icon(
        onPressed: _pickImage,
        icon: const Icon(Icons.folder_open),
        label:  Text('${_locale.get("selectImage")}'),
      ),
    ],
  );
}
    Widget _buildTextEditor() {
      return TextField(
        onChanged: (v) => _textContent = v,
        controller: TextEditingController(text: _textContent),
        maxLines: 5,
        style: const TextStyle(color: Colors.white),
        decoration:  InputDecoration(
          labelText: '${_locale.get("typeTextDescription")}',
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Color(0xFF1E1E1E),
          border: OutlineInputBorder(),
        ),
      );
    }

    Widget _buildUrlEditor() {
      return Column(
        children: [
          TextField(
            onChanged: (v) => _url = v,
            controller: TextEditingController(text: _url),
            style: const TextStyle(color: Colors.white),
            decoration:  InputDecoration(
              labelText: '${_locale.get("urlType")}',
              labelStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Color(0xFF1E1E1E),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
    }

    Widget _buildFileEditor() {
      return Column(
        children: [
          TextField(
            onChanged: (v) => _filePath = v,
            controller: TextEditingController(text: _filePath),
            style: const TextStyle(color: Colors.white),
            decoration:  InputDecoration(
              labelText: '${_locale.get("pathToFile")}',
              labelStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Color(0xFF1E1E1E),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.folder_open),
            label:  Text('${_locale.get("pickFile2")}'),
          ),
        ],
      );
    }

    Widget _buildMacroEditor() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                     Text(
                      '${_locale.get("macrosActions")}:',
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    if (_macro != null)
                      SizedBox(
                        width: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration:  InputDecoration(
                            labelText: '${_locale.get("loop")}',
                            labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
                            filled: true,
                            fillColor: Color(0xFF2A2A2A),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          onChanged: (value) {
                            final amount = int.tryParse(value) ?? 1;
                            setState(() => _macro!.loopAmount = amount.clamp(1, 100));
                          },
                          controller: TextEditingController(text: _macro?.loopAmount.toString() ?? '1'),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: (_macro?.actions.length ?? 0) + 1,
                    itemBuilder: (context, index) {
                      if (index == (_macro?.actions.length ?? 0)) {
                        return Tooltip(
                          message: '${_locale.get("addMacroAction")}',
                          child: GestureDetector(
                            onTap: _addMacroAction,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.green),
                              ),
                              child: const Icon(Icons.add, color: Colors.green, size: 20),
                            ),
                          ),
                        );
                      }
                      final action = _macro!.actions[index];
                      return Tooltip(
                        message: action.toScript(),
                        child: GestureDetector(
                          onTap: () => _editMacroAction(index),
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(action.icon, size: 20, color: Colors.white),
                                const SizedBox(height: 2),
                                Text(
                                  action.displayName.length > 4 
                                      ? '${action.displayName.substring(0, 4)}..' 
                                      : action.displayName,
                                  style: const TextStyle(color: Colors.white, fontSize: 8),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    void _editMacroAction(int index) {
      showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (context) => MacroActionDialog(
          existingAction: _macro!.actions[index],
          onAdd: (action) {
            setState(() => _macro!.actions[index] = action);
            Navigator.pop(context);
          },
        ),
      );
    }

    Widget _buildActionSelector() {
      final availableActions = _getAvailableActions();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text('${_locale.get("actions")}:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: availableActions.map((action) {
              final selected = _actions.contains(action);
              return Tooltip(
                message: _getActionName(action),
                child: FilterChip(
                  label: Icon(_getActionIcon(action), size: 20),
                  selected: selected,
                  onSelected: (v) => setState(() {
                    if (v) _actions.add(action); else _actions.remove(action);
                  }),
                  backgroundColor: const Color(0xFF1E1E1E),
                  selectedColor: Colors.blue,
                  checkmarkColor: Colors.white,
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    String _getActionName(KeyAction action) {
      switch (action) {
        case KeyAction.copyToClipboard: return '${_locale.get("toBuffer")}';
        case KeyAction.pasteToForeground: return '${_locale.get("toForeground")}';
        case KeyAction.open: return '${_locale.get("toOpen")}';
        case KeyAction.openInExplorer: return '${_locale.get("toPath")}';
        case KeyAction.run: return '${_locale.get("toRun")}';
      }
    }

    IconData _getActionIcon(KeyAction action) {
      switch (action) {
        case KeyAction.copyToClipboard: return Icons.content_copy;
        case KeyAction.pasteToForeground: return Icons.content_paste;
        case KeyAction.open: return Icons.open_in_new;
        case KeyAction.openInExplorer: return Icons.folder_open;
        case KeyAction.run: return Icons.play_arrow;
      }
    }

   List<KeyAction> _getAvailableActions() {
  switch (_type) {
    case KeyContentType.image: return [KeyAction.copyToClipboard, KeyAction.pasteToForeground, KeyAction.open];
    case KeyContentType.text: return [KeyAction.copyToClipboard, KeyAction.pasteToForeground];
    case KeyContentType.url: return [KeyAction.copyToClipboard, KeyAction.pasteToForeground, KeyAction.open];
    case KeyContentType.windowsShortcut: return [KeyAction.open, KeyAction.openInExplorer, KeyAction.run];
    case KeyContentType.macros: return [KeyAction.run];
    case KeyContentType.clipboard: return [KeyAction.copyToClipboard, KeyAction.pasteToForeground];
  }
}
Widget _buildButtons() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Кнопки действий - выровнены по левому краю
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _getAvailableActions().map((action) {
              final selected = _actions.contains(action);
              return Tooltip(
                message: _getActionName(action),
                child: FilterChip(
                  label: Icon(_getActionIcon(action), size: 14),
                  selected: selected,
                  onSelected: (v) => setState(() {
                    if (v) _actions.add(action); else _actions.remove(action);
                  }),
                  backgroundColor: const Color(0xFF1E1E1E),
                  selectedColor: Colors.blue,
                  checkmarkColor: Colors.white,
                  labelStyle: const TextStyle(fontSize: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  visualDensity: VisualDensity.compact,
                ),
              );
            }).toList(),
          ),

          // Кнопки управления - выровнены по правому краю
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.onDelete != null)
                Tooltip(
                  message: '${_locale.get("delete")}',
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete, size: 14),
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              const SizedBox(width: 6),
              Tooltip(
                message: '${_locale.get("cancel")}',
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 14),
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Tooltip(
                message: '${_locale.get("save")}',
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    onPressed: _save,
                    icon: const Icon(Icons.save, size: 14),
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

    Future<void> _pickImage() async {
      final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _imagePath = result.files.single.path!;
          if (_nameCtrl.text.isEmpty) _nameCtrl.text = p.basenameWithoutExtension(result.files.single.name);
        });
      }
    }

    Future<void> _pickFile() async {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _filePath = result.files.single.path!;
          if (_nameCtrl.text.isEmpty) _nameCtrl.text = p.basename(result.files.single.name);
        });
      }
    }

    void _addMacroAction() {
  // Создаем макрос если его нет
  if (_macro == null) {
    setState(() {
      _macro = Macro(actions: [], loopAmount: 1);
    });
  }
  
  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => MacroActionDialog(
      onAdd: (action) {
        if (mounted) {
          setState(() {
            _macro!.actions.add(action);
          });
        }
      },
    ),
  );
}

    void _save() {
      final bind = KeyBind(
        key: widget.keyId,
        name: _nameCtrl.text.isEmpty ? 'Key ${widget.keyId}' : _nameCtrl.text,
        hint: _hintCtrl.text,
        description: _descCtrl.text,
        type: _type,
        imagePath: _imagePath,
        filePath: _filePath,
        textContent: _textContent,
        url: _url,
        macro: _macro,
        combination: '$_modifier+${widget.keyId}',
        actions: _actions.isEmpty ? [KeyAction.copyToClipboard] : _actions,
        icon: _selectedIcon,
      );
      widget.onSave(bind);
    }

    @override
    void dispose() {
      _nameCtrl.dispose();
      _hintCtrl.dispose();
      _descCtrl.dispose();
      super.dispose();
    }
  }

  // ==================== ДИАЛОГ РЕДАКТОРА МАКРОСОВ ====================
class MacroActionDialog extends StatefulWidget {
  final Function(MacroAction) onAdd;
  final MacroAction? existingAction;
  const MacroActionDialog({Key? key, required this.onAdd, this.existingAction}) : super(key: key);

  @override
  State<MacroActionDialog> createState() => _MacroActionDialogState();
}

class _MacroActionDialogState extends State<MacroActionDialog> {
  MacroActionType _type = MacroActionType.delay;
  final _valueCtrl = TextEditingController();
  int _delay = 1000;
  int _x = 100, _y = 100;
  
  // Переменные для записи хоткеев и кликов
  bool _isRecordingHotkey = false;
  bool _isRecordingClick = false;
  List<String> _currentHotkey = [];
  Timer? _hotkeyTimer;
  Timer? _mousePositionTimer;
  StreamSubscription<RawKeyEvent>? _keyboardSubscription;
  ({int x, int y}) _currentMousePosition = (x: 0, y: 0);
  Localization _locale = Localization();
  @override
  void initState() {
    super.initState();
    _locale.init();
    if (widget.existingAction != null) {
      _type = widget.existingAction!.type;
      _valueCtrl.text = widget.existingAction!.value;
      _delay = widget.existingAction!.delay ?? 1000;
      _x = widget.existingAction!.x ?? 100;
      _y = widget.existingAction!.y ?? 100;
    }
  }

  @override
  void dispose() {
    _cleanupRecording();
    _valueCtrl.dispose();
    super.dispose();
  }



  Widget _buildTypeSpecificWidget() {
    switch (_type) {
      case MacroActionType.hotkey:
        return _buildHotkeyEditor();
      case MacroActionType.click:
        return _buildClickEditor();
      case MacroActionType.delay:
        return _buildDelayEditor();
      case MacroActionType.runPath:
        return _buildRunPathEditor();
    }
  }

  Widget _buildHotkeyEditor() {
    return Column(
      children: [
        TextField(
          controller: _valueCtrl,
          readOnly: true,
          style:  TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: _isRecordingHotkey ? '${_locale.get("putKeys")}...' : '${_locale.get("keyCombination")}',
            labelStyle: TextStyle(
              color: _isRecordingHotkey ? Colors.blue : Colors.white70,
            ),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isRecordingHotkey ? _stopRecordingHotkey : _startRecordingHotkey,
                icon: Icon(_isRecordingHotkey ? Icons.stop : Icons.keyboard),
                label: Text(_isRecordingHotkey ? '${_locale.get("stopRecord")}' : '${_locale.get("startRecord")}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecordingHotkey ? Colors.red : Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _clearHotkey,
              icon: const Icon(Icons.clear),
              tooltip: '${_locale.get("clear")}',
            ),
          ],
        ),
        if (_currentHotkey.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${_locale.get("keyCombination")}: ${_currentHotkey.join(' + ')}',
              style: const TextStyle(color: Colors.green),
            ),
          ),
      ],
    );
  }

  Widget _buildClickEditor() {
    return Column(
      children: [
        Text(
          _isRecordingClick 
            ? '${_locale.get("cursorPos")}: (${_currentMousePosition.x}, ${_currentMousePosition.y})\nНажмите SPACE для записи'
            : '${_locale.get("recordMouse")}',
          style: TextStyle(
            color: _isRecordingClick ? Colors.blue : Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isRecordingClick ? _stopRecordingClick : _startRecordingClick,
                icon: Icon(_isRecordingClick ? Icons.stop : Icons.mouse),
                label: Text(_isRecordingClick ? '${_locale.get("stopRecord")}' : '${_locale.get("startRecord")}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecordingClick ? Colors.red : Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _clearClick,
              icon: const Icon(Icons.clear),
              tooltip: '${_locale.get("clear")}',
            ),
          ],
        ),
        if (_valueCtrl.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _valueCtrl.text,
              style: const TextStyle(color: Colors.green),
            ),
          ),
      ],
    );
  }

  Widget _buildDelayEditor() {
    return Column(
      children: [
        Text('${_locale.get("delay")}: ${_delay}ms', style: const TextStyle(color: Colors.white, fontSize: 16)),
        Slider(
          value: _delay.toDouble(),
          min: 0,
          max: 5000,
          divisions: 50,
          label: '${_delay}ms',
          onChanged: (v) => setState(() => _delay = v.round()),
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildRunPathEditor() {
    return Column(
      children: [
        TextField(
          controller: _valueCtrl,
          style: const TextStyle(color: Colors.white),
          decoration:  InputDecoration(
            labelText: '${_locale.get("pathToRun")}',
            labelStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Color(0xFF1E1E1E),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _pickExecutable,
          icon: const Icon(Icons.folder_open),
          label:  Text('${_locale.get("pickFile")}'),
        ),
      ],
    );
  }
void _startRecordingHotkey() {
  _cleanupRecording();
  
  setState(() {
    _isRecordingHotkey = true;
    _currentHotkey.clear();
    _valueCtrl.clear();
  });

  // Вместо подписки используем RawKeyboard.addListener напрямую
  RawKeyboard.instance.addListener(_handleHotkeyRecording);
  _hotkeyTimer = Timer(const Duration(seconds: 10), _stopRecordingHotkey);
}

void _stopRecordingHotkey() {
  _hotkeyTimer?.cancel();
  RawKeyboard.instance.removeListener(_handleHotkeyRecording);

  if (_currentHotkey.isNotEmpty) {
    _valueCtrl.text = _currentHotkey.join('+');
  }

  setState(() {
    _isRecordingHotkey = false;
  });
}

void _handleHotkeyRecording(RawKeyEvent event) {
  if (!_isRecordingHotkey) return;
  
  if (event is RawKeyDownEvent) {
    final keyLabel = event.logicalKey.keyLabel;
    
    // Игнорируем системные клавиши
    if (_shouldIgnoreKey(keyLabel)) return;
    
    final keyName = _getKeyName(event.logicalKey);
    
    if (!_currentHotkey.contains(keyName)) {
      setState(() {
        _currentHotkey.add(keyName);
      });
    }
  }
}

void _cleanupRecording() {
  _hotkeyTimer?.cancel();
  _mousePositionTimer?.cancel();
  
  // Удаляем все слушатели
  RawKeyboard.instance.removeListener(_handleHotkeyRecording);
  RawKeyboard.instance.removeListener(_handleClickRecording);
}

  bool _shouldIgnoreKey(String keyLabel) {
    const ignoredKeys = ['Caps Lock', 'Num Lock', 'Scroll Lock'];
    return ignoredKeys.contains(keyLabel);
  }

  String _getKeyName(LogicalKeyboardKey key) {
    final keyLabel = key.keyLabel;
    
    if (key == LogicalKeyboardKey.controlLeft || key == LogicalKeyboardKey.controlRight) {
      return 'Ctrl';
    } else if (key == LogicalKeyboardKey.altLeft || key == LogicalKeyboardKey.altRight) {
      return 'Alt';
    } else if (key == LogicalKeyboardKey.shiftLeft || key == LogicalKeyboardKey.shiftRight) {
      return 'Shift';
    } else if (key == LogicalKeyboardKey.metaLeft || key == LogicalKeyboardKey.metaRight) {
      return 'Win';
    }
    
    if (keyLabel.length == 1 && keyLabel.toLowerCase() != keyLabel.toUpperCase()) {
      return keyLabel.toUpperCase();
    }
    
    return keyLabel;
  }

  void _clearHotkey() {
    setState(() {
      _currentHotkey.clear();
      _valueCtrl.clear();
    });
  }
void _startRecordingClick() {
  _cleanupRecording();
  
  setState(() {
    _isRecordingClick = true;
    _valueCtrl.clear();
  });

  final mouseService = NativeMouseService();
  mouseService.startMouseTracking();
  
  _mousePositionTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
    final position = mouseService.getCursorPosition();
    if (mounted) {
      setState(() {
        _currentMousePosition = position;
      });
    }
  });

  // Используем addListener вместо подписки
  RawKeyboard.instance.addListener(_handleClickRecording);

  ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
      content: Text('${_locale.get("pressSpaceToRecord")}'),
      duration: Duration(seconds: 5),
    ),
  );
}

void _handleClickRecording(RawKeyEvent event) {
  if (!_isRecordingClick) return;
  
  if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
    _recordMousePosition();
  }
}

  void _recordMousePosition() {
    setState(() {
      _valueCtrl.text = '(${_currentMousePosition.x}, ${_currentMousePosition.y})';
      _x = _currentMousePosition.x;
      _y = _currentMousePosition.y;
    });
    
    _stopRecordingClick();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("positionRecorded")}: (${_currentMousePosition.x}, ${_currentMousePosition.y})'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _stopRecordingClick() {
    _mousePositionTimer?.cancel();
    _keyboardSubscription?.cancel();
    _keyboardSubscription = null;
    
    setState(() {
      _isRecordingClick = false;
    });
  }

  void _clearClick() {
    setState(() {
      _valueCtrl.clear();
    });
  }

  Future<void> _pickExecutable() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    
    if (result != null && result.files.single.path != null) {
      setState(() {
        _valueCtrl.text = result.files.single.path!;
      });
    }
  }

  void _addAction() {
    MacroAction action;
    
    switch (_type) {
      case MacroActionType.hotkey:
        final hotkey = _currentHotkey.isNotEmpty ? _currentHotkey.join('+') : _valueCtrl.text;
        if (hotkey.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('${_locale.get("keyCombination")}'))
          );
          return;
        }
        action = MacroAction(type: _type, value: hotkey);
        break;
        
      case MacroActionType.click:
        if (_valueCtrl.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('${_locale.get("recordMouseClick")}'))
          );
          return;
        }
        action = MacroAction(
          type: _type, 
          value: 'click', 
          x: _x, 
          y: _y, 
          x1: _x, 
          y1: _y
        );
        break;
        
      case MacroActionType.delay:
        action = MacroAction(
          type: _type, 
          value: '${_delay}ms', 
          delay: _delay
        );
        break;
        
      case MacroActionType.runPath:
        if (_valueCtrl.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('${_locale.get("pathToRun")}'))
          );
          return;
        }
        action = MacroAction(type: _type, value: _valueCtrl.text);
        break;
    }
    
    widget.onAdd(action);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.8),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existingAction != null ? '${_locale.get("edit")}' : '${_locale.get("addMacroAction")}', 
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<MacroActionType>(
              value: _type,
              items: MacroActionType.values.map((t) {
                return DropdownMenuItem(
                  value: t, 
                  child: Text(_getTypeName(t), style: const TextStyle(color: Colors.white))
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) {
                  _cleanupRecording();
                  setState(() => _type = v);
                }
              },
              decoration:  InputDecoration(
                labelText: '${_locale.get("actionType")}',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
              ),
              dropdownColor: const Color(0xFF1E1E1E),
            ),
            const SizedBox(height: 16),
            _buildTypeSpecificWidget(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child:  Text('${_locale.get("cancel")}'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white70),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addAction,
                    child: Text(widget.existingAction != null ? '${_locale.get("save")}' : '${_locale.get("add")}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeName(MacroActionType type) {
    switch (type) {
      case MacroActionType.hotkey: return '${_locale.get("hotkeyMacro")}';
      case MacroActionType.click: return '${_locale.get("mouseClick")}';
      case MacroActionType.delay: return '${_locale.get("delay")}';
      case MacroActionType.runPath: return '${_locale.get("actionRun")}';
    }
  }
}







































class MusicBrainzService {
  static const String _baseUrl = 'https://musicbrainz.org/ws/2/';
  static const Map<String, String> _headers = {
    'User-Agent': 'MediaMetadataApp/1.0 ( your-email@example.com )',
    'Accept': 'application/json'
  };

  // Получение жанров трека по исполнителю и названию
  Future<List<String>> getTrackGenres(String artist, String title) async {
    try {
      print('MusicBrainz: Поиск жанров для "$artist" - "$title"');

      // 1. Сначала ищем запись (recording)
      final recordingId = await _findRecordingId(artist, title);
      if (recordingId == null) {
        print('MusicBrainz: Запись не найдена');
        return [];
      }

      // 2. Получаем теги/жанры для записи
      return await _getRecordingTags(recordingId);
    } catch (e) {
      print('MusicBrainz Ошибка: $e');
      return [];
    }
  }

  // Поиск ID записи по исполнителю и названию
  Future<String?> _findRecordingId(String artist, String title) async {
    final query = 'artist:"${_escapeQuery(artist)}" AND recording:"${_escapeQuery(title)}"';
    final url = '${_baseUrl}recording?query=${Uri.encodeQueryComponent(query)}&fmt=json&limit=5';

    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recordings = data['recordings'] as List?;
        
        if (recordings != null && recordings.isNotEmpty) {
          // Берем первую наиболее релевантную запись
          final recording = recordings.first;
          return recording['id'] as String;
        }
      } else {
        print('MusicBrainz: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('MusicBrainz Ошибка поиска записи: $e');
    }
    
    return null;
  }

  // Получение тегов/жанров для записи
  Future<List<String>> _getRecordingTags(String recordingId) async {
    final url = '${_baseUrl}recording/$recordingId?fmt=json&inc=tags';

    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tags = data['tags'] as List?;
        
        if (tags != null && tags.isNotEmpty) {
          final genreTags = tags.map<String>((tag) {
            return tag['name'] as String;
          }).toList();
          
          print('MusicBrainz: Найдены теги: $genreTags');
          return genreTags;
        }
      }
    } catch (e) {
      print('MusicBrainz Ошибка получения тегов: $e');
    }
    
    return [];
  }

  // Альтернативный метод: поиск жанров через исполнителя
  Future<List<String>> getArtistGenres(String artist) async {
    try {
      final query = 'artist:"${_escapeQuery(artist)}"';
      final url = '${_baseUrl}artist?query=${Uri.encodeQueryComponent(query)}&fmt=json&limit=1';

      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final artists = data['artists'] as List?;
        
        if (artists != null && artists.isNotEmpty) {
          final artistData = artists.first;
          final tags = artistData['tags'] as List?;
          
          if (tags != null && tags.isNotEmpty) {
            return tags.map<String>((tag) => tag['name'] as String).toList();
          }
        }
      }
    } catch (e) {
      print('MusicBrainz Ошибка поиска артиста: $e');
    }
    
    return [];
  }

  // Экранирование специальных символов в запросе
  String _escapeQuery(String text) {
    return text.replaceAll('"', '\\"').replaceAll("'", "\\'");
  }

  // Комбинированный метод: сначала трек, потом артист
  Future<String> getCombinedGenre(String artist, String title) async {
    // Пробуем найти жанры трека
    final trackGenres = await getTrackGenres(artist, title);
    if (trackGenres.isNotEmpty) {
      return trackGenres.first;
    }

    // Если не нашли, пробуем по артисту
    final artistGenres = await getArtistGenres(artist);
    if (artistGenres.isNotEmpty) {
      return artistGenres.first;
    }

    return 'unknown';
  }
}
































































Future<String> _getPageTitle(String url) async {
  try {
    // Простой способ - создаем HttpClient и игнорируем SSL ошибки
    HttpClient client = HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true) 
        as bool Function(X509Certificate, String, int)?;
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    
    if (response.statusCode == HttpStatus.ok) {
      String html = await response.transform(utf8.decoder).join();
      
      debugPrint('Fetching title from: $url');
      debugPrint('HTML length: ${html.length}');
      
      // Упрощенное регулярное выражение для поиска title
      final titleRegex = RegExp(
        r'<title\s*>([\s\S]*?)</title>',
        caseSensitive: false,
      );
      
      final match = titleRegex.firstMatch(html);
      
      if (match != null) {
        String title = match.group(1)!;
        debugPrint('Raw title found: "$title"');
        
        // Очистка title
        title = title
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
            
        AppLogger.writeLog('Cleaned title: "$title"');
        return title.isNotEmpty ? title : "none";
      } else {
        AppLogger.writeLog('Title tag not found');
        
        // Альтернативные варианты поиска title
        final alternativeRegexes = [
          RegExp(r'<meta\s+property="og:title"\s+content="([^"]*)"', caseSensitive: false),
          RegExp(r"<meta\s+property='og:title'\s+content='([^']*)'", caseSensitive: false),
          RegExp(r'<meta\s+name="twitter:title"\s+content="([^"]*)"', caseSensitive: false),
        ];
        
        for (final regex in alternativeRegexes) {
          final altMatch = regex.firstMatch(html);
          if (altMatch != null) {
            String altTitle = altMatch.group(1)!;
            AppLogger.writeLog('Found alternative title: "$altTitle"');

            return altTitle.trim();
          }
        }
      }
    } else {
      AppLogger.writeLog('HTTP error: ${response.statusCode}');
    }
    
    client.close();
  } catch (e) {
    AppLogger.writeLog('Error getting page title: $e');
  }
  return 'none';
}

void _writeToDebugLog1(String message) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final debugFile = File('${directory.path}/chat_debug1.log');
      await debugFile.writeAsString('${DateTime.now()}: $message\n', mode: FileMode.append);
      print('DEBUG: $message'); // Также выводим в консоль
    } catch (e) {
      print('Error writing to debug log: $e');
    }
  }
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
class ScreenAnalysis {
  static const MethodChannel _channel = MethodChannel('screenshot_channel');
  
  // Callback для получения результатов анализа
  static Function(String)? onAnalysisResult;
  
  static void initialize() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }
  
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onScreenAnalysisResult':
        final String result = call.arguments;
        if (onAnalysisResult != null) {
          onAnalysisResult!(result);
        }
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          message: 'Method ${call.method} not implemented',
        );
    }
  }
  
  static Future<bool> startAnalysis() async {
    try {
      final bool result = await _channel.invokeMethod('startScreenAnalysis');
      return result;
    } catch (e) {
      print('Failed to start analysis: $e');
      return false;
    }
  }
  
  static Future<bool> stopAnalysis() async {
    try {
      final bool result = await _channel.invokeMethod('stopScreenAnalysis');
      return result;
    } catch (e) {
      print('Failed to stop analysis: $e');
      return false;
    }
  }
}

































































































class EssentialsApp extends StatelessWidget {
  const EssentialsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: EssentialsContent(),
      ),
    );
  }
}

class EssentialsContent extends StatefulWidget {
  const EssentialsContent({Key? key}) : super(key: key);

  @override
  _EssentialsContentState createState() => _EssentialsContentState();
}

class _EssentialsContentState extends State<EssentialsContent> {
List<EssentialItem> _essentials = [];
final AudioPlayer _audioPlayer = AudioPlayer();
bool _isLoading = true;
final TextEditingController _searchController = TextEditingController();
List<EssentialItem> _filteredEssentials = [];
String? _backgroundImagePath;
final Map<String, int> _hashtagFrequency = {};
final Map<String, int> _emojiFrequency = {};
final GlobalKey _essentialsListKey = GlobalKey();
final _searchFocusNode = FocusNode();
bool _isDragging = false;
int _draggedIndex = -1;
double _dragOffset = 0.0;
final ScrollController _scrollController = ScrollController();

final String _orderFileName = 'essentials_order.json';
double _lastDragPosition = 0.0;
double _dragStartY = 0.0;
double _dragStartLocalY = 0.0; // Позиция внутри виджета
Map<int, Rect> _widgetRects = {}; // Позиции и размеры виджетов
final Map<String, GlobalKey> _essentialKeys = {};
final Localization _locale = Localization();


 EncryptionService1? service ;
  
  
int _getFilteredIndex(EssentialItem item) {
  return _filteredEssentials.indexWhere((element) => element.id == item.id);
}
Future<void> _loadOrder() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final orderFile = File('${directory.path}/essentials/$_orderFileName');
    
    if (orderFile.existsSync()) {
      final content = await orderFile.readAsString();
  
  final decrypted = await service!.decryptData(content);

  
      final List<dynamic> orderList = json.decode(decrypted);
      
      // Создаем карту для быстрого доступа к элементам по ID
      final Map<String, EssentialItem> itemsMap = {
        for (var item in _essentials) item.id: item
      };
      
      // Сортируем элементы согласно сохраненному порядку
      final List<EssentialItem> orderedItems = [];
      for (final id in orderList) {
        if (itemsMap.containsKey(id)) {
          orderedItems.add(itemsMap[id]!);
        }
      }
      
      // Добавляем элементы, которых нет в порядке (новые)
      for (final item in _essentials) {
        if (!orderList.contains(item.id)) {
          orderedItems.add(item);
        }
      }
      
      setState(() {
        _essentials = orderedItems;
      });
      _filterEssentials();
 
    }
  } catch (e) {
    print('Error loading order: $e');
  }
}
Future<void> _saveOrder() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final essentialsDir = Directory('${directory.path}/essentials');
    
    if (!essentialsDir.existsSync()) {
      essentialsDir.createSync(recursive: true);
    }
    
    final orderFile = File('${essentialsDir.path}/$_orderFileName');
    final orderList = _essentials.map((item) => item.id).toList();
    
    print('Saving order: $orderList');
      final encrypted = await service!.encryptData(json.encode(orderList));
    await orderFile.writeAsString(encrypted);
  } catch (e) {
    print('Error saving order: $e');
  }
}

 @override
void initState() {
  super.initState();
  _locale.init();
  _loadEssentials().then((_) {
    _loadOrder();
  });
  
  _startFileMonitoring();
  
  _searchController.addListener(_filterEssentials);
  _loadBackground();
  
  // Фокус на поиск при открытии
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_searchFocusNode.canRequestFocus) {
      _searchFocusNode.requestFocus();
    }
  });
}

List<EssentialItem> _getVisibleEssentials() {
  final scrollController = _scrollController;
  if (scrollController.hasClients) {
    final scrollOffset = scrollController.offset;
    final viewportHeight = scrollController.position.viewportDimension;
    
    // Вычисляем индексы видимых элементов
    final firstVisibleIndex = (scrollOffset / 92).floor(); // 92 - примерная высота элемента
    final lastVisibleIndex = ((scrollOffset + viewportHeight) / 92).ceil();
    
    // Возвращаем видимые элементы с корректными индексами
    return _filteredEssentials
        .sublist(
          firstVisibleIndex.clamp(0, _filteredEssentials.length),
          lastVisibleIndex.clamp(0, _filteredEssentials.length),
        )
        .toList();
  }
  
  return _filteredEssentials;
}

void _handleKeyEvent(KeyEvent event) {
  if (event is KeyDownEvent) {
    final logicalKey = event.logicalKey;
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
         windowManager.close();
          return;
        }
    // Check if Control is pressed using RawKeyboard
    final isControlPressed = RawKeyboard.instance.keysPressed.any((key) =>
        key == LogicalKeyboardKey.controlLeft || 
        key == LogicalKeyboardKey.controlRight);
    
    // Ctrl + цифры (1-9, 0) - только для видимых элементов
    if (isControlPressed) {
      final numberKeys = [
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.digit2,
        LogicalKeyboardKey.digit3,
        LogicalKeyboardKey.digit4,
        LogicalKeyboardKey.digit5,
        LogicalKeyboardKey.digit6,
        LogicalKeyboardKey.digit7,
        LogicalKeyboardKey.digit8,
        LogicalKeyboardKey.digit9,
        LogicalKeyboardKey.digit0,
      ];
      
      final index = numberKeys.indexOf(logicalKey);
      if (index != -1) {
        _activateVisibleEssentialByIndex(index);
        return;
      }
    }
    
    // Стрелки и Page Up/Down
    if (!_searchFocusNode.hasFocus) {
      switch (logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          _scrollByIndex(-1);
          break;
        case LogicalKeyboardKey.arrowDown:
          _scrollByIndex(1);
          break;
        case LogicalKeyboardKey.pageUp:
          _scrollByPercentage(-0.8);
          break;
        case LogicalKeyboardKey.pageDown:
          _scrollByPercentage(0.8);
          break;
      }
    }
  }
}

void _activateEssentialByIndex(int index) {
  if (index >= 0 && index < _filteredEssentials.length) {
    final item = _filteredEssentials[index];
    _copyToClipboard(item.name);
    
    // Визуальная обратная связь
    _showActivationFeedback(index);
  }
}

void _activateVisibleEssentialByIndex(int visibleIndex) {
  final visibleEssentials = _getVisibleEssentials();
  
  if (visibleIndex >= 0 && visibleIndex < visibleEssentials.length) {
    final item = visibleEssentials[visibleIndex];
    _activateEssential(item);
    
    // Визуальная обратная связь
    _showActivationFeedback(visibleIndex);
  }
}

void _activateEssential(EssentialItem item) {
  final url = _extractUrlFromText(item.name);
  
  if (url != null) {
    // Для URL - открываем в браузере
    _launchUrl(url);
  } else if (item.originalFilePath != null) {
    // Для файлов - открываем файл
    _openEssentialFile(item);
  } else {
    // Для текстовых элементов - копируем всё после первой :
    _copyEssentialText(item);
  }
}

// Перенесите эту функцию из EssentialWidget в _EssentialsContentState
String? _extractUrlFromText(String text) {
  try {
    final uri = Uri.parse(text);
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return text;
    }
    
    if (text.toLowerCase().contains('http') && text.contains('://')) {
      final start = text.indexOf('http');
      final end = text.indexOf(' ', start);
      if (end == -1) return text.substring(start);
      return text.substring(start, end);
    }
    
    return null;
  } catch (_) {
    return null;
  }
}

void _copyEssentialText(EssentialItem item) {
  final textToCopy = item.name.contains(':') 
      ? item.name.split(':').sublist(1).join(':').trim() 
      : item.name;
      
  Clipboard.setData(ClipboardData(text: textToCopy));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${_locale.get("copy")}: $textToCopy'),
      backgroundColor: Colors.green,
    ),
  );
}

Future<void> _openEssentialFile(EssentialItem item) async {
  try {
    if (item.originalFilePath != null) {
      final file = File(item.originalFilePath!);
      if (await file.exists()) {
        if (Platform.isWindows) {
          await Process.run('start', ['""', item.originalFilePath!], runInShell: true);
        } else if (Platform.isMacOS) {
          await Process.run('open', [item.originalFilePath!]);
        } else {
          await Process.run('xdg-open', [item.originalFilePath!]);
        }
        return;
      }
    }
    
    // Если файл не найден, показываем ошибку
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("error_no_found")}: ${item.name}'),
        backgroundColor: Colors.orange,
      ),
    );
  } catch (e) {
    print('Error opening file: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("error_open_file")}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_locale.get("error_open_link")}: $url'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  } catch (e) {
    print('Error launching URL: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("error_open_link")}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void _showActivationFeedback(int visibleIndex) {
  final visibleEssentials = _getVisibleEssentials();
  if (visibleIndex < visibleEssentials.length) {
    final item = visibleEssentials[visibleIndex];
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("activated")}: ${item.name}'),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 500),
      ),
    );
    
    // Можно добавить подсветку элемента (опционально)
    //_highlightEssential(item.id);
  }
}

void _highlightEssential(String id) {
  // Временная подсветка элемента (можно реализовать через состояние)
  setState(() {
    // Логика подсветки, если нужно
  });
  
  // Сброс подсветки через 500ms
  Future.delayed(Duration(milliseconds: 500), () {
    if (mounted) {
      setState(() {
        // Сброс состояния подсветки
      });
    }
  });
}

void _scrollByIndex(int delta) {
  final newOffset = _scrollController.offset + (92 * delta); // 92 - примерная высота элемента
  _scrollController.animateTo(
    newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
    duration: Duration(milliseconds: 200),
    curve: Curves.easeInOut,
  );
}

void _scrollByPercentage(double percentage) {
  final viewportHeight = _scrollController.position.viewportDimension;
  final scrollDelta = viewportHeight * percentage;
  final newOffset = _scrollController.offset + scrollDelta;
  _scrollController.animateTo(
    newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}

  void _filterEssentials() {
    final query = _searchController.text.trim().toLowerCase();
    
    if (query.isEmpty) {
      setState(() {
        _filteredEssentials = List.from(_essentials);
      });
      return;
    }

    final searchWords = query.split(' ').where((word) => word.isNotEmpty).toList();
    
    setState(() {
      _filteredEssentials = _essentials.where((item) {
        final searchText = '${item.icon ?? ''} ${item.name} ${item.comment ?? ''}'.toLowerCase();
        
        for (final word in searchWords) {
          if (!searchText.contains(word)) {
            return false;
          }
        }
        return true;
      }).toList();
    });
  }

  void _startFileMonitoring() {
    Timer.periodic(Duration(seconds: 12), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      await _checkForNewFiles();
    });
  }

  Future<void> _checkForNewFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final essentialsDir = Directory('${directory.path}/essentials');
      
      if (!essentialsDir.existsSync()) return;
      
      final files = essentialsDir.listSync();
      final currentFilePaths = _essentials.map((e) => e.originalFilePath).whereType<String>().toSet();
      
      for (var file in files) {
        if (!currentFilePaths.contains(file.path) && !file.path.endsWith('.json')) {
          final newItem = EssentialItem.fromFile(file);
          setState(() {
            _essentials.add(newItem);
          });
          _filterEssentials();
        }
      }
    } catch (e) {
      print('Error monitoring files: $e');
    }
  }

void _addNewEssential() {
  // Показываем диалог редактирования без предварительного создания объекта
  final newItem = EssentialItem(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: '${_locale.get("newElement")}',
    icon: '📝',
    backgroundColor: Colors.blue.value,
    textColor: Colors.white.value,
  );
  
  _showEditDialog(newItem, isNewItem: true);
  // НЕ добавляем в список до сохранения в диалоге
}


  Future<void> _loadEssentials() async {
    service = await EncryptionService1.create();
    try {
      final directory = await getApplicationDocumentsDirectory();
      final essentialsDir = Directory('${directory.path}/essentials');
      
      if (!essentialsDir.existsSync()) {
        essentialsDir.createSync(recursive: true);
      }
      
      final files = essentialsDir.listSync();
      final List<EssentialItem> loadedItems = [];
      
      for (var file in files) {
        if (file.path.endsWith('.json')) {
          try {
            final content = await File(file.path).readAsString();
             final decrypted = await service!.decryptData(content);
             if( !(decrypted.startsWith("{")&& decrypted.endsWith("}"))){continue;}
            final jsonData = json.decode(decrypted);
            loadedItems.add(EssentialItem.fromJson(jsonData));
          } catch (e) {
            print('Error loading essential: $e');
          }
        } else {
          loadedItems.add(EssentialItem.fromFile(file));
        }
      }
      
      if (mounted) {
        setState(() {
          _essentials.addAll(loadedItems);
          _isLoading = false;
          _updateHashtagFrequency();
          _updateEmojiFrequency();
        });
      }
    } catch (e) {
      print('Error loading essentials: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateHashtagFrequency() {
    _hashtagFrequency.clear();
    for (final item in _essentials) {
      if (item.comment != null) {
        final hashtags = RegExp(r'#\w+').allMatches(item.comment!);
        for (final match in hashtags) {
          final hashtag = match.group(0)!;
          _hashtagFrequency[hashtag] = (_hashtagFrequency[hashtag] ?? 0) + 1;
        }
      }
    }
  }

  void _updateEmojiFrequency() {
    _emojiFrequency.clear();
    for (final item in _essentials) {
      _emojiFrequency[item.icon] = (_emojiFrequency[item.icon] ?? 0) + 1;
    }
  }

Future<void> _saveEssential(EssentialItem item) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final essentialsDir = Directory('${directory.path}/essentials');
    
    if (!essentialsDir.existsSync()) {
      essentialsDir.createSync(recursive: true);
    }
    
    final file = File('${essentialsDir.path}/${item.id}.json');
      final encrypted = await service!.encryptData(json.encode(item.toJson()));
    await file.writeAsString(encrypted);
    
    // Обновляем состояние для мгновенного отображения изменений
    if (mounted) {
      setState(() {
        final index = _essentials.indexWhere((e) => e.id == item.id);
        if (index != -1) {
          _essentials[index] = item;
          _filterEssentials();
        }
      });
    }
    
    _updateHashtagFrequency();
    _updateEmojiFrequency();
  } catch (e) {
    print('Error saving essential: $e');
  }
}

  Future<void> _deleteEssential(EssentialItem item) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final essentialsDir = Directory('${directory.path}/essentials');
    
    final jsonFile = File('${essentialsDir.path}/${item.id}.json');
    if (jsonFile.existsSync()) {
      jsonFile.deleteSync();
    }
    
    setState(() {
      _essentials.remove(item);
      _filteredEssentials.removeWhere((e) => e.id == item.id);
    });
    
    _updateHashtagFrequency();
    _updateEmojiFrequency();
    await _saveOrder();
    
    // Показываем уведомление об удалении
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("deleted")}: ${item.name}'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    print('Error deleting essential: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("error_deleting")}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


 void _showEditDialog(EssentialItem item, {bool isNewItem = false}) {
  final sourceWidgetKey = GlobalKey();
  


  showDialog(
    context: context,
    builder: (context) => EssentialEditDialog(
    item: item,
    onSave: (updatedItem) async {
      if (isNewItem) {
        // Добавляем новый элемент
        setState(() {
          _essentials.add(updatedItem);
          _filteredEssentials.add(updatedItem);
        });
        await _saveEssential(updatedItem);
        await _saveOrder(); // Сохраняем новый порядок
        _updateHashtagFrequency();
        _updateEmojiFrequency();
      } else {
        // Обновляем существующий элемент
        setState(() {
          final index = _essentials.indexWhere((e) => e.id == item.id);
          if (index != -1) {
            _essentials[index] = updatedItem;
          }
          
          // Обновляем также в отфильтрованном списке
          final filteredIndex = _filteredEssentials.indexWhere((e) => e.id == item.id);
          if (filteredIndex != -1) {
            _filteredEssentials[filteredIndex] = updatedItem;
          }
        });
        await _saveEssential(updatedItem);
        _updateHashtagFrequency();
        _updateEmojiFrequency();
      }
    },
    onDelete: () => _showDeleteConfirmation(item,true),
    isNewItem: isNewItem,
    sourceWidgetKey: sourceWidgetKey,
  )
  ).then((_) {
    // После закрытия диалога обновляем интерфейс
    if (mounted) {
      setState(() {});
    }
  });
}

  void _showDeleteConfirmation(EssentialItem item, bool closeAfter) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        item: item,
        closeAfter: closeAfter,
        onDelete: (){
          _deleteEssential(item);},
      ),
    );
  }

  void _copyToClipboard(String text) {
    final textToCopy = text.contains(':') ? text.split(':').sublist(1).join(':').trim() : text;
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("copied")}: $textToCopy'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _loadBackground() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backgroundFile = File('${directory.path}/essentials_background.jpg');
      if (backgroundFile.existsSync()) {
        setState(() {
          _backgroundImagePath = backgroundFile.path;
        });
      }
    } catch (e) {
      print('Error loading background: $e');
    }
  }

  Future<void> _saveBackground(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backgroundFile = File('${directory.path}/essentials_background.jpg');
      final originalFile = File(imagePath);
      await originalFile.copy(backgroundFile.path);
      setState(() {
        _backgroundImagePath = backgroundFile.path;
      });
    } catch (e) {
      print('Error saving background: $e');
    }
  }

  void _handleFileDrop(List<File> files) {
    if (files.isNotEmpty) {
      final file = files.first;
      final newItem = EssentialItem.fromFile(file);
      setState(() {
        _essentials.add(newItem);
      });
      _saveEssential(newItem);
    }
  }

  void _handleBackgroundDrop(List<File> files) {
    if (files.isNotEmpty) {
      _saveBackground(files.first.path);
    }
  }
void _updateMainListOrder() {
  // Создаем карту для быстрого доступа к элементам по ID
  final Map<String, EssentialItem> itemsMap = {
    for (var item in _essentials) item.id: item
  };

  // Создаем новый упорядоченный список на основе отфильтрованного
  final List<EssentialItem> newOrderedEssentials = [];

  for (final filteredItem in _filteredEssentials) {
    if (itemsMap.containsKey(filteredItem.id)) {
      newOrderedEssentials.add(itemsMap[filteredItem.id]!);
    }
  }

  // Добавляем элементы, которых нет в отфильтрованном списке
  for (final item in _essentials) {
    if (!_filteredEssentials.any((filteredItem) => filteredItem.id == item.id)) {
      newOrderedEssentials.add(item);
    }
  }

  setState(() {
    _essentials = newOrderedEssentials;
  });
}
void _reorderItems(int oldIndex, int newIndex) {
  if (oldIndex == newIndex) return;

  print('REORDER: Moving from $oldIndex to $newIndex');

  setState(() {
    final item = _filteredEssentials.removeAt(oldIndex);
    
    // Корректируем newIndex если нужно
    final adjustedNewIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    _filteredEssentials.insert(adjustedNewIndex, item);

    _updateMainListOrder();
  });

  _saveOrder();
}
void _addHashtagToSearch(String hashtag) {
  final currentText = _searchController.text;
  
  // Если хэштег уже есть в тексте - удаляем его
  if (currentText.contains(hashtag)) {
    // Удаляем хэштег из текста
    final newText = currentText
        .replaceAll('$hashtag ', '') // Удаляем с пробелом после
        .replaceAll(' $hashtag', '') // Удаляем с пробелом перед
        .replaceAll(hashtag, '')     // Удаляем без пробелов
        .trim();                     // Убираем лишние пробелы
    
    _searchController.text = newText;
    _searchFocusNode.requestFocus();
    return; // Закрываем функцию
  }
  
  // Если хэштега нет - добавляем его
  final newText = currentText.isEmpty ? hashtag : '$currentText $hashtag';
  _searchController.text = newText;
}

  void _addEmojiToSearch(String emoji) {
    final currentText = _searchController.text;
    if (currentText.contains(emoji)) {
    // Удаляем хэштег из текста
    final newText = currentText
        .replaceAll('$emoji ', '') // Удаляем с пробелом после
        .replaceAll(' $emoji', '') // Удаляем с пробелом перед
        .replaceAll(emoji, '')     // Удаляем без пробелов
        .trim();                     // Убираем лишние пробелы
    
    _searchController.text = newText;
    return; // Закрываем функцию
  }
  
    final newText = currentText.isEmpty ? emoji : '$currentText $emoji';
    _searchController.text = newText;
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(), // Создаем отдельный FocusNode для глобальных горячих клавиш
      onKeyEvent: _handleKeyEvent,
      autofocus: true,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Background with pattern
            if (_backgroundImagePath != null)
              _buildBackgroundPattern(),
            
            // Main content
            Container(
              width: 400,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(right: 0),
              decoration: BoxDecoration(
                color: Color(0xFF2B2B2B).withOpacity(0.11),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  // Header with DropTarget
                  DropTarget(
                    onDragDone: (detail) async {
                      final files = <File>[];
                      
                      try {
                        final processedPaths = <String>{};
                        
                        for (final item in detail.files) {
                          final path = item.path;
                          
                          if (path != null && path.isNotEmpty && !processedPaths.contains(path)) {
                            processedPaths.add(path);
                            
                            final file = File(path);
                            if (await file.exists()) {
                              files.add(file);
                              break; // Берем только первый файл
                            }
                          }
                        }
                      } catch (e) {
                        print('Error in header drop: $e');
                      }
                      
                      if (files.isNotEmpty) {
                        _handleBackgroundDrop(files);
                        if (mounted) {
                          setState(() {});
                        }
                        files.clear();
                      }
                    },
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1A1A).withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${_locale.get("essentials")} [ALT+X]',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => windowManager.close(),
                              child: Icon(Icons.close, size: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Search row
                  Container(
                    padding: EdgeInsets.all(12),
                    color: Color(0xFF1A1A1A).withOpacity(0.7),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode, 
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: '${_locale.get("search")}',
                            hintStyle: TextStyle(color: Colors.white54),
                            prefixIcon: Icon(Icons.search, color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color(0xFF2B2B2B).withOpacity(0.8),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                        
                        // Hashtags suggestions
                        if ( _searchFocusNode.hasFocus && _hashtagFrequency.isNotEmpty)
                          _buildHashtagSuggestions(),
                        
                        // Emoji suggestions
                        if ( _searchFocusNode.hasFocus && _emojiFrequency.isNotEmpty)
                          _buildEmojiSuggestions(),
                      ],
                    ),
                  ),

                  // Essentials list with DropTarget
                  Expanded(
                    child: DropTarget(
                      onDragDone: (detail) async {
                        final files = <File>[];
                        
                        try {
                          final processedPaths = <String>{};
                          
                          for (final item in detail.files) {
                            final path = item.path;
                            
                            if (path != null && path.isNotEmpty && !processedPaths.contains(path)) {
                              processedPaths.add(path);
                              
                              final file = File(path);
                              if (await file.exists()) {
                                files.add(file);
                                break; // Берем только первый файл
                              }
                            }
                          }
                        } catch (e) {
                          print('Error in essentials drop: $e');
                        }
                        
                        if (files.isNotEmpty) {
                          _handleFileDrop(files);
                          if (mounted) {
                            setState(() {});
                          }
                          files.clear();
                        }
                      },
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator(color: Colors.white))
                          : _filteredEssentials.isEmpty
                              ? Center(
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2B2B2B).withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _searchController.text.isEmpty ? '${_locale.get("noElements")}' : '${_locale.get("nothing_found")}',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ),
                                )
                              : _buildReorderableList(),
                    ),
                  ),

                  // Add new Essential button
                  Container(
  padding: EdgeInsets.all(16),
  color: Color(0xFF1A1A1A).withOpacity(0.7),
  child: TextField(
    controller: TextEditingController(),
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: '${_locale.get("newElement")}',
      hintStyle: TextStyle(color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Color(0xFF2B2B2B).withOpacity(0.8),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    onSubmitted: (text) {
      if (text.trim().isNotEmpty) {
        final newItem = EssentialItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: text.trim(),
          icon: '📝',
          backgroundColor: Colors.blue.value,
          textColor: Colors.white.value,
        );
        _showEditDialog(newItem, isNewItem: true);
      }
    },
  ),
),
                ],
              ),
            ),

            // Drag and drop areas for background
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: Row(
                  children: [
                    // Left drop zone
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    
                    // Center content area (protected)
                    Container(
                      width: 400,
                      color: Colors.transparent,
                    ),
                    
                    // Right drop zone
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: Image.file(
        File(_backgroundImagePath!),
        fit: BoxFit.cover,
        alignment: Alignment.center,
        repeat: ImageRepeat.repeat,
      ),
    );
  }

  Widget _buildHashtagSuggestions() {
  final sortedHashtags = _hashtagFrequency.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value))
    ..take(10);

  return Container(
    margin: EdgeInsets.only(top: 8),
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Color(0xFF1A1A1A).withOpacity(0.9),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Wrap(
      spacing: 8, // горизонтальный отступ между элементами
      runSpacing: 8, // вертикальный отступ между строками
      children: sortedHashtags.map((entry) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _addHashtagToSearch(entry.key),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                entry.key,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildEmojiSuggestions() {
  final sortedEmojis = _emojiFrequency.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value))
    ..take(15);

  return Container(
    height: 50,
    margin: EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
      color: Color(0xFF1A1A1A).withOpacity(0.9),
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: sortedEmojis.length,
      itemBuilder: (context, index) {
        final entry = sortedEmojis[index];
        return Container(
          width: 45,
          height: 45,
          margin: EdgeInsets.all(2.5),
          child: GestureDetector(
            onTap: () => _addEmojiToSearch(entry.key),
            child: Text(
              entry.key,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    ),
  );
}
void _collectWidgetRects() {
  _widgetRects.clear();
  
  final listRenderBox = _essentialsListKey.currentContext?.findRenderObject() as RenderBox?;
  if (listRenderBox == null) return;

  final listPosition = listRenderBox.localToGlobal(Offset.zero);
  
  for (int i = 0; i < _filteredEssentials.length; i++) {
    try {
      // Находим элемент виджета по индексу
      final widgetElement = _findWidgetByIndex(i);
      if (widgetElement == null) continue;
      
      final widgetRenderBox = widgetElement.findRenderObject() as RenderBox?;
      if (widgetRenderBox != null) {
        final widgetPosition = widgetRenderBox.localToGlobal(Offset.zero);
        final relativeY = widgetPosition.dy - listPosition.dy + _scrollController.offset;
        
        _widgetRects[i] = Rect.fromLTWH(
          0, 
          relativeY, 
          widgetRenderBox.size.width, 
          widgetRenderBox.size.height
        );
        
        print('Widget $i: Y=$relativeY, height=${widgetRenderBox.size.height}');
      }
    } catch (e) {
      print('Error collecting rect for widget $i: $e');
    }
  }
}
void _handleDragUpdate(DragUpdateDetails details, int draggedIndex) {
  if (!_isDragging) return;

  final renderBox = _essentialsListKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final listPosition = renderBox.localToGlobal(Offset.zero);
  final mouseY = details.globalPosition.dy;

  // Вычисляем относительную позицию внутри списка
  final relativeY = mouseY - listPosition.dy;
  _lastDragPosition = relativeY;

  // Собираем позиции всех видимых виджетов
  // _collectWidgetRects();

  // Автопрокрутка при приближении к границам
  const scrollThreshold = 50.0;
  const scrollSpeed = 10.0;

  if (relativeY < scrollThreshold && _scrollController.offset > 0) {
    _scrollController.jumpTo(_scrollController.offset - scrollSpeed);
  } else if (relativeY > renderBox.size.height - scrollThreshold && 
             _scrollController.offset < _scrollController.position.maxScrollExtent) {
    _scrollController.jumpTo(_scrollController.offset + scrollSpeed);
  }
}


  void _handleDragStart(int index) {
    setState(() {
      _isDragging = true;
      _dragOffset = 0.0;
    });
  }



// Обновить функцию построения списка
Widget _buildReorderableList() {
  return Container(
    key: _essentialsListKey,
    child: ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(5), // Уменьшили padding
      itemCount: _filteredEssentials.length,
      itemBuilder: (context, index) {
        final item = _filteredEssentials[index];
        return _buildDraggableEssentialItem(
          item: item,
          index: index,
        );
      },
    ),
  );
}
void _handleDragUpdateWithCustomLogic(DragUpdateDetails details, int draggedIndex) {
  final renderBox = _essentialsListKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final listPosition = renderBox.localToGlobal(Offset.zero);
  final mouseY = details.globalPosition.dy - listPosition.dy;

  // Автопрокрутка при приближении к границам
  const scrollThreshold = 150.0;
  const scrollSpeed = 20.0;

  if (mouseY < scrollThreshold && _scrollController.offset > 0) {
    _scrollController.jumpTo(_scrollController.offset - scrollSpeed);
  } else if (mouseY > renderBox.size.height - scrollThreshold && 
             _scrollController.offset < _scrollController.position.maxScrollExtent) {
    _scrollController.jumpTo(_scrollController.offset + scrollSpeed);
  }

  // Определяем новый индекс на основе позиции Y
  final itemHeight = 92.0; // Примерная высота элемента
  final newIndex = (mouseY / itemHeight).clamp(0, _essentials.length - 1).floor();

  if (newIndex != draggedIndex && newIndex >= 0 && newIndex < _essentials.length) {
    _reorderItems(draggedIndex, newIndex);
  }
}
void _handleDragEnd(int draggedIndex) {
  if (_lastDragPosition < 0) return;

  // Получаем реальную высоту перетаскиваемого виджета
  final double widgetHeight = _getWidgetHeight(draggedIndex);
  final double minDragDistance = widgetHeight * 0.3; // Уменьшили минимальное расстояние

  final double dragDistance = (_lastDragPosition - _dragStartLocalY).abs();
  
  print('Real widget height: $widgetHeight, drag distance: $dragDistance');

  if (dragDistance < minDragDistance) {
    print('Drag distance too small, returning to original position');
    setState(() {
      _isDragging = false;
      _draggedIndex = -1;
      _lastDragPosition = 0.0;
    });
    return;
  }

  // Собираем реальные позиции и размеры всех виджетов
  final Map<int, double> widgetHeights = {};
  final Map<int, double> widgetPositions = {};
  
  double currentY = 0;
  for (int i = 0; i < _filteredEssentials.length; i++) {
    final double height = _getWidgetHeight(i);
    widgetHeights[i] = height;
    widgetPositions[i] = currentY;
    currentY += height + 8; // + margin
  }

  // Вычисляем позицию с учетом прокрутки
  final double dropPosition = _lastDragPosition + _scrollController.offset;

  // Ищем между какими виджетами находится точка отпускания
  int newIndex = draggedIndex;
  
  for (int i = 0; i < _filteredEssentials.length; i++) {
    final double widgetTop = widgetPositions[i]!;
    final double widgetBottom = widgetTop + widgetHeights[i]!;
    final double widgetCenter = widgetTop + (widgetHeights[i]! / 2);

    if (i == draggedIndex) continue;

    // Проверяем попадает ли точка в зону виджета
    if (dropPosition >= widgetTop && dropPosition <= widgetBottom) {
      // Сравниваем с центром виджета
      if (dropPosition < widgetCenter) {
        newIndex = i; // Ставим ПЕРЕД этим виджетом
      } else {
        newIndex = i + 1; // Ставим ПОСЛЕ этого виджета
      }
      break;
    }
  }

  // Ограничиваем индекс
  newIndex = newIndex.clamp(0, _filteredEssentials.length - 1);

  print('Moving from $draggedIndex to $newIndex based on real positions');

  // Предотвращаем перемещение на то же место
  if (newIndex != draggedIndex) {
    _reorderItems(draggedIndex, newIndex);
  }

  setState(() {
    _isDragging = false;
    _draggedIndex = -1;
    _lastDragPosition = 0.0;
  });
}

Map<int, Rect> _getVisibleWidgetRects() {
  final Map<int, Rect> rects = {};
  
  final listRenderBox = _essentialsListKey.currentContext?.findRenderObject() as RenderBox?;
  if (listRenderBox == null) return rects;

  final listPosition = listRenderBox.localToGlobal(Offset.zero);
  final listTop = listPosition.dy;
  final listBottom = listTop + listRenderBox.size.height;

  for (int i = 0; i < _filteredEssentials.length; i++) {
    try {
      // Создаем GlobalKey для каждого виджета чтобы получить его позицию
      final key = GlobalKey();
      
      // Получаем контекст виджета (упрощенный способ)
      final widgetContext = _essentialsListKey.currentContext;
      if (widgetContext == null) continue;

      // Ищем все RenderBox в списке
      final widgetFinder = _findWidgetByIndex(i);
      if (widgetFinder != null) {
        final widgetRenderBox = widgetFinder.findRenderObject() as RenderBox?;
        if (widgetRenderBox != null) {
          final widgetPosition = widgetRenderBox.localToGlobal(Offset.zero);
          final widgetTop = widgetPosition.dy;
          final widgetBottom = widgetTop + widgetRenderBox.size.height;

          // Проверяем, виден ли виджет в области списка
          if (widgetBottom >= listTop && widgetTop <= listBottom) {
            final relativeTop = widgetTop - listTop + _scrollController.offset;
            rects[i] = Rect.fromLTWH(
              0, 
              relativeTop, 
              widgetRenderBox.size.width, 
              widgetRenderBox.size.height
            );
            
            print('Widget $i: top=$relativeTop, height=${widgetRenderBox.size.height}');
          }
        }
      }
    } catch (e) {
      print('Error getting rect for widget $i: $e');
    }
  }

  return rects;
}
Element? _findWidgetByIndex(int index) {
  try {
    final listContext = _essentialsListKey.currentContext;
    if (listContext == null) return null;

    Element? targetElement;
    int foundIndex = 0;
    
    void traverse(Element element) {
      if (targetElement != null) return;

      // Проверяем, является ли это Container с EssentialWidget
      final widget = element.widget;
      if (widget is Container) {
        if (widget.child is EssentialWidget) {
          if (foundIndex == index) {
            targetElement = element;
            return;
          }
          foundIndex++;
        }
      }

      element.visitChildren(traverse);
    }

    // Приводим BuildContext к Element и обходим
    (listContext as Element).visitChildren(traverse);
    return targetElement;
  } catch (e) {
    print('Error finding widget by index: $e');
    return null;
  }
}

double _getWidgetHeight(int index) {
  try {
    final item = _filteredEssentials[index];
    final widgetKey = _essentialKeys[item.id];
    if (widgetKey != null && widgetKey.currentContext != null) {
      final renderBox = widgetKey.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        return renderBox.size.height;
      }
    }
  } catch (e) {
    print('Error getting widget height for index $index: $e');
  }
  
  // Fallback если не удалось получить реальный размер
  return 80.0; // Примерная высота по умолчанию
}
int _findPositionBetweenWidgets(double draggedCenter, Map<int, Rect> widgetRects, int draggedIndex) {
  if (widgetRects.isEmpty) return draggedIndex;

  // Сортируем виджеты по позиции
  final sortedEntries = widgetRects.entries.toList()
    ..sort((a, b) => a.value.top.compareTo(b.value.top));

  // Проверяем позицию перед первым виджетом
  final firstWidget = sortedEntries.first;
  if (draggedCenter < firstWidget.value.top) {
    return 0;
  }

  // Проверяем позицию после последнего виджета
  final lastWidget = sortedEntries.last;
  if (draggedCenter > lastWidget.value.bottom) {
    return _filteredEssentials.length - 1;
  }

  // Ищем между какими виджетами находится центр
  for (int i = 0; i < sortedEntries.length - 1; i++) {
    final currentWidget = sortedEntries[i];
    final nextWidget = sortedEntries[i + 1];

    // Проверяем, находится ли центр между текущим и следующим виджетом
    if (draggedCenter > currentWidget.value.bottom && 
        draggedCenter < nextWidget.value.top) {
      
      // Возвращаем индекс следующего виджета (ставим перед ним)
      return nextWidget.key;
    }
  }

  return draggedIndex; // Оставляем на месте если не нашли подходящую позицию
}

Widget _buildDraggableEssentialItem({
  required EssentialItem item,
  required int index,
}) {
  return LongPressDraggable<int>(
    data: index,
    feedback: Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      child: Opacity(
        opacity: 0.8,
        child: Container(
          width: 360,
          child: _buildEssentialContent(item),
        ),
      ),
    ),
    childWhenDragging: Container(
      height: 76,
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white30, width: 2),
      ),
    ),
    onDragStarted: () {
  // Используем PostFrameCallback чтобы гарантировать что виджеты отрендерены
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final renderBox = _essentialsListKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final listPosition = renderBox.localToGlobal(Offset.zero);
          
          // Получаем позицию конкретного виджета
          final widgetElement = _findWidgetByIndex(index);
          if (widgetElement != null) {
            final widgetRenderBox = widgetElement.findRenderObject() as RenderBox?;
            if (widgetRenderBox != null) {
              final widgetPosition = widgetRenderBox.localToGlobal(Offset.zero);
              _dragStartY = widgetPosition.dy;
              _dragStartLocalY = widgetPosition.dy - listPosition.dy;
              
              print('Drag started at index $index, localY: $_dragStartLocalY');
            }
          }
        }
      });

      setState(() {
        _isDragging = true;
        _draggedIndex = index;
      });
    },
    onDragUpdate: (details) {
      _handleDragUpdate(details, index);
    },
    onDragEnd: (details) {
      _handleDragEnd(index);
    },
    child: _buildEssentialWidget(item, index),
  );
}



  Widget _buildEssentialContent(EssentialItem item) {
    return Container(
      width: 360, // Ширина контейнера
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(item.backgroundColor).withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        image: item.backgroundImagePath != null
            ? DecorationImage(
                image: FileImage(File(item.backgroundImagePath!)),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              )
            : null,
      ),
      child: _buildEssentialInfo(item),
    );
  }

  Widget _buildEssentialInfo(EssentialItem item) {
    final filePathDisplay = _getFilePathDisplay(item);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              item.icon,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  color: Color(item.textColor),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        
        if (filePathDisplay != null)
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              filePathDisplay,
              style: TextStyle(
                color: Color(item.textColor).withOpacity(0.6),
                fontSize: 10,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        
        if (item.comment != null && item.comment!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              item.comment!,
              style: TextStyle(
                color: Color(item.textColor).withOpacity(0.8),
                fontSize: 12,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
Widget _buildEssentialWidget(EssentialItem item, int index) {
  if (!_essentialKeys.containsKey(item.id)) {
    _essentialKeys[item.id] = GlobalKey();
  }
  
  // Получаем индекс в видимой области для отображения горячей клавиши
  final visibleEssentials = _getVisibleEssentials();
  final visibleIndex = visibleEssentials.indexWhere((element) => element.id == item.id);
  final hotkeyLabel = visibleIndex >= 0 && visibleIndex < 9 ? 'Ctrl+${visibleIndex + 1}' : 
                     visibleIndex == 9 ? 'Ctrl+0' : '';

  return Container(
    key: _essentialKeys[item.id],
    margin: EdgeInsets.only(bottom: 8),
    child: EssentialWidget(
      key: Key(item.id),
      item: item,
      hotkeyLabel: hotkeyLabel, // Добавляем передачу горячей клавиши
      onTap: () => _activateEssential(item), // Обновляем обработчик тапа
      onEdit: () => _showEditDialog(item),
      onDelete: () => _showDeleteConfirmation(item,false),
    ),
  );
}

  String? _getFilePathDisplay(EssentialItem item) {
    if (item.shortcutTarget != null) {
      return '${_locale.get("shortcut")}: ${item.shortcutTarget}';
    } else if (item.filePath != null) {
      return '${_locale.get("file")}: ${item.filePath}';
    }
    return null;
  }


  @override
void dispose() {
  _searchFocusNode.dispose();
   _scrollController.dispose();
  super.dispose();
}
}
class EssentialWidget extends StatefulWidget {
  final EssentialItem item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String hotkeyLabel; // Добавляем этот параметр

  const EssentialWidget({
    Key? key,
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.hotkeyLabel, // Добавляем в конструктор
  }) : super(key: key);

  @override
  _EssentialWidgetState createState() => _EssentialWidgetState();
}

class _EssentialWidgetState extends State<EssentialWidget> {
  bool _isHovered = false;
  Uint8List? _imagePreview;
  Uint8List? _appIcon;
  Uint8List? _favicon;
  Timer? _doubleTapTimer;
  bool _isWaitingDoubleTap = false;
  Localization _locale = Localization();
  @override
  void initState() {
    super.initState();
    _locale.init();
    _loadImagePreview();
    _loadAppIcon();
    _loadFavicon();
  }

  @override
  void dispose() {
    _doubleTapTimer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    if (_isWaitingDoubleTap) {
      // Это двойной клик
      _doubleTapTimer?.cancel();
      _isWaitingDoubleTap = false;
      _handleDoubleTap();
    } else {
      // Это одинарный клик - ждем возможный второй клик
      _isWaitingDoubleTap = true;
      _doubleTapTimer = Timer(Duration(milliseconds: 300), () {
        if (_isWaitingDoubleTap) {
          _isWaitingDoubleTap = false;
          _handleSingleTap();
        }
      });
    }
  }

  void _handleSingleTap() {
    final url = _extractUrlFromText(widget.item.name);
    if (url != null) {
      _launchUrl(url);
    } else if (widget.item.originalFilePath != null) {
      _openFile();
    } else {
      widget.onTap();
    }
  }

  void _handleDoubleTap() {
    final url = _extractUrlFromText(widget.item.name);
    if (url != null) {
      // Для URL открываем в Google
      _launchUrlInGoogle(url);
    } else if (widget.item.originalFilePath != null) {
      // Для файлов открываем расположение
      _openFileLocation();
    } else {
      // Для обычных элементов - копируем в буфер
      widget.onTap();
    }
  }

  Future<void> _openFileLocation() async {
    try {
      if (widget.item.originalFilePath != null) {
        final file = File(widget.item.originalFilePath!);
        final directory = file.parent;
        
        if (await directory.exists()) {
          final uri = Uri.file(directory.path);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${_locale.get("error_open_file")}'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error opening file location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_locale.get("error_open_file")}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _launchUrlInGoogle(String url) async {
    try {
      // Преобразуем URL для открытия в Google
      final googleUrl = 'https://www.google.com/search?q=${Uri.encodeComponent(url)}';
      final uri = Uri.parse(googleUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // Если не получилось открыть в Google, открываем обычным способом
        await _launchUrl(url);
      }
    } catch (e) {
      print('Error launching URL in Google: $e');
      await _launchUrl(url);
    }
  }

  
  Widget _buildIcon() {
    final url = _extractUrlFromText(widget.item.name);
    
    if (_imagePreview != null) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            image: MemoryImage(_imagePreview!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (_appIcon != null) {
      return Image.memory(_appIcon!, width: 32, height: 32);
    } else if (_favicon != null) {
      return Image.memory(_favicon!, width: 32, height: 32);
    } else if (url != null) {
      return Icon(Icons.public, color: Color(widget.item.textColor), size: 20);
    } else {
      return Text(
        widget.item.icon,
        style: TextStyle(fontSize: 20),
      );
    }
  }

  String? _getFilePathDisplay() {
  if (widget.item.shortcutTarget != null) {
    return '${_locale.get("shortcut")}: ${widget.item.shortcutTarget}';
  } else if (widget.item.filePath != null) {
    return '${_locale.get("file")}: ${widget.item.filePath}';
  } else if (widget.item.originalFilePath != null) {
    return '${_locale.get("path")}: ${widget.item.originalFilePath}';
  }
  return null;
}
  Future<void> _openFile() async {
    try {
      final file = File(widget.item.originalFilePath!);
      if (await file.exists()) {
        final uri = Uri.file(widget.item.originalFilePath!);
        if (Platform.isWindows) {
        await Process.run('start', ['""', widget.item.originalFilePath!], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', [widget.item.originalFilePath!]);
      } else {
        await Process.run('xdg-open', [widget.item.originalFilePath!]);
      }
      }
    } catch (e) {
      print('Error opening file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_locale.get("error_open_file")}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


    String? _extractUrlFromText(String text) {
    try {
      final uri = Uri.parse(text);
      if (uri.scheme == 'http' || uri.scheme == 'https') {
        return text;
      }
      
      if (text.toLowerCase().contains('http') && text.contains('://')) {
        final start = text.indexOf('http');
        final end = text.indexOf(' ', start);
        if (end == -1) return text.substring(start);
        return text.substring(start, end);
      }
      
      return null;
    } catch (_) {
      return null;
    }
  }

  bool _isImageFile(String path) {
    final ext = path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);
  }

  bool _isWebUrl(String text) {
    try {
      final uri = Uri.parse(text);
      return uri.scheme == 'http' || uri.scheme == 'https';
    } catch (_) {
      return false;
    }
  }
    Future<void> _loadImagePreview() async {
    if (widget.item.originalFilePath != null && 
        _isImageFile(widget.item.originalFilePath!)) {
      try {
        final file = File(widget.item.originalFilePath!);
        final bytes = await file.readAsBytes();
        if (mounted) {
          setState(() {
            _imagePreview = bytes;
          });
        }
      } catch (e) {
        print('Error loading image preview: $e');
      }
    }
  }

  Future<void> _loadAppIcon() async {
    if (widget.item.originalFilePath != null && 
        widget.item.originalFilePath!.toLowerCase().endsWith('.exe')) {
      try {
        // В реальном приложении используйте MethodChannel для извлечения иконки EXE
        // Это упрощенная заглушка
        final iconBytes = await _extractExeIcon(widget.item.originalFilePath!);
        if (mounted && iconBytes != null) {
          setState(() {
            _appIcon = iconBytes;
          });
        }
      } catch (e) {
        print('Error loading app icon: $e');
      }
    }
  }

  Future<void> _loadFavicon() async {
    final url = _extractUrlFromText(widget.item.name);
    if (url != null) {
      try {
        final faviconBytes = await _downloadFavicon(url);
        if (mounted && faviconBytes != null) {
          setState(() {
            _favicon = faviconBytes;
          });
        }
      } catch (e) {
        print('Error loading favicon: $e');
      }
    }
  }

  Future<Uint8List?> _extractExeIcon(String exePath) async {
    // Заглушка для извлечения иконки EXE
    // В реальном приложении используйте platform channels для вызова WinAPI
    try {
      // Возвращаем заглушку - зеленый квадрат
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()..color = Colors.green;
      canvas.drawRect(Rect.fromLTWH(0, 0, 32, 32), paint);
      final picture = recorder.endRecording();
      final image = await picture.toImage(32, 32);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error extracting EXE icon: $e');
      return null;
    }
  }

  Future<Uint8List?> _downloadFavicon(String url) async {
    try {
      final uri = Uri.parse(url);
      final faviconUrl = '${uri.scheme}://${uri.host}/favicon.ico';
      final response = await http.get(Uri.parse(faviconUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      
      // Пробуем альтернативные пути
      final alternativeUrls = [
        '${uri.scheme}://${uri.host}/apple-touch-icon.png',
        '${uri.scheme}://${uri.host}/favicon.png',
      ];
      
      for (final altUrl in alternativeUrls) {
        try {
          final altResponse = await http.get(Uri.parse(altUrl));
          if (altResponse.statusCode == 200) {
            return altResponse.bodyBytes;
          }
        } catch (e) {
          continue;
        }
      }
    } catch (e) {
      print('Error downloading favicon: $e');
    }
    return null;
  }


  // Остальные методы класса остаются без изменений...
  // _loadImagePreview, _loadAppIcon, _loadFavicon, _launchUrl, _openFile и т.д.

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_locale.get("error_open_link")}: $url'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_locale.get("error_open_link")}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
@override
Widget build(BuildContext context) {
  final filePathDisplay = _getFilePathDisplay();
  
  // Получаем индекс для отображения горячей клавиши
  final parentState = context.findAncestorStateOfType<_EssentialsContentState>();
  final index = parentState?._getFilteredIndex(widget.item) ?? -1;
  final hotkeyLabel = index >= 0 && index < 9 ? 'Ctrl+${index + 1}' : 
                     index == 9 ? 'Ctrl+0' : '';

  return MouseRegion(
    onEnter: (_) => setState(() => _isHovered = true),
    onExit: (_) => setState(() => _isHovered = false),
    child: GestureDetector(
      onTap: _handleTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(widget.item.backgroundColor).withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          image: widget.item.backgroundImagePath != null
              ? DecorationImage(
                  image: FileImage(File(widget.item.backgroundImagePath!)),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                )
              : null,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildIcon(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.item.name,
                        style: TextStyle(
                          color: Color(widget.item.textColor),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                if (filePathDisplay != null)
                  GestureDetector(
                    onTap: _openFileLocation,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          filePathDisplay,
                          style: TextStyle(
                            color: Color(widget.item.textColor).withOpacity(0.8),
                            fontSize: 10,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                
                if (widget.item.comment != null && widget.item.comment!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      widget.item.comment!,
                      style: TextStyle(
                        color: Color(widget.item.textColor).withOpacity(0.8),
                        fontSize: 12,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                
                if (widget.item.reminderTime != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '${_locale.get("notification")}: ${DateFormat('dd.MM.yyyy HH:mm').format(widget.item.reminderTime!)}',
                      style: TextStyle(
                        color: Color(widget.item.textColor).withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),

            // Горячая клавиша в левом нижнем углу
           if (widget.hotkeyLabel.isNotEmpty)
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.hotkeyLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            if (_isHovered)
              Positioned(
                top: 4,
                right: 4,
                child: Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: widget.onEdit,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.settings, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: widget.onDelete,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}}

class EssentialEditDialog extends StatefulWidget {
  final EssentialItem item;
  final Function(EssentialItem) onSave;
  final VoidCallback onDelete;
  final bool isNewItem;
  final GlobalKey? sourceWidgetKey;

  const EssentialEditDialog({
    Key? key,
    required this.item,
    required this.onSave,
    required this.onDelete,
    this.isNewItem = false,
    this.sourceWidgetKey,
  }) : super(key: key);

  @override
  _EssentialEditDialogState createState() => _EssentialEditDialogState();
}

class _EssentialEditDialogState extends State<EssentialEditDialog> {
  late EssentialItem _editedItem;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _musicController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _iconFocusNode = FocusNode();
  bool _showReminderSettings = false;
  bool _showEmojiGrid = false;
  Color _currentColor = Colors.blue;
  Localization _locale = Localization();
  final List<String> _quickEmojis = ['🔑', '⭐', '📄', 'ℹ️', '⚠️', '🌐', '📝', '🟢', '❓'];

  @override
  void initState() {
    super.initState();
    _locale.init();
    _editedItem = widget.item;
    _nameController.text = _editedItem.name;
    _iconController.text = _editedItem.icon;
    _commentController.text = _editedItem.comment ?? '';
    _musicController.text = _editedItem.musicFile ?? 'alarm.mp3';
    _selectedDate = _editedItem.reminderTime;
    _selectedTime = _editedItem.reminderTime != null
        ? TimeOfDay.fromDateTime(_editedItem.reminderTime!)
        : null;
    _showReminderSettings = _editedItem.reminderTime != null;
    _currentColor = Color(_editedItem.backgroundColor);

    if (widget.isNewItem) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _nameFocusNode.requestFocus();
      });
    }

    _iconFocusNode.addListener(() {
      setState(() {
        _showEmojiGrid = _iconFocusNode.hasFocus;
      });
    });
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        final directory = await getApplicationDocumentsDirectory();
        final backgroundsDir = Directory('${directory.path}/Essentials_backgrounds');
        if (!backgroundsDir.existsSync()) {
          backgroundsDir.createSync(recursive: true);
        }

        final originalFile = File(result.files.single.path!);
        final newPath = '${backgroundsDir.path}/${DateTime.now().millisecondsSinceEpoch}.${result.files.single.extension}';
        await originalFile.copy(newPath);

        setState(() {
          _editedItem = _editedItem.copyWith(backgroundImagePath: newPath);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _editedItem = _editedItem.copyWith(backgroundImagePath: null);
    });
  }

  Future<void> _pickMusic() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowedExtensions: ['mp3', 'wav'],
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final extension = result.files.single.extension?.toLowerCase();
        
        if (extension == 'mp3' || extension == 'wav') {
          setState(() {
            _editedItem = _editedItem.copyWith(musicFile: path);
            _musicController.text = path;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Поддерживаются только MP3 и WAV файлы'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error picking music: $e');
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
void _saveChanges() {
  final updatedItem = _editedItem.copyWith(
    name: _nameController.text.trim(),
    icon: _iconController.text.trim(),
    comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
    musicFile: _musicController.text.trim(),
    reminderTime: _showReminderSettings && _selectedDate != null && _selectedTime != null
        ? DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          )
        : null,
  );

  // Сохраняем элемент
  widget.onSave(updatedItem);
  
  // Закрываем диалог
  Navigator.of(context).pop();
}
  void _selectEmoji(String emoji) {
    setState(() {
      _iconController.text = emoji;
    });
  }

@override
Widget build(BuildContext context) {
  // Обработчик ESC
  void handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
    }
  }

  // Создаем виджет с KeyboardListener
  Widget dialogContent;
  
  if (widget.isNewItem || widget.sourceWidgetKey == null) {
    dialogContent = _buildDialog(context);
  } else {
    dialogContent = Stack(
      children: [
        Positioned.fill(
          child: Container(color: Colors.transparent),
        ),
        Positioned(
          top: _getDialogPosition(context).dy,
          left: _getDialogPosition(context).dx,
          child: _buildDialog(context),
        ),
      ],
    );
  }

  return KeyboardListener(
    focusNode: FocusNode(),
    onKeyEvent: handleKeyEvent,
    autofocus: true,
    child: dialogContent,
  );
}

  Offset _getDialogPosition(BuildContext context) {
    try {
      final renderBox = widget.sourceWidgetKey?.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final offset = renderBox.localToGlobal(Offset.zero);
        return offset;
      }
    } catch (e) {
      print('Error getting widget position: $e');
    }
    return Offset.zero;
  }

Widget _buildDialog(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8, // Увеличил высоту
      decoration: BoxDecoration(
        color: Color(_editedItem.backgroundColor).withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A).withOpacity(0.9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${_locale.get("editEssential")}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Icon field with emoji grid
                      Container(
                        width: 60,
                        child: Column(
                          children: [
                            TextField(
                              controller: _iconController,
                              focusNode: _iconFocusNode,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                              textAlign: TextAlign.center,
                              maxLength: 1, // Ограничение на 1 символ
                              buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) => null, // Скрываем счетчик
                              inputFormatters: [
                                // Ограничиваем ввод только 1 символом (включая эмодзи)
                                LengthLimitingTextInputFormatter(1),
                              ],
                              onChanged: (value) {
                                // Дополнительная валидация на стороне кода
                                if (value.length > 1) {
                                  _iconController.text = value.substring(0, 1);
                                  _iconController.selection = TextSelection.collapsed(offset: 1);
                                }
                              },
                              decoration: InputDecoration(
                                hintText: '🔖',
                                hintStyle: TextStyle(fontSize: 20),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                            
                          // Emoji grid
                          if (_showEmojiGrid)
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                                itemCount: _quickEmojis.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {

                                      _iconController.text=_quickEmojis[index];
                                      setState((){
                                       _iconController.text=_quickEmojis[index]; 
                                      });
                                    }
                                    ,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _quickEmojis[index],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: '${_locale.get("name")}',
                            labelStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ПРАВИЛЬНОЕ МЕСТО ДЛЯ ОТОБРАЖЕНИЯ ПУТИ ФАЙЛА - после строки с названием
                  if (_editedItem.filePath != null || _editedItem.shortcutTarget != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _editedItem.shortcutTarget != null 
                            ? '${_locale.get("shortcut")}: ${_editedItem.shortcutTarget}'
                            : '${_locale.get("file")}: ${_editedItem.filePath}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  SizedBox(height: 16),
                  // Color pickers
                  Row(
                    children: [
                      Text('${_locale.get("widgetColor")}:', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: _buildColorPicker(
                            initialColor: Color(_editedItem.backgroundColor),
                            onColorChanged: (color) {
                              setState(() {
                                _editedItem = _editedItem.copyWith(backgroundColor: color.value);
                                _currentColor = color;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Text('${_locale.get("textColor")}:', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: _buildColorPicker(
                            initialColor: Color(_editedItem.textColor),
                            onColorChanged: (color) {
                              setState(() {
                                _editedItem = _editedItem.copyWith(textColor: color.value);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _commentController,
                            style: TextStyle(color: Colors.white),
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: '${_locale.get("comment")}',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                          ),

                          SizedBox(height: 16),

                          // Image management
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _editedItem.backgroundImagePath != null
                                      ? '${_locale.get("imageSet")}'
                                      : '${_locale.get("noImage")}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${_locale.get("selectImage")}',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                              if (_editedItem.backgroundImagePath != null) ...[
                                SizedBox(width: 8),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: _removeImage,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.delete, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          SizedBox(height: 16),

                          // Skins section
                          _buildSkinsSection(),

                          SizedBox(height: 16),

                          // Reminder toggle
                          Row(
                            children: [
                              Checkbox(
                                value: _showReminderSettings,
                                onChanged: (value) {
                                  setState(() {
                                    _showReminderSettings = value ?? false;
                                    if (!_showReminderSettings) {
                                      _selectedDate = null;
                                      _selectedTime = null;
                                    }
                                  });
                                },
                              ),
                              Text(
                                '${_locale.get("createNotify")}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),

                          // Reminder settings (only visible when toggle is on)
                          if (_showReminderSettings) ...[
                            SizedBox(height: 8),
                            Text(
                              '${_locale.get("notification")}',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedDate != null
                                        ? '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}'
                                        : '${_locale.get("dateNotSet")}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: _pickDate,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${_locale.get("setDate")}',
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedTime != null
                                        ? '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                        : '${_locale.get("timeNotSet")}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: _pickTime,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${_locale.get("setTime")}',
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            // Music
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _musicController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: '${_locale.get("musicFile")}',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: _pickMusic,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${_locale.get("pickFile")}',
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                          ],

                          SizedBox(height: 16),

                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: _saveChanges,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${_locale.get("save")}',
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: widget.onDelete,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${_locale.get("delete")}',
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSkinsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Skins:',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      FutureBuilder<List<FileSystemEntity>>(
        future: _loadSkins(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.white));
          }
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Text(
              'No skins found. Add PNG/JPG images to documents/qwa/essentials_skins folder',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            );
          }
          
          final skins = snapshot.data!;
          return Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: skins.length,
              itemBuilder: (context, index) {
                final skin = skins[index];
                final isSelected = _editedItem.backgroundImagePath == skin.path;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _editedItem = _editedItem.copyWith(backgroundImagePath: skin.path);
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: FileImage(File(skin.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    ],
  );
}

Future<List<FileSystemEntity>> _loadSkins() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final skinsDir = Directory('${directory.path}/qwa/essentials_skins');
    
    if (!skinsDir.existsSync()) {
      skinsDir.createSync(recursive: true);
      return [];
    }
    
    final files = skinsDir.listSync();
    return files.where((file) {
      final path = file.path.toLowerCase();
      return path.endsWith('.png') || path.endsWith('.jpg') || path.endsWith('.jpeg');
    }).toList();
  } catch (e) {
    print('Error loading skins: $e');
    return [];
  }
}


Widget _buildColorPicker({required Color initialColor, required ValueChanged<Color> onColorChanged}) {
  return GestureDetector(
    onTap: () {
      Color selectedColor = initialColor; // Запоминаем начальный цвет
      
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: selectedColor,
              title: Text('${_locale.get("pickColor")}', style: TextStyle(
                color: selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white
              )),
              content: Container(
                width: 300,
                height: 300,
                child: ColorPicker(
                  color: selectedColor,
                  onColorChanged: (color) {
                    setDialogState(() {
                      selectedColor = color; // Обновляем выбранный цвет
                    });
                  },
                  showLabel: false,
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('${_locale.get("cancel")}', style: TextStyle(
                    color: selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white
                  )),
                ),
                TextButton(
                  onPressed: () {
                    onColorChanged(selectedColor); // Сохраняем выбранный цвет
                    Navigator.of(context).pop();
                  },
                  child: Text('${_locale.get("ok")}', style: TextStyle(
                    color: selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white
                  )),
                ),
              ],
            );
          },
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: initialColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
    ),
  );
}
}

class ColorPicker extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool showLabel;
  final double pickerAreaHeightPercent;

  const ColorPicker({
    Key? key,
    required this.color,
    required this.onColorChanged,
    this.showLabel = true,
    this.pickerAreaHeightPercent = 0.8,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.color;
  }

  List<Color> _generateColors() {
    final colors = <Color>[];
    
    // Basic colors
    colors.addAll([
      Colors.black, Colors.white, Colors.grey,
      Colors.red, Colors.pink, Colors.purple,
      Colors.deepPurple, Colors.indigo, Colors.blue,
      Colors.lightBlue, Colors.cyan, Colors.teal,
      Colors.green, Colors.lightGreen, Colors.lime,
      Colors.yellow, Colors.amber, Colors.orange,
      Colors.deepOrange, Colors.brown,
    ]);

    // Generate more shades
    for (var baseColor in [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple]) {
      for (int i = 1; i <= 9; i++) {
        colors.add(baseColor[i * 100]!);
      }
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final colors = _generateColors();
    
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentColor = color;
                  });
                  widget.onColorChanged(color);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: _currentColor.value == color.value ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
        ),
        
        SizedBox(height: 16),
        
        // Gradient picker
        Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Colors.red, Colors.orange, Colors.yellow, 
                Colors.green, Colors.blue, Colors.indigo, 
                Colors.purple
              ],
            ),
          ),
          child: GestureDetector(
            onTapDown: (details) {
              final relativeX = details.localPosition.dx;
              final containerWidth = context.size?.width ?? 1;
              final ratio = relativeX / containerWidth;
              
              final hue = ratio * 360;
              final color = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
              
              setState(() {
                _currentColor = color;
              });
              widget.onColorChanged(color);
            },
          ),
        ),
        
        SizedBox(height: 8),
        
        // Current color display
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _currentColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white),
          ),
          child: Text(
            'RGB: ${_currentColor.red}, ${_currentColor.green}, ${_currentColor.blue}',
            style: TextStyle(
              color: _currentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
class DeleteConfirmationDialog extends StatefulWidget {
  final EssentialItem item;
  final VoidCallback onDelete;
  final bool closeAfter;
  const DeleteConfirmationDialog({
    Key? key,
    required this.item,
    required this.closeAfter,
    required this.onDelete,
  }) : super(key: key);

  @override
  _DeleteConfirmationDialogState createState() => _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    Localization _locale = Localization();
    _locale.init();
    
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        backgroundColor: Color(0xFF2B2B2B),
        title: Text(
          '${_locale.get("elementDelete")}',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '${_locale.get("ensureDeletion")}"${widget.item.name}"?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('${_locale.get("cancel")}', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete();
              Navigator.of(context).pop();
              if(widget.closeAfter){  Navigator.of(context).pop(); }
              
            },
            child: Text('${_locale.get("delete")}', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
class EssentialItem {
  final String id;
  final String name;
  final String icon;
  final int backgroundColor;
  final int textColor;
  final String? comment;
  final String? backgroundImagePath;
  final String? musicFile;
  final DateTime? reminderTime;
  final String? originalFilePath;
  final String? filePath; // Новое поле для пути файла/ярлыка
  final String? shortcutTarget; // Новое поле для цели ярлыка

  EssentialItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.comment,
    this.backgroundImagePath,
    this.musicFile,
    this.reminderTime,
    this.originalFilePath,
    this.filePath,
    this.shortcutTarget,
  });

  factory EssentialItem.fromFile(FileSystemEntity file) {
    final fileName = file.path.split('/').last;
    final extension = fileName.split('.').last.toLowerCase();
    
    String icon = '📄';
    String? shortcutTarget;
    
    // Проверяем, является ли файл ярлыком
    if (extension == 'lnk' || extension == 'url') {
      icon = '🔗';
      shortcutTarget = _readShortcutTarget(file.path);
    } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension)) {
      icon = '🖼️';
    } else if (['mp3', 'wav', 'ogg'].contains(extension)) {
      icon = '🎵';
    } else if (['exe'].contains(extension)) {
      icon = '⚙️';
    }
    
    return EssentialItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: fileName,
      icon: icon,
      backgroundColor: Colors.blue.value,
      textColor: Colors.white.value,
      originalFilePath: file.path,
      filePath: file.path,
      shortcutTarget: shortcutTarget,
    );
  }

  // Функция для чтения цели ярлыка (упрощенная версия)
  static String? _readShortcutTarget(String shortcutPath) {
    try {
      if (shortcutPath.toLowerCase().endsWith('.url')) {
        final file = File(shortcutPath);
        final lines = file.readAsLinesSync();
        for (final line in lines) {
          if (line.toLowerCase().startsWith('url=')) {
            return line.substring(4).trim();
          }
        }
      }
      // Для .lnk файлов в реальном приложении нужно использовать native channel
      return shortcutPath;
    } catch (e) {
      return shortcutPath;
    }
  }

  factory EssentialItem.fromJson(Map<String, dynamic> json) {
    return EssentialItem(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      backgroundColor: json['backgroundColor'],
      textColor: json['textColor'],
      comment: json['comment'],
      backgroundImagePath: json['backgroundImagePath'],
      musicFile: json['musicFile'],
      reminderTime: json['reminderTime'] != null ? DateTime.parse(json['reminderTime']) : null,
      originalFilePath: json['originalFilePath'],
      filePath: json['filePath'],
      shortcutTarget: json['shortcutTarget'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'comment': comment,
      'backgroundImagePath': backgroundImagePath,
      'musicFile': musicFile,
      'reminderTime': reminderTime?.toIso8601String(),
      'originalFilePath': originalFilePath,
      'filePath': filePath,
      'shortcutTarget': shortcutTarget,
    };
  }

  EssentialItem copyWith({
    String? id,
    String? name,
    String? icon,
    int? backgroundColor,
    int? textColor,
    String? comment,
    String? backgroundImagePath,
    String? musicFile,
    DateTime? reminderTime,
    String? originalFilePath,
    String? filePath,
    String? shortcutTarget,
  }) {
    return EssentialItem(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      comment: comment ?? this.comment,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
      musicFile: musicFile ?? this.musicFile,
      reminderTime: reminderTime ?? this.reminderTime,
      originalFilePath: originalFilePath ?? this.originalFilePath,
      filePath: filePath ?? this.filePath,
      shortcutTarget: shortcutTarget ?? this.shortcutTarget,
    );
  }
}




























class ClipboardHistoryWindow extends StatefulWidget {
  const ClipboardHistoryWindow({super.key});

  @override
  State<ClipboardHistoryWindow> createState() => _ClipboardHistoryWindowState();
}

class _ClipboardHistoryWindowState extends State<ClipboardHistoryWindow> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _clipboardHistory = [];
  List<Map<String, dynamic>> _filteredHistory = [];
  bool _isLoading = true;
  late Timer _keyboardInputTimer;
  String _currentTypedText = '';
  DateTime _lastTypedTime = DateTime.now();
  late Directory _copypasteDir;
  late StreamSubscription<FileSystemEvent> _fileWatcher;
  int _currentTab = 0; // 0 - все, 1 - избранное
  File? _backgroundImage;
  Map<String, dynamic>? _expandedItem;
  List<String> _selectedItems = []; // Для compose функционала
  bool _showExportOptions = false;
  String _exportMode = 'auto'; // auto, image, text, html, archive, separate
  EncryptionService1? service ;
  // CSS для HTML экспорта
  final String _htmlCss = '''
    <style>
      body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        max-width: 70%;
        margin: 0 auto;
        padding: 40px 20px;
        background-color: #1a1a1a;
        color: #ffffff;
        line-height: 1.6;
      }
      .text-block {
        background: #2b2b2b;
        padding: 25px;
        margin: 20px 0;
        border-radius: 8px;
        border-left: 4px solid #4CAF50;
      }
      .code-block {
        background: #1e1e1e;
        padding: 25px;
        margin: 20px 0;
        border-radius: 8px;
        border-left: 4px solid #2196F3;
        font-family: 'Consolas', 'Monaco', monospace;
        white-space: pre-wrap;
        overflow-x: auto;
      }
      .image-block {
        text-align: center;
        margin: 30px 0;
        padding: 15px;
        background: #2b2b2b;
        border-radius: 8px;
        border-left: 4px solid #FF9800;
      }
      .image-block img {
        max-width: 100%;
        height: auto;
        border-radius: 4px;
      }
      .image-caption {
        margin-top: 10px;
        font-style: italic;
        color: #cccccc;
      }
      .header {
        text-align: center;
        margin-bottom: 40px;
        padding-bottom: 20px;
        border-bottom: 2px solid #333;
      }
      .timestamp {
        color: #888;
        font-size: 0.9em;
        margin-top: 10px;
      }
    </style>
  ''';


  final Localization _locale = Localization();
final FocusNode _searchFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _initializeApp();
    _setupKeyboardListeners();
    _locale.init();
      _scrollController.addListener(_onScroll);
     // Фокус на поиск после инициализации
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
    FocusScope.of(context).requestFocus(_searchFocusNode);
  });
  }

  void _onScroll() {
  // При прокрутке обновляем состояние для перерисовки горячих клавиш
  if (mounted) {
    setState(() {
      // Просто обновляем состояние, чтобы перерисовать элементы с новыми индексами
    });
  }
}

  void _setupKeyboardListeners() {
    // Слушатель для клавиш Esc и Ctrl+Z
    RawKeyboard.instance.addListener(_handleKeyEvent);
      RawKeyboard.instance.addListener(_handleNavigationKeys);
  }

void _handleKeyEvent(RawKeyEvent event) {
  if (event is RawKeyDownEvent) {
    // Esc - различные действия в зависимости от контекста
    if (event.logicalKey == LogicalKeyboardKey.escape) {

      if (_expandedItem!=null){

        setState((){
          _expandedItem=null;
        });
      }else
      if (_selectedItems.isNotEmpty) {
        // Если есть выделенные элементы - очистить выделение //peekay
        setState(() {
          _selectedItems.clear();
          _showExportOptions = false;
        });
      } else {
        // Если выделения нет - закрыть окно
        _closeWindow();
      }
    }
    // Ctrl+Z - отменить последнее выделение
    else if (event.logicalKey == LogicalKeyboardKey.keyZ && 
             event.isControlPressed) {
      if (_selectedItems.isNotEmpty) {
        setState(() {
          _selectedItems.removeLast();
          _showExportOptions = _selectedItems.isNotEmpty;
        });
      }
    }
  }
}

// Метод для закрытия окна
void _closeWindow() {
  // Используем WindowsManager для закрытия
  if (windowManager != null) {
    windowManager.close();
  } 
}
  void _handleNavigationKeys(RawKeyEvent event) {
  if (event is RawKeyDownEvent) {
    final logicalKey = event.logicalKey;
    
    // Цифровые клавиши 1-9 для быстрого выбора
    if (event.isControlPressed && _isNumberKey(logicalKey)) {
      _handleNumberKeySelection(logicalKey);
    }
    
    // Клавиши навигации
    if (!event.isControlPressed) {
      switch (logicalKey) {
        case LogicalKeyboardKey.arrowDown:
          _scrollByOffset(1); // Вниз на 1 элемент
          break;
        case LogicalKeyboardKey.arrowUp:
          _scrollByOffset(-1); // Вверх на 1 элемент
          break;
        case LogicalKeyboardKey.pageDown:
          _scrollByPage(0.8); // Вниз на 80% высоты
          break;
        case LogicalKeyboardKey.pageUp:
          _scrollByPage(-0.8); // Вверх на 80% высоты
          break;
      }
    }
  }
}


bool _isNumberKey(LogicalKeyboardKey key) {
  return key == LogicalKeyboardKey.digit1 ||
         key == LogicalKeyboardKey.digit2 ||
         key == LogicalKeyboardKey.digit3 ||
         key == LogicalKeyboardKey.digit4 ||
         key == LogicalKeyboardKey.digit5 ||
         key == LogicalKeyboardKey.digit6 ||
         key == LogicalKeyboardKey.digit7 ||
         key == LogicalKeyboardKey.digit8 ||
         key == LogicalKeyboardKey.digit9 ||
         key == LogicalKeyboardKey.digit0;
}

void _handleNumberKeySelection(LogicalKeyboardKey key) {
  try {
    // Получаем видимые элементы в viewport
    final visibleItems = _getVisibleItems();
    if (visibleItems.isEmpty) return;
    
    final index = _getIndexFromKey(key);
    if (index < visibleItems.length) {
      final item = visibleItems[index];
      _copyToClipboard(item);
      
      // Показать подтверждение
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_locale.get("elementCopiedP1")} ${index + 1} ${_locale.get("fromVisible")}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } else {
      // Если индекс превышает количество видимых элементов
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_locale.get("element")} ${index + 1} ${_locale.get("notVisible")}'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  } catch (e) {
    print('Error in number key selection: $e');
    // Fallback: копируем по абсолютному индексу
    _handleNumberKeySelectionFallback(key);
  }
}

void _handleNumberKeySelectionFallback(LogicalKeyboardKey key) {
  try {
    final index = _getIndexFromKey(key);
    if (index < _filteredHistory.length) {
      final item = _filteredHistory[index];
      _copyToClipboard(item);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_locale.get("elementCopiedP1")} ${index + 1}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  } catch (e) {
    print('Error in fallback key selection: $e');
  }
}

List<Map<String, dynamic>> _getVisibleItems() {
  try {
    final scrollController = _scrollController;
    if (!scrollController.hasClients || _filteredHistory.isEmpty) {
      return _filteredHistory;
    }
    
    final scrollOffset = scrollController.offset;
    
    // Используем фиксированную высоту viewport вместо MediaQuery
    const viewportHeight = 500.0; // Примерная высота области контента
    const estimatedItemHeight = 100.0;
    
    // Вычисляем индексы видимых элементов
    final firstVisibleIndex = (scrollOffset / estimatedItemHeight).floor();
    final lastVisibleIndex = ((scrollOffset + viewportHeight) / estimatedItemHeight).ceil();
    
    // Ограничиваем индексы в пределах списка
    final startIndex = firstVisibleIndex.clamp(0, _filteredHistory.length - 1);
    final endIndex = lastVisibleIndex.clamp(0, _filteredHistory.length);
    
    // Возвращаем видимые элементы
    return _filteredHistory.sublist(startIndex, endIndex);
  } catch (e) {
    print('Error getting visible items: $e');
    return _filteredHistory; // Fallback: возвращаем все элементы
  }
}

List<Map<String, dynamic>> _getVisibleItemsSimple() {
  try {
    if (!_scrollController.hasClients || _filteredHistory.isEmpty) {
      return _filteredHistory;
    }
    
    // Простая логика: берем первые 10 элементов от текущей позиции скролла
    final scrollOffset = _scrollController.offset;
    const estimatedItemHeight = 100.0;
    final startIndex = (scrollOffset / estimatedItemHeight).floor();
    final endIndex = (startIndex + 10).clamp(0, _filteredHistory.length);
    
    return _filteredHistory.sublist(startIndex, endIndex);
  } catch (e) {
    return _filteredHistory;
  }
}

int _getIndexFromKey(LogicalKeyboardKey key) {
  switch (key) {
    case LogicalKeyboardKey.digit1: return 0;
    case LogicalKeyboardKey.digit2: return 1;
    case LogicalKeyboardKey.digit3: return 2;
    case LogicalKeyboardKey.digit4: return 3;
    case LogicalKeyboardKey.digit5: return 4;
    case LogicalKeyboardKey.digit6: return 5;
    case LogicalKeyboardKey.digit7: return 6;
    case LogicalKeyboardKey.digit8: return 7;
    case LogicalKeyboardKey.digit9: return 8;
    case LogicalKeyboardKey.digit0: return 9;
    default: return 0;
  }
}

final ScrollController _scrollController = ScrollController();

void _scrollByOffset(int offset) {
  final currentPosition = _scrollController.offset;
  final itemHeight = 100.0; // Примерная высота элемента
  final newPosition = currentPosition + (offset * itemHeight);
  
  _scrollController.animateTo(
    newPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}

void _scrollByPage(double factor) {
  final viewportHeight = MediaQuery.of(context).size.height - 200; // Учитываем заголовок и поиск
  final scrollAmount = viewportHeight * factor;
  final newPosition = _scrollController.offset + scrollAmount;
  
  _scrollController.animateTo(
    newPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}

  void _handleBackgroundImageDrop(List<File> files) async {
    if (files.isNotEmpty && (files.first.path.endsWith('.png') || files.first.path.endsWith('.jpg'))) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final bgDir = Directory('${directory.path}/imeyou_pet/widget_backgrounds');
        if (!bgDir.existsSync()) {
          bgDir.createSync(recursive: true);
        }
        
        // Сохраняем изображение
        final newFile = File('${bgDir.path}/cnp_bg${path.extension(files.first.path)}');
        await newFile.writeAsBytes(await files.first.readAsBytes());
        
        // Сохраняем путь в JSON
        final configFile = File('${bgDir.path}/current_cnp_bg.json');
        final configData = {
          'current_bg': newFile.path
        };
        await configFile.writeAsString(json.encode(configData));
        
        setState(() {
          _backgroundImage = newFile;
        });
        
        print('Background saved: ${newFile.path}');
        
      } catch (e) {
        print('Error setting background: $e');
      }
    }
  }

  void _loadBackgroundImage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final bgDir = Directory('${directory.path}/imeyou_pet/widget_backgrounds');
      
      if (bgDir.existsSync()) {
        // Сначала пытаемся загрузить из JSON
        final configFile = File('${bgDir.path}/current_cnp_bg.json');
        if (configFile.existsSync()) {
          final jsonString = await configFile.readAsString();
          final configData = json.decode(jsonString);
          final bgPath = configData['current_bg'];
          
          if (bgPath != null && File(bgPath).existsSync()) {
            setState(() {
              _backgroundImage = File(bgPath);
            });
            print('Background loaded from config: $bgPath');
            return; // Выходим, если нашли в конфиге
          }
        }
        
        // Если JSON нет или путь невалидный, ищем любой подходящий файл
        final files = bgDir.listSync();
        for (var file in files) {
          if (file.path.endsWith('cnp_bg.png') || file.path.endsWith('cnp_bg.jpg')) {
            setState(() {
              _backgroundImage = File(file.path);
            });
            print('Background loaded from fallback: ${file.path}');
            break;
          }
        }
      }
    } catch (e) {
      print('Error loading background: $e');
    }
  }

  void _initializeApp() async {
    try {
      // Инициализация окна
      await windowManager.ensureInitialized();
      await windowManager.setAsFrameless();
      await windowManager.setSize(const Size(400, 700));
      await windowManager.setAlwaysOnTop(true);
      
      // Инициализация директории
      final directory = await getApplicationDocumentsDirectory();
      _copypasteDir = Directory('${directory.path}/copypasted');
      if (!_copypasteDir.existsSync()) {
        _copypasteDir.createSync(recursive: true);
      }
      service = await EncryptionService1.create();
      // Загрузка истории и запуск слушателей
      await _loadClipboardHistory();
      _searchController.addListener(_filterHistory);
      _startFileWatcher();
      _startKeyboardListener();
      _loadBackgroundImage();
      
    } catch (e) {
      print('Error initializing app: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startFileWatcher() {
    _fileWatcher = _copypasteDir.watch(events: FileSystemEvent.all).listen((event) {
      if (event.type == FileSystemEvent.create || event.type == FileSystemEvent.modify) {
        // Задержка для гарантии что файл полностью записан
        Future.delayed(const Duration(milliseconds: 100), () {
          _loadClipboardHistory();
        });
      }
    });
  }

  void _startKeyboardListener() {
    return;
    _keyboardInputTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkKeyboardInput();
    });
  }

  void _checkKeyboardInput() {
    final now = DateTime.now();
    final timeDiff = now.difference(_lastTypedTime).inSeconds;
    
    // Если прошло больше 45 секунд с последнего ввода и есть набранный текст
    if (timeDiff > 45 && _currentTypedText.trim().isNotEmpty) {
      _saveKeyboardInput(_currentTypedText);
      _currentTypedText = '';
    }
  }

  bool _isValidContent(String content) {
    if (content.isEmpty) return false;
    
    // Фильтрация слишком коротких текстов (меньше 3 символов)
    if (content.length < 3) return false;
    
    // Фильтрация только пробелов/переносов строк
    if (content.trim().isEmpty) return false;
    
    // Фильтрация повторяющихся символов (например, "aaaaaaa")
    final regex = RegExp(r'^(.)\1+$');
    if (regex.hasMatch(content)) return false;
    
    // Фильтрация только цифр без букв
    final onlyDigits = RegExp(r'^\d+$');
    if (onlyDigits.hasMatch(content) && content.length < 10) return false;
    
    return true;
  }

  Future<void> _saveKeyboardInput(String text) async {
    if (!_isValidContent(text)) return;
    
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'keyboard_$timestamp.cnp';
      final file = File('${_copypasteDir.path}/$fileName');
      
      final entry = {
        'content': text,
        'timestamp': timestamp,
        'source': 'keyboard',
        'starred': false,
      };
      
      await file.writeAsString(jsonEncode(entry), encoding: utf8);
      print('Keyboard input saved: ${text.length} characters');
    } catch (e) {
      print('Error saving keyboard input: $e');
    }
  }

  Future<void> _saveToClipboardHistory(String text) async {
    if (!_isValidContent(text)) return;
    
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'clipboard_$timestamp.cnp';
      final file = File('${_copypasteDir.path}/$fileName');
      
      final entry = {
        'content': text,
        'timestamp': timestamp,
        'source': 'clipboard',
        'starred': false,
      };
      
      await file.writeAsString(jsonEncode(entry), encoding: utf8);
      print('Clipboard content saved: ${text.length} characters');
    } catch (e) {
      print('Error saving clipboard content: $e');
    }
  }

@override
void dispose() {
  _searchController.dispose();
    _scrollController.removeListener(_onScroll);
  _scrollController.dispose();
  _searchFocusNode.dispose();

  _keyboardInputTimer.cancel();
  _fileWatcher.cancel();
  RawKeyboard.instance.removeListener(_handleKeyEvent);
  RawKeyboard.instance.removeListener(_handleNavigationKeys); // Убираем новый слушатель
  super.dispose();
}


Future<void> _loadClipboardHistory() async {
  try {
    List<Map<String, dynamic>> history = [];
    
    if (_copypasteDir.existsSync()) {
      final files = _copypasteDir.listSync()
        .where((file) => file is File && file.path.endsWith('.cnp'))
        .toList();

      // Сортировка по времени изменения
      files.sort((a, b) {
        final aStat = a.statSync();
        final bStat = b.statSync();
        return bStat.modified.compareTo(aStat.modified);
      });

      for (final file in files.take(100)) {
        try {
          final content = await File(file.path).readAsString(encoding: utf8);
          if( (content.startsWith("{")&& content.endsWith("}"))){continue;} // NON ENCRYPTED JSON --> SKIP
          final decrypted = await service!.decryptData(content); 
          if( !(decrypted.startsWith("{")&& decrypted.endsWith("}"))){continue;} // DECRYPTED IS NOT JSON --> SKIP
          final entry = jsonDecode(decrypted);  
          
          if (entry is Map<String, dynamic>) {
            final textContent = entry['content']?.toString() ?? '';
            String itemType = entry['type'] as String? ?? 'text';
            
            // Автоматически определяем тип для файлов изображений
            if (itemType == 'file') {
              final fileExtension = path.extension(textContent).toLowerCase();
              if (fileExtension == '.png' || fileExtension == '.jpg' || fileExtension == '.jpeg') {
                itemType = 'image';
              }
            }
            
            history.add({
              'content': textContent,
              'timestamp': entry['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
              'length': textContent.length,
              'filePath': file.path,
              'starred': entry['starred'] as bool? ?? false,
              'source': entry['source'] as String? ?? 'clipboard',
              'type': itemType, // Используем обновленный тип
              'file_info': entry['file_info'],
            });
          }
        } catch (e) {
          print('Error reading file ${file.path}: $e');
        }
      }
    }

    setState(() {
      _clipboardHistory = history;
      _filterHistory();
      _isLoading = false;
    });
    
  } catch (e) {
    print('Error loading history: $e');
    setState(() {
      _isLoading = false;
      _clipboardHistory = [];
      _filteredHistory = [];
    });
  }
}

 void _filterHistory() {
  final query = _searchController.text.toLowerCase().trim();
  setState(() {
    if (query.isEmpty) {
      _filteredHistory = _currentTab == 0 
          ? _clipboardHistory 
          : _clipboardHistory.where((item) => item['starred'] == true).toList();
    } else {
      final baseList = _currentTab == 0 
          ? _clipboardHistory 
          : _clipboardHistory.where((item) => item['starred'] == true).toList();
      
      // Разбиваем запрос на отдельные слова
      final queryWords = query.split(RegExp(r'\s+')).where((word) => word.length > 1).toList();
      
      // Если запрос состоит из одного слова, используем простой поиск
      if (queryWords.length <= 1) {
        _filteredHistory = baseList.where((item) {
          final content = item['content']?.toString().toLowerCase() ?? '';
          final type = _getTypeDisplayName(item['type'] as String? ?? 'text').toLowerCase();
          final date = _formatDate(item['timestamp'] as int? ?? 0).toLowerCase();
          final time = _formatTime(item['timestamp'] as int? ?? 0).toLowerCase();
          
          return content.contains(query) || 
                 type.contains(query) || 
                 date.contains(query) || 
                 time.contains(query);
        }).toList();
      } else {
        // Для многокомпонентного запроса используем сложную логику ранжирования
        final List<Map<String, dynamic>> resultsWithScore = [];
        
        for (final item in baseList) {
          final content = item['content']?.toString().toLowerCase() ?? '';
          final type = _getTypeDisplayName(item['type'] as String? ?? 'text').toLowerCase();
          final date = _formatDate(item['timestamp'] as int? ?? 0).toLowerCase();
          final time = _formatTime(item['timestamp'] as int? ?? 0).toLowerCase();
          
          double score = 0.0;
          int foundWords = 0;
          
          // Проверяем каждое слово запроса
          for (final word in queryWords) {
            bool wordFound = false;
            
            // Поиск точного совпадения слова
            final wordVariations = _getWordVariations(word);
            for (final variation in wordVariations) {
              if (content.contains(variation)) {
                score += variation == word ? 3.0 : 2.5; // Чуть меньше баллов за вариации
                wordFound = true;
                break;
              }
            }
            
            // Поиск частичного совпадения (для версий слов)
            if (!wordFound) {
              // Ищем слова, которые начинаются с этого корня
              final wordPattern = RegExp(r'\b' + word);
              if (wordPattern.hasMatch(content)) {
                score += 2.0; // Средний балл за частичное совпадение
                wordFound = true;
              }
            }
            
            // Поиск в других полях
            if (!wordFound) {
              if (type.contains(word) || date.contains(word) || time.contains(word)) {
                score += 1.0; // Низкий балл за совпадение в метаданных
                wordFound = true;
              }
            }
            
            if (wordFound) foundWords++;
          }
          
          // Дополнительные бонусы
          if (foundWords == queryWords.length) {
            score += 5.0; // Бонус за все слова
          }
          
          // Бонус за избранное
          if (item['starred'] == true) {
            score += 2.0;
          }
          
          // Штраф за длинный текст (предпочтение более коротким релевантным результатам)
          final lengthPenalty = content.length > 200 ? content.length / 1000.0 : 0.0;
          score -= lengthPenalty;
          
          // Бонус за точное совпадение всей фразы
          if (content.contains(query)) {
            score += 4.0;
          }
          
          // Бонус за совпадение в начале текста
          if (content.startsWith(query)) {
            score += 3.0;
          }
          
          if (foundWords > 0) {
            resultsWithScore.add({
              'item': item,
              'score': score,
              'foundWords': foundWords,
              'contentLength': content.length,
            });
          }
        }
        
        // Сортируем по релевантности
        resultsWithScore.sort((a, b) {
          final double scoreA = a['score'] as double;
          final double scoreB = b['score'] as double;
          
          // Сначала по баллам (по убыванию)
          if (scoreB > scoreA) return 1;
          if (scoreB < scoreA) return -1;
          
          // Затем по количеству найденных слов (по убыванию)
          final int wordsA = a['foundWords'] as int;
          final int wordsB = b['foundWords'] as int;
          if (wordsB > wordsA) return 1;
          if (wordsB < wordsA) return -1;
          
          // Затем по длине контента (по возрастанию - короткие первыми)
          final int lengthA = a['contentLength'] as int;
          final int lengthB = b['contentLength'] as int;
          return lengthA.compareTo(lengthB);
        });
        
        _filteredHistory = resultsWithScore.map((e) => e['item'] as Map<String, dynamic>).toList();
      }

      // Дополнительная сортировка для избранного (если поиск не многокомпонентный)
      if (queryWords.length <= 1) {
        _filteredHistory.sort((a, b) {
          final aStarred = a['starred'] as bool? ?? false;
          final bStarred = b['starred'] as bool? ?? false;
          
          if (aStarred && !bStarred) return -1;
          if (!aStarred && bStarred) return 1;
          return 0;
        });
      }
    }
  });
}

// Добавьте этот метод в класс
List<String> _getWordVariations(String word) {
  final variations = <String>[];
  
  // Базовое слово
  variations.add(word);
  
  // Простые окончания для русского языка
  if (word.length > 3) {
    if (word.endsWith('а')) {
      variations.add(word.substring(0, word.length - 1)); // маша -> маш
    }
    if (word.endsWith('я')) {
      variations.add(word.substring(0, word.length - 1)); // танцую -> танцу
    }
    if (word.endsWith('о')) {
      variations.add(word.substring(0, word.length - 1)); // яблоко -> яблок
    }
    if (word.endsWith('ы')) {
      variations.add(word.substring(0, word.length - 1)); // яблоки -> яблок
    }
    if (word.endsWith('и')) {
      variations.add(word.substring(0, word.length - 1)); // груши -> груш
    }
  }
  
  return variations;
}
String _getTypeDisplayName(String type) {
  switch (type) {
    case 'file': return '${_locale.get("file")}';
    case 'image_url': return '${_locale.get("image")}';
    case 'url': return '${_locale.get("link")}';
    case 'document_url': return '${_locale.get("docment")}';
    case 'email': return 'Email';
    case 'code': return '${_locale.get("code")}';
    case 'html': return 'HTML';
    case 'keyboard': return '${_locale.get("keyboard")}';
    case 'image': return '${_locale.get("image")}';
    default: return '${_locale.get("text")}';
  }
}

  Color _getTypeBorderColor(String type) {
    switch (type) {
      case 'file': return Colors.orange;
      case 'image_url': return Colors.pink;
      case 'image': return Colors.pink;
      case 'url': return Colors.blue;
      case 'document_url': return Colors.purple;
      case 'email': return Colors.green;
      case 'code': return Colors.cyan;
      case 'html': return Colors.yellow;
      case 'keyboard': return Colors.grey;
      default: return Colors.white;
    }
  }

  Future<void> _copyToClipboard(Map<String, dynamic> item) async {
    try {
      final content = item['content']?.toString() ?? '';
      final type = item['type'] as String? ?? 'text';
      
      if (type == 'file') {
        final file = File(content);
        if (await file.exists()) {
          if (Platform.isWindows) {
            await _copyFileToClipboardWindows(content);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:  Text('${_locale.get("copiedToClipboard_file")}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            await Clipboard.setData(ClipboardData(text: content));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:  Text('${_locale.get("pathCopiedToClipboard")}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          await Clipboard.setData(ClipboardData(text: content));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:  Text('${_locale.get("pathCopiedToClipboard")}'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        await Clipboard.setData(ClipboardData(text: content));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:  Text('${_locale.get("copiedToClipboard")}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error copying to clipboard: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_locale.get("error")}: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _openItem(Map<String, dynamic> item) async {
    try {
      final content = item['content']?.toString() ?? '';
      final type = item['type'] as String? ?? 'text';
      
      if (type == 'url' || type == 'image_url' || type == 'document_url') {
        // Открываем ссылку в браузере
        if (await canLaunch(content)) {
          await launch(content);
        } else {
          throw Exception('Could not launch $content');
        }
      } else if (type == 'file') {
        // Открываем файл
        final file = File(content);
        if (await file.exists()) {
          if (Platform.isWindows) {
            await Process.run('start', ['""', content], runInShell: true);
          } else if (Platform.isMacOS) {
            await Process.run('open', [content]);
          } else if (Platform.isLinux) {
            await Process.run('xdg-open', [content]);
          }
        } else {
          throw Exception('File not found: $content');
        }
      }
    } catch (e) {
      print('Error opening item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка открытия: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _copyFileToClipboardWindows(String filePath) async {
    try {
      final powerShellScript = '''
        Add-Type -AssemblyName System.Windows.Forms
        \$file = Get-Item '$filePath'
        
        if (\$file.Attributes -band [System.IO.FileAttributes]::Directory) {
          [System.Windows.Forms.Clipboard]::SetText('$filePath')
        } else {
          \$collection = New-Object System.Collections.Specialized.StringCollection
          \$collection.Add('$filePath')
          [System.Windows.Forms.Clipboard]::SetFileDropList(\$collection)
        }
      ''';

      final result = await Process.run('powershell', [
        '-NoProfile',
        '-ExecutionPolicy', 
        'Bypass',
        '-Command',
        powerShellScript
      ]);

      if (result.stderr != null && result.stderr.toString().isNotEmpty) {
        print('PowerShell error: ${result.stderr}');
        await Clipboard.setData(ClipboardData(text: filePath));
      }
    } catch (e) {
      print('Error copying file to clipboard: $e');
      await Clipboard.setData(ClipboardData(text: filePath));
    }
  }

  Future<void> _toggleStar(Map<String, dynamic> item) async {
    try {
      final filePath = item['filePath']?.toString();
      if (filePath != null && File(filePath).existsSync()) {
        final currentStarred = item['starred'] as bool? ?? false;
        final newStarred = !currentStarred;
        
        final content = await File(filePath).readAsString(encoding: utf8);
        final entry = jsonDecode(content) as Map<String, dynamic>;
        
        entry['starred'] = newStarred;
          final encrypted = await service!.encryptData(jsonEncode(entry));
        await File(filePath).writeAsString(encrypted, encoding: utf8);
        
        _loadClipboardHistory();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newStarred ? '${_locale.get("addedToFav")}' : '${_locale.get("removedFromFav")}'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error toggling star: $e');
    }
  }

  Future<void> _deleteItem(Map<String, dynamic> item) async {
    try {
      final filePath = item['filePath']?.toString();
      if (filePath != null && File(filePath).existsSync()) {
        await File(filePath).delete();
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
    
    setState(() {
      _clipboardHistory.remove(item);
      _filteredHistory.remove(item);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:  Text('${_locale.get("elementRemoved")}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _clearAllHistory() async {
    try {
      int deletedCount = 0;
      int skippedCount = 0;
      
      if (_copypasteDir.existsSync()) {
        final files = _copypasteDir.listSync()
          .where((file) => file is File && file.path.endsWith('.cnp'))
          .toList();

        for (final file in files) {
          try {
            final content = await File(file.path).readAsString(encoding: utf8);
            final entry = jsonDecode(content) as Map<String, dynamic>;
            
            final isStarred = entry['starred'] as bool? ?? false;
            
            if (isStarred) {
              skippedCount++;
              continue;
            }
            
            await file.delete();
            deletedCount++;
            
          } catch (e) {
            print('Error processing file ${file.path}: $e');
            skippedCount++;
          }
        }
      }

      _loadClipboardHistory();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_locale.get("removedElementsP1")} $deletedCount, ${_locale.get("savedFavsP2")} $skippedCount'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error clearing history: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_locale.get("error")}: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _toggleSelection(Map<String, dynamic> item) {
    final filePath = item['filePath']?.toString() ?? '';
    setState(() {
      if (_selectedItems.contains(filePath)) {
        _selectedItems.remove(filePath);
      } else {
        _selectedItems.add(filePath);
      }
      _showExportOptions = _selectedItems.isNotEmpty;
    });
  }

  bool _isSelected(Map<String, dynamic> item) {
    return _selectedItems.contains(item['filePath']?.toString() ?? '');
  }
Future<void> _executeCompose() async {
  try {
    // Получаем выбранные элементы
    final selectedItems = _clipboardHistory.where(
      (item) => _selectedItems.contains(item['filePath']?.toString() ?? '')
    ).toList();

    if (selectedItems.isEmpty) return;

    // Определяем тип экспорта
    String exportType = _exportMode;
    if (_exportMode == 'auto') {
      exportType = _determineExportType(selectedItems);
    }

    // Выполняем экспорт
    String? resultPath;
    switch (exportType) {
      case 'text':
        resultPath = await _exportAsText(selectedItems);
        break;
      case 'image':
        resultPath = await _exportAsImage(selectedItems);
        break;
      case 'html':
        resultPath = await _exportAsHtml(selectedItems);
        break;
      case 'archive':
        resultPath = await _exportAsArchive(selectedItems);
        break;
      case 'separate':
        resultPath = await _exportAsSeparateFiles(selectedItems);
        break;
    }

    // Очищаем выделение после экспорта
    setState(() {
      _selectedItems.clear();
      _showExportOptions = false;
    });

    // Открываем результат если есть путь
    if (resultPath != null && await File(resultPath).exists()) {
      await _openResultFile(resultPath, exportType);
    }

  } catch (e) {
    print('Error during compose: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("error")}: $e'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

String _determineExportType(List<Map<String, dynamic>> items) {
  final hasImages = items.any((item) => item['type'] == 'image' || item['type'] == 'image_url');
  final hasText = items.any((item) => item['type'] == 'text' || item['type'] == 'code' || item['type'] == 'html');
  final hasFiles = items.any((item) => item['type'] == 'file');
  
  if (hasFiles) return 'archive';
  if (hasImages || hasText) return 'html'; // HTML доступен при наличии и текста и изображений
  if (hasImages) return 'image';
  if (hasText) return 'text';
  return 'archive';
}
 Future<String?> _exportAsText(List<Map<String, dynamic>> items) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/qwa_clipboard_export');
    if (!exportDir.existsSync()) {
      exportDir.createSync(recursive: true);
    }

    final buffer = StringBuffer();
    for (final item in items) {
      if (item['type'] == 'text' || item['type'] == 'code' || item['type'] == 'html') {
        buffer.writeln(item['content']?.toString() ?? '');
        buffer.writeln('---'); // Разделитель
      }
    }

    final content = buffer.toString();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${exportDir.path}/text_export_$timestamp.txt');
    await file.writeAsString(content, encoding: utf8);

    await Clipboard.setData(ClipboardData(text: content));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("textExported")}: ${file.path}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    
    return file.path;
  } catch (e) {
    print('Error exporting text: $e');
    rethrow;
  }
}

Future<String?> _exportAsSeparateFiles(List<Map<String, dynamic>> items) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/qwa_clipboard_export/separate_${DateTime.now().millisecondsSinceEpoch}');
    if (!exportDir.existsSync()) {
      exportDir.createSync(recursive: true);
    }

    for (final item in items) {
      try {
        final content = item['content']?.toString() ?? '';
        final type = item['type'] as String? ?? 'text';
        final timestamp = item['timestamp'] as int? ?? 0;
        final fileInfo = item['file_info'] as Map<String, dynamic>?;
        
        String extension = '.txt';
        String filename = 'item_${items.indexOf(item)}';
        
        switch (type) {
          case 'image':
            // Копируем файл изображения как есть
            final sourceFile = File(content);
            if (await sourceFile.exists()) {
              final originalName = fileInfo?['name']?.toString() ?? path.basename(content);
              final targetFile = File('${exportDir.path}/$originalName');
              await sourceFile.copy(targetFile.path);
              print('Copied image: ${sourceFile.path} -> ${targetFile.path} (${sourceFile.lengthSync()} bytes)');
            }
            break;
            
          case 'file':
            // Копируем файл как есть
            final sourceFile = File(content);
            if (await sourceFile.exists()) {
              final originalName = fileInfo?['name']?.toString() ?? path.basename(content);
              final targetFile = File('${exportDir.path}/$originalName');
              await sourceFile.copy(targetFile.path);
            }
            break;
            
          default:
            // Текстовые данные
            switch (type) {
              case 'code': extension = '.txt'; break;
              case 'html': extension = '.html'; break;
              case 'url': extension = '.url.txt'; break;
            }
            final file = File('${exportDir.path}/$filename$extension');
            await file.writeAsString(content, encoding: utf8);
            break;
        }
      } catch (e) {
        print('Error exporting separate file: $e');
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("filesExported")}: ${exportDir.path}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    
    return exportDir.path;
  } catch (e) {
    print('Error exporting separate files: $e');
    rethrow;
  }
}

Future<String?> _exportAsImage(List<Map<String, dynamic>> items) async {
  try {
    final imageItems = items.where((item) => 
      item['type'] == 'image' || item['type'] == 'image_url'
    ).toList();

    if (imageItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:  Text('${_locale.get("noImagesToExport")}'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      return null;
    }

    // Загружаем все изображения
    final List<img.Image> loadedImages = [];
    final List<String> imageSources = [];

    for (final item in imageItems) {
      try {
        final content = item['content']?.toString() ?? '';
        final type = item['type'] as String? ?? 'text';
        
        img.Image? image;
        
        if (type == 'image_url') {
          // Загрузка по URL
          final response = await http.get(Uri.parse(content));
          if (response.statusCode == 200) {
            image = img.decodeImage(response.bodyBytes);
          }
        } else if (type == 'image') {
          // Загрузка из файла
          final file = File(content);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            image = img.decodeImage(bytes);
          }
        }
        
        if (image != null) {
          loadedImages.add(image);
          imageSources.add(content);
        }
      } catch (e) {
        print('Error loading image: $e');
      }
    }

    if (loadedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:  Text('${_locale.get("unableToLoadImage")}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return null;
    }

    // Анализируем изображения и создаем коллаж
    final img.Image collage = await _createCollage(loadedImages);
    
    // Сохраняем коллаж
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/qwa_clipboard_export');
    if (!exportDir.existsSync()) {
      exportDir.createSync(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputFile = File('${exportDir.path}/collage_$timestamp.png');
    
    // Сохраняем как PNG
    final pngBytes = img.encodePng(collage);
    await outputFile.writeAsBytes(pngBytes);

    // Копируем в буфер обмена
    await _copyImageToClipboard(pngBytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("collageDone")}: ${outputFile.path}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    return outputFile.path;

  } catch (e) {
    print('Error creating image collage: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("error")}: $e'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
    return null;
  }
}

Future<img.Image> _createCollage(List<img.Image> images) async {
  if (images.length == 1) {
    // Если одно изображение - просто возвращаем его
    return images.first;
  }

  // Анализируем размеры и ориентации изображений
  final List<ImageInfo> imageInfos = [];
  int totalWidth = 0;
  int totalHeight = 0;
  bool allLandscape = true;
  bool allPortrait = true;
  bool allSameSize = true;
  int firstWidth = images.first.width;
  int firstHeight = images.first.height;

  for (final image in images) {
    final bool isLandscape = image.width >= image.height;
    final bool isPortrait = image.height > image.width;
    
    imageInfos.add(ImageInfo(
      image: image,
      width: image.width,
      height: image.height,
      isLandscape: isLandscape,
      isPortrait: isPortrait,
      aspectRatio: image.width / image.height
    ));

    allLandscape = allLandscape && isLandscape;
    allPortrait = allPortrait && isPortrait;
    allSameSize = allSameSize && 
                  image.width == firstWidth && 
                  image.height == firstHeight;
  }

  // Определяем стратегию компоновки
  CollageStrategy strategy;
  
  if (allLandscape && allSameSize) {
    // Все изображения альбомные и одинакового размера - горизонтальный ряд
    strategy = _createHorizontalRowStrategy(images, 1920, 1080);
  } else if (allPortrait && allSameSize) {
    // Все изображения портретные и одинакового размера - вертикальная колонка
    strategy = _createVerticalColumnStrategy(images, 1080, 1920);
  } else if (allLandscape) {
    // Все альбомные, но разных размеров - адаптивная сетка
    strategy = _createAdaptiveGridStrategy(images, 1920, 1080, true);
  } else if (allPortrait) {
    // Все портретные, но разных размеров - адаптивная сетка
    strategy = _createAdaptiveGridStrategy(images, 1080, 1920, false);
  } else {
    // Смешанные ориентации - интеллектуальная компоновка
    strategy = _createMixedOrientationStrategy(images, 1920, 1080);
  }

  // Создаем холст
  final canvas = img.Image(
    width: strategy.canvasWidth,
    height: strategy.canvasHeight,
  );

  // Рисуем изображения на холсте
  for (final placement in strategy.placements) {
    final resizedImage = img.copyResize(
      placement.image,
      width: placement.width,
      height: placement.height,
    );
    
    img.compositeImage(
      canvas,
      resizedImage,
      dstX: placement.x,
      dstY: placement.y,
    );
  }

  return canvas;
}

Future<void> _copyImageToClipboard(List<int> imageBytes) async {
  try {
    if (Platform.isWindows) {
      await _copyImageToClipboardWindows(imageBytes);
    } else {
      // Для других платформ пока просто сохраняем путь
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/clipboard_image.png');
      await tempFile.writeAsBytes(imageBytes);
      
      await Clipboard.setData(ClipboardData(text: tempFile.path));
    }
  } catch (e) {
    print('Error copying image to clipboard: $e');
    // Fallback - копируем как текст
    await Clipboard.setData(ClipboardData(text: '${_locale.get("imageMadeButNotCopied")}'));
  }
}

Future<void> _copyImageToClipboardWindows(List<int> imageBytes) async {
  try {
    final powerShellScript = '''
      Add-Type -AssemblyName System.Windows.Forms
      Add-Type -AssemblyName System.Drawing
      
      \$memoryStream = New-Object System.IO.MemoryStream
      \$memoryStream.Write([byte[]] @(${imageBytes.join(',')}), 0, ${imageBytes.length})
      \$memoryStream.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
      
      \$bitmap = [System.Drawing.Bitmap]::FromStream(\$memoryStream)
      [System.Windows.Forms.Clipboard]::SetImage(\$bitmap)
      
      \$bitmap.Dispose()
      \$memoryStream.Dispose()
    ''';

    final result = await Process.run('powershell', [
      '-NoProfile',
      '-ExecutionPolicy', 
      'Bypass',
      '-Command',
      powerShellScript
    ]);

    if (result.stderr != null && result.stderr.toString().isNotEmpty) {
      print('PowerShell error: ${result.stderr}');
      throw Exception('PowerShell execution failed');
    }
  } catch (e) {
    print('Error in Windows image copy: $e');
    rethrow;
  }
}
Future<String?> _exportAsHtml(List<Map<String, dynamic>> items) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/qwa_clipboard_export/html_${DateTime.now().millisecondsSinceEpoch}');
    if (!exportDir.existsSync()) {
      exportDir.createSync(recursive: true);
    }

    final htmlBuffer = StringBuffer();
    htmlBuffer.writeln('<!DOCTYPE html>');
    htmlBuffer.writeln('<html lang="ru">');
    htmlBuffer.writeln('<head>');
    htmlBuffer.writeln('<meta charset="UTF-8">');
    htmlBuffer.writeln('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    htmlBuffer.writeln('<title>QWA Clipboard Export</title>');
    htmlBuffer.writeln(_htmlCss);
    htmlBuffer.writeln('</head>');
    htmlBuffer.writeln('<body>');
    
    htmlBuffer.writeln('<div class="header">');
    htmlBuffer.writeln('<h1>Clipboard Export</h1>');
    htmlBuffer.writeln('<p>Создано: ${DateTime.now()}</p>');
    htmlBuffer.writeln('</div>');

    for (final item in items) {
      final type = item['type'] as String? ?? 'text';
      final content = item['content']?.toString() ?? '';
      final timestamp = item['timestamp'] as int? ?? 0;

      switch (type) {
        case 'text':
        case 'email':
        case 'url':
          htmlBuffer.writeln('<div class="text-block">');
          htmlBuffer.writeln(content);
          htmlBuffer.writeln('<div class="timestamp">${_formatDate(timestamp)} ${_formatTime(timestamp)}</div>');
          htmlBuffer.writeln('</div>');
          break;
        
        case 'code':
        case 'html':
          htmlBuffer.writeln('<div class="code-block">');
          htmlBuffer.writeln(content);
          htmlBuffer.writeln('<div class="timestamp">${_formatDate(timestamp)} ${_formatTime(timestamp)}</div>');
          htmlBuffer.writeln('</div>');
          break;
        
        case 'image':
        case 'image_url':
          htmlBuffer.writeln('<div class="image-block">');
          // Для реальных изображений нужно конвертировать в base64
          htmlBuffer.writeln('<img src="$content" alt="Image">');
          htmlBuffer.writeln('<div class="image-caption">${_formatDate(timestamp)} ${_formatTime(timestamp)}</div>');
          htmlBuffer.writeln('</div>');
          break;
      }
    }

    htmlBuffer.writeln('</body>');
    htmlBuffer.writeln('</html>');

    final htmlFile = File('${exportDir.path}/export.html');
    await htmlFile.writeAsString(htmlBuffer.toString(), encoding: utf8);

    // Копируем HTML в буфер обмена
    await Clipboard.setData(ClipboardData(text: htmlBuffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("htmlExported")}: ${htmlFile.path}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    
    return htmlFile.path;
  } catch (e) {
    print('Error exporting HTML: $e');
    rethrow;
  }
}
Future<String?> _exportAsArchive(List<Map<String, dynamic>> items) async {
  try {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:  Text('${_locale.get("noElementsToArchive")}'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      return null;
    }

    final archive = Archive();
    int addedFiles = 0;

    // Обрабатываем каждый элемент
    for (final item in items) {
      try {
        final content = item['content']?.toString() ?? '';
        final type = item['type'] as String? ?? 'text';
        final timestamp = item['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch;
        final fileInfo = item['file_info'] as Map<String, dynamic>?;

        switch (type) {
          case 'text':
          case 'code':
          case 'html':
          case 'email':
          case 'url':
          case 'document_url':
          case 'image_url':
          case 'keyboard':
            // Текстовые данные
            final extension = _getFileExtension(type);
            final filename = 'text_${items.indexOf(item)}_$timestamp$extension';
            final data = utf8.encode(content);
            archive.addFile(ArchiveFile(filename, data.length, data));
            addedFiles++;
            break;

          case 'image':
            // Локальные изображения - читаем как бинарные данные
            final file = File(content);
            if (await file.exists()) {
              final bytes = await file.readAsBytes();
              final originalName = fileInfo?['name']?.toString() ?? path.basename(content);
              final filename = 'image_${items.indexOf(item)}_$originalName';
              archive.addFile(ArchiveFile(filename, bytes.length, bytes));
              addedFiles++;
              print('Added image to archive: $filename (${bytes.length} bytes)');
            }
            break;

          case 'file':
            // Файлы из файловой системы
            final file = File(content);
            if (await file.exists()) {
              final bytes = await file.readAsBytes();
              final originalName = fileInfo?['name']?.toString() ?? path.basename(content);
              final filename = 'file_${items.indexOf(item)}_$originalName';
              archive.addFile(ArchiveFile(filename, bytes.length, bytes));
              addedFiles++;
              print('Added file to archive: $filename (${bytes.length} bytes)');
            }
            break;

          default:
            // Неизвестный тип - сохраняем как текст
            final filename = 'unknown_${items.indexOf(item)}_$timestamp.txt';
            final data = utf8.encode('Type: $type\nContent: $content');
            archive.addFile(ArchiveFile(filename, data.length, data));
            addedFiles++;
            break;
        }
      } catch (e) {
        print('Error processing item for archive: $e');
      }
    }

    if (addedFiles == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:  Text('${_locale.get("unableToArchive")}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return null;
    }

    // Сохраняем архив
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/qwa_clipboard_export');
    if (!exportDir.existsSync()) {
      exportDir.createSync(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final zipFile = File('${exportDir.path}/archive_$timestamp.zip');
    
    // Кодируем архив в ZIP
    final zipData = ZipEncoder().encode(archive);
    if (zipData != null) {
      await zipFile.writeAsBytes(zipData);
      print('Archive created: ${zipFile.path} (${zipData.length} bytes)');

      // Копируем путь к архиву в буфер обмена
      await Clipboard.setData(ClipboardData(text: zipFile.path));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_locale.get("zipDone")}\n${zipFile.path}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
      
      return zipFile.path;
    } else {
      throw Exception('Failed to encode ZIP archive');
    }

  } catch (e) {
    print('Error creating archive: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("error")}: $e'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
    return null;
  }
}

String _getFileExtension(String type) {
  switch (type) {
    case 'code':
      return '.txt';
    case 'html':
      return '.html';
    case 'url':
    case 'document_url':
    case 'image_url':
      return '.url.txt';
    case 'email':
      return '.email.txt';
    case 'keyboard':
      return '.keyboard.txt';
    default:
      return '.txt';
  }
}
Future<void> _openResultFile(String filePath, String exportType) async {
  try {
    if (exportType == 'html') {
      // Открываем HTML в браузере
      if (await canLaunch(filePath)) {
        await launch(filePath);
      } else {
        // Если не получается открыть как файл, пробуем как file:// URL
        await launch('file://$filePath');
      }
    } else if (exportType == 'text') {
      // Открываем текстовой файл
      if (Platform.isWindows) {
        await Process.run('notepad', [filePath], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', ['-t', filePath]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [filePath]);
      }
    } else if (exportType == 'image') {
      // Открываем изображение в стандартном просмотрщике
      if (Platform.isWindows) {
        await Process.run('start', ['""', filePath], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', [filePath]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [filePath]);
      }
    } else if (exportType == 'archive' || exportType == 'separate') {
      // Открываем папку и выделяем файл/папку
      final directory = path.dirname(filePath);
      if (Platform.isWindows) {
        await Process.run('explorer', ['/select,', filePath], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', ['-R', filePath]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [directory]);
      }
    }
  } catch (e) {
    print('Error opening result file: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("error")}: $e'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

void _ensureDirectoryInArchive(Archive archive, String directoryPath) {
  final parts = directoryPath.split('/');
  String currentPath = '';
  
  for (final part in parts) {
    if (part.isEmpty) continue;
    
    currentPath = currentPath.isEmpty ? part : '$currentPath/$part';
    
    // Проверяем, существует ли уже такая директория
    final exists = archive.files.any((file) => 
      file.name == '$currentPath/' || file.name.startsWith('$currentPath/')
    );
    
    if (!exists) {
      // Добавляем запись директории
      archive.addFile(ArchiveFile('$currentPath/', 0, []));
    }
  }
}

// Дополнительный метод для создания архива с метаданными
Future<void> _exportAsArchiveWithMetadata(List<Map<String, dynamic>> items) async {
  try {
    final archive = Archive();
    int addedFiles = 0;

    // Добавляем файл с метаданными
    final metadata = StringBuffer();
    metadata.writeln('QWA Clipboard Export Archive');
    metadata.writeln('Created: ${DateTime.now()}');
    metadata.writeln('Total items: ${items.length}');
    metadata.writeln('\n=== Items List ===');
    
    for (final item in items) {
      final index = items.indexOf(item);
      final type = item['type'] as String? ?? 'text';
      final timestamp = item['timestamp'] as int? ?? 0;
      final starred = item['starred'] as bool? ?? false;
      
      metadata.writeln('\nItem $index:');
      metadata.writeln('  Type: $type');
      metadata.writeln('  Date: ${_formatDate(timestamp)} ${_formatTime(timestamp)}');
      metadata.writeln('  Starred: $starred');
      metadata.writeln('  Source: ${item['source']}');
      
      if (type == 'file') {
        final fileInfo = item['file_info'] as Map<String, dynamic>?;
        metadata.writeln('  File: ${fileInfo?['name'] ?? item['content']}');
        if (fileInfo?['size'] != null) {
          metadata.writeln('  Size: ${_formatFileSize(fileInfo!['size'])}');
        }
      } else {
        final content = item['content']?.toString() ?? '';
        final preview = content.length > 100 ? 
            '${content.substring(0, 100)}...' : content;
        metadata.writeln('  Preview: $preview');
      }
    }

    final metadataBytes = utf8.encode(metadata.toString());
    archive.addFile(ArchiveFile('metadata.txt', metadataBytes.length, metadataBytes));
    addedFiles++;

    // Добавляем остальные файлы (как в основном методе)
    for (final item in items) {
      try {
        final content = item['content']?.toString() ?? '';
        final type = item['type'] as String? ?? 'text';
        final timestamp = item['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch;
        final fileInfo = item['file_info'] as Map<String, dynamic>?;

        String filename;
        List<int> data;

        switch (type) {
          case 'text':
          case 'code':
          case 'html':
          case 'email':
          case 'url':
          case 'document_url':
          case 'image_url':
          case 'keyboard':
            final extension = _getFileExtension(type);
            filename = 'items/item_${items.indexOf(item)}$extension';
            data = utf8.encode(content);
            break;

          case 'image':
            final file = File(content);
            if (await file.exists()) {
              data = await file.readAsBytes();
              final originalName = fileInfo?['name']?.toString() ?? path.basename(content);
              filename = 'images/$originalName';
            } else {
              continue;
            }
            break;

          case 'file':
            final file = File(content);
            if (await file.exists()) {
              data = await file.readAsBytes();
              final originalName = fileInfo?['name']?.toString() ?? path.basename(content);
              filename = 'files/$originalName';
            } else {
              continue;
            }
            break;

          default:
            filename = 'unknown/item_${items.indexOf(item)}.txt';
            data = utf8.encode('Type: $type\nContent: $content');
            break;
        }

        // Создаем директории если нужно
        final dirPath = path.dirname(filename);
        if (dirPath.isNotEmpty && dirPath != '.') {
          _ensureDirectoryInArchive(archive, dirPath);
        }

        archive.addFile(ArchiveFile(filename, data.length, data));
        addedFiles++;

      } catch (e) {
        print('Error processing item for archive: $e');
      }
    }

    if (addedFiles == 0) {
      throw Exception('No files were added to archive');
    }

    // Сохраняем архив
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/qwa_clipboard_export');
    if (!exportDir.existsSync()) {
      exportDir.createSync(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final zipFile = File('${exportDir.path}/archive_${timestamp}_with_metadata.zip');
    
    final zipData = ZipEncoder().encode(archive);
    if (zipData != null) {
      await zipFile.writeAsBytes(zipData);
      await Clipboard.setData(ClipboardData(text: zipFile.path));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_locale.get("zipDone")}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    }

  } catch (e) {
    print('Error creating archive with metadata: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_locale.get("error")}: $e'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

String _formatFileSize(dynamic size) {
  try {
    final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
    if (bytes == 0) return '0 B';
    
    const units = ['B', 'KB', 'MB', 'GB'];
    var unitIndex = 0;
    double value = bytes.toDouble();
    
    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }
    
    return '${value.toStringAsFixed(1)} ${units[unitIndex]}';
  } catch (e) {
    return 'Unknown';
  }
}
Widget _buildHistoryItem(Map<String, dynamic> item, int index) {
  // Получаем видимые элементы для вычисления относительного индекса
  final visibleItems = _getVisibleItemsSimple();
  final visibleIndex = visibleItems.indexOf(item);
  
  return HistoryItemWidget(
    item: item,
    index: visibleIndex, // Используем индекс в видимой области
    isSelected: _isSelected(item),
    onCopy: () => _copyToClipboard(item),
    onLongPress: () {
      final type = item['type'] as String? ?? 'text';
      if (type == 'text' || type == 'code') {
        setState(() {
          _expandedItem = item;
        });
      } else {
        _openItem(item);
      }
    },
    onToggleSelection: () => _toggleSelection(item),
    onToggleStar: () => _toggleStar(item),
    onDelete: () => _deleteItem(item),
    showExportOptions: _showExportOptions,
  );
}

// Вспомогательный метод для получения файла изображения
Future<File> _getImageFile(String content, Map<String, dynamic>? fileInfo) async {
  try {
    final file = File(content);
    if (await file.exists()) {
      return file;
    } else {
      // Если файл не найден, создаем временный файл из base64 или других данных
      throw Exception('File not found');
    }
  } catch (e) {
    throw Exception('Failed to load image: $e');
  }
}

  Widget _buildExpandedView() {
    if (_expandedItem == null) return const SizedBox.shrink();

    final content = _expandedItem!['content']?.toString() ?? '';
    final timestamp = _expandedItem!['timestamp'] as int? ?? 0;
    final type = _expandedItem!['type'] as String? ?? 'text';

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.9),
        child: Column(
          children: [
            // Заголовок
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A).withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _expandedItem = null;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    type == 'code' ? '${_locale.get("viewCode")}' : '${_locale.get("fullText")}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_formatDate(timestamp)} ${_formatTime(timestamp)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            // Контент
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: type == 'code' 
                      ? SelectableText(
                          content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Monospace',
                          ),
                        )
                      : SelectableText(
                          content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ),
            // Кнопки
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _copyToClipboard(_expandedItem!),
                      child:  Text('${_locale.get("copy")}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _expandedItem = null;
                        });
                      },
                      child:  Text('${_locale.get("close")}'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildSearchField() {
  return Container(
    padding: const EdgeInsets.all(16),
    color: const Color(0xFF1A1A1A).withOpacity(0.7),
    child: TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: '${_locale.get("search")}',
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF2B2B2B).withOpacity(0.8),
        prefixIcon: const Icon(Icons.search, color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
  );
}
  Widget _buildHeader() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          // Кнопка Compose
          if (_selectedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _executeCompose,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.get_app_outlined, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          // Кнопка Clear Selection
          if (_selectedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedItems.clear();
                      _showExportOptions = false;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.clear, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          // Кнопка Clear All
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _clearAllHistory,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_forever, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
          const Spacer(),
          // Заголовок
          Text(
            _currentTab == 0 ? '📋 ${_locale.get("clipboa rdHistory")}' : '⭐ ${_locale.get("favorite")}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Кнопка закрытия
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => windowManager.close(),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFF1A1A1A).withOpacity(0.8),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: _currentTab == 0 ? const Color(0xFF2B2B2B).withOpacity(0.8) : Colors.transparent,
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                setState(() {
                  _currentTab = 0;
                  _filterHistory();
                });
              },
              child: Text(
                '${_locale.get("all")}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: _currentTab == 1 ? const Color(0xFF2B2B2B).withOpacity(0.8) : Colors.transparent,
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                setState(() {
                  _currentTab = 1;
                  _filterHistory();
                });
              },
              child: Text(
                '${_locale.get("favorite")}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
Widget _buildExportOptions() {
  if (!_showExportOptions) return const SizedBox.shrink();

  final selectedItems = _clipboardHistory.where(
    (item) => _selectedItems.contains(item['filePath']?.toString() ?? '')
  ).toList();

  final hasImages = selectedItems.any((item) => item['type'] == 'image' || item['type'] == 'image_url');
  final hasText = selectedItems.any((item) => item['type'] == 'text' || item['type'] == 'code' || item['type'] == 'html');
  final hasFiles = selectedItems.any((item) => item['type'] == 'file');

  return Container(
    height: 60, // Фиксированная высота
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    color: const Color(0xFF1A1A1A).withOpacity(0.9),
    child: Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildExportOption('simple', 'auto', true, Colors.grey),
                const SizedBox(width: 6),
                if (hasImages) _buildExportOption('IMG', 'image', hasImages, Colors.pink),
                if (hasImages) const SizedBox(width: 6),
                if (hasText) _buildExportOption('TXT', 'text', hasText, Colors.green),
                if (hasText) const SizedBox(width: 6),
                if (hasImages || hasText) _buildExportOption('WEB', 'html', hasImages || hasText, Colors.blue),
                if (hasImages || hasText) const SizedBox(width: 6),
                if (hasFiles) _buildExportOption('ZIP', 'archive', hasFiles, Colors.orange),
                if (hasFiles) const SizedBox(width: 6),
                _buildExportOption('Plain', 'separate', true, Colors.purple),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Кнопка Process
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _executeCompose,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Process',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildExportOption(String label, String value, bool enabled, Color color) {
  final isSelected = _exportMode == value;
  return FilterChip(
    label: Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontSize: 9, // Уменьшенный шрифт
      ),
    ),
    selected: isSelected,
    onSelected: enabled ? (selected) {
      setState(() {
        _exportMode = value;
      });
    } : null,
    backgroundColor:  Colors.grey[600],
    selectedColor: color,
    checkmarkColor: Colors.white,
    disabledColor: Colors.grey[600],
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

  Widget _buildContent() {
  if (_isLoading) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            '${_locale.get("loadingHistory")}...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  if (_filteredHistory.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _currentTab == 0 ? Icons.content_paste : Icons.star,
            size: 64, 
            color: Colors.white54
          ),
          const SizedBox(height: 16),
          Text(
            _clipboardHistory.isEmpty 
                ? '${_locale.get("emptyHistory")}'
                : _currentTab == 1 
                  ? '${_locale.get("noFavElements")}'
                  : '${_locale.get("nothingFound")}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            _clipboardHistory.isEmpty
                ? '${_locale.get("copySomeText")}'
                : '${_locale.get("imageMadeButNotCopied")}',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  return ListView.builder(
    controller: _scrollController, // Добавляем контроллер прокрутки
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: _filteredHistory.length,
    itemBuilder: (context, index) {
      return _buildHistoryItem(_filteredHistory[index], index);
    },
  );
}

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Background
            if (_backgroundImage != null)
              Positioned.fill(
                child: Image.file(
                  _backgroundImage!,
                  fit: BoxFit.cover,
                ),
              ),
            
            // Main content
            Container(
              width: 400,
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.only(right: 0),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2B2B).withOpacity(0.12),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildTabBar(),
                  _buildSearchField(),
                  _buildExportOptions(),
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
            ),

            // Expanded view
            if (_expandedItem != null)
              _buildExpandedView(),
          ],
        ),
      ),
    );
  }
}
class HistoryItemWidget extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index; // Добавляем индекс
  final bool isSelected;
  final VoidCallback onCopy;
  final VoidCallback onLongPress;
  final VoidCallback onToggleSelection;
  final VoidCallback onToggleStar;
  final VoidCallback onDelete;
  final bool showExportOptions;

  const HistoryItemWidget({
    Key? key,
    required this.item,
    required this.index,
    required this.isSelected,
    required this.onCopy,
    required this.onLongPress,
    required this.onToggleSelection,
    required this.onToggleStar,
    required this.onDelete,
    required this.showExportOptions,
  }) : super(key: key);

  @override
  State<HistoryItemWidget> createState() => _HistoryItemWidgetState();
}

class _HistoryItemWidgetState extends State<HistoryItemWidget> {
  bool _isHovered = false;
@override
Widget build(BuildContext context) {
  final item = widget.item;
  final content = item['content']?.toString() ?? '';
  final timestamp = item['timestamp'] as int? ?? 0;
  final isStarred = item['starred'] as bool? ?? false;
  final type = item['type'] as String? ?? 'text';
  final fileInfo = item['file_info'] as Map<String, dynamic>?;
  final isSelected = widget.isSelected;
  final borderColor = _getTypeBorderColor(type);
  
  String displayText;
  String typeText = _getTypeDisplayName(type);
  IconData leadingIcon;
  Color backgroundColor = const Color(0xFF2B2B2B).withOpacity(0.8);
  
  // Переменные для превью изображения
  Widget? imagePreview;
  bool showImagePreview = false;
  bool isImageFile = false;
  
  switch (type) {
    case 'file':
      final fileName = fileInfo?['name']?.toString() ?? path.basename(content);
      displayText = fileName;
      leadingIcon = fileInfo?['is_directory'] as bool? ?? false ? Icons.folder : Icons.insert_drive_file;
      
      // Проверяем, является ли файл изображением
      final fileExtension = path.extension(content).toLowerCase();
      if (fileExtension == '.png' || fileExtension == '.jpg' || fileExtension == '.jpeg') {
        isImageFile = true;
        showImagePreview = true;
        typeText = 'Image';
        leadingIcon = Icons.image;
        
        // Создаем превью для файла изображения
        imagePreview = Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[800],
          ),
          child: FutureBuilder<File>(
            future: Future.value(File(content)),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 50, color: Colors.white54);
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.broken_image, size: 50, color: Colors.white54);
              } else {
                return Center(child: CircularProgressIndicator(color: Colors.white54));
              }
            },
          ),
        );
      }
      break;
    case 'image_url':
    case 'image':
      displayText = type == 'image' ? 'Image: ${fileInfo?['name'] ?? 'From Clipboard'}' : 'Image URL: $content';
      leadingIcon = Icons.image;
      showImagePreview = true;
      
      // Создаем превью для изображения
      if (type == 'image_url') {
        // Для URL изображения
        imagePreview = Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[800],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              content,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 50, color: Colors.white54);
              },
            ),
          ),
        );
      } else if (type == 'image') {
        // Для локального изображения
        imagePreview = Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[800],
          ),
          child: FutureBuilder<File>(
            future: _getImageFile(content, fileInfo),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 50, color: Colors.white54);
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.broken_image, size: 50, color: Colors.white54);
              } else {
                return Center(child: CircularProgressIndicator(color: Colors.white54));
              }
            },
          ),
        );
      }
      break;
    case 'url':
      displayText = content.length > 100 ? '${content.substring(0, 100)}...' : content;
      leadingIcon = Icons.link;
      break;
    case 'document_url':
      displayText = content.length > 100 ? '${content.substring(0, 100)}...' : content;
      leadingIcon = Icons.description;
      break;
    case 'email':
      displayText = content;
      leadingIcon = Icons.email;
      break;
    case 'code':
      displayText = content.length > 100 ? '${content.substring(0, 100)}...' : content;
      leadingIcon = Icons.code;
      break;
    case 'html':
      displayText = content.length > 100 ? '${content.substring(0, 100)}...' : content;
      leadingIcon = Icons.web;
      break;
    default:
      displayText = content.length > 100 ? '${content.substring(0, 100)}...' : content;
      leadingIcon = Icons.text_fields;
      break;
  }

  return MouseRegion(
    onEnter: (_) => setState(() => _isHovered = true),
    onExit: (_) => setState(() => _isHovered = false),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Stack(
        children: [
          GestureDetector(
            onTap: widget.onCopy,
            onLongPress: widget.onLongPress,
            child: Card(
              color: backgroundColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? Colors.blue : borderColor,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Иконка и тип
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey[700],
                          radius: 20,
                          child: Icon(
                            leadingIcon,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          typeText,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Контент
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showImagePreview && imagePreview != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imagePreview,
                                const SizedBox(height: 8),
                                Text(
                                  isImageFile ? 'Image File: ${path.basename(content)}' : displayText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          else
                            Text(
                              displayText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 4),
                          Text(
                            '${_formatDate(timestamp)} ${_formatTime(timestamp)} • ${content.length} символов',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Кнопка выбора для compose (видна при hover или если выбрана)
          if (_isHovered || isSelected)
            Positioned(
              top: 8,
              left: 8,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: widget.onToggleSelection,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.black.withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: isSelected 
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
          
          // Кнопки звездочки и удаления (видны только при hover)
          if (_isHovered)
            Positioned(
              top: 8,
              right: 8,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Звездочка (видна всегда если избранное, и при hover)
                    GestureDetector(
                      onTap: widget.onToggleStar,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isStarred ? Icons.star : Icons.star_border,
                          color: isStarred ? Colors.amber : Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Крестик (виден только при hover)
                    GestureDetector(
                      onTap: widget.onDelete,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Отображение горячих клавиш (добавьте этот блок)
         Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.index >= 0 ? 'Ctrl+${widget.index < 9 ? widget.index + 1 : 0}' : '',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ),
        ),
        ],
      ),
    ),
  );
}
  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'file': return 'Файл';
      case 'image_url': return 'Изображение';
      case 'url': return 'Ссылка';
      case 'document_url': return 'Документ';
      case 'email': return 'Email';
      case 'code': return 'Код';
      case 'html': return 'HTML';
      case 'keyboard': return 'Клавиатура';
      case 'image': return 'Изображение';
      default: return 'Текст';
    }
  }

  Color _getTypeBorderColor(String type) {
    switch (type) {
      case 'file': return Colors.orange;
      case 'image_url': return Colors.pink;
      case 'image': return Colors.pink;
      case 'url': return Colors.blue;
      case 'document_url': return Colors.purple;
      case 'email': return Colors.green;
      case 'code': return Colors.cyan;
      case 'html': return Colors.yellow;
      case 'keyboard': return Colors.grey;
      default: return Colors.white;
    }
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<File> _getImageFile(String content, Map<String, dynamic>? fileInfo) async {
    try {
      final file = File(content);
      if (await file.exists()) {
        return file;
      } else {
        throw Exception('File not found');
      }
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }
}


class ArrowPainter extends CustomPainter {
  final List<Arrow> arrows;
  final Offset? arrowStart;
  final Offset? currentArrowEnd;
  
  ArrowPainter(this.arrows, {this.arrowStart, this.currentArrowEnd});
  
  @override
  void paint(Canvas canvas, Size size) {
    // Рисуем сохраненные стрелки
    for (final arrow in arrows) {
      _drawArrow(canvas, arrow.start, arrow.end);
    }
    
    // Рисуем предварительный просмотр текущей стрелки
    if (arrowStart != null && currentArrowEnd != null) {
      _drawArrow(canvas, arrowStart!, currentArrowEnd!, isPreview: true);
    }
  }
  
  void _drawArrow(Canvas canvas, Offset start, Offset end, {bool isPreview = false}) {
    final paint = Paint()
      ..color = isPreview ? Colors.red.withOpacity(0.7) : Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
    
    // Рисуем наконечник стрелки только для завершенных стрелок
    if (!isPreview) {
      final angle = (end - start).direction;
      const arrowSize = 8.0;
      
      final path = Path()
        ..moveTo(end.dx, end.dy)
        ..lineTo(
          end.dx - arrowSize * cos(angle - pi / 6),
          end.dy - arrowSize * sin(angle - pi / 6),
        )
        ..lineTo(
          end.dx - arrowSize * cos(angle + pi / 6),
          end.dy - arrowSize * sin(angle + pi / 6),
        )
        ..close();
      
      canvas.drawPath(path, paint..style = PaintingStyle.fill);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
/// Декодер для CP1251
class Windows1251Decoder extends Converter<List<int>, String> {
  const Windows1251Decoder();
  static const _cp1251 = [
    'Ѓ','Ђ','Ѓ','ѓ','„','…','†','‡','€','‰','Љ','‹','Њ','Ќ','Ћ','Џ',
    'ђ','‘','’','“','”','•','–','—','','™','љ','›','њ','ќ','ћ','џ',
    ' ','Ў','ў','Ј','¤','Ґ','¦','§','Ё','©','Є','«','¬','­','®','Ї',
    '°','±','І','і','ґ','µ','¶','·','ё','№','є','»','ј','Ѕ','ѕ','ї',
    'А','Б','В','Г','Д','Е','Ж','З','И','Й','К','Л','М','Н','О','П',
    'Р','С','Т','У','Ф','Х','Ц','Ч','Ш','Щ','Ъ','Ы','Ь','Э','Ю','Я',
    'а','б','в','г','д','е','ж','з','и','й','к','л','м','н','о','п',
    'р','с','т','у','ф','х','ц','ч','ш','щ','ъ','ы','ь','э','ю','я'
  ];

  @override
  String convert(List<int> input) {
    final sb = StringBuffer();
    for (final b in input) {
      if (b >= 0xC0) {
        sb.write(_cp1251[b - 0xC0 + 64]);
      } else {
        sb.writeCharCode(b);
      }
    }
    return sb.toString();
  }
}

String _fixEncoding(String text) {
  try {
    // Если текст содержит символы неправильной кодировки, пробуем конвертировать
    if (text.contains('Р') && text.contains('С')) {
      // Пробуем конвертировать из CP1251/Windows-1251 в UTF-8
      final bytes = latin1.encode(text);
      return utf8.decode(bytes, allowMalformed: true);
    }
    return text;
  } catch (e) {
    return text;
  }
}

class Arrow {
  final Offset start;
  final Offset end;
  
  Arrow(this.start, this.end);
}

class ScreenshotApp extends StatelessWidget {
  const ScreenshotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Скриншот модуль',
      theme: ThemeData.dark(),
      home: ScreenshotScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScreenshotScreen extends StatefulWidget {
  const ScreenshotScreen({Key? key}) : super(key: key);

  @override
  _ScreenshotScreenState createState() => _ScreenshotScreenState();
}

class _ScreenshotScreenState extends State<ScreenshotScreen> with WindowListener {
  Uint8List? _screenshotData;
  Offset _startOffset = Offset.zero;
  Offset _currentOffset = Offset.zero;
  bool _isSelecting = false;
  final TextEditingController _textController = TextEditingController();
  bool _isProcessing = false;
  Rect? _selectedRegion;
  bool _showTextInput = false;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _screenshotKey = GlobalKey();
  final GlobalKey _globalKey = GlobalKey(); // Добавляем GlobalKey
  List<Arrow> _arrows = []; // Список стрелок
final List<List<Arrow>> _arrowHistory = []; // История для undo
Offset? _currentArrowEnd; 
// Добавьте эти поля в класс State
Offset _selectionStart = Offset.zero;
Offset _selectionEnd = Offset.zero;
String _recognizedTextFromScreenshot ="";
final _httpClient = http.Client();
String _defaultLanguage = 'ru'; // Русский по умолчанию
Localization _locale = Localization();
  @override
  void initState() {
    super.initState();
    _locale.init();
    windowManager.addListener(this);
    _initializeScreenshot();
    _setupKeyboardListener();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

void _setupKeyboardListener() {
  RawKeyboard.instance.addListener((RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final isControlPressed = event.isControlPressed;
      
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        windowManager.close();
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyZ) {
        _undoArrow();
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyS) {
        _copyScreenshotToClipboard();
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyX) {
        _createMemeScreenshot();
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyC) {
        _copyTextAndClose(); // Обновлено
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyQ) {
        _translateTextToDefaultLanguage(); // Обновлено
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyW) {
        _translateTextToEnglishLanguage(); // Обновлено
      }
    }
  });
}
Future<void> _copyTextAndClose() async {
  final text = _textController.text.trim();
  if (text.isNotEmpty) {
    await Clipboard.setData(ClipboardData(text: text));
    _showMessage('Текст скопирован в буфер');
    Future.delayed(Duration(milliseconds: 500), () {
      windowManager.close();
    });
  } else {
    _showMessage('${_locale.get("notFoundTextForCopy")}');
  }
}


Future<void> _translateTextToDefaultLanguage() async {
  await _translateText(_defaultLanguage);
}

Future<void> _translateTextToEnglishLanguage() async {
  await _translateText('en');
}

Future<void> _translateText(String targetLanguage) async {
  final text = _textController.text.trim();
  if (text.isEmpty) {
    _showMessage('${_locale.get("noTextForTranslate")}');
    return;
  }

  try {
    setState(() {
      _isProcessing = true;
    });

    // Определяем исходный язык
    final sourceLanguage = await _detectLanguage(text);
    
    // Если исходный язык уже целевой - не переводим
    if (sourceLanguage == targetLanguage) {
      _showMessage('${_locale.get("textAlreadyTranslated")}');
      return;
    }

    // Пробуем разные API переводчиков
    String translatedText = await _translateWithLibreTranslate(text, sourceLanguage, targetLanguage);
    
    if (translatedText.isEmpty) {
      translatedText = await _translateWithMyMemory(text, sourceLanguage, targetLanguage);
    }

    if (translatedText.isNotEmpty) {
      setState(() {
        _textController.text = translatedText;
      });
      _showMessage('${_locale.get("textTranslated")}');
    } else {
      _showMessage('${_locale.get("translationError")}');
    }
    
  } catch (e) {
    _showMessage('${_locale.get("error")}: $e');
  } finally {
    setState(() {
      _isProcessing = false;
    });
  }
}

// Бесплатный API LibreTranslate
Future<String> _translateWithLibreTranslate(String text, String from, String to) async {
  try {
    final response = await _httpClient.post(
      Uri.parse('https://libretranslate.de/translate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'source': from,
        'target': to,
        'format': 'text'
      }),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['translatedText'] ?? '';
    }
  } catch (e) {
    print('LibreTranslate error: $e');
  }
  return '';
}

// Резервный API MyMemory
Future<String> _translateWithMyMemory(String text, String from, String to) async {
  try {
    final response = await _httpClient.get(
      Uri.parse('https://api.mymemory.translated.net/get?'
          'q=${Uri.encodeComponent(text)}&'
          'langpair=$from|$to'),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['responseData']['translatedText'] ?? '';
    }
  } catch (e) {
    print('MyMemory error: $e');
  }
  return '';
}

Future<String> _detectLanguage(String text) async {
  try {
    // Простая эвристика для определения языка
    return _detectLanguageBasic(text);
    
    // Для более точного определения можно использовать API (раскомментировать при необходимости)
    // return await _detectLanguageWithAPI(text);
  } catch (e) {
    return _detectLanguageBasic(text);
  }
}

// API определение языка (раскомментировать при необходимости)
/*
Future<String> _detectLanguageWithAPI(String text) async {
  try {
    final response = await _httpClient.post(
      Uri.parse('https://libretranslate.de/detect'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'q': text}),
    ).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['language'] ?? 'en';
      }
    }
  } catch (e) {
    print('Language detection API error: $e');
  }
  return _detectLanguageBasic(text);
}
*/

String _detectLanguageBasic(String text) {
  // Улучшенная эвристика для определения языка
  final russianRegex = RegExp(r'[а-яА-ЯёЁ]');
  final englishRegex = RegExp(r'[a-zA-Z]');
  final koreanRegex = RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]');
  final chineseRegex = RegExp(r'[\u4e00-\u9fff]');
  final japaneseRegex = RegExp(r'[\u3040-\u309F\u30A0-\u30FF]');
  
  // Подсчет символов разных языков
  int russianCount = russianRegex.allMatches(text).length;
  int englishCount = englishRegex.allMatches(text).length;
  int koreanCount = koreanRegex.allMatches(text).length;
  int chineseCount = chineseRegex.allMatches(text).length;
  int japaneseCount = japaneseRegex.allMatches(text).length;
  
  // Определяем язык по преобладающим символам
  if (russianCount > 0 && russianCount > englishCount) return 'ru';
  if (koreanCount > 0) return 'ko';
  if (chineseCount > 0) return 'zh';
  if (japaneseCount > 0) return 'ja';
  if (englishCount > 0) return 'en';
  
  return 'en'; // По умолчанию английский
}


  Future<void> _initializeScreenshot() async {
    try {
      // Сначала скрываем окно, делаем скриншот, потом показываем
      
      
      final screenshot = await _takeRealScreenshot();
      if (screenshot != null) {
        setState(() {
          _screenshotData = screenshot;
        });
        
        // Показываем поверх скриншота
        await windowManager.show();
        await windowManager.focus();
        await windowManager.setAlwaysOnTop(true);
        await windowManager.setFullScreen(true);
      }
    } catch (e) {
      print('Ошибка инициализации скриншота: $e');
      await windowManager.show();
      await windowManager.focus();
    }
  }

  Future<Uint8List?> _takeRealScreenshot() async {
    return takeScreen();
  }

  Future<Uint8List?> takeScreen() async {
    try {
      // Using platform channels to take screenshot
      const channel = MethodChannel('screenshot_channel');
      final result = await channel.invokeMethod('takeScreenshot');
      if (result != null && result is Uint8List) {
        return result;
      }
      return null;
    } catch (e) {
      print('Ошибка скриншота: $e');
      return _takeScreenshotFallback();
    }
  }

  Future<Uint8List?> _takeScreenshotFallback() async {
    try {
      // Alternative method using screenshot package
      // You'll need to implement this based on your platform
      return null;
    } catch (e) {
      print('Fallback screenshot failed: $e');
      return null;
    }
  }



Future<void> _writeTextLog(String message) async {
  try {
    final documentsDir = await getApplicationDocumentsDirectory();
    final logFile = File('${documentsDir.path}/log_decode_text.log');
    final timestamp = DateTime.now().toString();
    final logMessage = '[$timestamp] $message\n';
    await logFile.writeAsString(logMessage, mode: FileMode.append);
    if (kDebugMode) print(message);
  } catch (e) {
    if (kDebugMode) print('Ошибка записи лога: $e');
  }
}
Future<String> _recognizeTextFromBytes(Uint8List imageData) async {
  await _writeTextLog('=== НАЧАЛО РАСПОЗНАВАНИЯ ТЕКСТА ===');
  await _writeTextLog('Размер изображения: ${imageData.length} байт');
  
  // Проверяем установлен ли Tesseract в системе
  final isTesseractAvailable = await _isTesseractInstalled();
  
  if (!isTesseractAvailable) {
    await _writeTextLog('Tesseract не установлен в системе');
    return _getTesseractNotInstalledMessage(imageData);
  }
  
  // Если Tesseract установлен, используем его
  return await _useSystemTesseract(imageData);
}

Future<bool> _isTesseractInstalled() async {
  try {
    await _writeTextLog('Проверка установки Tesseract...');
    
    final result = await Process.run('tesseract', ['--version']);
    
    await _writeTextLog('Код выхода: ${result.exitCode}');
    await _writeTextLog('Stdout: ${result.stdout}');
    
    return result.exitCode == 0;
    
  } catch (e) {
    await _writeTextLog('Tesseract не найден: $e');
    return false;
  }
}


Future<String> _useSystemTesseract(Uint8List imageData) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/ocr_input_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(imageData);

    await _writeTextLog('Запуск системного Tesseract...');

    final process = await Process.start(
      'tesseract',
      [
        filePath,
        'stdout',
        '-l', 'rus+eng',
        '--psm', '6',
        '--oem', '3',
      ],
      runInShell: true,
      environment: {
        'LANG': 'ru_RU.UTF-8',
        'LC_ALL': 'ru_RU.UTF-8',
      },
    );

    // читаем байты, не полагаясь на авто-декод
    final stdoutBytes = await process.stdout.fold<List<int>>([], (a, b) => a..addAll(b));
    final stderrBytes = await process.stderr.fold<List<int>>([], (a, b) => a..addAll(b));
    final exitCode = await process.exitCode;

    await file.delete();

    // Пробуем декодировать как UTF-8, если не получается — CP1251
    String decodeBytes(List<int> bytes) {
      try {
        return utf8.decode(bytes);
      } catch (_) {
        return const Windows1251Decoder().convert(bytes);
      }
    }

    final recognizedText = decodeBytes(stdoutBytes).trim();
    final stderrText = decodeBytes(stderrBytes);

    if (exitCode == 0) {
      await _writeTextLog('Tesseract распознал: ${recognizedText.length} символов');
      await _writeTextLog('Текст: "$recognizedText"');
      if (recognizedText.isNotEmpty) {
        setState(() {
         _recognizedTextFromScreenshot=_cleanRecognizedText(recognizedText);
      });
       
        return _cleanRecognizedText(_recognizedTextFromScreenshot);
      } else {
        return 'Текст не распознан. Попробуйте выделить область с более четким текстом.';
      }
    } else {
      await _writeTextLog('Ошибка Tesseract. Exit code: $exitCode');
      await _writeTextLog('Stderr: $stderrText');
      return 'Ошибка Tesseract: $stderrText';
    }
  } on TimeoutException catch (e) {
    await _writeTextLog('Таймаут Tesseract: $e');
    return 'Таймаут: Tesseract не ответил за 15 секунд';
  } catch (e) {
    await _writeTextLog('Ошибка вызова Tesseract: $e');
    return 'Ошибка вызова Tesseract: $e';
  }
}

String _cleanRecognizedText(String text) {
  // Очищаем текст от лишних пробелов и пустых строк
  text = text.trim();
  
  // Удаляем специальные символы которые могут быть мусором
  text = text.replaceAll(RegExp(r'[^\w\sа-яА-ЯёЁ.,!?;:()\\/_-]'), '');
  
  // Заменяем множественные пробелы на одинарные
  text = text.replaceAll(RegExp(r'\s+'), ' ');
  
  // Удаляем строки состоящие только из символов пунктуации
  final lines = text.split('\n');
  final cleanedLines = lines.where((line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return false;
    return RegExp(r'[a-zA-Zа-яА-Я0-9]').hasMatch(trimmed);
  }).toList();
  
  return cleanedLines.join('\n').trim();
}

Future<String> _getTesseractNotInstalledMessage(Uint8List imageData) async {
  // Сохраняем изображение для ручного анализа
  final documentsDir = await getApplicationDocumentsDirectory();
  final debugFilePath = '${documentsDir.path}/screenshot_area_${DateTime.now().millisecondsSinceEpoch}.png';
  final debugFile = File(debugFilePath);
  await debugFile.writeAsBytes(imageData);
  
  // Получаем информацию об изображении
  String imageInfo = 'Не удалось получить информацию об изображении';
  try {
    final codec = await ui.instantiateImageCodec(imageData);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    imageInfo = '${image.width}×${image.height} пикселей';
  } catch (e) {
    imageInfo = 'Ошибка анализа: $e';
  }

  return '''
🔍 ${_locale.get("TesseractError")}
''';
}
  Future<void> _processSelectedRegion(Rect region) async {
    if (_screenshotData == null) return;

    try {
      setState(() {
        _isProcessing = true;
      });

      print('Обработка области: $region');

      // Вырезаем область из скриншота
      final croppedImage = await _cropImageRegion(_screenshotData!, region);
      if (croppedImage == null) {
        _showMessage('${_locale.get("error")}');
        return;
      }

      // Пытаемся распознать QR-код
      final qrResult = await _scanQRCode(croppedImage);
      if (qrResult.isNotEmpty) {
        setState(() {
          _textController.text = qrResult;
        });
        _showMessage('${_locale.get("QRCodeDone")}');
        return;
      }

      // Если QR не найден, распознаем текст
      final textResult = await _recognizeTextFromBytes(croppedImage);
      setState(() {
        _textController.text = textResult;
      });
      _showMessage('${_locale.get("textDone")}!');

    } catch (e) {
      print('${_locale.get("error")}: $e');
      _showMessage('Ошибка: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

Future<Uint8List?> _cropImageRegion(Uint8List imageData, Rect region) async {
  try {
    print('Обрезка из готового скриншота, регион: $region');
    
    // Декодируем оригинальное изображение
    final codec = await ui.instantiateImageCodec(imageData);
    final frame = await codec.getNextFrame();
    final originalImage = frame.image;
    
    // Получаем размеры экрана
    final screenSize = MediaQuery.of(context).size;
    
    // Рассчитываем масштаб между скриншотом и экраном
    final scaleX = originalImage.width / screenSize.width;
    final scaleY = originalImage.height / screenSize.height;
    
    print('Original image: ${originalImage.width}x${originalImage.height}');
    print('Screen size: $screenSize');
    print('Scale: $scaleX x $scaleY');
    
    // Рассчитываем координаты в масштабе изображения
    final cropX = (region.left * scaleX).round();
    final cropY = (region.top * scaleY).round();
    final cropWidth = (region.width * scaleX).round();
    final cropHeight = (region.height * scaleY).round();
    
    print('Crop coordinates: $cropX,$cropY ${cropWidth}x$cropHeight');
    
    // Проверяем границы
    if (cropX < 0 || cropY < 0 || 
        cropX + cropWidth > originalImage.width || 
        cropY + cropHeight > originalImage.height) {
      print('Выход за границы изображения');
      return null;
    }
    
    // Создаем обрезанное изображение
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    canvas.drawImageRect(
      originalImage,
      ui.Rect.fromLTWH(
        cropX.toDouble(),
        cropY.toDouble(),
        cropWidth.toDouble(),
        cropHeight.toDouble(),
      ),
      ui.Rect.fromLTWH(0, 0, cropWidth.toDouble(), cropHeight.toDouble()),
      Paint(),
    );
    
    final picture = recorder.endRecording();
    final croppedImage = await picture.toImage(cropWidth, cropHeight);
    final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    final resultBytes = byteData!.buffer.asUint8List();
    
    print('Успешно обрезано: ${resultBytes.length} байт');
    
    // Сохраняем для отладки
    final docDir = await getApplicationDocumentsDirectory();
    final debugFile = File('${docDir.path}/debug_crop.png');
    await debugFile.writeAsBytes(resultBytes);
    print('Сохранено для отладки: ${debugFile.path}');
    
    return resultBytes;
    
  } catch (e) {
    print('Ошибка обрезки: $e');
    return null;
  }
}


Future<String> _scanQRCode(Uint8List imageData) async {
     const channel = MethodChannel('screenshot_channel');
  final String result = await channel.invokeMethod('scanQRCode', {
    'imageData': imageData,
  });
  return result;
}
Future<void> _sendToAI(String recognizedText, String userText) async {
  // Выполняем вычисления в изоляте
  final combinedText = await compute(_prepareCombinedText, {
    'recognizedText': recognizedText,
    'recognizedTextFromScreenshot': _recognizedTextFromScreenshot,
  });
  
  print('=' * 50);
  print('ОТПРАВКА В AI:');
  print('=' * 50);
  print(combinedText);
  print('=' * 50);
  
  // Отправка в отдельном потоке
  await _sendToServer(combinedText).timeout(const Duration(seconds: 30));
  
  // Закрытие окна в основном потоке
  WidgetsBinding.instance.addPostFrameCallback((_) {
    windowManager.close();
  });
}

// Функция для изолята
static String _prepareCombinedText(Map<String, String> data) {
  final recognizedText = data['recognizedText']!;
  final recognizedTextFromScreenshot = data['recognizedTextFromScreenshot']!;
  
  bool isSame = recognizedText == recognizedTextFromScreenshot;
  
  if (isSame) {
    return '''
    $recognizedTextFromScreenshot
    \n
    ''';
  } else {
    return '''
    $recognizedTextFromScreenshot
    \n
    $recognizedText
    ''';
  }
}
//пикей


static Future<void> _sendToServer(String data) async {
  try {
    final socket = await Socket.connect('localhost', 8081);
    // Явно кодируем в UTF-8
    final encodedData = utf8.encode(data);
    socket.add(encodedData);
    await socket.flush();
    socket.destroy();
  } catch (e) {
    print('Error sending data: $e');
  }
}


  Rect _getSelectionRect() {
    final left = _startOffset.dx < _currentOffset.dx ? _startOffset.dx : _currentOffset.dx;
    final top = _startOffset.dy < _currentOffset.dy ? _startOffset.dy : _currentOffset.dy;
    final right = _startOffset.dx > _currentOffset.dx ? _startOffset.dx : _currentOffset.dx;
    final bottom = _startOffset.dy > _currentOffset.dy ? _startOffset.dy : _currentOffset.dy;

    return Rect.fromLTRB(left, top, right, bottom);
  }

void _onPanStart(DragStartDetails details) {
  setState(() {
    _startOffset = details.localPosition;
    _currentOffset = details.localPosition;
    _isSelecting = true;
    _showTextInput = false;
    _arrows.clear(); // Очищаем стрелки при новом выделении
  });
}

void _onPanUpdate(DragUpdateDetails details) {
  setState(() {
    _currentOffset = details.localPosition;
  });
}

void _onPanEnd(DragEndDetails details) {
  final selectionRect = _getSelectionRect();
  setState(() {
    _selectedRegion = selectionRect;
    _isSelecting = false;
    _showTextInput = true;
  });

  // Обрабатываем выделенную область только если она достаточно большая
  if (selectionRect.width >= 20 && selectionRect.height >= 20) {
    _processSelectedRegion(selectionRect);
  }
}
void _onSend() async {
  if (_isProcessing || _selectedRegion == null) return;

  try {
    setState(() {
      _isProcessing = true;
    });

    // Получаем текст из поля ввода
    final recognizedText = _textController.text.trim();
    
    if (recognizedText.isEmpty) {
      _showMessage('${_locale.get("addTextForAI")}');
      return;
    }

    // Отправляем в AI
    await _sendToAI(recognizedText, "${_locale.get("userInput")}");

    // Закрываем окно после успешной отправки
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        windowManager.close();
      }
    });

  } catch (e) {
    _showMessage('${_locale.get("error")}: $e');
  } finally {
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('Ошибка') ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _cancelScreenshot() {
    windowManager.close();
  }


  Offset? _arrowStart;
bool _isDrawingArrow = false;

void _undoArrow() {
  if (_arrowHistory.isNotEmpty) {
    setState(() {
      _arrowHistory.removeLast();
      _arrows = _arrowHistory.isNotEmpty ? List.from(_arrowHistory.last) : [];
    });
  }
}
Future<void> _copyScreenshotToClipboard() async {
  if (_screenshotData == null || _selectedRegion == null) return;

  try {
    // Добавляем проверку на null и оператор ! для явного указания non-null
    final croppedImageData = await _cropImageRegion(_screenshotData!, _selectedRegion!);
    if (croppedImageData != null) {
      // Для Windows используем канал для копирования изображения в буфер
      const channel = MethodChannel('screenshot_channel');
      await channel.invokeMethod('copyImageToClipboard', {
        'imageData': croppedImageData,
      });
      windowManager.close();
    }
  } catch (e) {
    _showMessage('${_locale.get("error")}: $e');
  }
}

Future<void> _createMemeScreenshot() async {
  if (_screenshotData == null || _selectedRegion == null) return;

  try {
    final memeImage = await _createMemeImage(_screenshotData!, _selectedRegion!, _textController.text);
    if (memeImage != null) {
      // Для Windows используем канал для копирования изображения в буфер
      const channel = MethodChannel('screenshot_channel');
      await channel.invokeMethod('copyImageToClipboard', {
        'imageData': memeImage,
      });
      windowManager.close();
    }
  } catch (e) {
    _showMessage('Ошибка создания демотиватора: $e');
  }
}

Future<Uint8List?> _addArrowsToImage(Uint8List imageData, Rect region) async {
  try {
    final codec = await ui.instantiateImageCodec(imageData);
    final frame = await codec.getNextFrame();
    final originalImage = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Рисуем оригинальное изображение
    canvas.drawImage(originalImage, Offset.zero, Paint());
    
    // Рисуем стрелки
    for (final arrow in _arrows) {
      _drawArrow(canvas, arrow.start, arrow.end);
    }
    
    final picture = recorder.endRecording();
    final finalImage = await picture.toImage(originalImage.width, originalImage.height);
    final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData?.buffer.asUint8List();
  } catch (e) {
    print('${_locale.get("error")}: $e');
    return null;
  }
}

void _drawArrow(Canvas canvas, Offset start, Offset end) {
  final paint = Paint()
    ..color = Colors.red
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  // Рисуем линию
  canvas.drawLine(start, end, paint);
  
  // Рисуем стрелку
  final angle = (end - start).direction;
  const arrowSize = 4.0;
  
  final path = Path()
    ..moveTo(end.dx, end.dy)
    ..lineTo(
      end.dx - arrowSize * cos(angle - pi / 6),
      end.dy - arrowSize * sin(angle - pi / 6),
    )
    ..lineTo(
      end.dx - arrowSize * cos(angle + pi / 6),
      end.dy - arrowSize * sin(angle + pi / 6),
    )
    ..close();
  
  canvas.drawPath(path, paint..style = PaintingStyle.fill);
}
Future<Uint8List?> _createMemeImage(Uint8List imageData, Rect region, String text) async {
  try {
    // Сначала обрезаем изображение по выделенной области
    final croppedImageData = await _cropImageRegion(imageData, region);
    if (croppedImageData == null) return null;

    final codec = await ui.instantiateImageCodec(croppedImageData);
    final frame = await codec.getNextFrame();
    var baseImage = frame.image;

    // Базовые размеры для демотиватора
    const padding = 80.0;
    const bottomPadding = 80.0;
    const watermarkHeight = 40.0;
    const qrCodeSize = 70.0;

    // Определяем ширину изображения с учетом ограничений
    double imageWidth = baseImage.width.toDouble();
    if (imageWidth > 1600) {
      // Ресайзим до 1440 ширины
      final scale = 1440 / imageWidth;
      final scaledWidth = 1440;
      final scaledHeight = (baseImage.height * scale).toDouble();
      
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawImageRect(
        baseImage,
        Rect.fromLTWH(0, 0, baseImage.width.toDouble(), baseImage.height.toDouble()),
        Rect.fromLTWH(0, 0, scaledWidth.toDouble(), scaledHeight),
        Paint(),
      );
      final picture = recorder.endRecording();
      baseImage = await picture.toImage(scaledWidth, scaledHeight.toInt());
      imageWidth = scaledWidth.toDouble();
    }

    // Вычисляем общую ширину с отступами
    final totalWidth = imageWidth + 160; // +160px (80px с каждой стороны)
    
    // Высота изображения
    final imageHeight = baseImage.height.toDouble();

    // Определяем размер шрифта в зависимости от длины текста
    double fontSize = 25.0;
    if (text.length <= 30) {
      fontSize = 32.0;
    } else if (text.length <= 50) {
      fontSize = 28.0;
    }

    // Создаем Paragraph для текста, чтобы определить его высоту
    final textParagraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontSize: fontSize,
        textAlign: ui.TextAlign.center,
        fontWeight: ui.FontWeight.bold,
      ),
    )..pushStyle(ui.TextStyle(
        color: Colors.white,
      ))
     ..addText(text);
    
    final textParagraph = textParagraphBuilder.build();
    textParagraph.layout(ui.ParagraphConstraints(
      width: totalWidth - 40, // Отступы по 20 с каждой стороны
    ));

    final textHeight = textParagraph.height;

    // Вычисляем общую высоту изображения
    final totalHeight = padding + imageHeight + padding + textHeight + bottomPadding;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Рисуем черный фон
    canvas.drawRect(
      Rect.fromLTWH(0, 0, totalWidth, totalHeight),
      Paint()..color = Colors.black,
    );
    
    // Рисуем основное изображение со смещением на 80px по X
    final imageRect = Rect.fromLTWH(
      padding, // 80px отступ слева
      padding, 
      imageWidth, 
      imageHeight
    );
    
    // Создаем изображение с белой рамкой
    canvas.drawRect(
      imageRect.inflate(2),
      Paint()..color = Colors.white,
    );
    
    // Рисуем основное изображение
    canvas.drawImageRect(
      baseImage,
      Rect.fromLTWH(0, 0, baseImage.width.toDouble(), baseImage.height.toDouble()),
      imageRect,
      Paint(),
    );

    // Рисуем текст
    final textY = padding + imageHeight + padding;
    canvas.drawParagraph(
      textParagraph,
      Offset(20, textY),
    );

    // Создаем виртуальный Row для водяного знака "Created with" и логотипа
    const logoWidth = 70.0;
    const logoHeight = 40.0;
    const textLogoSpacing = 5.0; // Отступ между текстом и логотипом
    
    // Создаем Paragraph для текста "Created with"
    final createdWithBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontSize: 11,
      ),
    )..pushStyle(ui.TextStyle(
        color: Colors.white,
      ))
     ..addText("Created with");
    
    final createdWithParagraph = createdWithBuilder.build();
    createdWithParagraph.layout(ui.ParagraphConstraints(
      width: 100,
    ));

    final createdWithHeight = createdWithParagraph.height;
    
    // Вычисляем общую ширину водяного знака (текст + отступ + логотип)
    final watermarkTotalWidth = createdWithParagraph.width + textLogoSpacing + logoWidth;
    
    // Позиция водяного знака (правый нижний угол)
    final watermarkX = totalWidth - watermarkTotalWidth - 10;
    final watermarkY = totalHeight - logoHeight - 10;
    
    // Создаем виртуальный Rect для всего водяного знака
    final watermarkRect = Rect.fromLTWH(
      watermarkX,
      watermarkY,
      watermarkTotalWidth,
      logoHeight, // Высота равна высоте логотипа
    );

    // Вычисляем вертикальный центр для текста
    final textVerticalCenter = watermarkRect.top + (watermarkRect.height - createdWithHeight) / 2;

    // Рисуем текст "Created with" по центру по вертикали
    canvas.drawParagraph(
      createdWithParagraph,
      Offset(watermarkRect.left, textVerticalCenter),
    );

    // Добавляем логотип (если есть в assets)
    try {
      final logoData = await rootBundle.load('assets/images/logo.png');
      final logoCodec = await ui.instantiateImageCodec(logoData.buffer.asUint8List());
      final logoFrame = await logoCodec.getNextFrame();
      final logoImage = logoFrame.image;
      
      final logoRect = Rect.fromLTWH(
        watermarkRect.left + createdWithParagraph.width + textLogoSpacing,
        watermarkRect.top,
        logoWidth,
        logoHeight
      );
      
      canvas.drawImageRect(
        logoImage,
        Rect.fromLTWH(0, 0, logoImage.width.toDouble(), logoImage.height.toDouble()),
        logoRect,
        Paint(),
      );
    } catch (e) {
      print('Логотип не найден: $e');
    }

    // Добавляем QR-код
    try {
      final qrData = await rootBundle.load('assets/images/qr_code.png');
      final qrCodec = await ui.instantiateImageCodec(qrData.buffer.asUint8List());
      final qrFrame = await qrCodec.getNextFrame();
      final qrImage = qrFrame.image;
      
      canvas.drawImageRect(
        qrImage,
        Rect.fromLTWH(0, 0, qrImage.width.toDouble(), qrImage.height.toDouble()),
        Rect.fromLTWH(
          10.0, 
          totalHeight - qrCodeSize - 10, 
          qrCodeSize, 
          qrCodeSize
        ),
        Paint(),
      );
    } catch (e) {
      print('QR-код не найден: $e');
    }

    final picture = recorder.endRecording();
    final memeImage = await picture.toImage(totalWidth.toInt(), totalHeight.toInt());
    final byteData = await memeImage.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData?.buffer.asUint8List();
  } catch (e) {
    print('Ошибка создания демотиватора: $e');
    return null;
  }
}

Widget _buildMainInteractionListener() {
  return Positioned.fill(
    child: Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        if (event.buttons == kPrimaryButton) {
          setState(() {
            _isSelecting = true;
            _selectionStart = event.localPosition;
            _selectionEnd = event.localPosition;
            _selectedRegion = null;
            _showTextInput = false;
            _arrows.clear();
            _arrowHistory.clear();
          });
        }
      },
      onPointerMove: (event) {
        if (_isSelecting) {
          setState(() {
            _selectionEnd = event.localPosition;
          });
        }
      },
      onPointerUp: (event) {
        if (_isSelecting) {
          setState(() {
            _isSelecting = false;
            final selectionRect = _getSelectionRect();
            if (selectionRect.width > 10 && selectionRect.height > 10) {
              _selectedRegion = selectionRect;
              _showTextInput = true;
              _focusNode.requestFocus();
            } else {
              _selectedRegion = null;
              _showTextInput = false;
            }
          });
        }
      },
    ),
  );
}

Widget _buildArrowInteractionListener() {
  return Positioned.fill(
    child: MouseRegion(
      cursor: SystemMouseCursors.precise,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          if (event.buttons == kSecondaryButton) {
            final localPosition = event.localPosition;
            if (_selectedRegion!.contains(localPosition)) {
              setState(() {
                _arrowStart = localPosition;
                _isDrawingArrow = true;
                _currentArrowEnd = localPosition;
              });
            }
          }
        },
        onPointerMove: (event) {
          if (_isDrawingArrow && _arrowStart != null) {
            setState(() {
              _currentArrowEnd = event.localPosition;
            });
          }
        },
        onPointerUp: (event) {
          if (_isDrawingArrow && _arrowStart != null) {
            setState(() {
              _arrows.add(Arrow(_arrowStart!, event.localPosition));
              _arrowHistory.add(List.from(_arrows));
              _isDrawingArrow = false;
              _arrowStart = null;
              _currentArrowEnd = null;
            });
          }
        },
        onPointerCancel: (event) {
          if (_isDrawingArrow) {
            setState(() {
              _isDrawingArrow = false;
              _arrowStart = null;
              _currentArrowEnd = null;
            });
          }
        },
      ),
    ),
  );
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          _cancelScreenshot();
        }
      },
      child: Stack(
        children: [
          if (_screenshotData == null)
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      '${_locale.get("capture")}...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          else
            Stack(
              children: [
                // Фоновое изображение (скриншот)
                Positioned.fill(
                  child: Image.memory(
                    _screenshotData!,
                    fit: BoxFit.cover,
                  ),
                ),

                // Затемнение
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),

                // Область выделения (показывается как во время выделения, так и после)
                if (_isSelecting || _selectedRegion != null) _buildSelectionArea(),
                
                // Стрелки
                if (_selectedRegion != null)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ArrowPainter(
                        _arrows, 
                        arrowStart: _arrowStart,
                        currentArrowEnd: _currentArrowEnd,
                      ),
                    ),
                  ),

                // Контролы с полем ввода
                if (_showTextInput && _selectedRegion != null) _buildControls(),

                // Инструкция
                if (!_showTextInput)
                  Positioned(
                    top: 20,
                    left: 20,
                    child: _buildInstructions(),
                  ),

                // Кнопка отмены
                Positioned(
                  top: 20,
                  right: 20,
                  child: _buildCancelButton(),
                ),

                // Основной GestureDetector для взаимодействия
                if (!_isProcessing)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: _showTextInput,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.precise,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onPanStart: (details) {
                            if (_selectedRegion == null) {
                              // Левая кнопка - выделение области
                              _isSelecting = true;
                              _onPanStart(details);
                            } else if (_selectedRegion!.contains(details.localPosition)) {
                              // Правая кнопка - рисование стрелки (только в пределах выделения)
                              setState(() {
                                _arrowStart = details.localPosition;
                                _isDrawingArrow = true;
                              });
                            }
                          },
                          onPanUpdate: (details) {
                            if (_isSelecting) {
                              _onPanUpdate(details);
                            } else if (_isDrawingArrow) {
                              // Обновляем предварительный просмотр стрелки
                              setState(() {
                                _currentArrowEnd = details.localPosition;
                              });
                            }
                          },
                          onPanEnd: (details) {
                            if (_isSelecting) {
                              _onPanEnd(details);
                              _isSelecting = false;
                            } else if (_isDrawingArrow && _arrowStart != null) {
                              // Завершаем рисование стрелки
                              setState(() {
                                _arrows.add(Arrow(_arrowStart!, _currentArrowEnd ?? _arrowStart!));
                                _arrowHistory.add(List.from(_arrows));
                                _isDrawingArrow = false;
                                _arrowStart = null;
                                _currentArrowEnd = null;
                              });
                            }
                          },
                          onPanCancel: () {
                            // Сбрасываем состояния при отмене жеста
                            _isSelecting = false;
                            if (_isDrawingArrow) {
                              setState(() {
                                _isDrawingArrow = false;
                                _arrowStart = null;
                                _currentArrowEnd = null;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                // Индикатор обработки
                if (_isProcessing)
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text(
                            '${_locale.get("processing")}...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    ),
  );
}

Widget _buildSelectionArea() {
  final selectionRect = _getSelectionRect();
  
  return Stack(
    children: [
      // Затемнение вокруг выделенной области (только во время выделения)
      if (_isSelecting)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
      
      // Выделенная область (показывается всегда)
      Positioned(
        left: selectionRect.left,
        top: selectionRect.top,
        child: Container(
          width: selectionRect.width,
          height: selectionRect.height,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            border: Border.all(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
      ),

      // Размеры области (показывается всегда)
      if (selectionRect.width > 50 && selectionRect.height > 20)
        Positioned(
          left: selectionRect.left,
          top: selectionRect.top - 30,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${selectionRect.width.round()} × ${selectionRect.height.round()}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
    ],
  );
}



Widget _buildControls() {
  final screenSize = MediaQuery.of(context).size;
  final region = _selectedRegion!;

  double left = region.left;
  double top = region.bottom + 10;
  double width = region.width.clamp(300.0, screenSize.width - left - 20);

  if (top + 180 > screenSize.height) {
    top = region.top - 180;
    top = top.clamp(20.0, screenSize.height - 180);
  }

  double maxHeight = 120.0;

  return Positioned(
    left: left,
    top: top,
    width: width,
    child: Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.edit, color: Colors.white70, size: 14),
                SizedBox(width: 6),
                Text(
                  '${_locale.get("edit")} ${_locale.get("text")}:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                // Кнопка отмены
                IconButton(
                  icon: Icon(Icons.close, size: 16, color: Colors.white70),
                  onPressed: _cancelScreenshot,
                  tooltip: '${_locale.get("cancel")} (Esc)',
                ),
              ],
            ),
            SizedBox(height: 8),

            // Поле ввода текста
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 40,
                maxHeight: maxHeight,
              ),
              child: TextField(
                focusNode: _focusNode,
                controller: _textController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '${_locale.get("addSomeText")}...',
                  hintStyle: TextStyle(color: Colors.white60, fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.blue.withOpacity(0.5), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.blue.withOpacity(0.5), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  filled: true,
                  fillColor: Colors.grey[900],
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: TextStyle(color: Colors.white, fontSize: 13),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),

            SizedBox(height: 12),

            Row(
              children: [
                // Информация о стрелках
                if (_arrows.isNotEmpty)
                  Text(
                    'Стрелок: ${_arrows.length}',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                SizedBox(width: 8),
                
                // Кнопка отмены стрелки
                if (_arrowHistory.isNotEmpty)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      minimumSize: Size(0, 30),
                    ),
                    icon: Icon(Icons.undo, size: 12),
                    label: Text('Ctrl+Z', style: TextStyle(fontSize: 10)),
                    onPressed: _undoArrow,
                  ),

                Spacer(),

                // Кнопка "Копировать"
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    minimumSize: Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: Icon(Icons.copy, size: 14),
                  label: Text('Ctrl+C', style: TextStyle(fontSize: 12)),
                  onPressed: _copyScreenshotToClipboard,
                ),
                SizedBox(width: 8),

                // Кнопка "Демотиватор"
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    minimumSize: Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: Icon(Icons.photo_size_select_large, size: 14),
                  label: Text('Ctrl+X', style: TextStyle(fontSize: 12)),
                  onPressed: _createMemeScreenshot,
                ),
                SizedBox(width: 8),

                // Кнопка "Send to AI"
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    minimumSize: Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: _isProcessing
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.send, size: 14),
                  label: Text('Send to AI', style: TextStyle(fontSize: 12)),
                  onPressed: _isProcessing ? null : _onSend,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildCancelButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.close, color: Colors.white),
        onPressed: _cancelScreenshot,
        tooltip: '${_locale.get("close")} (Esc)',
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_locale.get("guide")}:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 6),
          Text(
            '1. ${_locale.get("selectArea")}\n'
            '2. ${_locale.get("autoRecognition")}\n'
            '3. ${_locale.get("sendToAIg")}\n'
            '4. Esc - ${_locale.get("close")}\n${_locale.get("keysTranslate")}',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  void onWindowClose() {
    super.onWindowClose();
  }
}
class KeyboardLogger {
  static final KeyboardLogger _instance = KeyboardLogger._internal();
  factory KeyboardLogger() => _instance;
  KeyboardLogger._internal();

  Timer? _inactivityTimer;
  String _currentBuffer = '';
  DateTime _lastKeyTime = DateTime.now();
  final Duration _inactivityThreshold = Duration(seconds: 35);
  bool _isEnabled = false;

  // Фильтр для исключения системных клавиш
  final Set<LogicalKeyboardKey> _ignoredKeys = {
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.controlRight,
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.meta,
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
    LogicalKeyboardKey.capsLock,
    LogicalKeyboardKey.numLock,
    LogicalKeyboardKey.scrollLock,
    LogicalKeyboardKey.f1,
    LogicalKeyboardKey.f2,
    LogicalKeyboardKey.f3,
    LogicalKeyboardKey.f4,
    LogicalKeyboardKey.f5,
    LogicalKeyboardKey.f6,
    LogicalKeyboardKey.f7,
    LogicalKeyboardKey.f8,
    LogicalKeyboardKey.f9,
    LogicalKeyboardKey.f10,
    LogicalKeyboardKey.f11,
    LogicalKeyboardKey.f12,
    LogicalKeyboardKey.escape,
    LogicalKeyboardKey.printScreen,
    LogicalKeyboardKey.pause,
    LogicalKeyboardKey.insert,
    LogicalKeyboardKey.home,
    LogicalKeyboardKey.pageUp,
    LogicalKeyboardKey.delete,
    LogicalKeyboardKey.end,
    LogicalKeyboardKey.pageDown,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
  };

  Future<void> initialize() async {
    if (_isEnabled) return;
    
    _isEnabled = true;
    _currentBuffer = '';
    _lastKeyTime = DateTime.now();
    
    await _writeTextLog('Keyboard logger initialized');
    
    // Запускаем таймер проверки неактивности
    _startInactivityTimer();
  }

  void _startInactivityTimer() {
    return;
    _inactivityTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final timeDiff = now.difference(_lastKeyTime);
      
      if (timeDiff >= _inactivityThreshold && _currentBuffer.isNotEmpty) {
        _writeTextLog('Inactivity timeout reached, saving buffer');
        _saveKeyboardInput();
      }
    });
  }

  void handleKeyEvent(RawKeyEvent event) {
    if (!_isEnabled) return;
    
    final now = DateTime.now();
    _lastKeyTime = now;

    if (event is RawKeyDownEvent) {
      final logicalKey = event.logicalKey;
      
      // Пропускаем системные клавиши
      if (_ignoredKeys.contains(logicalKey)) return;

      // Обработка специальных клавиш
      if (logicalKey == LogicalKeyboardKey.backspace) {
        _handleBackspace();
      } else if (logicalKey == LogicalKeyboardKey.enter) {
        _handleEnter();
      } else if (logicalKey == LogicalKeyboardKey.space) {
        _handleSpace();
      } else if (logicalKey == LogicalKeyboardKey.tab) {
        _handleTab();
      } else {
        // Обычные символы
        _handleCharacter(logicalKey);
      }
    }
  }

  void _handleBackspace() {
    if (_currentBuffer.isNotEmpty) {
      _currentBuffer = _currentBuffer.substring(0, _currentBuffer.length - 1);
      _writeTextLog('Backspace pressed, buffer length: ${_currentBuffer.length}');
    }
  }

  void _handleEnter() {
    _writeTextLog('Enter pressed, saving buffer with ${_currentBuffer.length} characters');
    _currentBuffer += '\n';
    // Сохраняем при нажатии Enter
    _saveKeyboardInput();
  }

  void _handleSpace() {
    _currentBuffer += ' ';
    _writeTextLog('Space pressed, buffer: "${_getBufferPreview()}"');
  }

  void _handleTab() {
    _currentBuffer += '\t';
    _writeTextLog('Tab pressed, buffer: "${_getBufferPreview()}"');
  }

  void _handleCharacter(LogicalKeyboardKey key) {
    final keyLabel = key.keyLabel;
    
    // Фильтрация специальных символов которые не должны быть в тексте
    if (keyLabel.length == 1 && _isValidCharacter(keyLabel)) {
      _currentBuffer += keyLabel;
      _writeTextLog('Character pressed: "$keyLabel", buffer: "${_getBufferPreview()}"');
    } else {
      _writeTextLog('Invalid character filtered: "$keyLabel" (key: ${key.keyId})');
    }
  }

  String _getBufferPreview() {
    if (_currentBuffer.isEmpty) return 'empty';
    final preview = _currentBuffer.length > 30 
        ? '${_currentBuffer.substring(0, 30)}...' 
        : _currentBuffer;
    return preview.replaceAll('\n', '\\n').replaceAll('\t', '\\t');
  }

  bool _isValidCharacter(String char) {
    // Базовые проверки валидности символа
    if (char.isEmpty) return false;
    
    final codeUnit = char.codeUnitAt(0);
    
    // Разрешаем буквы, цифры, основные символы
    // Кириллица: 1040-1103 (А-Яа-я) + Ёё (1025, 1105)
    // Латинница: 65-90 (A-Z), 97-122 (a-z)
    // Цифры: 48-57 (0-9)
    // Основные символы: 32 (пробел), 33-47, 58-64, 91-96, 123-126
    return (codeUnit >= 1040 && codeUnit <= 1103) || // Кириллица
           (codeUnit == 1025 || codeUnit == 1105) || // Ёё
           (codeUnit >= 65 && codeUnit <= 90) ||     // A-Z
           (codeUnit >= 97 && codeUnit <= 122) ||    // a-z
           (codeUnit >= 48 && codeUnit <= 57) ||     // 0-9
           (codeUnit >= 32 && codeUnit <= 126);      // Основные символы
  }

  bool _isValidContent(String content) {
    if (content.isEmpty) return false;
    
    final trimmed = content.trim();
    
    // Слишком короткие сообщения
    if (trimmed.length < 3) {
      _writeTextLog('Content too short: $trimmed');
      return false;
    }
    
    // Только пробелы/переносы
    if (trimmed.isEmpty) {
      _writeTextLog('Content only whitespace');
      return false;
    }
    
    // Повторяющиеся символы (например, "aaaaaaa")
    final repeatingRegex = RegExp(r'^(.)\1{4,}$'); // 5+ одинаковых символов
    if (repeatingRegex.hasMatch(trimmed)) {
      _writeTextLog('Content repeating characters: $trimmed');
      return false;
    }
    
    // Только цифры (короткие числовые последовательности)
    final onlyDigits = RegExp(r'^\d+$');
    if (onlyDigits.hasMatch(trimmed) && trimmed.length < 5) {
      _writeTextLog('Content only digits: $trimmed');
      return false;
    }
    
    // Случайные нажатия (например, "asdfghjk")
    if (_isRandomTyping(trimmed)) {
      _writeTextLog('Content random typing: $trimmed');
      return false;
    }
    
    return true;
  }

  bool _isRandomTyping(String text) {
    if (text.length < 6) return false;
    
    // Проверяем на последовательности типа "asdfgh" или "qwerty"
    final commonRandomPatterns = [
      'asdfgh', 'qwerty', 'zxcvbn', 'йцукен', 'фывапр', 'ячсмит'
    ];
    
    final lowerText = text.toLowerCase();
    for (final pattern in commonRandomPatterns) {
      if (lowerText.contains(pattern)) {
        return true;
      }
    }
    
    return false;
  }

  Future<void> _saveKeyboardInput() async {
    if (_currentBuffer.isEmpty) {
      _writeTextLog('Save attempted but buffer is empty');
      return;
    }

    if (!_isValidContent(_currentBuffer)) {
      _writeTextLog('Invalid content, skipping save: "${_currentBuffer.substring(0, min(_currentBuffer.length, 20))}..."');
      _currentBuffer = '';
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final copypasteDir = Directory('${directory.path}/copypasted');
      
      if (!copypasteDir.existsSync()) {
        copypasteDir.createSync(recursive: true);
        _writeTextLog('Created directory: ${copypasteDir.path}');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'keyboard_$timestamp.cnp';
      final file = File('${copypasteDir.path}/$fileName');
      
      final entry = {
        'content': _currentBuffer,
        'timestamp': timestamp,
        'source': 'keyboard',
        'starred': false,
        'length': _currentBuffer.length,
      };

      // Сохраняем с правильной кодировкой UTF-8
      final jsonString = jsonEncode(entry);
      final bytes = utf8.encode(jsonString);
      await file.writeAsBytes(bytes);
      
      _writeTextLog('Keyboard input saved: ${_currentBuffer.length} characters to $fileName');
      
      // Очищаем буфер после успешного сохранения
      _currentBuffer = '';
      
    } catch (e) {
      await _writeTextLog('Error saving keyboard input: $e');
    }
  }

  Future<void> _writeTextLog(String message) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final logFile = File('${documentsDir.path}/log_keylogger_text.log');
      
      final timestamp = DateTime.now().toString();
      final logMessage = '[$timestamp] $message\n';
      
      // Добавляем в конец файла
      await logFile.writeAsString(logMessage, mode: FileMode.append);
      
      // Также выводим в консоль для отладки
      print(message);
    } catch (e) {
      print('Ошибка записи лога: $e');
    }
  }

  // Принудительно сохранить текущий буфер
  Future<void> forceSave() async {
    if (_currentBuffer.isNotEmpty) {
      await _writeTextLog('Force save triggered');
      await _saveKeyboardInput();
    } else {
      await _writeTextLog('Force save attempted but buffer is empty');
    }
  }

  // Очистить текущий буфер без сохранения
  void clearBuffer() {
    _writeTextLog('Buffer cleared manually, was ${_currentBuffer.length} characters');
    _currentBuffer = '';
    _lastKeyTime = DateTime.now();
  }

  // Получить текущее состояние (для отладки)
  Map<String, dynamic> getStatus() {
    return {
      'isEnabled': _isEnabled,
      'bufferLength': _currentBuffer.length,
      'lastActivity': _lastKeyTime,
      'timeSinceLastActivity': DateTime.now().difference(_lastKeyTime).inSeconds,
      'bufferPreview': _currentBuffer.length > 50 
          ? '${_currentBuffer.substring(0, 50)}...' 
          : _currentBuffer,
    };
  }

  void dispose() {
    _writeTextLog('Keyboard logger disposed');
    _isEnabled = false;
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
    
    // Принудительно сохраняем оставшийся буфер при закрытии
    if (_currentBuffer.isNotEmpty) {
      _writeTextLog('Auto-saving remaining buffer on dispose');
      _saveKeyboardInput();
    }
  }

  int min(int a, int b) => a < b ? a : b;
}
class ProcessManager {
  static final ProcessManager _instance = ProcessManager._internal();
  final Map<String, Process> _processes = {};

  factory ProcessManager() => _instance;

  ProcessManager._internal();

  void registerProcess(String id, Process process) {
    _processes[id] = process;
  }

  void killProcess(String id) {
    if (_processes.containsKey(id)) {
      _processes[id]?.kill();
      _processes.remove(id);
    }
  }

  void killAllProcesses() {
    _processes.forEach((id, process) {
      process.kill();
    });
    _processes.clear();
  }

  bool hasProcess(String id) => _processes.containsKey(id);

  // ======================
  // Добавляем метод getProcess
  // ======================
  Process? getProcess(String id) {
    return _processes[id];
  }
}

  void _writeToDebugLog(String message) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final debugFile = File('${directory.path}/chat_debug.log');
      await debugFile.writeAsString('${DateTime.now()}: $message\n', mode: FileMode.append);
      print('DEBUG: $message'); // Также выводим в консоль
    } catch (e) {
      print('Error writing to debug log: $e');
    }
  }

Future<String> _getSharedFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/shared_eaten_files.json';
}

void _handleFileFeed(String filePath) {
  // Обработка файла из контекстного меню
  print('Feeding file to AI: $filePath');
  // Здесь можно отправить файл в основное приложение
}

void _handleTextFeed(String text) {
  // Обработка текста из контекстного меню браузера
  print('Feeding text to AI: $text');
  // Здесь можно отправить текст в основное приложение
  
}


void main(List<String> args) async {
  _writeToDebugLog1("0");
  WidgetsFlutterBinding.ensureInitialized();
  _writeToDebugLog1("1");
   // Передаем args в checkMainInstance
  if (!args.contains('--subprocess') && !Platform.executableArguments.contains('--subprocess')) {
    await SimpleMutex.checkMainInstance(args: args);
  }
  // Проверяем аргументы командной строки
  if (args.isNotEmpty) {
      if (args.contains('--feed-file')) {
    final fileIndex = args.indexOf('--feed-file') + 1;
    if (fileIndex < args.length) {
      final filePath = args[fileIndex];
      _handleFileFeed(filePath);
      return;
    }
  }
  
  if (args.contains('--feed-text')) {
    final textIndex = args.indexOf('--feed-text') + 1;
    if (textIndex < args.length) {
      final text = args[textIndex];
      _handleTextFeed(text);
      return;
    }
  }
    if (args[0]=='ai_open'){
      
      await _initAIWindow();
      // runApp(MaterialApp(
      //  title: 'Advanced Neural Network System',
      //  theme: ThemeData.dark(),
      //  home: NeuralNetworkApp(),
      //));
        return;
    }else if (args[0]=='essentials'){
      
      await _initEssentialsWindow();
        runApp(EssentialsApp(
        ));
        return;
    }else if (args[0]=='macro_keyboard'){
      
      await _initMacroKeyboardWindow();
         runApp( VirtualKeyboardApp());
        return;
    }else

    if (args[0] == 'chat') {
        final debugFile = File('chat_debug.log');
        await debugFile.writeAsString('Chat window args: $args\n', mode: FileMode.append);
        
        // Парсим историю чата
        List<Map<String, String>> chatHistory = [];
        if (args.length > 1 && args[1].isNotEmpty && args[1] != '[]') {
          try {
            final parsed = json.decode(args[1]) as List;
            chatHistory = parsed.map((item) => Map<String, String>.from(item)).toList();
          } catch (e) {
            debugFile.writeAsString('Error parsing chat history: $e\n', mode: FileMode.append);
          }
        }
        
        await _initChatWindow(args);
        runApp(ChatWindowApp(initialChatHistory: chatHistory));
        return;
      }else if (args[0] == 'files') {
  await _initFilesWindow();
   runZonedGuarded(() {
    runApp(const EatenFilesWindowApp());
  }, (error, stack) {
    debugPrint('Error in runZoned: $error');
  });
} else if(args[0] == 'screenshoter') {
    await _initScreenshotWindow();
    runApp(const ScreenshotApp());
  }else if(args[0] == 'clipboard-history') {
    await _initClipboardHistoryWindow();
    runApp(const ClipboardHistoryWindow());
  } else if (args[0] == 'settings') {
  await _initSettingsWindow();
  
  // Получаем основные параметры из args
  String apiKey = args.length > 1 ? args[1] : '';
  bool useDeepSeek = args.length > 2 ? args[2].toLowerCase() == 'true' : false;
  String petName = args.length > 3 ? args[3] : 'Питомец';
  bool useVision = args.length > 4 ? args[4].toLowerCase() == 'true' : false;
  
  // Загружаем дополнительные настройки из SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Локализация
  final localizationLanguage = prefs.getString('localization_language') ?? 'Русский';
  
  // Визуализация тамагочи
  final tamagochiVisual = prefs.getString('tamagochi_visual') ?? 'assets/images/main_template0.png';
  
  // Загружаем скины окон
  final windowSkins = <String, String>{};
  final windowTypes = [
    'ChatSkin',
    'EssentialSkin',
    'ClipboardSkin',
    'EatenFilesSkin',
    'VirtualKeyboardSkin'
  ];
  
  for (var type in windowTypes) {
    final skinPath = prefs.getString('skin_$type');
    if (skinPath != null && skinPath.isNotEmpty) {
      windowSkins[type] = skinPath;
    }
  }
  
  // Загружаем цвета окон
  final windowColors = <String, Color>{};
  for (var type in windowTypes) {
    final colorValue = prefs.getInt('color_$type');
    if (colorValue != null) {
      windowColors[type] = Color(colorValue);
    } else {
      windowColors[type] = Colors.grey[800]!;
    }
  }
  
  // Загружаем горячие клавиши
  final hotkeys = <String, String>{};
  final hotkeyKeys = [
    'translate_to_english',
    'translate_to_input',
    'keyboard',
    'eaten_files',
    'chat_ai',
    'essentials',
    'clipboard',
    'ai_feed',
  ];
  
  // Функция для получения горячих клавиш по умолчанию
  String getDefaultHotkey(String key) {
    switch (key) {
      case 'translate_to_english':
        return 'ALT+Q';
      case 'translate_to_input':
        return 'ALT+W';
      case 'keyboard':
        return 'ALT+E';
      case 'eaten_files':
        return 'ALT+A';
      case 'chat_ai':
        return 'ALT+Z';
      case 'essentials':
        return 'ALT+X';
      case 'clipboard':
        return 'ALT+C';
      case 'ai_feed':
        return 'ALT+V';
      default:
        return '';
    }
  }
  
  for (var key in hotkeyKeys) {
    final hotkey = prefs.getString('hotkey_$key') ?? getDefaultHotkey(key);
    hotkeys[key] = hotkey;
  }
  
  runApp(SettingsWindowApp(
    apiKey: apiKey,
    petName: petName,
    localizationLanguage: localizationLanguage,
    tamagochiVisual: tamagochiVisual,
    windowSkins: windowSkins,
    windowColors: windowColors,
    hotkeys: hotkeys,
  ));
} else  if (args.contains('--feed-file') && args.length > 1) {
    final fileIndex = args.indexOf('--feed-file') + 1;
    if (fileIndex < args.length) {
      final filePath = args[fileIndex];
      print('Feeding file: $filePath');
    }
  }
  else {
      // Запуск основного приложения
      await _initMainWindow();
      
    }   
  } else {
    // Запуск основного приложения
    await _initMainWindow();
    
  }
}


Future<void> _initClipboardHistoryWindow() async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(400, 800), // Временный размер, потом установим точный
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    try {
      await windowManager.setAsFrameless();
    } catch (e) {
      print('Error setting frameless: $e');
    }

    try {
      await windowManager.setHasShadow(false);
    } catch (e) {
      print('Error disabling shadow: $e');
    }

    // Получаем размеры экрана через screen_retriever
    final primaryDisplay = await screenRetriever.getPrimaryDisplay();
    final screenSize = primaryDisplay.size;
    final windowHeight = screenSize.height * 0.8;

    // Устанавливаем точный размер
    await windowManager.setSize(Size(400, windowHeight));

    // Начальная позиция (за пределами экрана справа)
    final startPosition = Offset(
      screenSize.width, // Полностью за правым краем
      (screenSize.height - windowHeight) / 2,
    );

    // Конечная позиция
    final endPosition = Offset(
      screenSize.width - 405, // Правый край
      (screenSize.height - windowHeight) / 2,
    );

    // Устанавливаем начальную позицию (невидимо за экраном)
    await windowManager.setPosition(startPosition);
    await windowManager.setOpacity(0.0); // Начальная прозрачность

    // Показываем окно (но пока прозрачное и за экраном)
    await windowManager.show();

    // Анимация появления
    await _animateWindowAppearance(startPosition, endPosition);

    await windowManager.focus();

    print('Clipboard window initialized with animation');
  });
}


Future<void> _initAIWindow() async {
  await windowManager.ensureInitialized();
  await windowManager.setSize(ui.Size(1820, 940));
  await windowManager.center();
  //await windowManager.setAlwaysOnTop(true);
  await windowManager.setTitle('Квантовый мозг');
  await windowManager.show();
}



Future<void> _initMacroKeyboardWindow() async {
  await windowManager.ensureInitialized();
  await windowManager.setOpacity(0.0);
  WindowOptions windowOptions = WindowOptions(
    size: Size(420, 800), // Временный размер, потом установим точный
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    try {
      await windowManager.setAsFrameless();
    } catch (e) {
      print('Error setting frameless: $e');
    }

    try {
      await windowManager.setHasShadow(false);
    } catch (e) {
      print('Error disabling shadow: $e');
    }

    // Получаем размеры экрана через screen_retriever
    final primaryDisplay = await screenRetriever.getPrimaryDisplay();
    final screenSize = primaryDisplay.size;
    final windowHeight = screenSize.height * 0.35;
    final windowWidth = screenSize.width * 0.55;
    // Устанавливаем точный размер
    await windowManager.setSize(Size(windowWidth, windowHeight));

    // Начальная позиция (за пределами экрана справа)
    final startPosition = Offset(
      (screenSize.width - windowWidth)/2, // Полностью за правым краем
      (screenSize.height ) ,
    );

    // Конечная позиция
    final endPosition = Offset(
  (screenSize.width - windowWidth )/2, // Правый край
      (screenSize.height - windowHeight) - 50,
    );

    // Устанавливаем начальную позицию (невидимо за экраном)
    await windowManager.setPosition(startPosition);
    await windowManager.setOpacity(0.0); // Начальная прозрачность

    // Показываем окно (но пока прозрачное и за экраном)
    await windowManager.show();

    // Анимация появления
    await _animateWindowAppearanceFromBottom(startPosition, endPosition);

    await windowManager.focus();

    print('Clipboard window initialized with animation');
  });
}
Future<void> _initEssentialsWindow() async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(420, 800), // Временный размер, потом установим точный
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    try {
      await windowManager.setAsFrameless();
    } catch (e) {
      print('Error setting frameless: $e');
    }

    try {
      await windowManager.setHasShadow(false);
    } catch (e) {
      print('Error disabling shadow: $e');
    }

    // Получаем размеры экрана через screen_retriever
    final primaryDisplay = await screenRetriever.getPrimaryDisplay();
    final screenSize = primaryDisplay.size;
    final windowHeight = screenSize.height * 0.8;

    // Устанавливаем точный размер
    await windowManager.setSize(Size(420, windowHeight));

    // Начальная позиция (за пределами экрана справа)
    final startPosition = Offset(
      screenSize.width, // Полностью за правым краем
      (screenSize.height - windowHeight) / 2,
    );

    // Конечная позиция
    final endPosition = Offset(
      screenSize.width - 405, // Правый край
      (screenSize.height - windowHeight) / 2,
    );

    // Устанавливаем начальную позицию (невидимо за экраном)
    await windowManager.setPosition(startPosition);
    await windowManager.setOpacity(0.0); // Начальная прозрачность

    // Показываем окно (но пока прозрачное и за экраном)
    await windowManager.show();

    // Анимация появления
    await _animateWindowAppearance(startPosition, endPosition);

    await windowManager.focus();

    print('Clipboard window initialized with animation');
  });
}





Future<void> _animateWindowAppearanceFromBottom(Offset startPos, Offset endPos) async {
  const duration = Duration(milliseconds: 390);
  const steps = 60;
  final stepDuration = duration ~/ steps;

  for (int i = 0; i <= steps; i++) {
    final progress = i / steps;
    
    // Используем кривую для более естественной анимации
    final curvedProgress = Curves.easeOutCubic.transform(progress);
    
    final currentY = startPos.dy + (endPos.dy - startPos.dy) * curvedProgress;
    final currentPosition = Offset(startPos.dx,currentY);
    
    // Можно использовать разные кривые для прозрачности и движения
    final fadeProgress = Curves.easeOutCubic.transform(progress);
    final currentOpacity = fadeProgress;

    await windowManager.setPosition(currentPosition);
    await windowManager.setOpacity(currentOpacity);

    await Future.delayed(stepDuration);
  }

  // Финальные значения
  await windowManager.setPosition(endPos);
  await windowManager.setOpacity(1.0);
}


Future<void> _animateWindowAppearance(Offset startPos, Offset endPos) async {
  const duration = Duration(milliseconds: 390);
  const steps = 60;
  final stepDuration = duration ~/ steps;

  for (int i = 0; i <= steps; i++) {
    final progress = i / steps;
    
    // Используем кривую для более естественной анимации
    final curvedProgress = Curves.easeOutCubic.transform(progress);
    
    final currentX = startPos.dx + (endPos.dx - startPos.dx) * curvedProgress;
    final currentPosition = Offset(currentX, startPos.dy);
    
    // Можно использовать разные кривые для прозрачности и движения
    final fadeProgress = Curves.easeOutCubic.transform(progress);
    final currentOpacity = fadeProgress;

    await windowManager.setPosition(currentPosition);
    await windowManager.setOpacity(currentOpacity);

    await Future.delayed(stepDuration);
  }

  // Финальные значения
  await windowManager.setPosition(endPos);
  await windowManager.setOpacity(1.0);
}

Future<void> _animateFadeIn() async {
  const duration = Duration(milliseconds: 390);
  const steps = 60;
  final stepDuration = duration ~/ steps;

  for (int i = 0; i <= steps; i++) {
    final progress = i / steps;
    
    // Используем кривую для более естественной анимации
    final curvedProgress = Curves.easeOutCubic.transform(progress);
    
    
    // Можно использовать разные кривые для прозрачности и движения
    final fadeProgress = Curves.easeOutCubic.transform(progress);
    final currentOpacity = fadeProgress;

    await windowManager.setOpacity(currentOpacity);

    await Future.delayed(stepDuration);
  }


  await windowManager.setOpacity(1.0);
}

Future<void> _initChatWindow(List<String> args) async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(360, 700),
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    try {
      await windowManager.setAsFrameless();
    } catch (e) {
      print('Error setting frameless: $e');
    }

    try {
      await windowManager.setHasShadow(false);
    } catch (e) {
      print('Error disabling shadow: $e');
    }

    await windowManager.setSize(Size(360, 700));

    // Стартовая позиция, если передали args
    if (args.length >= 4) {
      try {
        final parentX = double.parse(args[2]);
        final parentY = double.parse(args[3]);
        final targetX = parentX - 180;
        final targetY = parentY - 650;

        final display = await screenRetriever.getPrimaryDisplay();
        final screenSize = display.size;

        final finalX = targetX.clamp(0.0, screenSize.width - 600);
        final finalY = max(targetY, 0.0);

        await windowManager.setPosition(Offset(finalX, finalY));
      } catch (e) {
        await windowManager.center();
      }
    } else {
      await windowManager.center();
    }

    await windowManager.show();
    await windowManager.focus();
  });
_animateFadeIn();
  // ======================
  // Слушатель stdin для обновления позиции
  // ======================
  
}
Future<void> _initFilesWindow() async {
    await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(800, 600), // Временный размер, потом установим точный
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    try {
      await windowManager.setAsFrameless();
    } catch (e) {
      print('Error setting frameless: $e');
    }

    try {
      await windowManager.setHasShadow(false);
    } catch (e) {
      print('Error disabling shadow: $e');
    }

    // Получаем размеры экрана через screen_retriever
    final primaryDisplay = await screenRetriever.getPrimaryDisplay();
    final screenSize = primaryDisplay.size;
    final windowHeight = screenSize.height * 0.8;

    // Устанавливаем точный размер
    await windowManager.setSize(Size(800, windowHeight));

    // Начальная позиция (за пределами экрана справа)
    final startPosition = Offset(
      screenSize.width, // Полностью за правым краем
      (screenSize.height - windowHeight) / 2,
    );

    // Конечная позиция
    final endPosition = Offset(
      screenSize.width - 805, // Правый край
      (screenSize.height - windowHeight) / 2,
    );

    // Устанавливаем начальную позицию (невидимо за экраном)
    await windowManager.setPosition(startPosition);
    await windowManager.setOpacity(0.0); // Начальная прозрачность

    // Показываем окно (но пока прозрачное и за экраном)
    await windowManager.show();

    // Анимация появления
    await _animateWindowAppearance(startPosition, endPosition);

    await windowManager.focus();
    await windowManager.setTitle('📁 Съеденные файлы');
    print('Clipboard window initialized with animation');
  });

}

Future<void> _initScreenshotWindow() async {
  await windowManager.ensureInitialized();
  final display = await screenRetriever.getPrimaryDisplay();
        final screenSize = display.size;

  await windowManager.setSize(ui.Size(screenSize.width,screenSize.height));
  await windowManager.center();
  await windowManager.setAlwaysOnTop(true);
  await windowManager.setTitle('📁 Screenshoter');
  await windowManager.show();
}
Future<void> _initSettingsWindow() async {
     await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1000, 1000), // Временный размер, потом установим точный
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: false,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    try {
      await windowManager.setAsFrameless();
    } catch (e) {
      print('Error setting frameless: $e');
    }

    try {
      await windowManager.setHasShadow(false);
    } catch (e) {
      print('Error disabling shadow: $e');
    }

    // Получаем размеры экрана через screen_retriever
    final primaryDisplay = await screenRetriever.getPrimaryDisplay();
    final screenSize = primaryDisplay.size;
    final windowHeight = screenSize.height * 0.9;
    final windowWidth = screenSize.width * 0.8;

    // Устанавливаем точный размер
    await windowManager.setSize(Size(windowWidth, windowHeight));

    // Начальная позиция (за пределами экрана справа)
    final startPosition = Offset(
      screenSize.width, // Полностью за правым краем
      (screenSize.height - windowHeight) / 2,
    );

    // Конечная позиция
    final endPosition = Offset(
      screenSize.width - windowWidth -5, // Правый край
      (screenSize.height - windowHeight) / 2,
    );

    // Устанавливаем начальную позицию (невидимо за экраном)
    await windowManager.setPosition(startPosition);
    await windowManager.setOpacity(0.0); // Начальная прозрачность

    // Показываем окно (но пока прозрачное и за экраном)
    await windowManager.show();

    // Анимация появления
    await _animateWindowAppearance(startPosition, endPosition);

    await windowManager.focus();
    await windowManager.setTitle('Settings');
    print('Clipboard window initialized with animation');
  });

}


Future<void> _initMainWindow() async {

  
  await windowManager.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final firstRun = prefs.getBool('first_run') ?? true;
  
  // Получаем размер экрана
  final display = await screenRetriever.getPrimaryDisplay();
  final screenSize = display.size;
  
  final windowWidth = firstRun ? 400.0 : 260.0;
  final windowHeight = firstRun ? 500.0 : 270.0;

  WindowOptions windowOptions = WindowOptions(
    size: ui.Size(windowWidth, windowHeight),
    backgroundColor: Colors.transparent,
    skipTaskbar: firstRun ? false : true, // Для первого запуска показываем в таскбаре
    titleBarStyle: firstRun ? TitleBarStyle.normal : TitleBarStyle.hidden,
    windowButtonVisibility: firstRun, // Кнопки только при первом запуске
    alwaysOnTop: !firstRun, // Всегда поверх других только не при первом запуске
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    if (firstRun) {
      // Для первого запуска - обычное окно по центру
      // Не frameless
      await windowManager.setAsFrameless();
      await windowManager.center(); // ✅ ПО ЦЕНТРУ ЭКРАНА
    
    } else {
      // Для последующих запусков - frameless окно в правом нижнем углу
      await windowManager.setAsFrameless();
      await windowManager.setAlwaysOnTop(true);
      await windowManager.setSkipTaskbar(true);
      await windowManager.setPosition(Offset(
        screenSize.width - windowWidth - 15, // right: 15
        screenSize.height - windowHeight - 110, // bottom: 150
      ));
    }
    if (Platform.isWindows) {
  // Настройка прозрачности и кликов
  windowManager.setIgnoreMouseEvents(false); // Разрешаем обработку мыши
  // Убедитесь, что фон окна прозрачный
}
    await windowManager.setTitle('ImeYou Tamagochi');
    await windowManager.setSize(ui.Size(windowWidth, windowHeight));
    await windowManager.show();
  });
  final clipboardMonitor = ClipboardMonitor();
  await clipboardMonitor.initialize();
  WindowManager.returnTo80x80Clickable();

  runApp(MaterialApp(
    home: firstRun ? NameInputScreen() : TamagochiOverlay(),
    debugShowCheckedModeBanner: false,
  ));
}


class ChatWindowApp extends StatelessWidget {
  final List<Map<String, String>> initialChatHistory;
  final String chatName;

  const ChatWindowApp({Key? key, required this.initialChatHistory, this.chatName = 'Small talk'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: ChatWindowContent(
          initialChatHistory: initialChatHistory,
          initialChatName: chatName,
        ),
      ),
    );
  }
}

class ChatWindowContent extends StatefulWidget {
  final List<Map<String, String>> initialChatHistory;
  final String initialChatName;

  const ChatWindowContent({Key? key, required this.initialChatHistory, required this.initialChatName}) : super(key: key);

  @override
  _ChatWindowContentState createState() => _ChatWindowContentState();
}

class _ChatWindowContentState extends State<ChatWindowContent> {
  final List<ChatMessage> _chatHistory = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _apiKey = '';
  bool _useDeepSeek = true;
  FocusNode _textFieldFocusNode = FocusNode();
  bool _isSearchMode = false;
  String _searchQuery = '';
  List<ChatMessage> _filteredChatHistory = [];
  bool _showFavorites = false;
  String _currentChatName = 'Small talk';
  List<String> _availableChats = ['Small talk'];
  Map<String, List<ChatMessage>> _chatHistories = {};
  Map<String, String> _chatFiles = {};
  bool _isRecording = false;
  stt.SpeechToText _speechToText = stt.SpeechToText();
  String _recognizedText = '';
  bool _searchWeb = true;
  bool _searchImages = false;
  bool _searchWiki = false;
  String _replyingTo = '';
  File? _backgroundImage;
  final Map<String, List<String>> _searchResults = {};
  final Map<String, List<Map<String, String>>> _imageResults = {};
  final Map<String, String> _wikiResults = {};
  bool _chatLocked = false;
  Timer? _directoryCheckTimer;
  int _hoveredMessageIndex = -1;
  String _defaultLanguage='ru';
  final _httpClient = http.Client();

 EncryptionService1? service ;
  Localization _locale = Localization();
   static Future<String> getCurrentInputLanguage() async {
      const MethodChannel _channel = 
      MethodChannel('screenshot_channel');

    try {
      final String languageCode = 
          await _channel.invokeMethod('getCurrentInputLanguage');
      return languageCode;
    } on PlatformException catch (e) {
      print("Ошибка получения языка ввода: ${e.message}");
      return 'en'; // Язык по умолчанию при ошибке
    }
  }

Future<void> _translateTextToDefaultLanguage() async {

  final targetLanguage =  await getCurrentInputLanguage();
  await _translateText(targetLanguage);
}

Future<void> _translateTextToEnglishLanguage() async {
  await _translateText('en');
}

Future<void> _translateText(String targetLanguage) async {
  final text = _messageController.text.trim();
  if (text.isEmpty) {
    //_showMessage('Нет текста для перевода');
    return;
  }

  try {
   

    // Определяем исходный язык
    final sourceLanguage = await _detectLanguage(text);
    
    // Если исходный язык уже целевой - не переводим
    if (sourceLanguage == targetLanguage) {
      //_showMessage('Текст уже на целевом языке');
      return;
    }

    // Пробуем разные API переводчиков
    String translatedText = await _translateWithLibreTranslate(text, sourceLanguage, targetLanguage);
    
    if (translatedText.isEmpty) {
      translatedText = await _translateWithMyMemory(text, sourceLanguage, targetLanguage);
    }

    if (translatedText.isNotEmpty) {
      setState(() {
        _messageController.text = translatedText;
      });
      //_showMessage('Текст переведен');
    } else {
      //_showMessage('Не удалось выполнить перевод');
    }
    
  } catch (e) {
    //_showMessage('Ошибка перевода: $e');
  } finally {
    setState(() {
      //_isProcessing = false;
    });
  }
}

void _setupKeyboardListener() {
  RawKeyboard.instance.addListener((RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final isControlPressed = event.isControlPressed;
            
      // Проверяем все возможные Enter клавиши
      final isEnterPressed = 
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter;
      
      if (isControlPressed && isEnterPressed) {
        _handleCtrlEnter();
        return; // Прерываем дальнейшую обработку
      }
      
      if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyQ) {
        _translateTextToDefaultLanguage(); // Обновлено
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyW) {
        _translateTextToEnglishLanguage(); // Обновлено
      }
    }
  });
}


void _handleCtrlEnter(){

   _sendMessage();
}
// Бесплатный API LibreTranslate
Future<String> _translateWithLibreTranslate(String text, String from, String to) async {
  try {
    final response = await _httpClient.post(
      Uri.parse('https://libretranslate.de/translate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'source': from,
        'target': to,
        'format': 'text'
      }),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['translatedText'] ?? '';
    }
  } catch (e) {
    print('LibreTranslate error: $e');
  }
  return '';
}

// Резервный API MyMemory
Future<String> _translateWithMyMemory(String text, String from, String to) async {
  try {
    final response = await _httpClient.get(
      Uri.parse('https://api.mymemory.translated.net/get?'
          'q=${Uri.encodeComponent(text)}&'
          'langpair=$from|$to'),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['responseData']['translatedText'] ?? '';
    }
  } catch (e) {
    print('MyMemory error: $e');
  }
  return '';
}

Future<String> _detectLanguage(String text) async {
  try {
    // Простая эвристика для определения языка
    return _detectLanguageBasic(text);
    
    // Для более точного определения можно использовать API (раскомментировать при необходимости)
    // return await _detectLanguageWithAPI(text);
  } catch (e) {
    return _detectLanguageBasic(text);
  }
}

// API определение языка (раскомментировать при необходимости)
/*
Future<String> _detectLanguageWithAPI(String text) async {
  try {
    final response = await _httpClient.post(
      Uri.parse('https://libretranslate.de/detect'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'q': text}),
    ).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['language'] ?? 'en';
      }
    }
  } catch (e) {
    print('Language detection API error: $e');
  }
  return _detectLanguageBasic(text);
}
*/

String _detectLanguageBasic(String text) {
  // Улучшенная эвристика для определения языка
  final russianRegex = RegExp(r'[а-яА-ЯёЁ]');
  final englishRegex = RegExp(r'[a-zA-Z]');
  final koreanRegex = RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]');
  final chineseRegex = RegExp(r'[\u4e00-\u9fff]');
  final japaneseRegex = RegExp(r'[\u3040-\u309F\u30A0-\u30FF]');
  
  // Подсчет символов разных языков
  int russianCount = russianRegex.allMatches(text).length;
  int englishCount = englishRegex.allMatches(text).length;
  int koreanCount = koreanRegex.allMatches(text).length;
  int chineseCount = chineseRegex.allMatches(text).length;
  int japaneseCount = japaneseRegex.allMatches(text).length;
  
  // Определяем язык по преобладающим символам
  if (russianCount > 0 && russianCount > englishCount) return 'ru';
  if (koreanCount > 0) return 'ko';
  if (chineseCount > 0) return 'zh';
  if (japaneseCount > 0) return 'ja';
  if (englishCount > 0) return 'en';
  
  return 'en'; // По умолчанию английский
}


  @override
  void initState() {
    super.initState();
    _locale.init();
    _loadAllChats().then((_) {
      setState(() {
        _currentChatName = widget.initialChatName;
        if (_chatHistories.containsKey(_currentChatName)) {
          _chatHistory.addAll(_chatHistories[_currentChatName]!);
        } else {
          _chatHistory.addAll(widget.initialChatHistory.map((msg) => ChatMessage.fromMap(msg)));
        }
        
        if (_chatHistory.isEmpty && _currentChatName == 'Small talk') {
          _chatHistory.add(ChatMessage(
            type: 'ai',
            message: 'Привет! Как дела? Чем могу помочь?',
            timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
            starred: false,
            chatName: 'Small talk'
          ));
        }
      });
      _scrollToBottom();
    });
    
    
    _loadSavedData();
    _initSpeechToText();
    _loadBackgroundImage();
    _startDirectoryWatcher();
    _initListenerStd();
    _startServer();
     _setupKeyboardListener();
  }
 Future<void> _imReady() async {
  try {
    // Добавляем задержку 1500 мс
    await Future.delayed(const Duration(milliseconds: 300));
    await windowManager.focus();
      if (!_textFieldFocusNode.hasFocus) {
    _textFieldFocusNode.requestFocus();
  }
    final socket = await Socket.connect('localhost', 8082);
    // Явно кодируем в UTF-8
    final encodedData = utf8.encode("chat is ready");
    socket.add(encodedData);
    await socket.flush();
    socket.destroy();
  } catch (e) {
    print('Error sending data: $e');
  }
}
  void _initListenerStd(){
  // Текущие координаты окна
  double currentX = 0;
  double currentY = 0;
  
  stdin.transform(utf8.decoder).transform(const LineSplitter()).listen((line) async {
    try {
      final parts = line.trim().split(',');
      if (parts.length == 2) {
        final targetX = double.tryParse(parts[0]) ?? 0;
        final targetY = double.tryParse(parts[1]) ?? 0;
        
        final dx = targetX - 45;
        final dy = targetY - 625;
        
        // Запускаем плавную анимацию
        await _smoothMove(currentX, currentY, dx, dy, 50);
        
        // Обновляем текущие координаты
        currentX = dx;
        currentY = dy;
      }
    } catch (e) {
      print('Error parsing position from stdin: $e');
    }
  });
}

Future<void> _smoothMove(double startX, double startY, double targetX, double targetY, int durationMs) async {
  const int frames = 8; // Количество кадров анимации
  const double frameDuration = 50 / 8; // ~6.25ms на кадр
  
  for (int i = 1; i <= frames; i++) {
    // Вычисляем прогресс анимации (0.0 - 1.0)
    double progress = i / frames;
    
    // Используем линейную интерполяцию
    double currentX = startX + (targetX - startX) * progress;
    double currentY = startY + (targetY - startY) * progress;
    
    // Устанавливаем только позицию окна (без изменения размера)
    await windowManager.setPosition(Offset(currentX, currentY));
    
    // Ждем перед следующим кадром
    await Future.delayed(Duration(milliseconds: frameDuration.round()));
  }
  
  // Финальная позиция для точности
  await windowManager.setPosition(Offset(targetX, targetY));
}

Future<void> _startServer() async {
  final server = await ServerSocket.bind('localhost', 8080);
  print('Server listening on port 8080');

  server.listen((Socket socket) {
    final List<int> dataBuffer = [];
    
    socket.listen(
      (List<int> data) {
        dataBuffer.addAll(data);
      },
      onDone: () {
        // Декодируем все полученные данные как UTF-8
        final String receivedString = utf8.decode(dataBuffer);
        _putIntoInput(receivedString);
      },
      onError: (error) {
        print('Socket error: $error');
      }
    );
  });

  await _imReady();
}
void _putIntoInput(String clipboardtext) {

  
  // Убедимся, что текстовое поле получает фокус
  if (!_textFieldFocusNode.hasFocus) {
    _textFieldFocusNode.requestFocus();
  }
  
  final currentText = _messageController.text;
  
  String newText;
  int newPosition;
  
  // Если текстовое поле не в фокусе или нет активного выделения,
  // просто добавляем текст в конец
  if (!_textFieldFocusNode.hasFocus || _messageController.selection.baseOffset == -1) {
    newText = currentText + clipboardtext;
    newPosition = newText.length;
  } else {
    final selection = _messageController.selection;
    
    if (selection.start == selection.end) {
      // Курсор без выделения - вставляем в позицию курсора
      final before = currentText.substring(0, selection.start);
      final after = currentText.substring(selection.end);
      newText = '$before$clipboardtext$after';
      newPosition = selection.start + clipboardtext.length;
    } else {
      // Есть выделенный текст - заменяем его
      final before = currentText.substring(0, selection.start);
      final after = currentText.substring(selection.end);
      newText = '$before$clipboardtext$after';
      newPosition = selection.start + clipboardtext.length;
    }
  }
  
  // Используем setValue для полного обновления контроллера
  _messageController.value = TextEditingValue(
    text: newText,
    selection: TextSelection.collapsed(offset: newPosition),
  );
  
  // Убедимся, что фокус установлен
  _textFieldFocusNode.requestFocus();
  setState(() {}); // Обновляем высоту
}
  void _startDirectoryWatcher() {
    _directoryCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await _checkForNewFiles();
    });
  }

  Future<void> _checkForNewFiles() async {
    await _loadAllChats();
  }

  Future<void> _loadAllChats() async {
    service = await EncryptionService1.create();
    final directory = await getApplicationDocumentsDirectory();
    final chatsDir = Directory('${directory.path}/imeyou_pet/chats');
    
    if (!chatsDir.existsSync()) {
      chatsDir.createSync(recursive: true);
      return;
    }

    var chatFolders = chatsDir.listSync();
    List<String> chats = ['${_locale.get("newChat")}'];
    Map<String, List<ChatMessage>> allChats = {};

    for (var folder in chatFolders) {
      if (folder is Directory) {
        String chatName = path.basename(folder.path);
        if (chatName != '${_locale.get("newChat")}') {
          chats.add(chatName);
          allChats[chatName] = await _loadChatHistory(chatName);
        }
      }
    }

    setState(() {
      _availableChats = chats;
      _chatHistories = allChats;
    });
  }

  Future<List<ChatMessage>> _loadChatHistory(String chatName) async {
    final directory = await getApplicationDocumentsDirectory();
    final chatDir = Directory('${directory.path}/imeyou_pet/chats/$chatName');
    List<ChatMessage> history = [];

    if (chatDir.existsSync()) {
      var messageFiles = chatDir.listSync();
      
      // Сортируем файлы по timestamp
      messageFiles.sort((a, b) {
        String nameA = path.basename(a.path);
        String nameB = path.basename(b.path);
        return nameA.compareTo(nameB);
      });

      for (var file in messageFiles) {
        if (file is File && file.path.endsWith('.json')) {
          try {
            String content = await file.readAsString();
             if( (content.startsWith("{")&& content.endsWith("}"))){continue;}
            final decrypted = await service!.decryptData(content);
            if( !(decrypted.startsWith("{")&& decrypted.endsWith("}"))){continue;}
            Map<String, dynamic> messageData = json.decode(decrypted);
            history.add(ChatMessage(
              type: messageData['source'] ?? messageData['type'] ?? 'user',
              message: messageData['text'] ?? messageData['message'] ?? '',
              timestamp: messageData['timestamp'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
              starred: messageData['starred'] == true || messageData['starred'] == 'true',
              chatName: chatName,
              searchResults: List<String>.from(messageData['searchResults'] ?? []),
              imageResults: List<Map<String, String>>.from(messageData['imageResults'] ?? []),
              wikiResult: messageData['wikiResult'] ?? ''
            ));
          } catch (e) {
            print('Ошибка чтения файла ${file.path}: $e');
          }
        }
      }
    }
    return history;
  }

  Future<void> _saveMessageToChat(ChatMessage message) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final chatDir = Directory('${directory.path}/imeyou_pet/chats/${message.chatName}');
      
      if (!chatDir.existsSync()) {
        chatDir.createSync(recursive: true);
      }
      
      String timestamp = message.timestamp;
      String sourcePrefix = message.type.toLowerCase() == 'ai' ? 'ai' : 'user';
      String fileName = '${timestamp}_$sourcePrefix.json';
      
      final messageFile = File('${chatDir.path}/$fileName');
       final encrypted = await service!.encryptData(json.encode(message.toMap()));

      await messageFile.writeAsString(encrypted);
      
    } catch (e) {
      print('Error saving message: $e');
    }
  }

  void _initSpeechToText() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      print("Speech to text not available");
    }
  }

  void _loadBackgroundImage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final bgDir = Directory('${directory.path}/imeyou_pet/widget_backgrounds');
      
      if (bgDir.existsSync()) {
        final configFile = File('${bgDir.path}/current_chat_bg.json');
        if (configFile.existsSync()) {
          final jsonString = await configFile.readAsString();
          final configData = json.decode(jsonString);
          final bgPath = configData['current_bg'];
          
          if (bgPath != null && File(bgPath).existsSync()) {
            setState(() {
              _backgroundImage = File(bgPath);
            });
            return;
          }
        }
        
        final files = bgDir.listSync();
        for (var file in files) {
          if (file.path.endsWith('chat_skin.png') || file.path.endsWith('chat_skin.jpg')) {
            setState(() {
              _backgroundImage = File(file.path);
            });
            break;
          }
        }
      }
    } catch (e) {
      print('Error loading background: $e');
    }
  }

  void _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _apiKey = prefs.getString('api_key') ?? '';
        _useDeepSeek = prefs.getBool('use_deepseek') ?? true;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    if (_chatLocked) return;
    
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final userMessage = ChatMessage(
      type: 'user',
      message: message,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      starred: false,
      chatName: _currentChatName
    );
    
    setState(() {
      _chatHistory.add(userMessage);
      _messageController.clear();
      _replyingTo = '';
    });
    
    await _saveMessageToChat(userMessage);
    _scrollToBottom();

    if (_apiKey.isNotEmpty) {
      await _callAIAPI(message);
    }

    if (_searchWeb || _searchImages || _searchWiki) {
      await _performSearches(message);
    }
  }

  Future<void> _callAIAPI(String prompt) async {
    try {
      List<Map<String, dynamic>> messages = [];
      int startIndex = max(0, _chatHistory.length - 100);
      
      for (int i = startIndex; i < _chatHistory.length; i++) {
        var msg = _chatHistory[i];
        messages.add({
          "role": msg.type == 'user' ? "user" : "assistant",
          "content": msg.message
        });
      }

      messages.add({"role": "user", "content": prompt});

      var response = await http.post(
        Uri.parse('https://api.deepseek.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'deepseek-chat',
          'messages': messages,
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String aiResponse = data['choices'][0]['message']['content'];
        
        if (_currentChatName == 'Новый чат' && aiResponse.contains('<chatname>')) {
          RegExp exp = RegExp(r'<chatname>(.*?)</chatname>');
          Match? match = exp.firstMatch(aiResponse);
          if (match != null) {
            String newChatName = match.group(1)!;
            setState(() {
              _currentChatName = newChatName;
              _availableChats = [_availableChats[0], 'Small talk', newChatName];
            });
            aiResponse = aiResponse.replaceAll(exp, '').trim();
          }
        }

        if (aiResponse.toLowerCase().contains('закрытие чата') || 
            aiResponse.toLowerCase().contains('chat closed')) {
          setState(() {
            _chatLocked = true;
          });
        }

        final aiMessage = ChatMessage(
          type: 'ai',
          message: aiResponse,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
          starred: false,
          chatName: _currentChatName
        );
        
        setState(() {
          _chatHistory.add(aiMessage);
        });
        
        await _saveMessageToChat(aiMessage);
        _scrollToBottom();
      }
    } catch (e) {
      print('Error calling AI API: $e');
      // Fallback сообщение
      final fallbackMessage = ChatMessage(
        type: 'ai',
        message: '${_locale.get("chatErrorCheckTokens")}',
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        starred: false,
        chatName: _currentChatName
      );
      
      setState(() {
        _chatHistory.add(fallbackMessage);
      });
      await _saveMessageToChat(fallbackMessage);
      _scrollToBottom();
    }
  }

  Future<void> _performSearches(String query) async {
    if (_searchWeb) {
      await _searchWebResults(query);
    }
    if (_searchImages) {
      await _searchImagesResults(query);
    }
    if (_searchWiki && query.split(' ').length < 10) {
      await _searchWikiResults(query);
    }
  }

  Future<void> _searchWebResults(String query) async {
    // Mock web search results
    final results = [
      'https://example.com/result1',
      'https://example.com/result2',
      'https://example.com/result3',
    ];
    
    if (_chatHistory.isNotEmpty) {
      final lastMessage = _chatHistory.last;
      lastMessage.searchResults = results;
      await _saveMessageToChat(lastMessage);
    }
  }

  Future<void> _searchImagesResults(String query) async {
    // Mock image results
    final results = [];
    for (int i = 0; i < 9; i++) {
      results.add({
        'url': 'https://example.com/image$i.jpg',
        'thumbnail': 'https://example.com/thumb$i.jpg',
        'title': 'Result ${i + 1}'
      });
    }
    
    if (_chatHistory.isNotEmpty) {
      final lastMessage = _chatHistory.last;
      lastMessage.imageResults = List<Map<String, String>>.from(results);
      await _saveMessageToChat(lastMessage);
    }
  }

  Future<void> _searchWikiResults(String query) async {
    // Mock wiki result
    final result = '${_locale.get("wikiOutput")}';
    
    if (_chatHistory.isNotEmpty) {
      final lastMessage = _chatHistory.last;
      lastMessage.wikiResult = result;
      await _saveMessageToChat(lastMessage);
    }
  }

  void _removeMessage(int index) async {
    if (index >= 0 && index < _chatHistory.length) {
      final message = _chatHistory[index];
      setState(() {
        _chatHistory.removeAt(index);
      });
      // Удаляем файл сообщения
      final directory = await getApplicationDocumentsDirectory();
      final chatDir = Directory('${directory.path}/imeyou_pet/chats/${message.chatName}');
      if (chatDir.existsSync()) {
        final files = chatDir.listSync();
        for (var file in files) {
          if (file is File && file.path.endsWith('.json')) {
            try {
              String content = await file.readAsString();
              Map<String, dynamic> messageData = json.decode(content);
              if (messageData['timestamp'] == message.timestamp) {
                file.deleteSync();
                break;
              }
            } catch (e) {
              print('Error deleting message file: $e');
            }
          }
        }
      }
    }
  }

  void _toggleStar(int index) async {
    if (index >= 0 && index < _chatHistory.length) {
      setState(() {
        _chatHistory[index].starred = !_chatHistory[index].starred;
      });
      await _saveMessageToChat(_chatHistory[index]);
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_locale.get("copiedToClipboard")}')),
    );
  }

  void _setReply(String message) {
    setState(() {
      _replyingTo = message;
    });
  }

  void _clearChat() {
    setState(() {
      _chatHistory.removeWhere((msg) => !msg.starred);
    });
  }

 void _startRecording() async {
  if (_isRecording) return;
  
  if (await _speechToText.initialize()) {
    setState(() {
      _isRecording = true;
      _recognizedText = '';
    });
    
    _speechToText.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
          _messageController.text = _recognizedText;
        });
      },
    );
  }
}

void _stopRecording() {
  _speechToText.stop();
  setState(() {
    _isRecording = false;
  });
}

  void _handleFileDrop(List<File> files) {
    if (files.isNotEmpty) {
      _analyzeFile(files.first.path);
    }
  }

  void _handleBackgroundImageDrop(List<File> files) async {
    if (files.isNotEmpty && (files.first.path.endsWith('.png') || files.first.path.endsWith('.jpg'))) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final bgDir = Directory('${directory.path}/imeyou_pet/widget_backgrounds');
        if (!bgDir.existsSync()) {
          bgDir.createSync(recursive: true);
        }
        
        final newFile = File('${bgDir.path}/chat_skin${path.extension(files.first.path)}');
        await newFile.writeAsBytes(await files.first.readAsBytes());
        
        final configFile = File('${bgDir.path}/current_chat_bg.json');
        final configData = {
          'current_bg': newFile.path
        };
        await configFile.writeAsString(json.encode(configData));
        
        print('Background saved: ${newFile.path}');
        _loadBackgroundImage();
        
      } catch (e) {
        print('Error setting background: $e');
      }
    }
  }

  void _analyzeFile(String filePath) async {
    final fileName = path.basename(filePath);
    final fileExtension = path.extension(filePath).toLowerCase();
    final fileSize = File(filePath).lengthSync();

    String fileMetadata = await _extractFileMetadata(filePath);

    String analysisPrompt = '''
${_locale.get("promptAnalyzeFile")}: $fileName
${_locale.get("path")}: $filePath
${_locale.get("size")}: ${fileSize ~/ 1024} KB
${_locale.get("extension")}: $fileExtension
$fileMetadata

${_locale.get("promptForAnalyze")}
''';

    setState(() {
      _chatHistory.add(ChatMessage(
        type: 'ai',
        message: '📁 ${_locale.get("fileAnalyzeAnswerP1")}: $fileName\n${_locale.get("isFileOfType")} $fileExtension. ${_locale.get("probably")}: ${_guessFileType(fileExtension)}',
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        starred: false,
        chatName: _currentChatName
      ));
    });
    _saveFileResponse(filePath, "Mock analysis response");
  }

  String _guessFileType(String extension) {
    switch (extension) {
      case '.txt': return 'Текстовый файл';
      case '.pdf': return 'PDF документ';
      case '.jpg': case '.png': return 'Изображение';
      case '.mp3': return 'Аудио файл';
      case '.mp4': return 'Видео файл';
      default: return 'Неизвестный тип файла';
    }
  }

  Future<String> _extractFileMetadata(String filePath) async {
    final file = File(filePath);
    final stat = await file.stat();
    return 'Создан: ${stat.modified}\nРазмер: ${stat.size} байт';
  }

  Future<void> _saveFileResponse(String filePath, String response) async {
    final directory = await getApplicationDocumentsDirectory();
    final responsesDir = Directory('${directory.path}/imeyou_pet/file_responses');
    if (!responsesDir.existsSync()) {
      responsesDir.createSync(recursive: true);
    }
    
    final responseFile = File('${responsesDir.path}/${path.basename(filePath)}.response.txt');
    await responseFile.writeAsString(response);
  }

  void _createNewChat() {
    setState(() {
      _currentChatName = '${_locale.get("newChat")}';
      _chatHistory.clear();
      _chatLocked = false;
    });
  }

  void _switchChat(String chatName) {
    if (chatName == '${_locale.get("newChat")}') {
      _createNewChat();
      return;
    }
    
    setState(() {
      _currentChatName = chatName;
      _chatHistory.clear();
      if (_chatHistories.containsKey(chatName)) {
        _chatHistory.addAll(_chatHistories[chatName]!);
      }
      _chatLocked = false;
    });
  }

  void _filterMessages() {
    if (_isSearchMode && _searchQuery.isNotEmpty) {
      _filteredChatHistory = _searchAcrossAllChats(_searchQuery);
    } else if (_showFavorites) {
      _filteredChatHistory = _getAllStarredMessages();
    } else {
      _filteredChatHistory = List.from(_chatHistory);
    }
  }

  List<ChatMessage> _getAllStarredMessages() {
    List<ChatMessage> allStarred = [];
    for (var chat in _chatHistories.values) {
      allStarred.addAll(chat.where((msg) => msg.starred));
    }
    // Сортируем по времени (новые сверху)
    allStarred.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return allStarred;
  }

  List<ChatMessage> _searchAcrossAllChats(String query) {
    List<ChatMessage> allMessages = [];
    for (var chat in _chatHistories.values) {
      allMessages.addAll(chat);
    }
    allMessages.addAll(_chatHistory); // Добавляем текущие сообщения

    return _filterSearchResults(allMessages, query);
  }

  List<ChatMessage> _filterSearchResults(List<ChatMessage> messages, String query) {
    final queryLower = query.toLowerCase().trim();
    
    if (queryLower.isEmpty) {
      return messages;
    }

    final queryWords = queryLower.split(RegExp(r'\s+')).where((word) => word.length > 1).toList();
    
    if (queryWords.length <= 1) {
      return messages.where((msg) {
        final content = msg.message.toLowerCase();
        return content.contains(queryLower);
      }).toList();
    } else {
      final List<Map<String, dynamic>> resultsWithScore = [];
      
      for (final message in messages) {
        final content = message.message.toLowerCase();
        
        double score = 0.0;
        int foundWords = 0;
        
        for (final word in queryWords) {
          bool wordFound = false;
          
          final wordVariations = _getWordVariations(word);
          for (final variation in wordVariations) {
            if (content.contains(variation)) {
              score += variation == word ? 3.0 : 2.5;
              wordFound = true;
              break;
            }
          }
          
          if (!wordFound) {
            final wordPattern = RegExp(r'\b' + word);
            if (wordPattern.hasMatch(content)) {
              score += 2.0;
              wordFound = true;
            }
          }
          
          if (wordFound) foundWords++;
        }
        
        if (foundWords == queryWords.length) {
          score += 5.0;
        }
        
        if (message.starred) {
          score += 2.0;
        }
        
        final lengthPenalty = content.length > 200 ? content.length / 1000.0 : 0.0;
        score -= lengthPenalty;
        
        if (content.contains(queryLower)) {
          score += 4.0;
        }
        
        if (content.startsWith(queryLower)) {
          score += 3.0;
        }
        
        // Бонус за новые сообщения
        final ageBonus = _calculateAgeBonus(message.timestamp);
        score += ageBonus;
        
        if (foundWords > 0) {
          resultsWithScore.add({
            'message': message,
            'score': score,
            'foundWords': foundWords,
            'contentLength': content.length,
          });
        }
      }
      
      resultsWithScore.sort((a, b) {
        final double scoreA = a['score'] as double;
        final double scoreB = b['score'] as double;
        
        if (scoreB > scoreA) return 1;
        if (scoreB < scoreA) return -1;
        
        final int wordsA = a['foundWords'] as int;
        final int wordsB = b['foundWords'] as int;
        if (wordsB > wordsA) return 1;
        if (wordsB < wordsA) return -1;
        
        final int lengthA = a['contentLength'] as int;
        final int lengthB = b['contentLength'] as int;
        return lengthA.compareTo(lengthB);
      });
      
      return resultsWithScore.map((e) => e['message'] as ChatMessage).toList();
    }
  }

  double _calculateAgeBonus(String timestamp) {
    try {
      final messageTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      final now = DateTime.now();
      final difference = now.difference(messageTime);
      
      if (difference.inDays == 0) return 3.0; // Сегодня
      if (difference.inDays <= 7) return 2.0; // На этой неделе
      if (difference.inDays <= 30) return 1.0; // В этом месяце
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  List<String> _getWordVariations(String word) {
    final variations = <String>[];
    variations.add(word);
    
    if (word.length > 3) {
      if (word.endsWith('а')) {
        variations.add(word.substring(0, word.length - 1));
      }
      if (word.endsWith('я')) {
        variations.add(word.substring(0, word.length - 1));
      }
      if (word.endsWith('о')) {
        variations.add(word.substring(0, word.length - 1));
      }
      if (word.endsWith('ы')) {
        variations.add(word.substring(0, word.length - 1));
      }
      if (word.endsWith('и')) {
        variations.add(word.substring(0, word.length - 1));
      }
    }
    
    return variations;
  }

  Widget _buildMessageBubble(ChatMessage chat, int index) {
    final isAI = chat.type == 'ai';
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredMessageIndex = index),
      onExit: (_) => setState(() => _hoveredMessageIndex = -1),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: isAI ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                if (isAI) ...[
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFF2B2B2B).withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.android, size: 16, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                ],
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isAI 
                        ? Color(0xFF2B2B2B).withOpacity(0.8)
                        : Color(0xFF2B2B2B).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.message,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        ..._buildConditionalWidgets(chat),
                      ],
                    ),
                  ),
                ),
                if (!isAI) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFF2B2B2B).withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                ],
              ],
            ),
            
            // Кнопки появляются только при ховере
            if (_hoveredMessageIndex == index)
              Container(
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isAI) SizedBox(width: 32),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _toggleStar(index),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              chat.starred ? Icons.star : Icons.star_border,
                              size: 16,
                              color: chat.starred ? Colors.yellow : Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _copyToClipboard(chat.message),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.content_copy, size: 16, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _setReply(chat.message),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.reply, size: 16, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _removeMessage(index),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.delete, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConditionalWidgets(ChatMessage chat) {
    final List<Widget> widgets = [];
    
    if (chat.type == 'ai' && chat.searchResults.isNotEmpty) {
      widgets.addAll([
        SizedBox(height: 8),
        _buildSearchResults(chat.searchResults),
      ]);
    }
    
    if (chat.type == 'ai' && chat.imageResults.isNotEmpty) {
      widgets.addAll([
        SizedBox(height: 8),
        _buildImageGrid(chat.imageResults),
      ]);
    }
    
    if (chat.type == 'ai' && chat.wikiResult.isNotEmpty) {
      widgets.addAll([
        SizedBox(height: 8),
        _buildWikiWidget(chat.wikiResult),
      ]);
    }
    
    return widgets;
  }

  Widget _buildSearchResults(List<String> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${_locale.get("searchResult")}:', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ...results.map((url) => GestureDetector(
          onTap: () => launch(url),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                margin: EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  url,
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildImageGrid(List<Map<String, String>> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: min(images.length, 9),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[800],
          ),
          child: Center(
            child: Text(
              'Image ${index + 1}',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWikiWidget(String wikiText) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.article, size: 16, color: Colors.white),
              SizedBox(width: 4),
              Text('Wikipedia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 4),
          Text(
            wikiText,
            style: TextStyle(color: Colors.white, fontSize: 12),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  _filterMessages();
  
  return Material(
    color: Colors.transparent,
    child: Stack(
      children: [
        if (_backgroundImage != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(_backgroundImage!),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        
        Container(
          color: Colors.transparent,
          child: Column(
            children: [
              // Header (фиксированная высота)
              Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 12),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: _currentChatName,
                        dropdownColor: Color(0xFF2B2B2B),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        underline: Container(),
                        onChanged: (String? newValue) {
                          if (newValue != null) _switchChat(newValue);
                        },
                        items: _availableChats.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 600),
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_chatLocked)
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          '${_locale.get("chatLocked")}',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _clearChat,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_locale.get("clearChat")}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => windowManager.close(),
                        child: Icon(Icons.close, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // Tabs (фиксированная высота)
              Container(
                height: 30,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _showFavorites = false;
                          _isSearchMode = false;
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !_showFavorites && !_isSearchMode 
                              ? Colors.blue.withOpacity(0.3) 
                              : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              '${_locale.get("allMessages")}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _showFavorites = true;
                          _isSearchMode = false;
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _showFavorites 
                              ? Colors.blue.withOpacity(0.3) 
                              : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              '${_locale.get("favorite")}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Reply widget (фиксированная высота при наличии)
              if (_replyingTo.isNotEmpty)
                Container(
                  height: 40, // фиксированная высота
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.reply, size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _replyingTo,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _replyingTo = ''),
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),

              // Гибкая область для истории сообщений и поля ввода
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Вычисляем высоту поля ввода
                    final double inputHeight = _calculateInputHeight();
                    // Высота истории сообщений = общая высота - высота поля ввода
                    final double chatHistoryHeight = constraints.maxHeight - inputHeight;
                    
                    return Column(
                      children: [
                        // История сообщений (растет/уменьшается сверху)
                        Container(
                          height: chatHistoryHeight,
                          child: _filteredChatHistory.isEmpty
                              ? Center(
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2B2B2B).withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${_locale.get("noMessages")}',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.all(16),
                                  itemCount: _filteredChatHistory.length,
                                  itemBuilder: (context, index) {
                                    return _buildMessageBubble(_filteredChatHistory[index], index);
                                  },
                                ),
                        ),
                        
                        // Поле ввода (растет вверх)
                        Container(
                          height: inputHeight,
                          child: Column(
                            children: [
                              // Checkboxes (фиксированная высота)
                              Container(
                                height: 30,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _searchWeb,
                                          onChanged: (value) => setState(() => _searchWeb = value ?? false),
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Text('${_locale.get("searchWeb")}', style: TextStyle(color: Colors.white, fontSize: 11)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _searchImages,
                                          onChanged: (value) => setState(() => _searchImages = value ?? false),
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Text('${_locale.get("searchImages")}', style: TextStyle(color: Colors.white, fontSize: 11)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _searchWiki,
                                          onChanged: (value) => setState(() => _searchWiki = value ?? false),
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Text('${_locale.get("searchWiki")}', style: TextStyle(color: Colors.white, fontSize: 11)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Поле ввода текста (растет вверх)
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2B2B2B).withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (_isSearchMode)
                                        Padding(
                                          padding: EdgeInsets.only(left: 16, top: 12),
                                          child: Text('?:', style: TextStyle(color: Colors.yellow)),
                                        ),
                                      
                                   
                              Expanded(
                                child: _AutoExpandingTextField(
                                  controller: _messageController,
                                  focusNode: _textFieldFocusNode,
                                  hintText: _isSearchMode ? '${_locale.get("searchChatHistory")}...' : '${_locale.get("enterMessage")}',
                                  onChanged: (value) {
                                    if (value.startsWith('?:')) {
                                      setState(() {
                                        _isSearchMode = true;
                                        _searchQuery = value.substring(2).trim();
                                      });
                                    } else if (_isSearchMode && !value.startsWith('?:')) {
                                      setState(() {
                                        _isSearchMode = false;
                                        _searchQuery = '';
                                      });
                                    }
                                  },
                                  onSubmitted: (value) {
                                    if (_isSearchMode) {
                                      setState(() {
                                        _isSearchMode = false;
                                        _searchQuery = '';
                                        _messageController.clear();
                                      });
                                    } else {
                                      _sendMessage();
                                    }
                                  },
                                  enabled: !_chatLocked,
                                ),
                              ),
                                      if (_isRecording)
                                        Padding(
                                          padding: EdgeInsets.only(right: 8, top: 12),
                                          child: Icon(Icons.mic, color: Colors.red),
                                        ),
                                      IconButton(
                                        icon: Icon(Icons.send, color: Colors.white),
                                        onPressed: _chatLocked ? null : _sendMessage,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

double _calculateInputHeight() {
  final text = _messageController.text;
  final double baseHeight = 110.0; // Базовая высота (чекбоксы + минимальная высота поля)
  
  if (text.isEmpty) {
    return baseHeight;
  }
  
  // Расчет высоты на основе количества строк
  final lineCount = '\n'.allMatches(text).length ;
  final double lineHeight = 50.0; // Высота одной строки
  final double minTextFieldHeight = 10.0; // Минимальная высота текстового поля
  final double maxInputHeight = 420.0; // Максимальная высота всего поля ввода
  
  // Высота текстового поля = минимум 40px + (количество строк - 1) * высота строки
  final double textFieldHeight = minTextFieldHeight + (1+lineCount ) * lineHeight;
  
  // Общая высота = чекбоксы (30px) + текстовое поле + отступы
  final double totalHeight = textFieldHeight ; // 32px = margin (16+16)
  
  return totalHeight.clamp(baseHeight, maxInputHeight);
}

  @override
  void dispose() {
    _directoryCheckTimer?.cancel();
    _speechToText.stop();
    super.dispose();
  }
}


// Добавляем новый виджет для автоматического расширения:
class _AutoExpandingTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final bool enabled;
  
  const _AutoExpandingTextField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    required this.enabled,
  });
  
  @override
  _AutoExpandingTextFieldState createState() => _AutoExpandingTextFieldState();
}

class _AutoExpandingTextFieldState extends State<_AutoExpandingTextField> {
  final double _minHeight = 50.0;
  final double _maxHeight = 200.0;
  double _currentHeight = 50.0;
  
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateHeight);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateHeight();
    });
  }
  
  @override
  void dispose() {
    widget.controller.removeListener(_updateHeight);
    super.dispose();
  }
  
  void _updateHeight() {
    final textSpan = TextSpan(
      text: widget.controller.text,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection:  Directionality.of(context), 
      maxLines: null,
    );
    
    // Вычисляем ширину с учетом отступов и других элементов
    final double maxWidth = MediaQuery.of(context).size.width - 
      32 - // margin контейнера (16+16)
      16 - // padding слева от TextField
      16 - // padding справа от TextField
      50 - // кнопка отправки
      8 -  // отступ для иконки микрофона (если есть)
      32;  // запас на другие элементы
    
    textPainter.layout(maxWidth: maxWidth);
    
    final double newHeight = max(
      _minHeight,
      min(textPainter.size.height + 24, _maxHeight), // +24 для вертикальных padding
    );
    
    if (newHeight != _currentHeight) {
      setState(() {
        _currentHeight = newHeight;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _currentHeight,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: TextStyle(color: Colors.white),
        maxLines: null,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.white70),
        ),
        onChanged: (value) {
          _updateHeight();
          widget.onChanged(value);
        },
        onSubmitted: widget.onSubmitted,
        enabled: widget.enabled,
      ),
    );
  }
}

class ChatMessage {
  final String type;
  final String message;
  final String timestamp;
  bool starred;
  final String chatName;
  List<String> searchResults;
  List<Map<String, String>> imageResults;
  String wikiResult;

  ChatMessage({
    required this.type,
    required this.message,
    required this.timestamp,
    required this.starred,
    required this.chatName,
    this.searchResults = const [],
    this.imageResults = const [],
    this.wikiResult = '',
  });

  factory ChatMessage.fromMap(Map<String, String> map) {
    return ChatMessage(
      type: map['type'] ?? map['source'] ?? 'user',
      message: map['message'] ?? map['text'] ?? '',
      timestamp: map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      starred: map['starred'] == 'true',
      chatName: map['chatName'] ?? 'Small talk',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'message': message,
      'timestamp': timestamp,
      'starred': starred,
      'chatName': chatName,
      'searchResults': searchResults,
      'imageResults': imageResults,
      'wikiResult': wikiResult,
    };
  }
}

class EatenFilesWindowApp extends StatefulWidget {
  const EatenFilesWindowApp({Key? key}) : super(key: key);

  @override
  State<EatenFilesWindowApp> createState() => _EatenFilesWindowAppState();
}

class _EatenFilesWindowAppState extends State<EatenFilesWindowApp> {
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _folderNameController = TextEditingController();
  final FocusNode _addFocusNode = FocusNode();
  final FocusNode _folderNameFocusNode = FocusNode();
  
  bool _isAdding = false;
  bool _isCreatingFolder = false;
  Set<String> _selectedFilters = {};
  Map<String, List<EatenFile>> _filteredFiles = {
    'recent': [],
    'this_month': [],
    'older': []
  };
  int _currentTab = 0;
  List<EatenFile> _files = [];
  List<EatenFile> _recentlyOpened = [];
  List<CustomFolder> _customFolders = [];
  
  final String _storageDir = path.join(Directory.current.path, 'imeyou_pet', 'eaten_files');
  final String _foldersDataPath = path.join(Directory.current.path, 'imeyou_pet', 'custom_folders.json');
  
  Offset? _contextMenuPosition;
  EatenFile? _contextMenuFile;
  int? _contextMenuIndex;
  StreamSubscription<FileSystemEvent>? _fileWatcher;
  bool _isInitialized = false;
  bool _isLoading = true;

  // Редактирование файла
  bool _isEditing = false;
  EatenFile? _editingFile;
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editCommentController = TextEditingController();
  
  // Дебаунс для поиска
  bool _isFirstSearchCall = true;
  String _previousSearchText = '';
  Timer? _searchDebounce;
  Localization _locale = Localization();
    bool _initStarted = false;
  late final String _windowId;
  late final MethodChannel _channel;
  @override
  void initState() {
    super.initState();
    _isFirstSearchCall = true;
    _locale.init();
    _previousSearchText = '';
     _windowId = 'eaten_files_${DateTime.now().millisecondsSinceEpoch}';
    _channel = MethodChannel('screenshot_channel_$_windowId');
    
    // ПРИНУДИТЕЛЬНО асинхронная инициализация
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _delayedInitialize();
    });
  }
  void _delayedInitialize() async {
    if (_initStarted) return;
    _initStarted = true;
    
    // ДАЕМ ВРЕМЯ основному процессу отпустить ресурсы
    await Future.delayed(const Duration(milliseconds: 100));
    
    // ЗАПУСКАЕМ в отдельной микротаске
    await Future.microtask(() {
      if (mounted) {
        _initializeApp();
      }
    });
  }
  void _initializeApp() async {
    // СРАЗУ показываем интерфейс
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isInitialized = true;
      });
    }
    
    try {
      await windowManager.ensureInitialized();
      
      // ВСЁ остальное - в фоновом режиме
      _loadDataInBackground();
      
    } catch (e) {
      debugPrint('Error in initializeApp: $e');
    }
  }


  void _loadDataInBackground() async {
    try {
      final storageDir = Directory(_storageDir);
      if (!await storageDir.exists()) {
        await storageDir.create(recursive: true);
      }
      
      await _loadFilesFromStorage();
      await _loadCustomFolders();
      _setupListeners();
      
    } catch (e) {
      debugPrint('Error in background loading: $e');
    }
  }
void _setupListeners() {
  _searchController.addListener(() {
    final currentText = _searchController.text;
    
    // Пропускаем первый вызов при инициализации
    if (_isFirstSearchCall) {
      _isFirstSearchCall = false;
      _previousSearchText = currentText;
      return;
    }
    
    // Если текст не изменился - выходим
    if (currentText == _previousSearchText) return;
    
    _previousSearchText = currentText;
    _searchDebounce?.cancel();
    
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (_isInitialized && mounted) {
        _updateFilteredFiles();
      }
    });
  });
}
  void _startFileWatcher() {
    
    try {
      final dir = Directory(_storageDir);
      _fileWatcher = dir.watch(recursive: false).listen((event) {
        if (event.type == FileSystemEvent.create || event.type == FileSystemEvent.delete) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _loadFilesFromStorage();
            }
          });
        }
      });
    } catch (e) {
      debugPrint('Error starting file watcher: $e');
    }
  }


  Future<void> _loadFilesFromStorage() async {
  try {
    final dir = Directory(_storageDir);
    if (!await dir.exists()) {
      if (mounted) {
        setState(() {
          _files = [];
        });
      }
      return;
    }
    
    final List<EatenFile> loadedFiles = [];
    final entities = await dir.list().toList();
    
    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.json')) {
        try {
          final content = await entity.readAsString();
          final jsonData = json.decode(content);
          final file = EatenFile.fromJson(jsonData);
          loadedFiles.add(file);
        } catch (e) {
          debugPrint('Error loading file ${entity.path}: $e');
        }
      }
    }
    
    if (mounted) {
      setState(() {
        _files = loadedFiles;
      });
      
      // ОБНОВЛЯЕМ через задержку после загрузки файлов
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _updateFilteredFiles();
        }
      });
    }
  } catch (e) {
    debugPrint('Error loading files from storage: $e');
  }
  }

  Future<void> _loadCustomFolders() async {
    try {
      final file = File(_foldersDataPath);
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonList = json.decode(content);
        if (mounted) {
          setState(() {
            _customFolders = jsonList.map((e) => CustomFolder.fromJson(e)).toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading custom folders: $e');
    }
  }

  void _saveCustomFolders() async {
    try {
      final file = File(_foldersDataPath);
      final dir = file.parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      await file.writeAsString(json.encode(_customFolders.map((e) => e.toJson()).toList()));
    } catch (e) {
      debugPrint('Error saving custom folders: $e');
    }
  }

Future<void> _saveFileWithDuplicateCheck(EatenFile newFile) async {
  final existingFileIndex = _files.indexWhere((file) => file.path == newFile.path);
  
  if (existingFileIndex != -1) {
    final existingFile = _files[existingFileIndex];
    newFile.isStarred = existingFile.isStarred;
    newFile.openCount = existingFile.openCount;
    newFile.lastOpened = existingFile.lastOpened;
    newFile.comment = existingFile.comment;
    if (newFile.iconBytes == null && existingFile.iconBytes != null) {
      newFile.iconBytes = existingFile.iconBytes;
    }
    _files.removeAt(existingFileIndex);
  }
  
  _files.insert(0, newFile);
  
  await _saveFile(newFile);
  if (mounted) {
    // ОБНОВЛЯЕМ через микротаск
    Future.microtask(() {
      if (mounted) {
        _updateFilteredFiles();
      }
    });
  }
}

  Future<void> _saveFile(EatenFile file) async {
    try {
      final fileName = '${file.id}.json';
      final filePath = path.join(_storageDir, fileName);
      final outputFile = File(filePath);
      final dir = outputFile.parent;
      
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      
      await outputFile.writeAsString(json.encode(file.toJson()));
    } catch (e) {
      debugPrint('Error saving file: $e');
    }
  }

Future<void> _deleteFile(EatenFile file) async {
  try {
    final fileName = '${file.id}.json';
    final filePath = path.join(_storageDir, fileName);
    final outputFile = File(filePath);
    if (await outputFile.exists()) {
      await outputFile.delete();
    }
    if (mounted) {
      setState(() {
        _files.remove(file);
      });
      
      // ОБНОВЛЯЕМ через микротаск
      Future.microtask(() {
        if (mounted) {
          _updateFilteredFiles();
        }
      });
    }
  } catch (e) {
    debugPrint('Error deleting file: $e');
  }
}

  void _addItem(String itemPath) async {
    final trimmedPath = itemPath.trim();
    if (trimmedPath.isEmpty) return;

    final isWeb = _isWebUrl(trimmedPath);
    final isSystemPath = _isSystemPath(trimmedPath);
    
    if (!isWeb && !isSystemPath) {
      _showErrorSnackbar('${_locale.get("error")}');
      return;
    }

    try {
      Uint8List? iconBytes;
      String title = 'none';
      
      if (isWeb) {
        // Для веб-сайтов загружаем иконку и заголовок асинхронно
        iconBytes = await _getFavicon(trimmedPath);
        title = await _getPageTitle(trimmedPath);
        if (title == 'none') {
          title = _getDomainName(trimmedPath);
        }
      } else if (isSystemPath) {
        // Для файлов получаем иконку
        if (trimmedPath.toLowerCase().endsWith('.lnk')) {
          iconBytes = await _getLnkFileIcon(trimmedPath);
        } else {
          iconBytes = await _getFileIcon(trimmedPath);
        }
      }

      final newFile = EatenFile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        path: trimmedPath,
        isWeb: isWeb,
        isStarred: false,
        openCount: 0,
        lastOpened: null,
        iconBytes: iconBytes,
        fileName: isWeb ? _getDomainName(trimmedPath) : path.basename(trimmedPath),
        pageTitle: title,
        comment: '',
      );

      await _saveFileWithDuplicateCheck(newFile);
      
      _addController.clear();
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    } catch (e) {
      debugPrint('Error adding item: $e');
      _showErrorSnackbar('Ошибка при добавлении файла');
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        )
      );
    }
  }

  Future<void> _handlePasteFromClipboard() async {
    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.any,
        );

        if (result != null && result.files.isNotEmpty) {
          for (var platformFile in result.files) {
            if (platformFile.path != null) {
              _addItem(platformFile.path!);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error handling paste: $e');
    }
  }

  bool _isWebUrl(String text) {
    final trimmed = text.trim();
    return trimmed.startsWith('http://') || 
           trimmed.startsWith('https://') ||
           trimmed.startsWith('www.');
  }

  bool _isSystemPath(String text) {
    final trimmed = text.trim();
    if (Platform.isWindows) {
      return trimmed.contains(':\\') || trimmed.startsWith('\\\\');
    } else {
      return trimmed.startsWith('/');
    }
  }

  Future<Uint8List?> _getFavicon(String url) async {
    try {
      final domain = _getDomainName(url);
      final faviconUrl = 'https://www.google.com/s2/favicons?domain=$domain&sz=32';
      final response = await http.get(Uri.parse(faviconUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      debugPrint('Error getting favicon: $e');
    }
    return null;
  }

  Future<String> _getPageTitle(String url) async {
    try {
      final formattedUrl = url.startsWith('http') ? url : 'https://$url';
      final response = await http.get(Uri.parse(formattedUrl));
      if (response.statusCode == 200) {
        final titleMatch = RegExp(r'<title>(.*?)</title>', caseSensitive: false).firstMatch(response.body);
        if (titleMatch != null && titleMatch.group(1)!.isNotEmpty) {
          return titleMatch.group(1)!;
        }
      }
    } catch (e) {
      debugPrint('Error getting page title: $e');
    }
    return _getDomainName(url);
  }

  Future<Uint8List?> _getLnkFileIcon(String lnkPath) async {
     return await _getFileIcon(lnkPath);
    try {
      const MethodChannel _channel = MethodChannel('screenshot_channel1');
      final result = await _channel.invokeMethod('getLnkFileIcon', lnkPath);
      if (result != null) {
        return result as Uint8List;
      }
    } catch (e) {
      debugPrint('Error getting lnk file icon: $e');
    }
    
    return await _getFileIcon(lnkPath);
  }

  Future<Uint8List?> _getFileIcon(String filePath) async {
    try {
      const MethodChannel _channel = MethodChannel('screenshot_channel1');
      final result = await _channel.invokeMethod('getFileIcon', filePath);
      return result as Uint8List?;
    } catch (e) {
      debugPrint('Error getting file icon: $e');
      return null;
    }
  }


  void _toggleStar(EatenFile file) async {
  if (mounted) {
    setState(() {
      file.isStarred = !file.isStarred;
    });
    
    // ОБНОВЛЯЕМ через микротаск
    Future.microtask(() {
      if (mounted) {
        _updateFilteredFiles();
      }
    });
  }
  await _saveFile(file);
}

void _incrementOpenCount(EatenFile file) async {
  if (mounted) {
    setState(() {
      file.openCount++;
      file.lastOpened = DateTime.now();
    });
    
    // ОБНОВЛЯЕМ через микротаск
    Future.microtask(() {
      if (mounted) {
        _updateFilteredFiles();
      }
    });
  }
  await _saveFile(file);
}


bool _isUpdatingFilteredFiles = false;

void _updateFilteredFiles() {
  if (!_isInitialized || !mounted || _isUpdatingFilteredFiles) return;

  _isUpdatingFilteredFiles = true;
  
  debugPrint('[_updateFilteredFiles] called - search: "${_searchController.text}", filters: $_selectedFilters');
  
  _searchDebounce?.cancel();
  
  final newFilteredFiles = _filterFilesSync();
  
  // Упрощенное сравнение только по длине
  final shouldUpdate = 
      _filteredFiles['recent']?.length != newFilteredFiles['recent']?.length ||
      _filteredFiles['this_month']?.length != newFilteredFiles['this_month']?.length ||
      _filteredFiles['older']?.length != newFilteredFiles['older']?.length;

  debugPrint('[_updateFilteredFiles] shouldUpdate: $shouldUpdate, '
      'old: ${_filteredFiles['recent']?.length}/${_filteredFiles['this_month']?.length}/${_filteredFiles['older']?.length}, '
      'new: ${newFilteredFiles['recent']?.length}/${newFilteredFiles['this_month']?.length}/${newFilteredFiles['older']?.length}');
  
  if (shouldUpdate && mounted) {
    setState(() {
      _filteredFiles = newFilteredFiles;
    });
    debugPrint('[_updateFilteredFiles] setState called');
  } else {
    debugPrint('[_updateFilteredFiles] no update needed');
  }
  
  _isUpdatingFilteredFiles = false;
}


bool _areFilteredFilesDeepEqual(
  Map<String, List<EatenFile>> a, 
  Map<String, List<EatenFile>> b
) {
  // Сравниваем каждый ключ
  for (final key in ['recent', 'this_month', 'older']) {
    final listA = a[key] ?? [];
    final listB = b[key] ?? [];
    
    // Если разная длина - сразу не равны
    if (listA.length != listB.length) {
      return false;
    }
    
    // Сравниваем каждый элемент в списке
    for (int i = 0; i < listA.length; i++) {
      final fileA = listA[i];
      final fileB = listB[i];
      
      // Сравниваем по ID и другим важным полям
      if (fileA.id != fileB.id ||
          fileA.isStarred != fileB.isStarred ||
          fileA.fileName != fileB.fileName ||
          fileA.path != fileB.path) {
        return false;
      }
    }
  }
  
  return true;
}
// Вспомогательный метод для сравнения
bool _areFilteredFilesEqual(
  Map<String, List<EatenFile>> a, 
  Map<String, List<EatenFile>> b
) {
  return a['recent']?.length == b['recent']?.length &&
         a['this_month']?.length == b['this_month']?.length &&
         a['older']?.length == b['older']?.length;
}
Map<String, List<EatenFile>> _filterFilesSync() {
  final currentTab = _currentTab;
  final searchQuery = _searchController.text.toLowerCase().trim();
  final selectedFilters = Set<String>.from(_selectedFilters);
  
  List<EatenFile> baseList = currentTab == 0 
      ? List<EatenFile>.from(_files) 
      : List<EatenFile>.from(_recentlyOpened);

  debugPrint('[_filterFilesSync] base: ${baseList.length}, search: "$searchQuery", filters: $selectedFilters');

  // Если нет фильтров - возвращаем исходный список БЕЗ дополнительной фильтрации
  if (searchQuery.isEmpty && selectedFilters.isEmpty) {
    debugPrint('[_filterFilesSync] no filters applied, returning base list');
    return _groupFilesByTimeOptimized(baseList, currentTab);
  }

  List<EatenFile> filteredList = baseList.where((file) {
    // Фильтрация по поиску
    if (searchQuery.isNotEmpty) {
      final matchesSearch = 
          file.fileName.toLowerCase().contains(searchQuery) ||
          file.path.toLowerCase().contains(searchQuery) ||
          (file.comment?.toLowerCase().contains(searchQuery) ?? false);
      if (!matchesSearch) return false;
    }
    
    // Фильтрация по типам
    if (selectedFilters.isNotEmpty) {
      final matchesFilter = _matchesFilter(file, selectedFilters);
      if (!matchesFilter) return false;
    }
    
    return true;
  }).toList();

  debugPrint('[_filterFilesSync] filtered: ${filteredList.length}');
  
  return _groupFilesByTimeOptimized(filteredList, currentTab);
}

bool _matchesFilter(EatenFile file, Set<String> filters) {
  if (file.isWeb) {
    final domain = _getDomainName(file.path);
    return filters.contains('url') || filters.contains('domain:$domain');
  } else {
    final ext = path.extension(file.path).toLowerCase();
    if (ext.isNotEmpty) {
      return filters.contains(ext);
    } else {
      return filters.contains('no_ext');
    }
  }
}

Map<String, List<EatenFile>> _groupFilesByTimeOptimized(List<EatenFile> files, int currentTab) {
  if (currentTab != 0) {
    return {
      'recent': List<EatenFile>.from(files), 
      'this_month': <EatenFile>[], 
      'older': <EatenFile>[]
    };
  }

  final recent = <EatenFile>[];
  final thisMonthList = <EatenFile>[];
  final older = <EatenFile>[];

  final now = DateTime.now();
  final currentMonth = DateTime(now.year, now.month);
  
  for (var file in files) {
    // Для веб-сайтов всегда показываем в "recent"
    if (file.isWeb) {
      recent.add(file);
      continue;
    }

    // Для файлов используем информацию из метаданных
    if (file.lastOpened != null) {
      final fileMonth = DateTime(file.lastOpened!.year, file.lastOpened!.month);
      
      if (file.lastOpened!.isAfter(now.subtract(const Duration(days: 7)))) {
        recent.add(file);
      } else if (fileMonth == currentMonth) {
        thisMonthList.add(file);
      } else {
        older.add(file);
      }
    } else {
      // Если нет информации о последнем открытии, считаем файл старым
      older.add(file);
    }
  }

  return {
    'recent': recent,
    'this_month': thisMonthList,
    'older': older,
  };
}


  String _getDomainName(String url) {
    try {
      final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
      return uri.host;
    } catch (e) {
      return url.length > 15 ? '${url.substring(0, 12)}...' : url;
    }
  }

  void _createFolder() {
    final folderName = _folderNameController.text.trim();
    if (folderName.isEmpty) return;

    final newFolder = CustomFolder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: folderName,
      fileIds: [],
    );

    if (mounted) {
      setState(() {
        _customFolders.add(newFolder);
        _isCreatingFolder = false;
        _folderNameController.clear();
      });
    }
    _saveCustomFolders();
  }

  Widget _buildFileGridItem(EatenFile file, int index) {
    return FileGridItem1(
      file: file,
      index: index,
      onTap: () {
        _hideContextMenu();
        if (file.isWeb || _isWebUrl(file.path)) {
          _openWebUrl(file);
        } else {
          _openFile(file);
        }
        _incrementOpenCount(file);
      },
      onLongPress: () {
        _hideContextMenu();
        if (file.isWeb || _isWebUrl(file.path)) {
          _searchWebTitle(file.path);
        } else {
          _revealInExplorer(file.path);
        }
      },
      onSecondaryTap: (details) {
        _showContextMenu(details.globalPosition, file, index);
      },
      onStarToggled: () => _toggleStar(file),
    );
  }

  void _showContextMenu(Offset position, EatenFile file, int index) {
    if (mounted) {
      setState(() {
        _contextMenuPosition = position;
        _contextMenuFile = file;
        _contextMenuIndex = index;
      });
    }
  }

  void _hideContextMenu() {
    if (mounted) {
      setState(() {
        _contextMenuPosition = null;
        _contextMenuFile = null;
        _contextMenuIndex = null;
      });
    }
  }

  void _handleMenuAction(String action) {
    if (_contextMenuFile == null || _contextMenuIndex == null) return;

    final file = _contextMenuFile!;
    final fileExists = file.isWeb ? true : File(file.path).existsSync();

    switch (action) {
      case 'open':
        if (file.isWeb) {
          _openWebUrl(file);
        } else if (fileExists) {
          _openFile(file);
        }
        _incrementOpenCount(file);
        break;
      case 'reveal':
        if (!file.isWeb && fileExists) {
          _revealInExplorer(file.path);
        }
        break;
      case 'search':
        if (file.isWeb) {
          _searchWebTitle(file.path);
        }
        break;
      case 'delete':
        _deleteFile(file);
        break;
      case 'toggle_star':
        _toggleStar(file);
        break;
      case 'edit':
        _startEditing(file);
        break;
    }

    _hideContextMenu();
  }

  void _startEditing(EatenFile file) {
    if (mounted) {
      setState(() {
        _isEditing = true;
        _editingFile = file;
        _editNameController.text = file.fileName;
        _editCommentController.text = file.comment ?? '';
      });
    }
  }

  void _stopEditing() {
    if (mounted) {
      setState(() {
        _isEditing = false;
        _editingFile = null;
        _editNameController.clear();
        _editCommentController.clear();
      });
    }
  }

  void _saveEditing() async {
    if (_editingFile == null) return;

    if (mounted) {
      setState(() {
        _editingFile!.fileName = _editNameController.text;
        _editingFile!.comment = _editCommentController.text;
        _filteredFiles = _filterFilesSync();
      });
    }

    await _saveFile(_editingFile!);
    _stopEditing();
  }

  Widget _buildContextMenu() {
    if (_contextMenuPosition == null || _contextMenuFile == null) return const SizedBox.shrink();

    final file = _contextMenuFile!;
    final isWeb = file.isWeb;
    final fileExists = isWeb ? true : File(file.path).existsSync();

    return Positioned(
      left: _contextMenuPosition!.dx,
      top: _contextMenuPosition!.dy,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContextMenuItem(
              Icons.open_in_new,
              '${_locale.get("open")}',
              Colors.blue,
              () => _handleMenuAction('open'),
            ),
            if (!isWeb && fileExists)
              _buildContextMenuItem(
                Icons.folder_open,
                '${_locale.get("location")}',
                Colors.green,
                () => _handleMenuAction('reveal'),
              )
            else
              _buildContextMenuItem(
                Icons.search,
                '${_locale.get("search")}',
                Colors.green,
                () => _handleMenuAction('search'),
              ),
            _buildContextMenuItem(
              file.isStarred ? Icons.star : Icons.star_border,
              file.isStarred ? '${_locale.get("unstar")}' : '${_locale.get("star")}',
              Colors.orange,
              () => _handleMenuAction('toggle_star'),
            ),
            _buildContextMenuItem(
              Icons.edit,
              '${_locale.get("edit")}',
              Colors.blue,
              () => _handleMenuAction('edit'),
            ),
            _buildContextMenuItem(
              Icons.delete,
              '${_locale.get("delete")}',
              Colors.red,
              () => _handleMenuAction('delete'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(IconData icon, String text, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExtensionFilter() {
    final extensions = _getAllExtensions();
    final domains = _getAllDomains();

    return Container(
      width: 200,
      color: Colors.black.withOpacity(0.3),
      child: ListView(
        children: [
           Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '${_locale.get("filters")}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(color: Colors.white54),
          if (domains.isNotEmpty) ...[
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('${_locale.get("domains")}:', style: TextStyle(color: Colors.white70)),
            ),
            ...domains.map((domain) => _buildFilterItem('🌐 $domain', 'domain:$domain')),
            Divider(color: Colors.white54),
          ],
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('${_locale.get("extensions")}:', style: TextStyle(color: Colors.white70)),
          ),
          ...extensions.map((ext) => _buildFilterItem(
            ext == 'url' ? '🌐 URL' : 
            ext == 'no_ext' ? '📄 ${_locale.get("noExtension")}' : 
            '📄 ${ext.toUpperCase()}',
            ext
          )),
          Divider(color: Colors.white54),
          ListTile(
            title:  Text(
              '${_locale.get("clearFilter")}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            trailing: const Icon(Icons.clear_all, size: 16, color: Colors.white70),
            onTap: () {
              if (mounted) {
                setState(() {
                  _selectedFilters.clear();
                  _filteredFiles = _filterFilesSync();
                });
              }
            },
          ),
        ],
      ),
    );
  }
Widget _buildFilterItem(String label, String value) {
  final isSelected = _selectedFilters.contains(value);
  
  return ListTile(
    title: Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.blue : Colors.white,
        fontSize: 12,
      ),
    ),
    trailing: isSelected ? const Icon(Icons.check, size: 16, color: Colors.blue) : null,
    onTap: () {
      if (mounted) {
        setState(() {
          if (isSelected) {
            _selectedFilters.remove(value);
          } else {
            _selectedFilters.add(value);
          }
        });
        
        // ОБНОВЛЯЕМ через микротаск чтобы избежать рекурсии
        Future.microtask(() {
          if (mounted) {
            _updateFilteredFiles();
          }
        });
      }
    },
  );
}


  Set<String> _getAllExtensions() {
    final extensions = <String>{};
    final currentList = _currentTab == 0 ? _files : _recentlyOpened;
    
    for (var file in currentList) {
      if (file.isWeb) {
        extensions.add('url');
      } else {
        final ext = path.extension(file.path).toLowerCase();
        if (ext.isNotEmpty) {
          extensions.add(ext);
        } else {
          extensions.add('no_ext');
        }
      }
    }
    
    return extensions;
  }

  Set<String> _getAllDomains() {
    final domains = <String>{};
    final currentList = _currentTab == 0 ? _files : _recentlyOpened;
    
    for (var file in currentList) {
      if (file.isWeb) {
        domains.add(_getDomainName(file.path));
      }
    }
    
    return domains;
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        _addController.text = result.files.single.path!;
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  void _searchWebTitle(String url) async {
    final searchUrl = 'https://www.google.com/search?q=${Uri.encodeComponent(url)}';
    if (await canLaunch(searchUrl)) {
      await launch(searchUrl);
    }
  }

  Widget _buildEditPanel() {
    if (!_isEditing || _editingFile == null) return const SizedBox.shrink();

    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      width: 200,
      child: Container(
        color: const Color(0xFF2B2B2B).withOpacity(0.95),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              '${_locale.get("edit")}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _editingFile!.iconBytes != null
                  ? Image.memory(
                      _editingFile!.iconBytes!,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      _editingFile!.isWeb ? Icons.language : Icons.insert_drive_file,
                      color: Colors.white,
                      size: 48,
                    ),
            ),
            const SizedBox(height: 16),
            
             Text(
              '${_locale.get("name")}:',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _editNameController,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
            const SizedBox(height: 16),
            
            if (!_editingFile!.isWeb) ...[
               Text(
                '${_locale.get("location")}:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _editingFile!.path,
                      style: const TextStyle(color: Colors.white54, fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _revealInExplorer(_editingFile!.path),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.folder_open, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
             Text(
              '${_locale.get("comment")}:',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: TextField(
                controller: _editCommentController,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  contentPadding: const EdgeInsets.all(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _saveEditing,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:  Center(
                          child: Text(
                            '${_locale.get("save")}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _deleteFile(_editingFile!);
                        _stopEditing();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:  Center(
                          child: Text(
                            '${_locale.get("delete")}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _stopEditing,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  Center(
                    child: Text(
                      '${_locale.get("cancel")}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Row(
              children: [
                _buildExtensionFilter(),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: _isEditing ? 200 : 0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B).withOpacity(0.95),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Header
                            Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A).withOpacity(0.9),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                   Text(
                                    '${_locale.get("files")} [ALT+A]',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => windowManager.close(),
                                      child: const Icon(Icons.close, size: 20, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Вкладки и поиск
                            Container(
                              padding: const EdgeInsets.all(12),
                              color: const Color(0xFF1A1A1A).withOpacity(0.7),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      _buildTab('📁 ${_locale.get("eaten")}', 0),
                                      _buildTab('🕐 ${_locale.get("recent")}', 1),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: TextField(
                                            controller: _searchController,
                                            style: const TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              hintText: '${_locale.get("search")}',
                                              hintStyle: const TextStyle(color: Colors.white54),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: const Color(0xFF2B2B2B).withOpacity(0.8),
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.paste, color: Colors.white),
                                        onPressed: _handlePasteFromClipboard,
                                        tooltip: '${_locale.get("paste")}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Строка добавления (только для съеденных)
                            if (_currentTab == 0) _buildAddRow(),

                            // Список файлов
                            Expanded(
                              child: _isLoading 
                                  ? const Center(child: CircularProgressIndicator())
                                  : _buildFileList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Контекстное меню
            _buildContextMenu(),

            // Панель редактирования
            _buildEditPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddRow() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF1A1A1A).withOpacity(0.7),
      child: Row(
        children: [
          if (_isAdding) ...[
            Expanded(
              child: TextField(
                controller: _addController,
                focusNode: _addFocusNode,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '${_locale.get("enterPath")}',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2B2B2B).withOpacity(0.8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _addItem(_addController.text),
              ),
            ),
            const SizedBox(width: 8),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _pickFile,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2B2B).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.folder_open, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 4),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _addItem(_addController.text),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 4),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _isAdding = false;
                      _addController.clear();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2B2B).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: Text(
                '📁 ${_locale.get("eatenFiles")} (${_files.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _isAdding = true;
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _addFocusNode.requestFocus();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        '${_locale.get("addFile")}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFileList() {
  final isEmpty = _currentTab == 0 ? _files.isEmpty : _recentlyOpened.isEmpty;

  if (isEmpty) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B).withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child:  Text(
          '${_locale.get("noFiles")}',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

  // ПРОСТАЯ проверка без сложной логики
  final hasRecent = _filteredFiles['recent']?.isNotEmpty ?? false;
  final hasThisMonth = _filteredFiles['this_month']?.isNotEmpty ?? false;
  final hasOlder = _filteredFiles['older']?.isNotEmpty ?? false;

  if (!hasRecent && !hasThisMonth && !hasOlder) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B).withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child:  Text(
          '${_locale.get("noFilteredFiles")}',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

  return Container(
    color: const Color(0xFF2B2B2B).withOpacity(0.8),
    child: ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (hasRecent) ...[
          _buildSectionHeader('${_locale.get("recent")}'),
          _buildFileGrid(_filteredFiles['recent']!),
          const SizedBox(height: 16),
        ],
        if (hasThisMonth) ...[
          _buildSectionHeader('${_locale.get("thisMonth")}'),
          _buildFileGrid(_filteredFiles['this_month']!),
          const SizedBox(height: 16),
        ],
        if (hasOlder) ...[
          _buildSectionHeader('${_locale.get("before")}'),
          _buildFileGrid(_filteredFiles['older']!),
        ],
      ],
    ),
  );
}

  Widget _buildFileGrid(List<EatenFile> files) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return _buildFileGridItem(file, index);
      },
    );
  }

  void _openWebUrl(EatenFile file) async {
    String formattedUrl = file.path.trim();
    if (!formattedUrl.startsWith('http')) {
      formattedUrl = 'https://$formattedUrl';
    }
    
    if (await canLaunch(formattedUrl)) {
      await launch(formattedUrl);
      _incrementOpenCount(file);
      _addToRecentlyOpened(file);
    }
  }

  void _openFile(EatenFile file) async {
    try {
      if (Platform.isWindows) {
        await Process.run('start', ['""', file.path], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', [file.path]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [file.path]);
      }
      _addToRecentlyOpened(file);
    } catch (e) {
      debugPrint('Error opening file: $e');
    }
  }

  void _addToRecentlyOpened(EatenFile file) {
    if (mounted) {
      setState(() {
        _recentlyOpened.removeWhere((f) => f.id == file.id);
        _recentlyOpened.insert(0, file);
        if (_recentlyOpened.length > 100) {
          _recentlyOpened.removeRange(100, _recentlyOpened.length);
        }
      });
    }
  }

Widget _buildTab(String title, int tabIndex) {
  final isSelected = _currentTab == tabIndex;
  return GestureDetector(
    onTap: () {
      if (mounted && _currentTab != tabIndex) {
        setState(() {
          _currentTab = tabIndex;
        });
        
        // ОБНОВЛЯЕМ через микротаск
        Future.microtask(() {
          if (mounted) {
            _updateFilteredFiles();
          }
        });
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _revealInExplorer(String filePath) async {
    try {
      if (Platform.isWindows) {
        await Process.run('explorer', ['/select,', filePath]);
      } else if (Platform.isMacOS) {
        await Process.run('open', ['-R', filePath]);
      } else if (Platform.isLinux) {
        final dir = path.dirname(filePath);
        await Process.run('xdg-open', [dir]);
      }
    } catch (e) {
      debugPrint('Error revealing file: $e');
    }
  }

@override
void dispose() {
  _isUpdatingFilteredFiles = false; // сбрасываем флаг
  _searchDebounce?.cancel();
  _fileWatcher?.cancel();
  _addFocusNode.dispose();
  _addController.dispose();
  _searchController.dispose();
  _folderNameController.dispose();
  _folderNameFocusNode.dispose();
  _editNameController.dispose();
  _editCommentController.dispose();
  super.dispose();
}
}

class EatenFile {
  final String id;
  final String path;
  final bool isWeb;
  bool isStarred;
  int openCount;
  DateTime? lastOpened;
  Uint8List? iconBytes;
  String fileName;
  final String pageTitle;
  String? comment;

  EatenFile({
    required this.id,
    required this.path,
    required this.isWeb,
    required this.isStarred,
    required this.openCount,
    this.lastOpened,
    this.iconBytes,
    required this.fileName,
    required this.pageTitle,
    this.comment,
  });

  factory EatenFile.fromJson(Map<String, dynamic> json) {
    return EatenFile(
      id: json['id'],
      path: json['path'],
      isWeb: json['isWeb'],
      isStarred: json['isStarred'],
      openCount: json['openCount'],
      lastOpened: json['lastOpened'] != null ? DateTime.parse(json['lastOpened']) : null,
      fileName: json['fileName'] ?? (json['isWeb'] ? _getDomainName(json['path']) : _getFileName(json['path'])),
      pageTitle: json['pageTitle'] != null ? json['pageTitle'] : 'none',
      comment: json['comment'],
    );
  }

  static String _getFileName(String filePath) {
    final parts = filePath.split(RegExp(r'[\\/]'));
    return parts.isNotEmpty ? parts.last : filePath;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'isWeb': isWeb,
      'isStarred': isStarred,
      'openCount': openCount,
      'lastOpened': lastOpened?.toIso8601String(),
      'fileName': fileName,
      'pageTitle': pageTitle,
      'comment': comment,
    };
  }

  static String _getDomainName(String url) {
    try {
      final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
      return uri.host;
    } catch (e) {
      return url.length > 15 ? '${url.substring(0, 12)}...' : url;
    }
  }
}
class CustomFolder {
  final String id;
  final String name;
  final List<String> fileIds;

  CustomFolder({
    required this.id,
    required this.name,
    required this.fileIds,
  });

  factory CustomFolder.fromJson(Map<String, dynamic> json) {
    return CustomFolder(
      id: json['id'],
      name: json['name'],
      fileIds: List<String>.from(json['fileIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fileIds': fileIds,
    };
  }
}

class FileGridItem1 extends StatefulWidget {
  final EatenFile file;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final void Function(TapDownDetails) onSecondaryTap;
  final VoidCallback onStarToggled;

  const FileGridItem1({
    Key? key,
    required this.file,
    required this.index,
    required this.onTap,
    required this.onLongPress,
    required this.onSecondaryTap,
    required this.onStarToggled,
  }) : super(key: key);

  @override
  State<FileGridItem1> createState() => _FileGridItemState1();
}

class _FileGridItemState1 extends State<FileGridItem1> {
  @override
  Widget build(BuildContext context) {
    String displayName = widget.file.fileName;
    
    if (widget.file.isWeb) {
      displayName = widget.file.pageTitle != 'none' ? widget.file.pageTitle : widget.file.fileName;
    }
    
    if (displayName.length > 12) {
      displayName = '${displayName.substring(0, 9)}...';
    }
    
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onSecondaryTapDown: widget.onSecondaryTap,
      child: Container(
        width: 85,
        height: 85,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  child: _buildContentPreview(widget.file),
                ),
                const SizedBox(height: 4),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: widget.onStarToggled,
                child: Icon(
                  widget.file.isStarred ? Icons.star : Icons.star_border,
                  color: widget.file.isStarred ? Colors.yellow : Colors.white54,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPreview(EatenFile file) {
    final isUrl = file.isWeb || _isWebUrl(file.path);
    final isImageFile = _isImageFile(file);
    
    if (isUrl) {
      return _buildUrlIcon(file);
    } else if (isImageFile) {
      return _buildImagePreview(file);
    } else {
      return _buildFileIcon(file);
    }
  }

  bool _isImageFile(EatenFile file) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg'];
    final ext = file.fileName.toLowerCase();
    return imageExtensions.any((imageExt) => ext.endsWith(imageExt));
  }

  bool _isWebUrl(String path) {
    return path.startsWith('http://') || 
           path.startsWith('https://') ||
           path.startsWith('www.');
  }

  Future<Uint8List?> _getFileIcon(String filePath) async {
    const MethodChannel _fileIconChannel = MethodChannel('screenshot_channel');
    try {
      final result = await _fileIconChannel.invokeMethod('getFileIcon', filePath);
      return result as Uint8List?;
    } catch (e) {
      debugPrint('Error getting file icon: $e');
      return null;
    }
  }

  String _getDomainName(String url) {
    try {
      final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
      return uri.host;
    } catch (e) {
      return url.length > 15 ? '${url.substring(0, 12)}...' : url;
    }
  }

  Future<Uint8List?> _getFavicon(String url) async {
    try {
      final domain = _getDomainName(url);
      final faviconUrl = 'https://www.google.com/s2/favicons?domain=$domain&sz=32';
      final response = await http.get(Uri.parse(faviconUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      debugPrint('Error getting favicon: $e');
    }
    return null;
  }   
  
  Widget _buildUrlIcon(EatenFile file) {
    if (file.iconBytes != null) {
      return Center(
        child: Image.memory(
          file.iconBytes!,
          width: 36,
          height: 36,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return FutureBuilder<Uint8List?>(
        future: _getFavicon(file.path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 36,
              height: 36,
              child: const CircularProgressIndicator(strokeWidth: 2),
            );
          } else if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              width: 36,
              height: 36,
              fit: BoxFit.contain,
            );
          } else {
            return const Icon(
              Icons.language,
              color: Colors.blue,
              size: 36,
            );
          }
        },
      );
    }
  }

  Widget _buildImagePreview(EatenFile file) {
    return Center(
      child: Container(
        width: 36,
        height: 36,
        child: Image.file(
          File(file.path),
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackIcon(file);
          },
        ),
      ),
    );
  }

  Widget _buildFileIcon(EatenFile file) {
    if (file.iconBytes != null) {
      return Center(
        child: Image.memory(
          file.iconBytes!,
          width: 36,
          height: 36,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return FutureBuilder<Uint8List?>(
        future: _getFileIcon(file.path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 36,
              height: 36,
              child: const CircularProgressIndicator(strokeWidth: 2),
            );
          } else if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              width: 36,
              height: 36,
              fit: BoxFit.contain,
            );
          } else {
            return _buildFallbackIcon(file);
          }
        },
      );
    }
  }

  Widget _buildFallbackIcon(EatenFile file) {
    return Icon(
      file.isWeb ? Icons.language : Icons.insert_drive_file,
      color: file.isWeb ? Colors.blue : Colors.white,
      size: 36,
    );
  }
}






























class SettingsWindowApp extends StatefulWidget {
  final String apiKey;
  final String petName;
  final String localizationLanguage;
  final String tamagochiVisual;
  final Map<String, String> windowSkins;
  final Map<String, Color> windowColors;
  final Map<String, String> hotkeys;

  const SettingsWindowApp({
    Key? key,
    required this.apiKey,
    required this.petName,
    required this.localizationLanguage,
    required this.tamagochiVisual,
    required this.windowSkins,
    required this.windowColors,
    required this.hotkeys,
  }) : super(key: key);

  @override
  State<SettingsWindowApp> createState() => _SettingsWindowAppState();
}

class _SettingsWindowAppState extends State<SettingsWindowApp> {
  late TextEditingController _apiKeyController;
  late TextEditingController _petNameController;
  late String _localizationLanguage;
  late String _tamagochiVisual;
  late Map<String, String> _windowSkins;
  late Map<String, Color> _windowColors;
  late Map<String, String> _hotkeys;
  late Map<String, FocusNode> _hotkeyFocusNodes;
  
  int _rightTabIndex = 0; // 0: shortcuts, 1: license, 2: tutorial
  
  // Для отслеживания наведения на виджеты скинов
  Map<String, bool> _skinHoverStates = {};
  Map<String, bool> _hotkeyEditingStates = {};

  final List<String> _tamagochiOptions = [
    'assets/images/main_template0.png',
    'assets/images/main_template1.png',
    'assets/images/main_template2.png',
    'assets/images/main_template3.png',
    'assets/images/main_template4.png',
  ];

  final List<String> _languageOptions = ['Русский', 'English', 'Español', '中文'];
  final List<String> _windowTypes = [
    'ChatSkin',
    'EssentialSkin',
    'ClipboardSkin',
    'EatenFilesSkin',
    'VirtualKeyboardSkin'
  ];

  final Map<String, String> _windowLabels = {
    'ChatSkin': 'Чат с АИ',
    'EssentialSkin': 'Essentials',
    'ClipboardSkin': 'Клипбоард',
    'EatenFilesSkin': 'Съеденные файлы',
    'VirtualKeyboardSkin': 'Клавиатура',
  };

  final Map<String, String> _hotkeyLabels = {
    'translate_to_english': 'Перевод на английский',
    'translate_to_input': 'Перевод на язык ввода',
    'keyboard': 'Клавиатура',
    'eaten_files': 'Съеденные файлы',
    'chat_ai': 'Чат с АИ',
    'essentials': 'Essentials',
    'clipboard': 'Клипбоард',
    'ai_feed': 'AI Feed',
  };
  
  String? _editingColorForWindow; // Для какого окна редактируем цвет
  Color _tempColor = Colors.grey[800]!;
  TextEditingController _hexController = TextEditingController();

   
  void _startColorEditing(String windowType) {
    setState(() {
      _editingColorForWindow = windowType;
      _tempColor = _windowColors[windowType] ?? Colors.grey[800]!;
      _hexController.text = _colorToHex(_tempColor);
    });
  }
  
  void _applyColor(String windowType) {
    setState(() {
      _windowColors[windowType] = _tempColor;
      _editingColorForWindow = null;
    });
    _saveWindowColor(windowType, _tempColor);
  }
  
  void _cancelColorEditing() {
    setState(() {
      _editingColorForWindow = null;
    });
  }
  
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase().substring(2)}';
  }
  
  Color? _hexToColor(String hex) {
    try {
      if (hex.startsWith('#')) {
        hex = hex.substring(1);
      }
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      final colorInt = int.parse(hex, radix: 16);
      return Color(colorInt);
    } catch (e) {
      return null;
    }
  }
  
  // Базовые цвета (20 цветов: 5x4)
  List<Color> _getColorPalette() {
    return [
      // Row 1
      Colors.black, Colors.grey[700]!, Colors.grey[400]!, Colors.white, Colors.brown[700]!,
      // Row 2
      Colors.red, Colors.pink, Colors.purple, Colors.deepPurple, Colors.indigo,
      // Row 3
      Colors.blue, Colors.lightBlue, Colors.cyan, Colors.teal, Colors.green,
      // Row 4
      Colors.lightGreen, Colors.lime, Colors.yellow, Colors.orange, Colors.deepOrange,
    ];
  }


  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController(text: widget.apiKey);
    _petNameController = TextEditingController(text: widget.petName);
    _localizationLanguage = widget.localizationLanguage;
    _tamagochiVisual = widget.tamagochiVisual;
    _windowSkins = Map.from(widget.windowSkins);
    _windowColors = Map.from(widget.windowColors);
    _hotkeys = Map.from(widget.hotkeys);
    
    // Инициализация состояний наведения для всех скинов
    for (var windowType in _windowTypes) {
      _skinHoverStates[windowType] = false;
      _hotkeyEditingStates[windowType] = false;
    }
    
    // Инициализация фокус нодов для горячих клавиш
    _hotkeyFocusNodes = {};
    _hotkeyLabels.keys.forEach((key) {
      _hotkeyFocusNodes[key] = FocusNode();
      _hotkeyEditingStates[key] = false;
    });
    
    // Подписываемся на изменения контроллеров для сохранения в реальном времени
    _apiKeyController.addListener(_saveApiKey);
    _petNameController.addListener(_savePetName);
  }

  @override
  void dispose() {
    _apiKeyController.removeListener(_saveApiKey);
    _petNameController.removeListener(_savePetName);
    _hotkeyFocusNodes.values.forEach((node) => node.dispose());
    super.dispose();
  }

  void _saveApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', _apiKeyController.text);
  }

  void _savePetName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_name', _petNameController.text);
  }

  void _saveLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('localization_language', _localizationLanguage);
  }

  void _saveTamagochiVisual() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tamagochi_visual', _tamagochiVisual);
  }

  void _saveWindowSkin(String windowType, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null) {
      await prefs.setString('skin_$windowType', value);
    } else {
      await prefs.remove('skin_$windowType');
    }
  }

  void _saveWindowColor(String windowType, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('color_$windowType', color.value);
  }

  void _saveHotkey(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hotkey_$key', value);
  }

 
 Future<void> _pickImage(String windowType) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: false,
  );

  if (result != null && result.files.isNotEmpty) {
    final filePath = result.files.first.path!;
    
    // Создаем директорию для сохранения скинов
    final documentsDir = await getApplicationDocumentsDirectory();
    final skinsDir = Directory(path.join(documentsDir.path, 'qwa', 'module_skins'));
    if (!await skinsDir.exists()) {
      await skinsDir.create(recursive: true);
    }

    // Копируем файл в целевую директорию
    final fileName = path.basename(filePath);
    final destPath = path.join(skinsDir.path, '${windowType}_$fileName');
    await File(filePath).copy(destPath);

    setState(() {
      _windowSkins[windowType] = destPath;
    });
  }
}

  void _removeSkin(String windowType) {
    setState(() {
      _windowSkins.remove(windowType);
      _windowColors[windowType] = Colors.grey[800]!;
    });
    
    // Сохраняем в реальном времени
    _saveWindowSkin(windowType, null);
    _saveWindowColor(windowType, Colors.grey[800]!);
  }

  Future<void> _handleFileDrop(String windowType, List<File> files) async {
    if (files.isNotEmpty) {
      final file = files.first;
      final filePath = file.path;
      
      // Создаем директорию для сохранения скинов
      final documentsDir = await getApplicationDocumentsDirectory();
      final skinsDir = Directory(path.join(documentsDir.path, 'qwa', 'module_skins'));
      if (!await skinsDir.exists()) {
        await skinsDir.create(recursive: true);
      }

      // Копируем файл в целевую директорию
      final fileName = path.basename(filePath);
      final destPath = path.join(skinsDir.path, '${windowType}_$fileName');
      await File(filePath).copy(destPath);

      setState(() {
        _windowSkins[windowType] = destPath;
      });
      
      // Сохраняем в реальном времени
      _saveWindowSkin(windowType, destPath);
    }
  }
void _showColorPicker(String windowType) {
  Color selectedColor = _windowColors[windowType] ?? Colors.grey[800]!;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Color(0xFF2B2B2B),
        title: Text(
          'Выберите цвет для ${_windowLabels[windowType]}',
          style: TextStyle(color: Colors.white),
        ),
        content: Container(
          width: 300,
          height: 300,
          child: _buildSimpleColorPicker(selectedColor, (color) {
            selectedColor = color;
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Отмена',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _windowColors[windowType] = selectedColor;
              });
              _saveWindowColor(windowType, selectedColor);
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildSimpleColorPicker(Color initialColor, ValueChanged<Color> onColorChanged) {
  // Базовые цвета
  final basicColors = [
    Colors.black, Colors.white, Colors.grey,
    Colors.red, Colors.pink, Colors.purple,
    Colors.deepPurple, Colors.indigo, Colors.blue,
    Colors.lightBlue, Colors.cyan, Colors.teal,
    Colors.green, Colors.lightGreen, Colors.lime,
    Colors.yellow, Colors.amber, Colors.orange,
    Colors.deepOrange, Colors.brown,
  ];

  // Оттенки серого
  final grayShades = [
    Colors.grey[50]!, Colors.grey[100]!, Colors.grey[200]!, 
    Colors.grey[300]!, Colors.grey[400]!, Colors.grey[500]!,
    Colors.grey[600]!, Colors.grey[700]!, Colors.grey[800]!, Colors.grey[900]!,
  ];

  // Текущий выбранный цвет
  Color currentColor = initialColor;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          // Текущий цвет
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: currentColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white),
            ),
            child: Center(
              child: Text(
                'RGB: ${currentColor.red}, ${currentColor.green}, ${currentColor.blue}',
                style: TextStyle(
                  color: currentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Базовые цвета
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: basicColors.length,
              itemBuilder: (context, index) {
                final color = basicColors[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentColor = color;
                    });
                    onColorChanged(color);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: currentColor.value == color.value ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          SizedBox(height: 16),
          
          // Оттенки серого
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: grayShades.length,
              itemBuilder: (context, index) {
                final color = grayShades[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentColor = color;
                    });
                    onColorChanged(color);
                  },
                  child: Container(
                    width: 40,
                    margin: EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: currentColor.value == color.value ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Hex ввод
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'HEX цвет',
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[800],
            ),
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              if (value.startsWith('#') && value.length == 7) {
                try {
                  final color = Color(int.parse(value.substring(1), radix: 16) + 0xFF000000);
                  setState(() {
                    currentColor = color;
                  });
                  onColorChanged(color);
                } catch (e) {
                  // ignore
                }
              }
            },
          ),
        ],
      );
    },
  );
}

  Widget _buildTamagochiOption(String option) {
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _tamagochiVisual == option ? Colors.blue : Colors.transparent,
          width: 3,
        ),
        image: DecorationImage(
          image: AssetImage(option),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            setState(() {
              _tamagochiVisual = option;
            });
            _saveTamagochiVisual();
          },
        ),
      ),
    );
  }




  Widget _buildWindowSkinWidget(String windowType) {
    final isEditingColor = _editingColorForWindow == windowType;
    
    return Container(
      width: 100,
      height: 240,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          // Название
          Container(
            height: 40,
            child: Center(
              child: Text(
                _windowLabels[windowType] ?? windowType,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: 8),
          
          // Основной виджет с картинкой и кнопками
          Container(
            width: 100,
            height: 180,
            decoration: BoxDecoration(
              color: _windowColors[windowType] ?? Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white54,
                width: 1,
              ),
              image: _windowSkins.containsKey(windowType)
                  ? DecorationImage(
                      image: FileImage(File(_windowSkins[windowType]!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                // Иконка если нет изображения
                if (!_windowSkins.containsKey(windowType))
                  Center(
                    child: Icon(
                      Icons.color_lens,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                
                // Если редактируем цвет - показываем пикер
                if (isEditingColor)
                  _buildColorPickerOverlay(windowType),
                
                // Кнопки внизу (меняются при редактировании цвета)
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: isEditingColor 
                      ? _buildColorEditButtons(windowType)
                      : _buildNormalButtons(windowType),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildColorPickerOverlay(String windowType) {
    return Container(
      width: 100,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            // Поле для HEX цвета (20px)
            Container(
              height: 20,
              child: TextField(
                controller: _hexController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  hintText: '#FFFFFF',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54, width: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54, width: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  isDense: true,
                ),
                onChanged: (value) {
                  final color = _hexToColor(value);
                  if (color != null) {
                    setState(() {
                      _tempColor = color;
                    });
                  }
                },
              ),
            ),
            
            SizedBox(height: 8),
            
            // Цветовая палитра (20x20 * 20 цветов = 100x80)
            Container(
              width: 100,
              height: 80,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 5 в ряд
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 1,
                ),
                itemCount: _getColorPalette().length,
                itemBuilder: (context, index) {
                  final color = _getColorPalette()[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _tempColor = color;
                        _hexController.text = _colorToHex(color);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                        border: _tempColor.value == color.value
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Текущий выбранный цвет (полоска 100x20)
            SizedBox(height: 8),
            Container(
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                color: _tempColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNormalButtons(String windowType) {
    return Container(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRoundButton(
            icon: Icons.color_lens,
            tooltip: 'Выбрать цвет',
            onPressed: () => _startColorEditing(windowType),
          ),
          SizedBox(width: 8),
          _buildRoundButton(
            icon: Icons.image,
            tooltip: 'Выбрать изображение',
            onPressed: () => _pickImage(windowType),
          ),
          SizedBox(width: 8),
          _buildRoundButton(
            icon: Icons.restore,
            tooltip: 'Сбросить настройки',
            onPressed: () => _removeSkin(windowType),
          ),
        ],
      ),
    );
  }
  
  Widget _buildColorEditButtons(String windowType) {
    return Container(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRoundButton(
            icon: Icons.check,
            tooltip: 'Применить цвет',
            onPressed: () => _applyColor(windowType),
          ),
          SizedBox(width: 8),
          _buildRoundButton(
            icon: Icons.close,
            tooltip: 'Отмена',
            onPressed: _cancelColorEditing,
          ),
        ],
      ),
    );
  }
  

    
  Widget _buildRoundButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: Color(0xFF2B2B2B).withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHotkeyField(String hotkeyId) {
    final label = _hotkeyLabels[hotkeyId] ?? hotkeyId;
    final currentValue = _hotkeys[hotkeyId] ?? '';
    final keyChar = currentValue.replaceAll('Alt+', '');
    
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              // Кнопка ALT
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF2B2B2B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  border: Border.all(color: Colors.white54),
                ),
                child: Center(
                  child: Text(
                    'ALT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Поле для ввода одной клавиши
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF2B2B2B),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border.all(color: Colors.white54),
                  ),
                  child: TextField(
                    focusNode: _hotkeyFocusNodes[hotkeyId],
                    controller: TextEditingController(text: keyChar),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      hintText: 'Клавиша',
                      hintStyle: TextStyle(color: Colors.white54),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    readOnly: true,
                    onTap: () {
                      setState(() {
                        _hotkeyEditingStates[hotkeyId] = true;
                      });
                      _hotkeyFocusNodes[hotkeyId]?.requestFocus();
                    },
                    onChanged: (value) {
                      // Обработка через RawKeyboardListener
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutsTab() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Горячие клавиши',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Нажмите на поле с клавишей и нажмите нужную клавишу на клавиатуре.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 20),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _hotkeyLabels.keys.map((hotkeyId) {
                  return _buildHotkeyField(hotkeyId);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseTab() {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Text(
          '''
ЛИЦЕНЗИОННОЕ СОГЛАШЕНИЕ НА ИСПОЛЬЗОВАНИЕ ПРОГРАММНОГО ОБЕСПЕЧЕНИЯ

1. ОБЩИЕ ПОЛОЖЕНИЯ
1.1. Настоящее Лицензионное соглашение (далее – "Соглашение") регулирует отношения между Вами (далее – "Пользователь") и разработчиком программного обеспечения (далее – "Лицензиар") в отношении использования программного обеспечения.

1.2. Используя программное обеспечение, Пользователь выражает свое полное и безоговорочное согласие со всеми условиями настоящего Соглашения.

2. ПРАВА И ОБЯЗАННОСТИ СТОРОН
2.1. Лицензиар предоставляет Пользователю неисключительную, непередаваемую лицензию на использование программного обеспечения на одном устройстве.

2.2. Пользователь обязуется:
- Не осуществлять декомпиляцию, дизассемблирование или модификацию программного обеспечения;
- Не использовать программное обеспечение в незаконных целях;
- Не удалять или изменять уведомления об авторских правах.

3. ОГРАНИЧЕНИЯ ОТВЕТСТВЕННОСТИ
3.1. Программное обеспечение предоставляется "как есть". Лицензиар не гарантирует бесперебойной работы программного обеспечения и не несет ответственности за любые косвенные убытки.

3.2. Лицензиар оставляет за собой право вносить изменения в программное обеспечение без предварительного уведомления Пользователя.

4. ЗАКЛЮЧИТЕЛЬНЫЕ ПОЛОЖЕНИЯ
4.1. Настоящее Соглашение действует бессрочно.

4.2. Лицензиар вправе вносить изменения в настоящее Соглашение с уведомлением Пользователя.

Дата вступления в силу: ${DateTime.now().toString().split(' ')[0]}
          ''',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialTab() {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Руководство пользователя',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            
            Text(
              'Добро пожаловать в приложение!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            
            Text(
              'Основные функции:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Настройте имя питомца для персонализации интерфейса',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '• Укажите API ключ для доступа к функционалу AI',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '• Выберите язык интерфейса из доступных вариантов',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '• Настройте визуализацию тамагочи',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            
            Text(
              'Настройки окон:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Для каждого типа окна можно установить свой скин',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '• Нажмите на цветной блок для выбора цвета окна',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '• Используйте drag & drop или кнопки для загрузки изображения',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '• Кнопка "default" сбрасывает настройки скина',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            
            Text(
              'Горячие клавиши:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Настройте горячие клавиши для быстрого доступа к функциям',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '• Нажмите на поле ввода и нажмите нужную клавишу',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Слушаем нажатия клавиш для всех полей горячих клавиш
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          final keyId = _hotkeyEditingStates.entries
              .firstWhere((entry) => entry.value == true, orElse: () => MapEntry('', false))
              .key;
          
          if (keyId.isNotEmpty && _hotkeyFocusNodes[keyId]?.hasFocus == true) {
            final logicalKey = event.logicalKey;
            final keyLabel = logicalKey.keyLabel;
            
            // Пропускаем служебные клавиши
            if (keyLabel.length == 1 || 
                ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12']
                    .contains(keyLabel) ||
                ['Space', 'Enter', 'Escape', 'Tab', 'Backspace', 'Delete']
                    .any((k) => logicalKey.toString().contains(k))) {
              
              setState(() {
                _hotkeys[keyId] = 'Alt+$keyLabel';
              });
              
              _saveHotkey(keyId, 'Alt+$keyLabel');
              _hotkeyFocusNodes[keyId]?.unfocus();
              
              setState(() {
                _hotkeyEditingStates[keyId] = false;
              });
            }
          }
        }
      },
      child: MaterialApp(
        home: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Row(
                children: [
                  // Левая панель с основными настройками
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2B2B).withOpacity(0.95),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A).withOpacity(0.9),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '⚙️ Настройки',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => windowManager.close(),
                                      child: const Icon(Icons.close, size: 20, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            // Основные настройки
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF1A1A1A).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Основные настройки',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),

                                  // Имя питомца
                                  TextField(
                                    controller: _petNameController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Имя питомца',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.white54),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.white54),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),

                                  // Язык локализации
                                  DropdownButtonFormField<String>(
                                    value: _localizationLanguage,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Язык интерфейса',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.white54),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.white54),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                    dropdownColor: Color(0xFF2B2B2B),
                                    items: _languageOptions.map((language) {
                                      return DropdownMenuItem(
                                        value: language,
                                        child: Text(language, style: TextStyle(color: Colors.white)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _localizationLanguage = value!;
                                      });
                                      _saveLanguage();
                                    },
                                  ),
                                  SizedBox(height: 16),

                                  // API ключ
                                  TextField(
                                    controller: _apiKeyController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'API Ключ',
                                      labelStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.white54),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.white54),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 16),

                                  // Визуализация тамагочи
                                  Text(
                                    'Визуализация тамагочи',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: _tamagochiOptions.map((option) {
                                        return _buildTamagochiOption(option);
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            // Скины окон
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF1A1A1A).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Скины окон',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Перетащите изображение на виджет или наведите для настроек',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: _windowTypes.map((windowType) {
                                        return _buildWindowSkinWidget(windowType);
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Правая панель с вкладками
                  Container(
                    width: 600,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A).withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Вкладки
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF2B2B2B).withOpacity(0.8),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => setState(() => _rightTabIndex = 0),
                                  style: TextButton.styleFrom(
                                    backgroundColor: _rightTabIndex == 0 
                                        ? Color(0xFF1A1A1A) 
                                        : Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Shortcuts',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: _rightTabIndex == 0 
                                          ? FontWeight.bold 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () => setState(() => _rightTabIndex = 1),
                                  style: TextButton.styleFrom(
                                    backgroundColor: _rightTabIndex == 1 
                                        ? Color(0xFF1A1A1A) 
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    'License Agreement',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: _rightTabIndex == 1 
                                          ? FontWeight.bold 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () => setState(() => _rightTabIndex = 2),
                                  style: TextButton.styleFrom(
                                    backgroundColor: _rightTabIndex == 2 
                                        ? Color(0xFF1A1A1A) 
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    'Tutorial',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: _rightTabIndex == 2 
                                          ? FontWeight.bold 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Контент вкладки
                        Expanded(
                          child: Container(
                            color: Color(0xFF1A1A1A),
                            child: _rightTabIndex == 0 
                                ? _buildShortcutsTab()
                                : _rightTabIndex == 1
                                    ? _buildLicenseTab()
                                    : _buildTutorialTab(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Кнопка сохранения
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    
                    // Сохраняем все настройки
                    await prefs.setString('api_key', _apiKeyController.text);
                    await prefs.setString('pet_name', _petNameController.text);
                    await prefs.setString('localization_language', _localizationLanguage);
                    await prefs.setString('tamagochi_visual', _tamagochiVisual);
                    
                    _windowSkins.forEach((key, value) async {
                      await prefs.setString('skin_$key', value);
                    });
                    
                    _windowColors.forEach((key, value) async {
                      await prefs.setInt('color_$key', value.value);
                    });
                    
                    _hotkeys.forEach((key, value) async {
                      await prefs.setString('hotkey_$key', value);
                    });
                    
                    windowManager.close();
                  },
                  icon: Icon(Icons.save),
                  label: Text('Сохранить настройки'),
                  backgroundColor: Color(0xFF2B2B2B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}












class NameInputScreen extends StatefulWidget {
  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ImeYou Tamagochi - Настройка'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => windowManager.close(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🎉 Добро пожаловать!',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Дайте имя вашему тамагочи:',
              style: TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Введите имя',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => windowManager.close(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('Закрыть', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('pet_name', _nameController.text);
                      await prefs.setBool('first_run', false);
                      
                      // Перезапускаем приложение в режиме тамагочи
                      await windowManager.destroy();
                      await _initMainWindow();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('Продолжить', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



  // Структура для кадров анимации
  class AnimationFrame {
    final String imagePath;
    final int durationMs;

    AnimationFrame(this.imagePath, this.durationMs);
  }

class TamagochiOverlay extends StatefulWidget {
  @override
  _TamagochiOverlayState createState() => _TamagochiOverlayState();
}

class _TamagochiOverlayState extends State<TamagochiOverlay>
    with WindowListener, TickerProviderStateMixin {
  // Состояние питомца
  
  final NativeSMTC _smtc = NativeSMTC();
  String _title = 'Не воспроизводится';
  String _artist = 'Нет данных';
  String _album = 'Нет данных';
  String _playbackState = 'Нет данных';
  String _lastUpdate = '';
  final GlobalKey _screenshotKey = GlobalKey();
  bool _screenshotAnalyzeActive = false;
  String _analysisResult = '';
    double _happiness = 50.0;
  double _hunger = 50.0;
  int _level = 1;
  int _daysAlive = 0;
  bool _isAlive = true;
  bool _isSleeping = false;
  String _petName = 'Тамагочи';
  bool _mouseOverWidgetOrChat = false;
  Timer? _longPressTimer;
  bool _isLongPressing = false;
  double _scale = 1.0;
  double _opacity = 0.0;
  bool _showStatus = false;
  bool _showRecentFiles = false;
  bool _isHoveringRecentFiles = false;
  final GlobalKey _petKey = GlobalKey();
  // Файлы и чат
  late List<String> _eatenFiles = [];
  final List<Map<String, String>> _chatHistory = [];
  String _apiKey = '';
  bool _useDeepSeek = true;
  final TextEditingController _promptController = TextEditingController();
  Process? _chatProcess;
  bool _isChatOpen = false;
  // Таймеры
  Timer? _dayTimer;
  Timer? _stateTimer;
  Timer? _movementTimer;
  Timer? _hoverTimer;
  Timer? _idleTimer;
 final String _storageDir = path.join(Directory.current.path, 'imeyou_pet', 'eaten_files');
  // Движение и позиционирование
  bool _isFollowingCursor = false;
  bool _isDragging = false;
  bool _isMovingWindow = false;
  bool _isAnimatingDrop = false;
  bool _contextMenuOpen = false;
  double _screenWidth = 1920;
  double _screenHeight = 1080;
  double _windowWidth = 260;
  double _windowHeight = 270;
  Offset _dragStartOffset = Offset.zero;
  Offset _windowStartOffset = Offset.zero;
  double _idleOffset = 0;
  double _idleDirection = 1;
  DateTime _lastCursorMove = DateTime.now();
  Offset _userSetPosition = Offset.zero;
  bool _userHasSetPosition = false;

  // Физика движения
  Offset _velocity = Offset.zero;
  Offset _position = Offset.zero;
  bool _isThrown = false;
  double _gravity = 0.5;
  double _friction = 0.95;
  double _bounceFactor = 0.7;
  Timer? _physicsTimer;

  // Анимации
  Map<String, List<AnimationFrame>> _animations = {};
  String _currentAnimation = 'idle';
  int _currentFrameIndex = 0;
  Timer? _animationTimer;
  DateTime _lastFrameChange = DateTime.now();

  // Оверлеи
  OverlayEntry? _chatOverlay;
  OverlayEntry? _contextMenuOverlay;
  OverlayEntry? _submenuOverlay;
  OverlayEntry? _fileViewerOverlay;
  bool _chatOverlayVisible = false;
  bool _isMusicPlaying = false;
  Timer? _musicCheckTimer;
  bool _chatIsReadyToReceiveMessages=false;
late final KeyboardLogger _keyboardLogger = KeyboardLogger();
late final HotkeyService _hotkeyService = HotkeyService();
late final http.Client _httpClient = http.Client();
String _defaultLanguage = 'ru';
Localization _locale = Localization();
  // Фразы
  List<String> _randomPhrases = [
    "Привет! Как дела?",
    "Я голоден!",
    "Поиграй со мной!",
    "Отличный день!",
    "Мне скучно...",
    "Ура! Новый файл!",
    "Я тебя люблю!",
    "Время покушать!",
  ];

  String _currentPhrase = "";

  late List<EatenFile> _files;
  late List<EatenFile> _filteredFiles;
  List<String> _recentlyOpened = [];
  final String _sharedFilesPath = 'eaten_files.json';
  final String _recentFilesPath = 'recent_files.json';
   final Map<String, Uint8List> _iconCache = {};
Timer? _clipboardTimer;
  Set<String> _lastFiles = {};

  static Process? _powerShellProcess;
  static Timer? _checkTimer;
  static final _script = '''
Add-Type -AssemblyName System.Windows.Forms
if ([System.Windows.Forms.Clipboard]::ContainsFileDropList()) {
    \$files = [System.Windows.Forms.Clipboard]::GetFileDropList()
    return (\$files | ConvertTo-Json -Compress)
}
return "[]"
''';


void _tabKeyPressed(String key){
    int index=-1;
    if (key=="Q"){
      index=0;
    } else
    if (key=="W"){
      index=1;
    } else
    if (key=="E"){
      index=2;
    } else
    if (key=="A"){
      index=3;
    } else
    if (key=="S"){
      index=4;
    } else
    if (key=="D"){
      index=5;
    } else
    if (key=="Z"){
      index=6;
    } else
    if (key=="X"){
      index=7;
    } else
    if (key=="C"){
      index=8;
    }
      if (index==-1) return;
      
// Сортируем файлы: сначала помеченные звездочкой, затем по частоте открытий, затем по давности последнего открытия
    final sortedFiles = _files.toList()
      ..sort((a, b) {
        // 1. Сначала помеченные звездочкой
        if (a.isStarred && !b.isStarred) return -1;
        if (!a.isStarred && b.isStarred) return 1;
        
        // 2. Затем по частоте открытий (по убыванию)
        final openCountComparison = b.openCount.compareTo(a.openCount);
        if (openCountComparison != 0) return openCountComparison;
        
        // 3. Затем по давности последнего открытия (сначала недавно открытые)
        if (a.lastOpened != null && b.lastOpened != null) {
          return b.lastOpened!.compareTo(a.lastOpened!);
        }
        if (a.lastOpened != null) return -1;
        if (b.lastOpened != null) return 1;
        
        return 0;
      });
      
                  final file=sortedFiles[index];
                   final displayName = file.isWeb? file.pageTitle : _getDisplayFileName(file);
            
            // Безопасная проверка на папку
            bool isDirectory = false;
            if (!file.isWeb) {
              try {
                final dir = Directory(file.path);
                isDirectory = dir.existsSync();
              } catch (e) {
                isDirectory = false;
              }
            }
            
                  setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
                  if (file.isWeb) {
                    _openWebUrl(file);
                  } else if (isDirectory) {
                    _openFile(file); // Нужно добавить этот метод
                  } else {
                    _openFile(file);
                  }
                  _incrementOpenCount(file);
                  _isFollowingCursor = false;
    


}
  Future<void> _registerHotkeys() async {

    /*
    await _hotkeyService.registerHotkey(
      modifier: 'tab',
      key: 'q',
      onPressed: () {_tabKeyPressed("Q");
     }
    );
    
    await _hotkeyService.registerHotkey(
      modifier: 'tab',
      key: 'w',
      onPressed: () {_tabKeyPressed("W");
     }
    );
    await _hotkeyService.registerHotkey(
      modifier: 'tab',
      key: 'e',
      onPressed: () {_tabKeyPressed("E");
     }
    );
    await _hotkeyService.registerHotkey(
      modifier: 'tab',
      key: 'a',
      onPressed: () {_tabKeyPressed("A");
     }
    );
    await _hotkeyService.registerHotkey(
      modifier: 'tab',
      key: 's',
      onPressed: () {_tabKeyPressed("S");
     }
    );
    await _hotkeyService.registerHotkey(
      modifier: 'tab',
      key: 'd',
      onPressed: () {_tabKeyPressed("D");
     }
    );
    await _hotkeyService.registerHotkey(
      modifier: 'tab',
      key: 'z',
      onPressed: () {_tabKeyPressed("Z");
     }
    );
    await _hotkeyService.registerHotkey(
      modifier: 'tab',
      key: 'x',
      onPressed: () {_tabKeyPressed("X");
     }
    );
    await _hotkeyService.registerHotkey(
      modifier: 'tab',
      key: 'c',
      onPressed: () {_tabKeyPressed("C");
     }
    );
    */
    
    // Alt+Z
    await _hotkeyService.registerHotkey(
      modifier: 'alt',
      key: 'z',
      onPressed: () => _openFullChatWindow(),
    );

    await _hotkeyService.registerHotkey(
      modifier: 'alt',
      key: 'a',
      onPressed: () => _showFileViewer(),
    );

    await _hotkeyService.registerHotkey(
      modifier: 'alt',
      key: 'e',
      onPressed: () => _showMacroKeyboardWindow(),
    );

    // Alt+X
    await _hotkeyService.registerHotkey(
      modifier: 'alt',
      key: 'x',
      onPressed: () => _showEssentialsViewer(),
    );

    // Alt+C
    await _hotkeyService.registerHotkey(
      modifier: 'alt',
      key: 'c',
      onPressed: () => _showCNPWindow(),
    );

    // Alt+V
    await _hotkeyService.registerHotkey(
      modifier: 'alt',
      key: 'v',
      onPressed: () => _copyVisibleAndOpenChatCopyCliplboardAsEntry(),
    );

    // Alt+S
    await _hotkeyService.registerHotkey(
      modifier: 'alt',
      key: 's',
      onPressed: () => _showScreenshotViewer(),
    );

   await _hotkeyService.registerHotkey(
      modifier: 'alt',
      key: 'q',
      onPressed: () => _translateCurrentSelectionToDefaultLanguage(),
    );

    await _hotkeyService.registerHotkey(
      modifier: 'alt',
      key: 'w',
      onPressed: () => _translateCurrentSelectionToEnglish(),
    );

  }

// Функция для получения информации о фокусе в Windows
Future<WindowsFocusInfo?> _getWindowsFocusInfo() async {
  try {
    const MethodChannel channel = MethodChannel('screenshot_channel');
    final String result = await channel.invokeMethod('getFocusInfo');
    return WindowsFocusInfo.fromJson(result);
  } catch (e) {
    print('Error getting Windows focus info: $e');
    return null;
  }
}
 

     static Future<String> getCurrentInputLanguage() async {
      const MethodChannel _channel = 
      MethodChannel('screenshot_channel');

    try {
      final String languageCode = 
          await _channel.invokeMethod('getCurrentInputLanguage');
      return languageCode;
    } on PlatformException catch (e) {
      print("Ошибка получения языка ввода: ${e.message}");
      return 'en'; // Язык по умолчанию при ошибке
    }
  }



Future<void> _translateCurrentSelectionToDefaultLanguage() async {
    final targetLanguage =  await getCurrentInputLanguage();
  await _translateAndReplaceSelection(targetLanguage);
}

Future<void> _translateCurrentSelectionToEnglish() async {
  await _translateAndReplaceSelection('en');
}

Future<void> _translateAndReplaceSelection(String targetLanguage) async {
  try {
    // Получаем информацию о фокусе и выделенном тексте
    final focusInfo = await _getWindowsFocusInfo();
    
    if (focusInfo == null ||focusInfo.selectedText==null || focusInfo.selectedText!.isEmpty) {
      //_showMessage('Нет выделенного текста для перевода');
      return;
    }

    final selectedText = focusInfo.selectedText!.trim();
    
    // Проверяем, что текст не является URL или email
    if (_isUrlOrEmail(selectedText)) {
      //_showMessage('Выделенный текст является URL или email, перевод пропущен');
      return;
    }

    // Определяем исходный язык
    final sourceLanguage = await _detectLanguage(selectedText);
    
    // Если исходный язык уже целевой - не переводим
    if (sourceLanguage == targetLanguage) {
      //_showMessage('Текст уже на целевом языке');
      return;
    }

    // Выполняем перевод
    String translatedText = await _translateWithLibreTranslate(selectedText, sourceLanguage, targetLanguage);
    
    if (translatedText.isEmpty) {
      translatedText = await _translateWithMyMemory(selectedText, sourceLanguage, targetLanguage);
    }

    if (translatedText.isNotEmpty) {
      // Копируем переведенный текст в буфер обмена
      await Clipboard.setData(ClipboardData(text: translatedText));
        AppLogger.writeLog('should be: $selectedText --> $translatedText');
      // Имитируем вставку (Ctrl+V) в текущее окно
      await _simulatePaste();
      
      //_showMessage('Текст переведен и вставлен');
    } else {
      //_showMessage('Не удалось выполнить перевод');
    }
    
  } catch (e) {
    //_showMessage('Ошибка перевода: $e');
  }
}

bool _isUrlOrEmail(String text) {
  final urlRegex = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    caseSensitive: false,
  );
  
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );
  
  return urlRegex.hasMatch(text) || emailRegex.hasMatch(text);
}

Future<void> _simulatePaste() async {
  try {
    const MethodChannel channel = MethodChannel('screenshot_channel');
    await channel.invokeMethod('simulatePaste');
  } catch (e) {
    print('Error simulating paste: $e');
    // Fallback: показываем сообщение с инструкцией
    //_showMessage('Переведенный текст скопирован в буфер. Нажмите Ctrl+V для вставки');
  }
}


// Бесплатный API LibreTranslate
Future<String> _translateWithLibreTranslate(String text, String from, String to) async {
  try {
    final response = await _httpClient.post(
      Uri.parse('https://libretranslate.de/translate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'source': from,
        'target': to,
        'format': 'text'
      }),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['translatedText'] ?? '';
    }
  } catch (e) {
    print('LibreTranslate error: $e');
  }
  return '';
}

// Резервный API MyMemory
Future<String> _translateWithMyMemory(String text, String from, String to) async {
  try {
    final response = await _httpClient.get(
      Uri.parse('https://api.mymemory.translated.net/get?'
          'q=${Uri.encodeComponent(text)}&'
          'langpair=$from|$to'),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['responseData']['translatedText'] ?? '';
    }
  } catch (e) {
    print('MyMemory error: $e');
  }
  return '';
}

Future<String> _detectLanguage(String text) async {
  try {
    // Простая эвристика для определения языка
    return _detectLanguageBasic(text);
    
    // Для более точного определения можно использовать API (раскомментировать при необходимости)
    // return await _detectLanguageWithAPI(text);
  } catch (e) {
    return _detectLanguageBasic(text);
  }
}

// API определение языка (раскомментировать при необходимости)
/*
Future<String> _detectLanguageWithAPI(String text) async {
  try {
    final response = await _httpClient.post(
      Uri.parse('https://libretranslate.de/detect'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'q': text}),
    ).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['language'] ?? 'en';
      }
    }
  } catch (e) {
    print('Language detection API error: $e');
  }
  return _detectLanguageBasic(text);
}
*/

String _detectLanguageBasic(String text) {
  // Улучшенная эвристика для определения языка
  final russianRegex = RegExp(r'[а-яА-ЯёЁ]');
  final englishRegex = RegExp(r'[a-zA-Z]');
  final koreanRegex = RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]');
  final chineseRegex = RegExp(r'[\u4e00-\u9fff]');
  final japaneseRegex = RegExp(r'[\u3040-\u309F\u30A0-\u30FF]');
  
  // Подсчет символов разных языков
  int russianCount = russianRegex.allMatches(text).length;
  int englishCount = englishRegex.allMatches(text).length;
  int koreanCount = koreanRegex.allMatches(text).length;
  int chineseCount = chineseRegex.allMatches(text).length;
  int japaneseCount = japaneseRegex.allMatches(text).length;
  
  // Определяем язык по преобладающим символам
  if (russianCount > 0 && russianCount > englishCount) return 'ru';
  if (koreanCount > 0) return 'ko';
  if (chineseCount > 0) return 'zh';
  if (japaneseCount > 0) return 'ja';
  if (englishCount > 0) return 'en';
  
  return 'en'; // По умолчанию английский
}


  void startMonitoring({int intervalMs = 1000}) {
    stopMonitoring(); // Останавливаем предыдущий таймер
    
    _checkTimer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (Timer t) => _checkWindowsClipboard()
    );
  }

  void _handleNewFiles(List<String> files) {
    return;
    final newFiles = files.toSet().difference(_lastFiles);
    if (newFiles.isNotEmpty) {
      // Файлы появились в буфере обмена - возможно началось перетаскивание
      print('Potential file drag detected: $newFiles');
      // Вызываем вашу функцию
      _handleFileDrag();
    }
    _lastFiles = files.toSet();
  }
  Future<void> _ensurePowerShell() async {
    if (_powerShellProcess != null) return;

    _powerShellProcess = await Process.start('powershell', [
      '-NoProfile',
      '-Command',
      '-'
    ], runInShell: false);
  }
   Future<void> _checkWindowsClipboard() async {
    try {
      await _ensurePowerShell();
      
      // Отправляем команду в существующий процесс
      _powerShellProcess!.stdin.writeln(_script);
      
      // Читаем результат с таймаутом
      final output = await _powerShellProcess!.stdout
          .transform(utf8.decoder)
          .transform(LineSplitter())
          .first
          .timeout(const Duration(seconds: 5));

      final filesJson = output.trim();
      if (filesJson != "[]") {
        try {
          final files = List<String>.from(json.decode(filesJson));
          _handleNewFiles(files);
        } catch (e) {
          print('Error parsing files: $e');
        }
      }
    } catch (e) {
      print('Clipboard check error: $e');
      // Пересоздаем процесс при ошибке
      _powerShellProcess?.kill();
      _powerShellProcess = null;
    }
  }




 Future<Uint8List?> _getFavicon(String url) async {
    try {
      final domain = _getDomainName(url);
      final faviconUrl = 'https://www.google.com/s2/favicons?domain=$domain&sz=32';
      final response = await http.get(Uri.parse(faviconUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      debugPrint('Error getting favicon: $e');
    }
    return null;
  }   
void _incrementOpenCount(EatenFile file) async {
    setState(() {
      file.openCount++;
      file.lastOpened = DateTime.now();
    });
    await _saveFile(file);
    _updateFilteredFiles();
  }



  void _updateFilteredFiles() {
  List<EatenFile> currentList = [];
  final Map<String, Uint8List> _iconCache = {};
  
    // Сначала помеченные звездочкой, затем по частоте открытий
    final starredFiles = _files.where((file) => file.isStarred).toList();
    final otherFiles = _files.where((file) => !file.isStarred).toList()
      ..sort((a, b) => b.openCount.compareTo(a.openCount));
    
    currentList = [...starredFiles, ...otherFiles];
  



    // Группируем по времени
    setState(() {
      _filteredFiles = currentList;
    });
  }

  

Future<Uint8List?> _getCachedIcon(EatenFile file) async {
  final cacheKey = file.isWeb ? 'web_${_getDomainName(file.path)}' : 'file_${file.path}';
  
  if (_iconCache.containsKey(cacheKey)) {
    return _iconCache[cacheKey];
  }
  
  Uint8List? iconBytes;
  if (file.isWeb) {
    iconBytes = await _getFavicon(file.path);
  } else {

    iconBytes =  await _getFileIcon(file);
  }
  
  if (iconBytes != null) {
    _iconCache[cacheKey] = iconBytes;
  }
  
  return iconBytes;
}

  void _onAnalysisResult(String result) {
    setState(() {
      _analysisResult = result;
    });
    print('Received analysis result: $result');
  }
  
  void _startAnalysis() async {
    bool success = await ScreenAnalysis.startAnalysis();
    if (success) {
      print('Screen analysis started');
    }
  }
  
  void _stopAnalysis() async {
    bool success = await ScreenAnalysis.stopAnalysis();
    if (success) {
      print('Screen analysis stopped');
    }
  }
  

  void _closeChatWindow() {
    _chatProcess?.kill();
    _chatProcess = null;
    _isChatOpen = false;
    // Не нужно удалять listener, так как мы используем миксин
  }
void _toggleChatWindow() async {
  const chatProcessId = 'chat_window';

  if (ProcessManager().hasProcess(chatProcessId)) {
    ProcessManager().killProcess(chatProcessId);
    _isChatOpen = false;
    return;
  }


  try {
    final pos = await windowManager.getPosition();
    final fullChatHistory = await _loadFullChatHistory();

    // JSON истории чата
    String chatHistoryJson;
    try {
      chatHistoryJson = json.encode(fullChatHistory);
      
    } catch (e) {
      
      chatHistoryJson = '[]';
    }

    // Логируем аргументы
    

    // Запуск дочернего процесса чата
    final process = await Process.start(
      Platform.resolvedExecutable,
      [
        'chat',
        chatHistoryJson,
        pos.dx.toString(),
        pos.dy.toString(),
      ],
    );

    

    ProcessManager().registerProcess(chatProcessId, process);
    _isChatOpen = true;

    // Слушаем stderr процесса
    process.stderr.transform(utf8.decoder).listen((data) async {
      
    });

    // Таймер для передачи координат каждые 80 мс
    Timer.periodic(Duration(milliseconds: 155), (timer) async {
      if (!ProcessManager().hasProcess(chatProcessId)) {
        timer.cancel();
        return;
      }
      if (!mounted) { // ← Добавьте эту проверку
        timer.cancel();
        return;
      }
      final currentPos = await windowManager.getPosition();
      final proc = ProcessManager().getProcess(chatProcessId);
      proc?.stdin.writeln('${currentPos.dx},${currentPos.dy}');
    });

    process.exitCode.then((code) async {
      
      if (mounted) {
        setState(() {
          _isChatOpen = false;
        });
      }
      ProcessManager().killProcess(chatProcessId);
    });
  } catch (e) {
    
    print('Error opening chat window: $e');
    _isChatOpen = false;
  }
}


void _windowListener() async {
  if (_isChatOpen) {
    final pos = await windowManager.getPosition();
    final size = await windowManager.getSize();
    
    // TODO: Отправить новую позицию процессу чата через IPC
  }
}



Future<void> _loadSharedFiles() async {
  try {
    final dir = Directory(_storageDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
      return;
    }
    
    final List<EatenFile> loadedFiles = [];
    final entities = await dir.list().toList();
    
    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.json')) {
        try {
          final content = await entity.readAsString();
          if (content.trim().isNotEmpty) {
            final jsonData = json.decode(content);
            final file = EatenFile.fromJson(jsonData);
            loadedFiles.add(file);
          }
        } catch (e) {
          debugPrint('Error loading file ${entity.path}: $e');
        }
      }
    }
    
    // Сортируем: сначала помеченные звездочкой, затем по частоте открытий
    loadedFiles.sort((a, b) {
      if (a.isStarred && !b.isStarred) return -1;
      if (!a.isStarred && b.isStarred) return 1;
      return b.openCount.compareTo(a.openCount);
    });
    
    setState(() {
      _files = loadedFiles;
      _updateFilteredFiles();
    });
    
    // Загружаем иконки для файлов
    _loadIconsForFiles();
  } catch (e) {
    debugPrint('Error loading files from storage: $e');
  }
}

void _loadIconsForFiles() async {
  for (var file in _files) {
    if (file.iconBytes == null) {
      final iconBytes = await _getCachedIcon(file);
      if (iconBytes != null && mounted) {
        setState(() {
          file.iconBytes = iconBytes;
        });
      }
    }
  }
}

Future<void> _saveFile(EatenFile file) async {
  try {
    final fileName = '${file.id}.json';
    final filePath = path.join(_storageDir, fileName);
    final outputFile = File(filePath);
    final dir = outputFile.parent;
    
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    
    await outputFile.writeAsString(json.encode(file.toJson()));
  } catch (e) {
    debugPrint('Error saving file: $e');
  }
}

Future<void> _deleteFile(EatenFile file) async {
  try {
    // Удаляем файл данных
    final fileName = '${file.id}.json';
    final filePath = path.join(_storageDir, fileName);
    final outputFile = File(filePath);
    
    if (await outputFile.exists()) {
      await outputFile.delete();
    }
    
    // Удаляем из кэша иконок
    final cacheKey = file.isWeb ? 'web_${_getDomainName(file.path)}' : 'file_${file.path}';
    _iconCache.remove(cacheKey);
    
    // Обновляем UI
    setState(() {
      _files.remove(file);
      _updateFilteredFiles();
    });
  } catch (e) {
    debugPrint('Error deleting file: $e');
  }
}
Future<void> _saveSharedFiles() async {
  try {
    final dir = Directory(_storageDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    
    // Сохраняем каждый файл отдельно
    for (var file in _files) {
      await _saveFile(file);
    }
    
    debugPrint('Saved ${_files.length} files to storage');
  } catch (e) {
    debugPrint('Error saving files to storage: $e');
  }
}

// Или если нужно сохранить только один файл:
Future<void> _saveSingleFile(EatenFile file) async {
  try {
    await _saveFile(file);
  } catch (e) {
    debugPrint('Error saving single file: $e');
  }
}

// Метод для массового сохранения (если нужно)
Future<void> _saveAllFiles(List<EatenFile> files) async {
  try {
    final dir = Directory(_storageDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    
    for (var file in files) {
      await _saveFile(file);
    }
    
    debugPrint('Saved ${files.length} files to storage');
  } catch (e) {
    debugPrint('Error saving all files: $e');
  }
}

Future<void> _keyLoggerActivate() async {
    //await _keyboardLogger.initialize();
}
  static void stopMonitoring() {
    _checkTimer?.cancel();
    _checkTimer = null;
    _powerShellProcess?.kill();
    _powerShellProcess = null;
  }


  /*

void _setupKeyboardListener() {
  RawKeyboard.instance.addListener((RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (_showRecentFiles == false) return;

      // Получаем реально видимые файлы с учетом скролла
      final visibleFiles = _getVisibleFiles();
      
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        setState(() {
          _showRecentFiles = false;
          _isHoveringRecentFiles = false;
        });
      } else {
        final keyMapping = {
          LogicalKeyboardKey.keyQ: 0,
          LogicalKeyboardKey.keyW: 1,
          LogicalKeyboardKey.keyE: 2,
          LogicalKeyboardKey.keyA: 3,
          LogicalKeyboardKey.keyS: 4,
          LogicalKeyboardKey.keyD: 5,
          LogicalKeyboardKey.keyZ: 6,
          LogicalKeyboardKey.keyX: 7,
          LogicalKeyboardKey.keyC: 8,
        };

        if (keyMapping.containsKey(event.logicalKey)) {
          final index = keyMapping[event.logicalKey]!;
          
          if (index < visibleFiles.length) {
            final file = visibleFiles[index];
            _openFileByKey(file);
          } else {
            print('No visible file at position $index');
          }
        }
      }
    }
  });
}
*/


void _setupKeyboardListener() {
  RawKeyboard.instance.addListener((RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      //peekay
    if (_showRecentFiles==false) return;
// Сортируем файлы: сначала помеченные звездочкой, затем по частоте открытий, затем по давности последнего открытия
 final sortedFiles = _files.toList()
    ..sort((a, b) {
      // 1. Сначала помеченные звездочкой
      if (a.isStarred && !b.isStarred) return -1;
      if (!a.isStarred && b.isStarred) return 1;
      
      // 2. Затем по частоте открытий (по убыванию)
      final openCountComparison = b.openCount.compareTo(a.openCount);
      if (openCountComparison != 0) return openCountComparison;
      
      // 3. Затем по давности последнего открытия (сначала недавно открытые)
      if (a.lastOpened != null && b.lastOpened != null) {
        return b.lastOpened!.compareTo(a.lastOpened!);
      }
      if (a.lastOpened != null) return -1;
      if (b.lastOpened != null) return 1;
      
      return 0;
    });


      //final visibleFiles = _getVisibleFiles();


      if (event.logicalKey == LogicalKeyboardKey.escape) {
        setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
      } else if ( event.logicalKey == LogicalKeyboardKey.keyQ) {
                  final file=sortedFiles[0];
                   final displayName = file.isWeb? file.pageTitle : _getDisplayFileName(file);
            
            // Безопасная проверка на папку
            bool isDirectory = false;
            if (!file.isWeb) {
              try {
                final dir = Directory(file.path);
                isDirectory = dir.existsSync();
              } catch (e) {
                isDirectory = false;
              }
            }
            
                  setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
                  if (file.isWeb) {
                    _openWebUrl(file);
                  } else if (isDirectory) {
                    _openFile(file); // Нужно добавить этот метод
                  } else {
                    _openFile(file);
                  }
                  _incrementOpenCount(file);
                  _isFollowingCursor = false;
                  

      } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
        final file=sortedFiles[1];
         final displayName = file.isWeb? file.pageTitle : _getDisplayFileName(file);
            
            // Безопасная проверка на папку
            bool isDirectory = false;
            if (!file.isWeb) {
              try {
                final dir = Directory(file.path);
                isDirectory = dir.existsSync();
              } catch (e) {
                isDirectory = false;
              }
            }
            
                  setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
                  if (file.isWeb) {
                    _openWebUrl(file);
                  } else if (isDirectory) {
                    _openFile(file); // Нужно добавить этот метод
                  } else {
                    _openFile(file);
                  }
                  _incrementOpenCount(file);
                  _isFollowingCursor = false;
      } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
        final file=sortedFiles[2];
         final displayName = file.isWeb? file.pageTitle : _getDisplayFileName(file);
            
            // Безопасная проверка на папку
            bool isDirectory = false;
            if (!file.isWeb) {
              try {
                final dir = Directory(file.path);
                isDirectory = dir.existsSync();
              } catch (e) {
                isDirectory = false;
              }
            }
            
                  setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
                  if (file.isWeb) {
                    _openWebUrl(file);
                  } else if (isDirectory) {
                    _openFile(file); // Нужно добавить этот метод
                  } else {
                    _openFile(file);
                  }
                  _incrementOpenCount(file);
                  _isFollowingCursor = false;
      } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
        final file=sortedFiles[3];
         final displayName = file.isWeb? file.pageTitle : _getDisplayFileName(file);
            
            // Безопасная проверка на папку
            bool isDirectory = false;
            if (!file.isWeb) {
              try {
                final dir = Directory(file.path);
                isDirectory = dir.existsSync();
              } catch (e) {
                isDirectory = false;
              }
            }
            
                  setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
                  if (file.isWeb) {
                    _openWebUrl(file);
                  } else if (isDirectory) {
                    _openFile(file); // Нужно добавить этот метод
                  } else {
                    _openFile(file);
                  }
                  _incrementOpenCount(file);
                  _isFollowingCursor = false;
      } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
        final file=sortedFiles[4];
         final displayName = file.isWeb? file.pageTitle : _getDisplayFileName(file);
            
            // Безопасная проверка на папку
            bool isDirectory = false;
            if (!file.isWeb) {
              try {
                final dir = Directory(file.path);
                isDirectory = dir.existsSync();
              } catch (e) {
                isDirectory = false;
              }
            }
            
                  setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
                  if (file.isWeb) {
                    _openWebUrl(file);
                  } else if (isDirectory) {
                    _openFile(file); // Нужно добавить этот метод
                  } else {
                    _openFile(file);
                  }
                  _incrementOpenCount(file);
                  _isFollowingCursor = false;
      } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
       final file=sortedFiles[5];
        final displayName = file.isWeb? file.pageTitle : _getDisplayFileName(file);
            
            // Безопасная проверка на папку
            bool isDirectory = false;
            if (!file.isWeb) {
              try {
                final dir = Directory(file.path);
                isDirectory = dir.existsSync();
              } catch (e) {
                isDirectory = false;
              }
            }
            
                  setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
                  if (file.isWeb) {
                    _openWebUrl(file);
                  } else if (isDirectory) {
                    _openFile(file); // Нужно добавить этот метод
                  } else {
                    _openFile(file);
                  }
                  _incrementOpenCount(file);
                  _isFollowingCursor = false;
      }else if (event.logicalKey == LogicalKeyboardKey.keyZ) {
        final file=sortedFiles[6];
         final displayName = file.isWeb? file.pageTitle : _getDisplayFileName(file);
            
            // Безопасная проверка на папку
            bool isDirectory = false;
            if (!file.isWeb) {
              try {
                final dir = Directory(file.path);
                isDirectory = dir.existsSync();
              } catch (e) {
                isDirectory = false;
              }
            }
            
                  setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
                  if (file.isWeb) {
                    _openWebUrl(file);
                  } else if (isDirectory) {
                    _openFile(file); // Нужно добавить этот метод
                  } else {
                    _openFile(file);
                  }
                  _incrementOpenCount(file);
                  _isFollowingCursor = false;
      }else if (event.logicalKey == LogicalKeyboardKey.keyX) {
        final file=sortedFiles[7];
         final displayName = file.isWeb? file.pageTitle : _getDisplayFileName(file);
            
            // Безопасная проверка на папку
            bool isDirectory = false;
            if (!file.isWeb) {
              try {
                final dir = Directory(file.path);
                isDirectory = dir.existsSync();
              } catch (e) {
                isDirectory = false;
              }
            }
            
                  setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
                  if (file.isWeb) {
                    _openWebUrl(file);
                  } else if (isDirectory) {
                    _openFile(file); // Нужно добавить этот метод
                  } else {
                    _openFile(file);
                  }
                  _incrementOpenCount(file);
                  _isFollowingCursor = false;
      }else if (event.logicalKey == LogicalKeyboardKey.keyC) {
        final file=sortedFiles[8];
         final displayName = file.isWeb? file.pageTitle : _getDisplayFileName(file);
            
            // Безопасная проверка на папку
            bool isDirectory = false;
            if (!file.isWeb) {
              try {
                final dir = Directory(file.path);
                isDirectory = dir.existsSync();
              } catch (e) {
                isDirectory = false;
              }
            }
            
                  setState(() {
                    _showRecentFiles = false;
                    _isHoveringRecentFiles = false;
                  });
                  if (file.isWeb) {
                    _openWebUrl(file);
                  } else if (isDirectory) {
                    _openFile(file); // Нужно добавить этот метод
                  } else {
                    _openFile(file);
                  }
                  _incrementOpenCount(file);
                  _isFollowingCursor = false;
      }
    }
  });
}


 List<EatenFile> _getVisibleFiles() {

  final sortedFiles = _files.toList()
    ..sort((a, b) {
      // 1. Сначала помеченные звездочкой
      if (a.isStarred && !b.isStarred) return -1;
      if (!a.isStarred && b.isStarred) return 1;
      
      // 2. Затем по частоте открытий (по убыванию)
      final openCountComparison = b.openCount.compareTo(a.openCount);
      if (openCountComparison != 0) return openCountComparison;
      
      // 3. Затем по давности последнего открытия (сначала недавно открытые)
      if (a.lastOpened != null && b.lastOpened != null) {
        return b.lastOpened!.compareTo(a.lastOpened!);
      }
      if (a.lastOpened != null) return -1;
      if (b.lastOpened != null) return 1;
      
      return 0;
    });


    final renderObject = _gridViewKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderObject == null) return sortedFiles.take(9).toList();

    final viewport = renderObject as RenderSliverGrid?;
    if (viewport == null) return sortedFiles.take(9).toList();

    // Получаем первый и последний видимый индекс
    final firstIndex = _getFirstVisibleIndex();
    final lastIndex = _getLastVisibleIndex();
    
    return sortedFiles.sublist(
      firstIndex, 
      min(lastIndex + 1, sortedFiles.length)
    );
  }

  int _getFirstVisibleIndex() {
    final scrollOffset = _gridScrollController.offset;
    final pixelsPerRow = (_windowWidth - 15) / 3; // Ширина одной ячейки
    final rowsScrolled = (scrollOffset / pixelsPerRow).floor();
    return rowsScrolled * 3;
  }

  int _getLastVisibleIndex() {
    final firstIndex = _getFirstVisibleIndex();
    return firstIndex + 8; // 3x3 видимая сетка
  }


// Общий метод для открытия файла
void _openFileByKey(EatenFile file) {
  final displayName = file.isWeb ? file.pageTitle : _getDisplayFileName(file);
  
  bool isDirectory = false;
  if (!file.isWeb) {
    try {
      final dir = Directory(file.path);
      isDirectory = dir.existsSync();
    } catch (e) {
      isDirectory = false;
    }
  }
  
  setState(() {
    _showRecentFiles = false;
    _isHoveringRecentFiles = false;
  });
  
  if (file.isWeb) {
    _openWebUrl(file);
  } else if (isDirectory) {
    _openFile(file);
  } else {
    _openFile(file);
  }
  
  _incrementOpenCount(file);
  _isFollowingCursor = false;
}

 /* void _setupDragDropListener() {
    FileDragDropService.onDragStart = () {
      setState(() {
        _isDragging = true;
      });
      print('Drag started!');
      _handleFileDrag();
    };

    FileDragDropService.onDragEnd = () {
      setState(() {
        _isDragging = false;
      });
      _returnToUserPosition();
    };

    FileDragDropService.initialize();
  }
  */


  bool _isYouTubeContent(String title, String artist) {
  final lowerTitle = title.toLowerCase();
  final lowerArtist = artist.toLowerCase();
  
  return lowerTitle.contains('youtube') ||
         lowerArtist.contains('chrome') ||
         lowerArtist.contains('edge') ||
         lowerArtist.contains('microsoft') ||
         lowerArtist.contains('google') ||
         lowerTitle.contains(' - youtube') ||
         lowerArtist == 'youtube';
}

bool _isMusicContent(String title, String artist) {
  // Если это не YouTube и есть артист/название - считаем музыкой
  return !_isYouTubeContent(title, artist) &&
         artist != 'Неизвестный исполнитель' &&
         title != 'Неизвестный трек' &&
         artist.isNotEmpty;
}

Future<void> _youtubeVideoIsPlaying(String title, String channel) async {
  print('Обнаружено YouTube видео: "$title" от "$channel"');
  
  // Очищаем название от YouTube-артефактов
  final cleanTitle = _cleanYouTubeTitle(title);
  final cleanChannel = _cleanYouTubeArtist(channel);
  
  // Пытаемся определить длительность (это будет эмуляция)
  final videoType = await _determineYouTubeVideoType(cleanTitle, cleanChannel);
  
  switch (videoType) {
    case 'live':
      _startAnimation("watching_stream");
      _showPhrase(cleanTitle, cleanChannel, isMusic: false);
      break;
    case 'movie':
      final genre = await _getMovieGenre(cleanTitle);
      _startAnimation("watching_movie");
      _showPhrase(cleanTitle, cleanChannel, isMusic: false, movieGenre: genre);
      break;
    default:
      _startAnimation("watching_video");
      _showPhrase(cleanTitle, cleanChannel, isMusic: false);
  }
}

String _cleanYouTubeTitle(String title) {
  return title
      .replaceAll('YouTube', '')
      .replaceAll(' - YouTube', '')
      .replaceAll('| YouTube', '')
      .trim();
}

String _cleanYouTubeArtist(String artist) {
  if (artist.toLowerCase().contains('chrome') || 
      artist.toLowerCase().contains('edge')) {
    return 'YouTube';
  }
  return artist;
}

Future<String> _determineYouTubeVideoType(String title, String channel) async {
  // Эвристический анализ названия для определения типа видео
  final lowerTitle = title.toLowerCase();
  
  // Проверка на трансляцию
  if (lowerTitle.contains('прямой эфир') ||
      lowerTitle.contains('стрим') ||
      lowerTitle.contains('live') ||
      lowerTitle.contains('трансляция')) {
    return 'live';
  }
  
  // Проверка на фильм (по ключевым словам)
  if (lowerTitle.contains('фильм') ||
      lowerTitle.contains('кино') ||
      lowerTitle.contains('movie') ||
      lowerTitle.contains('full movie') ||
      lowerTitle.contains('полнометражный')) {
    return 'movie';
  }
  
  // Для реального проекта здесь можно было бы использовать YouTube API
  // для получения реальной длительности видео
  
  return 'video'; // обычное видео
}

Future<void> _musicIsPlaying(String artist, String title, String album, String? cover) async {
  print('Обнаружена музыка: "$title" - "$artist"');
  
  // Получаем жанр трека
  final genre = await _getMusicGenre(artist, title);
  final basicGenre = _simplifyGenre(genre);
  
  _startAnimation("music_interact_$basicGenre");
  _showPhrase(title, artist, isMusic: true, musicGenre: basicGenre);
}
String  _previusGenreMusic="unknown";
     
Future<String> _getMusicGenre(String artist, String title) async {
  try {

   

    if (_previusArtist==artist && _previusTitle==title){
      return "";
    }
    final musicBrainzService = MusicBrainzService();
    
    // Пробуем MusicBrainz API
    final genre = await musicBrainzService.getCombinedGenre(artist, title);
    if (genre != 'unknown') {
      _previusGenreMusic=genre;
      return genre;
    }
    
    // Fallback: определяем по артисту (локальная база)
    return await _getArtistGenre(artist);
  } catch (e) {
    print('Ошибка получения жанра: $e');
    return 'unknown';
  }
}

Future<String> _getArtistGenre(String artist) async {
  // Упрощенная база жанров по артистам
  final genreMap = {
    'rock': ['nirvana', 'linkin park', 'queen', 'ac/dc', 'metallica'],
    'pop': ['taylor swift', 'justin bieber', 'ariana grande', 'katy perry'],
    'hiphop': ['eminem', 'kanye west', 'drake', 'snoop dogg'],
    'electronic': ['daft punk', 'deadmau5', 'skrillex', 'tiesto'],
    'classical': ['mozart', 'beethoven', 'bach', 'chopin'],
    'jazz': ['miles davis', 'louis armstrong', 'ella fitzgerald'],
  };
  
  final lowerArtist = artist.toLowerCase();
  for (final entry in genreMap.entries) {
    if (entry.value.any((artistName) => lowerArtist.contains(artistName))) {
      return entry.key;
    }
  }
  
  return 'unknown';
}

String _simplifyGenre(String genre) {
  final lowerGenre = genre.toLowerCase();
  
  if (lowerGenre.contains('rock')) return 'rock';
  if (lowerGenre.contains('pop')) return 'pop';
  if (lowerGenre.contains('hip') || lowerGenre.contains('rap')) return 'hiphop';
  if (lowerGenre.contains('electronic') || lowerGenre.contains('dance') || lowerGenre.contains('house')) return 'electronic';
  if (lowerGenre.contains('classical')) return 'classical';
  if (lowerGenre.contains('jazz')) return 'jazz';
  if (lowerGenre.contains('metal')) return 'metal';
  if (lowerGenre.contains('country')) return 'country';
  if (lowerGenre.contains('reggae')) return 'reggae';
  
  return 'unknown';
}


final List<String> randomPhrasesImpression = ["Ух ты", "О", "Воу", "Прикольно", "Вау", "Здорово"];
final List<String> randomPhrasesEnd = ["Интересно!", "Ща заценим", "Годнота", "Крутяк", "Обожаю это"];


Timer? _phraseTimer;


String _previusTitle="Неизвестный трек";
String _previusArtist="Неизвестный исполнитель";
DateTime _lastMessageAppeared=DateTime.now();
void _showPhrase(String title, String artist, {bool isMusic = true, String? movieGenre, String? musicGenre}) {
  final random = Random();

  final now = DateTime.now();
    final timeDiff = now.difference(_lastMessageAppeared).inSeconds;
  // Шанс 69% на возврат без выполнения
  if (random.nextDouble() < 0.69 || timeDiff<600 || (_previusTitle==title && _previusArtist==artist)) {
    return;
  }
  _previusTitle=title;
  _previusArtist=artist;
  _lastMessageAppeared = now;
  final impression = randomPhrasesImpression[random.nextInt(randomPhrasesImpression.length)];
  final end = randomPhrasesEnd[random.nextInt(randomPhrasesEnd.length)];
  
  String middle;
  if (isMusic) {
    middle = "$artist - $title";
  } else {
    middle = movieGenre != null ? "$title ($movieGenre)" : title;
  }
  
  setState(() {
    _currentPhrase = "$impression, $middle, $end";
  });
  
  // Очищаем фразу через 4 секунды
  _phraseTimer?.cancel();
  _phraseTimer = Timer(const Duration(seconds: 4), () {
    setState(() {
      _currentPhrase = "";
    });
  });
}

Future<String> _getMovieGenre(String title) async {
  // Эвристическое определение жанра фильма по названию
  final lowerTitle = title.toLowerCase();
  
  if (lowerTitle.contains('ужас') || lowerTitle.contains('хоррор') || lowerTitle.contains('страш')) return 'horror';
  if (lowerTitle.contains('комедия') || lowerTitle.contains('смеш')) return 'comedy';
  if (lowerTitle.contains('драма')) return 'drama';
  if (lowerTitle.contains('фантастика') || lowerTitle.contains('фэнтези')) return 'fantasy';
  if (lowerTitle.contains('боевик') || lowerTitle.contains('экшн')) return 'action';
  if (lowerTitle.contains('роман') || lowerTitle.contains('любов')) return 'romance';
  if (lowerTitle.contains('детектив') || lowerTitle.contains('мистик')) return 'mystery';
  
  return 'movie';
}

    
  // Функции управления
  Future<void> _play() async {
    final success = _smtc.play();
    print('Play команда: $success');
  }

  Future<void> _pause() async {
    final success = _smtc.pause();
    print('Pause команда: $success');
  }

  Future<void> _next() async {
    final success = _smtc.next();
    print('Next команда: $success');
  }

  Future<void> _previous() async {
    final success = _smtc.previous();
    print('Previous команда: $success');
  }

  Timer? _updateTimer;
  Future<void> _initializeMediaControls() async {

    return;
    _updateTimer = Timer.periodic(const Duration(seconds: 25), (timer) {
      try{
      _updateMediaInfo();
      }
      catch (e){
        AppLogger.writeLog("update media info broken, try again");
      }
    });
  }

  void _updateMediaInfo() {
    try {
      final mediaInfo = _smtc.getCurrentMediaInfo();
      final playbackState = _smtc.getPlaybackState();
      if (_playbackState=="Воспроизведение"){
      setState(() {
        _title = mediaInfo.title.isNotEmpty ? mediaInfo.title : 'Неизвестный трек';
        _artist = mediaInfo.artist.isNotEmpty ? mediaInfo.artist : 'Неизвестный исполнитель';
        _album = mediaInfo.album.isNotEmpty ? mediaInfo.album : 'Неизвестный альбом';
        _playbackState = _parsePlaybackState(playbackState);
        _lastUpdate = 'Обновлено: ${DateTime.now().toString().substring(11, 19)}';
      });
      
      print('Метаданные: "$_title" - "$_artist" ($_playbackState)');
      AppLogger.writeLog('Метаданные: "$_title" - "$_artist" ($_playbackState)');
      // Анализируем тип контента

    
      if (_isYouTubeContent(_title, _artist)) {
        _youtubeVideoIsPlaying(_title, _artist);
      } else if (_isMusicContent(_title, _artist)) {
        _musicIsPlaying(_artist, _title, _album, null);
      }}

    } catch (e) {
      print('Ошибка получения метаданных: $e');
    }
  }



  String _parsePlaybackState(PlaybackState state) {
    switch (state) {
      case PlaybackState.playing:
        return 'Воспроизведение';
      case PlaybackState.paused:
        return 'Пауза';
      case PlaybackState.stopped:
        return 'Остановлено';
      default:
        return 'Неизвестно';
    }
  }



 @override
void initState() {
  super.initState();
_locale.init();
  
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {

      startMonitoring(intervalMs: 1000);
      //_setupDragDropListener();
      windowManager.addListener(this);
      _startServer();
      _startServer2();
      _initializeMediaControls();
      await _keyLoggerActivate();
      

      await _loadSavedData();
      _registerHotkeys();
      _setupKeyboardListener();
      

      await _initializeScreenSizeAndWindow();
      

      _startTimers();
      

      _startIdleDetection();

      await _ensureShortcutsFolderExists();
      

      await _loadChatHistory();
      

      _startMusicChecker();
      

      _setupWindowsContextMenu();
      

      await _loadAnimations();
      

      await windowManager.setAlwaysOnTop(true);
      

      _startPhysicsEngine();
      

      
    } catch (e, stack) {

      
      // Пытаемся показать окно даже при ошибке
      try {
        await windowManager.show();

      } catch (e2) {

      }
    }
  });
}

  // Загрузка анимаций
  Future<void> _loadAnimations() async {
    try {
      final animations = {
        'idle': await _loadAnimationFrames('idle'),
        'walk': await _loadAnimationFrames('walk'),
        'catch': await _loadAnimationFrames('catch'),
        'sleep': await _loadAnimationFrames('sleep'),
        'happy': await _loadAnimationFrames('happy'),
      };
      
      setState(() {
        _animations = animations;
      });
      
      _startAnimation('idle');
    } catch (e) {
      print('Error loading animations: $e');
    }
  }

  Future<List<AnimationFrame>> _loadAnimationFrames(String animationName) async {
    final List<AnimationFrame> frames = [];
    final petName="test";
    try {
      final directory = await getApplicationDocumentsDirectory();
      final animationDir = Directory('${directory.path}/$petName/animations/$animationName');
      
      if (animationDir.existsSync()) {
        final files = animationDir.listSync()
          .where((file) => file.path.endsWith('.png'))
          .toList();
        
        files.sort((a, b) {
          final aName = path.basenameWithoutExtension(a.path);
          final bName = path.basenameWithoutExtension(b.path);
          return int.parse(aName).compareTo(int.parse(bName));
        });
        
        for (final file in files) {
          final fileName = path.basenameWithoutExtension(file.path);
          final durationMs = int.parse(fileName);
          frames.add(AnimationFrame(file.path, durationMs));
        }
      }
    } catch (e) {
      print('Error loading animation $animationName: $e');
    }
    
    return frames;
  }

  void _startAnimation(String animationName) {
    if (_animations[animationName] == null || _animations[animationName]!.isEmpty) {
      return;
    }
    
    _animationTimer?.cancel();
    _currentAnimation = animationName;
    _currentFrameIndex = 0;
    _lastFrameChange = DateTime.now();
    
    _animationTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
          if (!mounted) { // ← Добавьте эту проверку
        timer.cancel();
        return;
      }
      final now = DateTime.now();
      final currentFrame = _animations[_currentAnimation]![_currentFrameIndex];
      final elapsed = now.difference(_lastFrameChange).inMilliseconds;
      
      if (elapsed >= currentFrame.durationMs) {
        setState(() {
          _currentFrameIndex = (_currentFrameIndex + 1) % _animations[_currentAnimation]!.length;
          _lastFrameChange = now;
        });
      }
    });
  }

  void _startPhysicsEngine() {
    _physicsTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (!mounted) { // ← Добавьте эту проверку
        timer.cancel();
        return;
      }
      if (!_isThrown) return;
      
      _updatePhysics();
    });
  }

void _updatePhysics() {
  // Применяем гравитацию
  _velocity = Offset(_velocity.dx, _velocity.dy + _gravity);
  
  // Обновляем позицию
  _position = Offset(
    _position.dx + _velocity.dx,
    _position.dy + _velocity.dy
  );
  
  // Определяем высоту поверхности (150 пикселей от нижней границы экрана)
  final surfaceLevel = _screenHeight - 50;
  
  // Проверяем столкновения с краями экрана
  bool hitBoundary = false;
  
  if (_position.dx < -30) {
    _position = Offset(-30, _position.dy);
    _velocity = Offset(-_velocity.dx * _bounceFactor, _velocity.dy);
    hitBoundary = true;
  } else if (_position.dx > _screenWidth - _windowWidth+30) {
    _position = Offset(_screenWidth - _windowWidth, _position.dy);
    _velocity = Offset(-_velocity.dx * _bounceFactor, _velocity.dy);
    hitBoundary = true;
  }
  
  if (_position.dy < 0) {
    _position = Offset(_position.dx, 0);
    _velocity = Offset(_velocity.dx, -_velocity.dy * _bounceFactor);
    hitBoundary = true;
  } else if (_position.dy > surfaceLevel - _windowHeight) {
    // Останавливаем на поверхности (150px от нижней границы)
    _position = Offset(_position.dx, surfaceLevel - _windowHeight);
    _velocity = Offset(_velocity.dx, -_velocity.dy * _bounceFactor);
    hitBoundary = true;
    
    // Если скорость очень мала после отскока от поверхности, останавливаем
    if (_velocity.dy.abs() < 1.0) {
      _isThrown = false;
      _velocity = Offset.zero;
      _userSetPosition = _position;
      _userHasSetPosition = true;
      _saveData();
      _startAnimation('idle');
    }
  }
  
  // Применяем трение
  _velocity = Offset(_velocity.dx * _friction, _velocity.dy * _friction);
  
  // Если скорость очень мала, останавливаем
  if (_velocity.distance < 0.5 && !hitBoundary) {
    _isThrown = false;
    _velocity = Offset.zero;
    _userSetPosition = _position;
    
    _userHasSetPosition = true;
    _saveData();
    _startAnimation('idle');
  }
  
  // Обновляем позицию окна

  if (!_isDragging){
windowManager.setPosition(_position);
  }
  
}

  void _startMusicChecker() {
    _musicCheckTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      try {
        final isPlaying = await AudioChecker.isAudioPlaying();
        if (mounted && isPlaying != _isMusicPlaying) {
          setState(() {
            _isMusicPlaying = isPlaying;
          });
        }
      } catch (e) {
        print('Music check failed: $e');
      }
    });
  }

  void _setupWindowsContextMenu() async {
    if (Platform.isWindows) {
      try {
        final exePath = Platform.resolvedExecutable;
        final regCommand = '''
          \$keyPath = "Registry::HKEY_CLASSES_ROOT\\\\*\\\\shell\\\\FeedTo${_petName.replaceAll(' ', '')}"
          New-Item -Path \$keyPath -Force
          Set-ItemProperty -Path \$keyPath -Name "MUIVerb" -Value "Скормить файл $_petName"
          Set-ItemProperty -Path \$keyPath -Name "Icon" -Value "$exePath"
          
          \$commandPath = "\$keyPath\\\\command"
          New-Item -Path \$commandPath -Force
          Set-ItemProperty -Path \$commandPath -Name "(Default)" -Value "'$exePath' --feed-file '%1'"
        ''';

        await Process.run('powershell', ['-Command', regCommand]);
      } catch (e) {
        print('Error setting up Windows context menu: $e');
      }
    }
  }

  void _showRandomPhrase() {
    setState(() {
      _currentPhrase = _randomPhrases[Random().nextInt(_randomPhrases.length)];
    });
    
    Timer(Duration(seconds: 3), () {
      setState(() {
        _currentPhrase = "";
      });
    });
  }

Future<List<Map<String, String>>> _loadFullChatHistory() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final chatDir = Directory('${directory.path}/ai_chat');
    final file = File('${chatDir.path}/chat_history.json');

    if (file.existsSync()) {
      final content = await file.readAsString();
      await File('chat_debug.log').writeAsString(
        '${DateTime.now()}: File content: $content\n',
        mode: FileMode.append,
      );

      if (content.trim().isEmpty) {
        return [];
      }

      final List<dynamic> data = json.decode(content);
      // Преобразуем каждый элемент в Map<String, String>
      return data.map((item) {
        final map = item as Map<String, dynamic>;
        return map.map((key, value) => MapEntry(key, value.toString()));
      }).toList();
    }
  } catch (e) {
    await File('chat_debug.log').writeAsString(
      '${DateTime.now()}: Error loading chat history: $e\n',
      mode: FileMode.append,
    );
    print('Error loading chat history: $e');
  }

  return [];
}



  void _openFullChatWindow() async {
    const chatProcessId = 'chat_window';

  if (ProcessManager().hasProcess(chatProcessId)) {
    ProcessManager().killProcess(chatProcessId);
    _isChatOpen = false;
    return;
  }

  final debugFile = File('chat_debug.log');
  await debugFile.writeAsString(
    '${DateTime.now()}: _toggleChatWindow started\n',
    mode: FileMode.append,
  );

  try {
    final pos = await windowManager.getPosition();
    final fullChatHistory = await _loadFullChatHistory();

    // JSON истории чата
    String chatHistoryJson;
    try {
      chatHistoryJson = json.encode(fullChatHistory);
      await debugFile.writeAsString(
        '${DateTime.now()}: JSON encoded successfully: ${chatHistoryJson.length} chars\n',
        mode: FileMode.append,
      );
    } catch (e) {
      await debugFile.writeAsString(
        '${DateTime.now()}: JSON encode error: $e\n',
        mode: FileMode.append,
      );
      chatHistoryJson = '[]';
    }

    // Логируем аргументы
    await debugFile.writeAsString(
      '${DateTime.now()}: Starting process with args: chat, $chatHistoryJson, ${pos.dx}, ${pos.dy}\n',
      mode: FileMode.append,
    );

    // Запуск дочернего процесса чата
    final process = await Process.start(
      Platform.resolvedExecutable,
      [
        'chat',
        chatHistoryJson,
        pos.dx.toString(),
        pos.dy.toString(),'--subprocess',
      ],
    );

    await debugFile.writeAsString(
      '${DateTime.now()}: Process started with PID: ${process.pid}\n',
      mode: FileMode.append,
    );

    ProcessManager().registerProcess(chatProcessId, process);
    _isChatOpen = true;

    // Слушаем stderr процесса
    process.stderr.transform(utf8.decoder).listen((data) async {
      await debugFile.writeAsString(
        '${DateTime.now()}: Process stderr: $data\n',
        mode: FileMode.append,
      );
    });

    // Таймер для передачи координат каждые 80 мс
    Timer.periodic(Duration(milliseconds: 25), (timer) async {
      if (!ProcessManager().hasProcess(chatProcessId)) {
        timer.cancel();
        return;
      }
      if (!mounted) { // ← Добавьте эту проверку
        timer.cancel();
        return;
      }
      final currentPos = await windowManager.getPosition();
      final proc = ProcessManager().getProcess(chatProcessId);
      proc?.stdin.writeln('${currentPos.dx},${currentPos.dy}');
    });

    process.exitCode.then((code) async {
      await debugFile.writeAsString(
        '${DateTime.now()}: Process exited with code: $code\n',
        mode: FileMode.append,
      );
      if (mounted) {
        setState(() {
          _isChatOpen = false;
          _chatIsReadyToReceiveMessages=false;
        });
      }
      ProcessManager().killProcess(chatProcessId);
    });
  } catch (e) {
    await debugFile.writeAsString(
      '${DateTime.now()}: Error opening chat window: $e\n',
      mode: FileMode.append,
    );
    print('Error opening chat window: $e');
    _isChatOpen = false;
  }
}


void _showContextMenuAtPosition() async {
  if (_contextMenuOverlay != null) {
    _removeContextMenu();
    return;
  }

  // Получаем позицию и размер виджета тамагочи
  final RenderBox petRenderBox = _petKey.currentContext!.findRenderObject() as RenderBox;
  final Offset petPosition = petRenderBox.localToGlobal(Offset.zero);
  final ui.Size petSize = petRenderBox.size;

  final display = await screenRetriever.getPrimaryDisplay();
  final screenSize = display.size;

  final menuWidth = 200.0;
  final menuHeight = 200.0;

  // Позиционируем меню по центру виджета тамагочи
  double menuX = petPosition.dx + (petSize.width - menuWidth) / 2;
  double menuY = petPosition.dy + (petSize.height - menuHeight) / 2 + 15;

  // Корректируем позицию, если меню выходит за границы экрана
  if (menuX + menuWidth > screenSize.width) {
    menuX = screenSize.width - menuWidth - 10;
  }
  if (menuY + menuHeight > screenSize.height) {
    menuY = screenSize.height - menuHeight - 10;
  }
  if (menuX < 10) menuX = 10;
  if (menuY < 10) menuY = 10;

  _contextMenuOpen = true;

  _contextMenuOverlay = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Затемнение фона
        Positioned.fill(
          child: GestureDetector(
            onTap: _removeContextMenu,
            child: Container(color: Colors.transparent),
          ),
        ),
        // Контекстное меню с отслеживанием выхода курсора
        Positioned(
          left: menuX,
          top: menuY,
          child: MouseRegion(
            // Указываем область, при выходе за которую меню закроется
            onExit: (event) {
              _removeContextMenu();
            },
            child: Container(
              width: menuWidth,
              height: menuHeight,
              decoration: BoxDecoration(
                color: Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: GridView.count(
                crossAxisCount: 3,
                padding: EdgeInsets.all(11),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  _buildGridMenuItem(
                    Icons.camera_alt,
                    '${_locale.get("screenshot")}',
                    Colors.blue,
                    () {
                      _removeContextMenu();
                      _showScreenshotViewer();
                    },
                  ),
                  _buildGridMenuItem(
                    Icons.star,
                    'Essentials',
                    Colors.orange,
                    () {
                      _removeContextMenu();
                      _showEssentialsViewer();
                    },
                  ),
                  _buildGridMenuItem(
                    Icons.folder,
                    '${_locale.get("files")}',
                    Colors.blue,
                    () {
                      _removeContextMenu();
                      _showFileViewer();
                    },
                  ),
                  _buildGridMenuItem(
                    Icons.chat,
                    '${_locale.get("AIChat")}',
                    Colors.green,
                    () {
                      _removeContextMenu();
                      _openFullChatWindow();
                    },
                  ),
                  _buildGridMenuItem(
                    Icons.chat,
                    '${_locale.get("clipboard01")}',
                    Colors.green,
                    () {
                      _removeContextMenu();
                      _showCNPWindow();
                    },
                  ),
                   _buildGridMenuItem(
                    Icons.keyboard,
                    '${_locale.get("virtualKeyboard")}',
                    Colors.orange,
                    () {
                      _removeContextMenu();
                      _showMacroKeyboardWindow();
                    },
                  ),
                  _buildGridMenuItem(
                    Icons.settings,
                    '${_locale.get("settings01")}',
                    Colors.orange,
                    () {
                      _removeContextMenu();
                      _showSettingsWindow();
                    },
                  ),
                  //_buildGridMenuItem(
                  //  Icons.settings,
                  //  'AI Test',
                  //  Colors.orange,
                  //  () {
                  //    _removeContextMenu();
                  //    _showAIWindow();
                  //  },
                  //),
                 
                  _buildGridMenuItem(
                    Icons.close,
                    '${_locale.get("close")}',
                    Colors.red,
                    () {
                      _removeContextMenu();
                      ProcessManager().killAllProcesses();
                      windowManager.close();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Overlay.of(context)!.insert(_contextMenuOverlay!);
}
Widget _buildGridMenuItem(IconData icon, String text, Color color, VoidCallback onTap) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 55, // максимум 55 пикселей
        height: 55,
        decoration: BoxDecoration(
          color: Color(0xFF3D3D3D),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color), // чуть больше иконка
            SizedBox(height: 2),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 10, // читаемый размер шрифта
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
bool _isHoveringPet=false;
void _removeContextMenu() {
  if (_contextMenuOverlay != null) {
    _contextMenuOverlay!.remove();
    _contextMenuOverlay = null;
    _contextMenuOpen = false;
  }
     if (Platform.isWindows && !_isHoveringPet && !_isHoveringRecentFiles && !_contextMenuOpen) {
              WindowManager.returnTo80x80Clickable();
      }
}
  void _showEatenFilesOnClick() async {
    final pos = await windowManager.getPosition();
    //_showEatenFilesSubmenu(Offset(pos.dx, pos.dy - 100));
  }

  void _startLongPressTimer(Offset position) {
    _longPressTimer?.cancel();
    _isLongPressing = true;
    _longPressTimer = Timer(Duration(milliseconds: 450), () {
      if (_isLongPressing && mounted) {
        //_showEatenFilesSubmenu(position);
      }
    });
  }

  void _cancelLongPressTimer() {
    _longPressTimer?.cancel();
    _isLongPressing = false;
  }

  Future<void> _loadChatHistory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final chatDir = Directory('${directory.path}/ai_chat');
      final file = File('${chatDir.path}/chat_history.json');
      
      if (file.existsSync()) {
        final content = await file.readAsString();
        final List<dynamic> data = json.decode(content);
        setState(() {
          _chatHistory.clear();
          _chatHistory.addAll(data.cast<Map<String, String>>());
        });
      }
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  Future<void> _ensureShortcutsFolderExists() async {
    try {
      final exeDir = _getExeDirectory();
      final shortcuts = Directory(path.join(exeDir, 'Shortcuts'));
      if (!shortcuts.existsSync()) shortcuts.createSync(recursive: true);
    } catch (_) {}
  }

  String _getExeDirectory() {
    try {
      final exe = Platform.resolvedExecutable;
      final exeDir = path.dirname(exe);
      return exeDir;
    } catch (e) {
      return Directory.current.path;
    }
  }

  Future<void> _initializeScreenSizeAndWindow() async {
    final display = await screenRetriever.getPrimaryDisplay();
    final screenSize = display.size;
    final pos = await windowManager.getPosition();

    final prefs = await SharedPreferences.getInstance();
    final firstRun = prefs.getBool('first_run') ?? true;

    setState(() {
      _screenWidth = screenSize.width;
      _screenHeight = screenSize.height;
      _position = pos;
    });

    if (!firstRun) {
      _userSetPosition = Offset(
        _screenWidth - _windowWidth - 15,
        _screenHeight - _windowHeight-150,
      );
      _userHasSetPosition = true;
      await windowManager.setPosition(_userSetPosition);
      _position = _userSetPosition;
    } else {
      _userSetPosition = Offset(
        _screenWidth - 500,
        _screenHeight - 600,
      );
      _userHasSetPosition = true;
      await windowManager.setPosition(_userSetPosition);
      _position = _userSetPosition;
    }
  }

  void _startIdleDetection() {
    _idleTimer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      if (_isDragging || _isAnimatingDrop || _contextMenuOpen || _chatOverlayVisible || _isThrown) return;

      final now = DateTime.now();
      final idleTime = now.difference(_lastCursorMove).inSeconds;

      if (idleTime >= 20 && _userHasSetPosition && !_isThrown) {
        _startAnimation('idle');
        
        setState(() {
          _idleOffset += 2 * _idleDirection;
          if (_idleOffset.abs() >= 20) {
            _idleDirection *= -1;
          }
        });

        final currentPos = await windowManager.getPosition();
        await windowManager.setPosition(Offset(
          _userSetPosition.dx + _idleOffset,
          _userSetPosition.dy
        ));
      }
    });
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _happiness = prefs.getDouble('happiness') ?? 50.0;
        _hunger = prefs.getDouble('hunger') ?? 50.0;
        _level = prefs.getInt('level') ?? 1;
        _daysAlive = prefs.getInt('days_alive') ?? 0;
        _apiKey = prefs.getString('api_key') ?? '';
        _useDeepSeek = prefs.getBool('use_deepseek') ?? true;
        _petName = prefs.getString('pet_name') ?? 'Тамагочи';
        
        _screenshotAnalyzeActive=prefs.getBool('vision') ?? false;
        final savedX = prefs.getDouble('user_position_x');
        final savedY = prefs.getDouble('user_position_y');
        if (savedX != null && savedY != null) {
          _userSetPosition = Offset(savedX, savedY);
          _position = _userSetPosition;
          _userHasSetPosition = true;
          windowManager.setPosition(_userSetPosition);
        }
      });
      _loadSharedFiles();
    }

    if (_screenshotAnalyzeActive==true){
      _startAnalysis();

    }else{
      _stopAnalysis();
    }
  }


  void _startTimers() {
    _dayTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (!_isAlive || !mounted) return;
      setState(() {
        _daysAlive++;
        if (_daysAlive % 1440 == 0) _level++;
        _saveData();
      });
    });

    _stateTimer = Timer.periodic(Duration(seconds: 1100), (timer) {
      if (!_isAlive || _isSleeping || !mounted) return;
      setState(() {
        _happiness = max(0, _happiness - 2);
        _hunger = min(100, _hunger + 1);
        if (_hunger >= 100) _isAlive = false;
        _saveData();
      });
    });
  }

  void _onTap() {
    if (!_isAlive) return;
    
    setState(() {
      _happiness = min(100, _happiness + 5);
      _showRandomPhrase();
    });
    
    _saveData();
  }

void _onDoubleTap() {
  if (!_isAlive) return;
  
  // Отменяем любые pending таймеры
  _cancelLongPressTimer();
  
  // Задержка для предотвращения конфликта с другими жестами
  Future.delayed(Duration(milliseconds: 100), () {
    if (mounted) {
      _toggleChatWindow();
    }
  });
}

  void _showChatWindow() async {
    if (_chatOverlayVisible) {
      _removeChatOverlay();
      return;
    }

    final pos = await windowManager.getPosition();
    final display = await screenRetriever.getPrimaryDisplay();
    final screenSize = display.size;

    double chatX = pos.dx - 600;
    double chatY = pos.dy - 900;

    chatX = chatX.clamp(0.0, screenSize.width - 600);
    chatY = chatY.clamp(0.0, screenSize.height - 900);

    _isFollowingCursor = false;
    _chatOverlayVisible = true;

    _chatOverlay = OverlayEntry(
      builder: (context) => MouseRegion(
        onEnter: (_) {
          _mouseOverWidgetOrChat = true;
          _isFollowingCursor = false;
        },
        onExit: (_) {
          _mouseOverWidgetOrChat = false;
          if (!_mouseOverWidgetOrChat && _chatOverlayVisible) {
            _removeChatOverlay();
          }
        },
        
      ),
    );

    Overlay.of(context)!.insert(_chatOverlay!);
    await windowManager.setAlwaysOnTop(false);
  }

  void _sendChatMessage(String message) async {
    _chatHistory.add({
      'type': 'user',
      'message': message,
      'timestamp': DateTime.now().toString(),
    });

    setState(() {});

    if (message.startsWith('http')) {
      await launchUrl(Uri.parse(message));
    } else {
      final response = await _callAIAPI(message);
      _chatHistory.add({
        'type': 'ai',
        'message': response,
        'timestamp': DateTime.now().toString(),
      });
    }

    setState(() {});
  //  _saveChatHistory();
  }

  void _removeChatOverlay() async {
    _chatOverlay?.remove();
    _chatOverlay = null;
    _chatOverlayVisible = false;
    _isFollowingCursor = false;
    await windowManager.setAlwaysOnTop(true);
  }

  bool _isSystemPath(String text) {
    final trimmed = text.trim();
    if (Platform.isWindows) {
      return trimmed.contains(':\\') || trimmed.startsWith('\\\\');
    } else {
      return trimmed.startsWith('/');
    }
  }
  Future<Uint8List?> _getFileIcon1(String filePath) async {
    const MethodChannel _fileIconChannel = MethodChannel('screenshot_channel');
    try {
    final result = await _fileIconChannel.invokeMethod('getFileIcon', filePath);
    return result as Uint8List?;
  } catch (e) {
    print('Error getting file icon: $e');
    return null;
  }
  }
void _onFileDropped(List<String> files) async {
  if (!_isAlive || files.isEmpty) return;

  // Создаем список для новых файлов
  final List<EatenFile> newFiles = [];
 
  for (final filePath in files) {
    final trimmedPath = filePath.trim();
    if (trimmedPath.isEmpty) continue;
    
    final isWeb = _isWebUrl(trimmedPath);
    final isSystemPath = _isSystemPath(trimmedPath);
    
    if (!isWeb && !isSystemPath) continue;
    
    Uint8List? iconBytes;
    String title="none";
    if (isWeb) {
      iconBytes = await _getFavicon(trimmedPath);
      title = await _getPageTitle(trimmedPath);
    } else if (isSystemPath) {
      iconBytes = await _getFileIcon1(trimmedPath);
      title = "none";
    }

    final newFile = EatenFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      path: trimmedPath,
      isWeb: isWeb,
      isStarred: false,
      openCount: 0,
      lastOpened: null,
      iconBytes: iconBytes,
      fileName: isWeb ? _getDomainName(trimmedPath) : path.basename(trimmedPath),
      pageTitle: title,
    );
  //_openFile(newFile);
    newFiles.add(newFile);
  }

  setState(() {
    for (final newFile in newFiles) {
      // Ищем существующий файл с таким же path
      final existingFileIndex = _files.indexWhere((file) => file.path == newFile.path);
      
      if (existingFileIndex != -1) {
        // Если файл уже существует, удаляем его
        final existingFile = _files.removeAt(existingFileIndex);
        // Сохраняем данные из старого файла (звездочку, счетчик открытий и т.д.)
        newFile.isStarred = existingFile.isStarred;
        newFile.openCount = existingFile.openCount;
        newFile.lastOpened = existingFile.lastOpened;
        // Сохраняем иконку если новая не загрузилась
        if (newFile.iconBytes == null && existingFile.iconBytes != null) {
          newFile.iconBytes = existingFile.iconBytes;
        }
      }
      
      // Добавляем новый файл в начало списка
      _files.insert(0, newFile);
      _saveFile(newFile);
    }
    
    _hunger = max(0, _hunger - 100);
    
    // Ограничиваем общее количество файлов
    if (_files.length > 1000) {
      final filesToRemove = _files.sublist(1000);
      for (final file in filesToRemove) {
        _deleteFile(file); // Удаляем файлы из хранилища
      }
      _files.removeRange(1000, _files.length);
    }
  });

  _saveData();
  // _saveSharedFiles(); // ЭТУ СТРОЧКУ УДАЛЯЕМ, т.к. метод больше не существует
  _analyzeFile(files.last);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Файл принят: ${path.basename(files.last)}'), 
      duration: Duration(seconds: 2)
    ),
  );
}
void _onUrlDropped(String url) async {
  if (!_isAlive || url.isEmpty) return;

  final trimmedUrl = url.trim();
  if (trimmedUrl.isEmpty) return;

  // Проверяем, что это валидный URL
  if (!_isWebUrl(trimmedUrl)) return;
  String title = await _getPageTitle(trimmedUrl);
  // Получаем favicon для URL
  final iconBytes = await _getFavicon(trimmedUrl);

  final newFile = EatenFile(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    path: trimmedUrl,
    isWeb: true,
    isStarred: false,
    openCount: 0,
    lastOpened: null,
    iconBytes: iconBytes,
    fileName: _getDomainName(trimmedUrl),
    pageTitle: title,
  );

  setState(() {
    // Ищем существующий файл с таким же URL
    final existingFileIndex = _files.indexWhere((file) => file.path == newFile.path);
    
    if (existingFileIndex != -1) {
      // Если URL уже существует, удаляем его
      final existingFile = _files.removeAt(existingFileIndex);
      // Сохраняем данные из старого файла
      newFile.isStarred = existingFile.isStarred;
      newFile.openCount = existingFile.openCount;
      newFile.lastOpened = existingFile.lastOpened;
      // Сохраняем иконку если новая не загрузилась
      if (newFile.iconBytes == null && existingFile.iconBytes != null) {
        newFile.iconBytes = existingFile.iconBytes;
      }
    }
    
    // Добавляем новый файл в начало списка
    _files.insert(0, newFile);
    _saveFile(newFile);
    
    _hunger = max(0, _hunger - 100);
    
    // Ограничиваем общее количество файлов
    if (_files.length > 1000) {
      final filesToRemove = _files.sublist(1000);
      for (final file in filesToRemove) {
        _deleteFile(file); // Удаляем файлы из хранилища
      }
      _files.removeRange(1000, _files.length);
    }
  });

  _saveData();


  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('URL принят: ${_getDomainName(trimmedUrl)}'), 
      duration: Duration(seconds: 2)
    ),
  );
}


// Вспомогательная функция для получения доменного имени
String _getDomainName(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.host;
  } catch (e) {
    // Если не удалось распарсить URL, возвращаем оригинальную строку
    return url;
  }
}

// Добавьте этот метод для проверки URL
bool _isWebUrl(String text) {
  final trimmed = text.trim();
  return trimmed.startsWith('http://') || 
         trimmed.startsWith('https://') ||
         trimmed.startsWith('www.') ||
         (trimmed.contains('.') && 
         (trimmed.contains('/') || 
          trimmed.endsWith('.com') || 
          trimmed.endsWith('.ru') || 
          trimmed.endsWith('.org')));
}

// Добавьте этот метод для создания ярлыков URL
void _createShortcutForUrl(String url) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final shortcutsDir = Directory('${directory.path}/url_shortcuts');
    if (!shortcutsDir.existsSync()) {
      shortcutsDir.createSync(recursive: true);
    }

    final domain = _getDomainName(url);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final shortcutFile = File('${shortcutsDir.path}/$domain-$timestamp.url');
    
    await shortcutFile.writeAsString('[InternetShortcut]\nURL=$url');
  } catch (e) {
    debugPrint('Error creating URL shortcut: $e');
  }
}



void _saveData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('happiness', _happiness);
  await prefs.setDouble('hunger', _hunger);
  await prefs.setInt('level', _level);
  await prefs.setInt('days_alive', _daysAlive);
  await prefs.setString('api_key', _apiKey);
  await prefs.setBool('use_deepseek', _useDeepSeek);
  await _loadSharedFiles();
  await prefs.setDouble('user_position_x', _userSetPosition.dx);
  await prefs.setDouble('user_position_y', _userSetPosition.dy);
  await prefs.setBool('vision',_screenshotAnalyzeActive);
  await _saveSharedFiles(); // ← ДОБАВЬТЕ ЭТУ СТРОЧКУ
}


  void _analyzeFile(String filePath) async {
    final fileName = path.basename(filePath);
    final fileExtension = path.extension(filePath).toLowerCase();
    final fileSize = File(filePath).lengthSync();

    String fileMetadata = await _extractFileMetadata(filePath);

    String analysisPrompt = '''
Проанализируй файл: $fileName
Путь: $filePath
Размер: ${fileSize ~/ 1024} KB
Расширение: $fileExtension
$fileMetadata

Если тебе знаком название или ты можешь предположить что это за файл - дай обратную связь (например, музыкальная композиция, книга, программа). Если файл незнаком так и напиши "файл неопознан". Будь краток и информативен.
''';

    final response = await _callAIAPI(analysisPrompt);
    _chatHistory.add({
      'type': 'ai',
      'message': '📁 Анализ файла: $fileName\n$response',
      'timestamp': DateTime.now().toString(),
    });
    //_saveChatHistory();
    _saveFileResponse(filePath, response);
  }

  Future<void> _saveFileResponse(String filePath, String response) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/file_responses.json');
      
      Map<String, dynamic> responses = {};
      if (file.existsSync()) {
        final content = await file.readAsString();
        responses = json.decode(content);
      }
      
      responses[filePath] = response;
      await file.writeAsString(json.encode(responses));
    } catch (e) {
      print('Error saving file response: $e');
    }
  }

  Future<String> _extractFileMetadata(String filePath) async {
    try {
      final file = File(filePath);
      final stat = await file.stat();
      String metadata = 'Модификация: ${stat.modified}\n';

      if (file.existsSync()) {
        try {
          final bytes = await file.readAsBytes();
          if (bytes.length > 10) {
            final header = bytes.take(10).toList();
            if (header[0] == 0xFF && header[1] == 0xD8) {
              metadata += 'Тип: JPEG изображение\n';
            } else if (header[0] == 0x89 && header[1] == 0x50) {
              metadata += 'Тип: PNG изображение\n';
            } else if (header[0] == 0x50 && header[1] == 0x4B) {
              metadata += 'Тип: ZIP архив или Office документ\n';
            } else if (header[0] == 0x49 && header[1] == 0x44 && header[2] == 0x33) {
              metadata += 'Тип: MP3 файл с ID3 тегом\n';
            }
          }
        } catch (e) {}
      }

      if (filePath.toLowerCase().endsWith('.mp3') || 
          filePath.toLowerCase().endsWith('.wav') ||
          filePath.toLowerCase().endsWith('.flac') ||
          filePath.toLowerCase().endsWith('.m4a')) {
        metadata += 'Категория: Аудио файл\n';
      } else if (filePath.toLowerCase().endsWith('.txt') || 
                filePath.toLowerCase().endsWith('.doc') ||
                filePath.toLowerCase().endsWith('.docx') ||
                filePath.toLowerCase().endsWith('.pdf')) {
        metadata += 'Категория: Текстовый документ\n';
      } else if (filePath.toLowerCase().endsWith('.jpg') || 
                filePath.toLowerCase().endsWith('.png') ||
                filePath.toLowerCase().endsWith('.gif') ||
                filePath.toLowerCase().endsWith('.bmp')) {
        metadata += 'Категория: Изображение\n';
      } else if (filePath.toLowerCase().endsWith('.exe') ||
                filePath.toLowerCase().endsWith('.msi') ||
                filePath.toLowerCase().endsWith('.app')) {
        metadata += 'Категория: Исполняемый файл\n';
      }

      return metadata;
    } catch (e) {
      return 'Метаданные: недоступны\n';
    }
  }

  Future<String> _callAIAPI(String prompt) async {
    if (_apiKey.isEmpty) return 'API ключ не установлен. Настройте его в контекстном меню.';

    try {
      final url = _useDeepSeek
          ? 'https://api.deepseek.com/v1/chat/completions'
          : 'https://api.openai.com/v1/chat/completions';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': _useDeepSeek ? 'deepseek-chat' : 'gpt-4',
          'messages': [{'role': 'user', 'content': prompt}],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['choices'][0]['message']['content']?.trim() ?? 'Пустой ответ от API';
      } else {
        return 'Ошибка API: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Ошибка соединения: $e';
    }
  }

  void _saveChatHistory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final chatDir = Directory('${directory.path}/ai_chat');
      if (!chatDir.existsSync()) chatDir.createSync(recursive: true);

      final file = File('${chatDir.path}/chat_history.json');
      await file.writeAsString(json.encode(_chatHistory));
    } catch (e) {
      print('Error saving chat history: $e');
    }
  }

  Future<void> _createShortcutForFile(String targetPath) async {
    try {
      final exeDir = _getExeDirectory();
      final shortcutsDir = Directory(path.join(exeDir, 'Shortcuts'));
      if (!shortcutsDir.existsSync()) shortcutsDir.createSync(recursive: true);

      final fileName = path.basename(targetPath);
      final safeName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
      final shortcutPath = path.join(shortcutsDir.path, '$safeName.lnk');

      final ps = r'''
$target = "%TARGET%"
$shortcutPath = "%SHORTCUT%"
$w = New-Object -ComObject WScript.Shell
$sc = $w.CreateShortcut($shortcutPath)
$sc.TargetPath = $target
$sc.WorkingDirectory = (Split-Path $target)
$sc.Save()
''';

      final command = ps
          .replaceAll('%TARGET%', targetPath.replaceAll(r'%', '%%'))
          .replaceAll('%SHORTCUT%', shortcutPath.replaceAll(r'%', '%%'));

      final result = await Process.run('powershell',
          ['-NoProfile', '-NonInteractive', '-Command', command],
          runInShell: true);

      if (result.exitCode != 0) {
        final fallback = File(path.join(shortcutsDir.path, '$safeName.shortcut.txt'));
        await fallback.writeAsString(targetPath);
      }
    } catch (e) {
      try {
        final exeDir = _getExeDirectory();
        final shortcutsDir = Directory(path.join(exeDir, 'Shortcuts'));
        if (!shortcutsDir.existsSync()) shortcutsDir.createSync(recursive: true);
        final safeName = path.basename(targetPath).replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
        final fallback = File(path.join(shortcutsDir.path, '$safeName.shortcut.txt'));
        await fallback.writeAsString(targetPath);
      } catch (_) {}
    }
  }

  Widget _buildStatusBar(String label, double value, Color color) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${value.toInt()}%',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          SizedBox(height: 2),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (value / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFileViewer() async {

    const processId="eaten_files_all";

    if (ProcessManager().hasProcess(processId)) {
    ProcessManager().killProcess(processId);
    
    return;
  }

   final process =   await Process.start(
      Platform.resolvedExecutable,
      [
        'files',
        json.encode(_eatenFiles),'--subprocess'
      ],
      mode: ProcessStartMode.detached,
      runInShell: false,
    );

      ProcessManager().registerProcess(processId, process);
  }
 void _showScreenshotViewer() async {

       const processId="screenshoter";

    if (ProcessManager().hasProcess(processId)) {
    ProcessManager().killProcess(processId);
    
    return;
  }


    final process =  
    await Process.start(
      Platform.resolvedExecutable,
      [
        'screenshoter','--subprocess'
      ],
      runInShell: true,
    );

    ProcessManager().registerProcess(processId, process);
    
    


  }

  

  void _openFile(EatenFile filePath) async {
    try {
      if (Platform.isWindows) {
        await Process.run('start', ['""', filePath.path], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', [filePath.path]);
      } else {
        await Process.run('xdg-open', [filePath.path]);
      }
    } catch (e) {
      print('Error opening file: $e');
    }
  }

  void _openFileFolder(String filePath) {
    final directory = File(filePath).parent;
    try {
      if (Platform.isWindows) {
        Process.run('explorer', ['/select,', filePath], runInShell: true);
      } else if (Platform.isMacOS) {
        Process.run('open', ['-R', filePath]);
      } else {
        Process.run('xdg-open', [directory.path]);
      }
    } catch (e) {
      print('Error opening file folder: $e');
    }
  }

  void _clearEatenFiles() {
    setState(() {
      _eatenFiles.clear();
      _saveData();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Список съеденных файлов очищен'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSettingsWindow() async {


         const processId="settings_window";

    if (ProcessManager().hasProcess(processId)) {
    ProcessManager().killProcess(processId);
    
    return;
  }


    final process = await Process.start(
      Platform.resolvedExecutable,
      [
            'settings',
      _apiKey,
      _useDeepSeek.toString(),
      _petName,
      _screenshotAnalyzeActive.toString(),'--subprocess',
      ],
    );

    ProcessManager().registerProcess(processId, process);
    
    


  // После закрытия окна настроек перезагружаем настройки из SharedPreferences
  if (process.exitCode == 0) {
    _loadSavedData(); // Перезагружаем настройки из файла
  }
}



 void _showMacroKeyboardWindow() async {


         const processId="macro_keyboard";

    if (ProcessManager().hasProcess(processId)) {
    ProcessManager().killProcess(processId);
    
    return;
  }


    final process = await Process.start(
      Platform.resolvedExecutable,
      [
            'macro_keyboard','--subprocess',
      ],
    );

    ProcessManager().registerProcess(processId, process);
    
    


  // После закрытия окна настроек перезагружаем настройки из SharedPreferences
  if (process.exitCode == 0) {
    _loadSavedData(); // Перезагружаем настройки из файла
  }
}


  void _showAIWindow() async {
    return;

         const processId="ai_process";

    if (ProcessManager().hasProcess(processId)) {
    ProcessManager().killProcess(processId);
    
    return;
  }


    final process = await Process.start(
      Platform.resolvedExecutable,
      [
            'ai_open',
      ],
    );

    ProcessManager().registerProcess(processId, process);
    
    


  // После закрытия окна настроек перезагружаем настройки из SharedPreferences
  if (process.exitCode == 0) {
    _loadSavedData(); // Перезагружаем настройки из файла
  }
}

  void _showCNPWindow() async {
     const processId="cnp_window";

    if (ProcessManager().hasProcess(processId)) {
    ProcessManager().killProcess(processId);
    
    return;
  }


    final process = await Process.start(
      Platform.resolvedExecutable,
      [
        'clipboard-history','--subprocess'
       
      ],
    );

    ProcessManager().registerProcess(processId, process);
    
    
   
  }


void _copyVisibleAndOpenChatCopyCliplboardAsEntry() async {
  const chatProcessId = 'chat_window';
  
  try {
    // 1. Получаем информацию о текущем фокусе в Windows
    final focusInfo = await _getWindowsFocusInfo();
    
    if (focusInfo == null) {
      print('Не удалось получить информацию о фокусе');
      return;
    }
    
    // 2. Обработка файлов
    if (focusInfo.isFileSelection) {
      final filePath = focusInfo.selectedPath;
      if (filePath != null && filePath.isNotEmpty) {
        // 2.1 Копируем путь файла в буфер обмена
        await _copyToClipboard(filePath);
        
        // 2.2 Вызываем обработку файла в текущем классе
        _onFileDropped([filePath]);
        return; // Не открываем окно чата для файлов
      }
    }
    
    // 3. Обработка текста
    if (focusInfo.isTextSelection && focusInfo.selectedText != null) {
      final selectedText = focusInfo.selectedText!.trim();
      
      if (selectedText.isEmpty) {
        print('Выделенный текст пуст');
        return;
      }
      
      // 2. Копируем текст в буфер обмена
      await _copyToClipboard(selectedText);
      
      // 3.1 Проверяем является ли текст ссылкой
      if (_isWebUrl(selectedText)) {
        // 3.2 Обрабатываем ссылку в текущем классе
        _onUrlDropped(selectedText);
        return; // Не открываем окно чата для ссылок
      }
      
      // 3.1 Открываем окно чата для обычного текста
      String clipboardText = selectedText;
      
      // Если окно чата уже открыто - отправляем текст
      if (ProcessManager().hasProcess(chatProcessId)) {
        await _sendToServer(clipboardText);
        return;
      }
      
      // Открываем новое окно чата
      await _openChatWindowWithText(clipboardText, chatProcessId);
    }
    
  } catch (e) {
    print('Error in _copyVisibleAndOpenChatCopyCliplboardAsEntry: $e');
  }
}
static Future<void> _sendToServer(String data) async {
  try {
    final socket = await Socket.connect('localhost', 8080);
    // Явно кодируем в UTF-8
    final encodedData = utf8.encode(data);
    socket.add(encodedData);
    await socket.flush();
    socket.destroy();
  } catch (e) {
    print('Error sending data: $e');
  }
}



// Вспомогательная функция для открытия окна чата с текстом
// Вспомогательная функция для открытия окна чата с текстом
Future<void> _openChatWindowWithText(String clipboardText, String chatProcessId) async {
  try {
    final pos = await windowManager.getPosition();
    final emptyChatHistory = '[]'; // Пустой JSON

    // Запуск дочернего процесса чата
    final process = await Process.start(
      Platform.resolvedExecutable,
      [
        'chat',
        emptyChatHistory,
        pos.dx.toString(),
        pos.dy.toString(),
      ],
    );

    ProcessManager().registerProcess(chatProcessId, process);
    _isChatOpen = true;

    // Слушаем stderr процесса
    process.stderr.transform(utf8.decoder).listen((data) {
      // Обработка ошибок дочернего процесса
    });

    // Ждем пока чат будет готов принимать сообщения (с таймаутом 5 секунд)
    bool isReady = await _waitForChatReady(
      timeout: const Duration(seconds: 5),
      checkInterval: const Duration(milliseconds: 150),
    );

    

    if (isReady) {
      // Отправляем текст в открытое окно
      _sendToServer(clipboardText);
    } else {
      print('Chat window failed to become ready within timeout');
      return;
    }

    // Таймер для передачи координат
    Timer.periodic(const Duration(milliseconds: 25), (timer) async {
      if (!ProcessManager().hasProcess(chatProcessId)) {
        timer.cancel();
        return;
      }
      final currentPos = await windowManager.getPosition();
      final currentProc = ProcessManager().getProcess(chatProcessId);
      currentProc?.stdin.writeln('${currentPos.dx},${currentPos.dy}');
      await currentProc?.stdin.flush();
    });

    process.exitCode.then((code) {
      if (mounted) {
        setState(() {
          _isChatOpen = false;
        });
      }
      ProcessManager().killProcess(chatProcessId);
    });
    
  } catch (e) {
    print('Error opening chat window: $e');
    _isChatOpen = false;
  }
}

// Вспомогательная функция для ожидания готовности чата
Future<bool> _waitForChatReady({
  Duration timeout = const Duration(seconds: 5),
  Duration checkInterval = const Duration(milliseconds: 100),
}) async {
  final startTime = DateTime.now();
  
  while (DateTime.now().difference(startTime) < timeout) {
    if (_chatIsReadyToReceiveMessages) {
      return true;
    }
    await Future.delayed(checkInterval);
  }
  
  // Проверяем последний раз перед возвратом false
  return _chatIsReadyToReceiveMessages;
}


// Функция для копирования в буфер обмена
Future<void> _copyToClipboard(String text) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
  } catch (e) {
    print('Error copying to clipboard: $e');
  }
}


   void _showEssentialsViewer() async {


      const processId="essentials";

    if (ProcessManager().hasProcess(processId)) {
    ProcessManager().killProcess(processId);
    
    return;
  }


    final process =  
    await Process.start(
      Platform.resolvedExecutable,
      [
         'essentials','--subprocess'
      ],
      
    );

    ProcessManager().registerProcess(processId, process);
    


   
  }


    final List<Offset> _cursorHistory = [];
  Timer? _cursorHistoryTimer;
  DateTime _dragStartTime = DateTime.now();


   Offset _calculateRecentCursorVelocity() {
    if (_cursorHistory.length < 2) {
      // Если недостаточно данных, используем стандартную скорость из details
      return Offset.zero;
    }

    // Берем последние позиции из истории (последние 400 мс)
    final recentPoints = _cursorHistory;
    
    if (recentPoints.length < 2) {
      return Offset.zero;
    }

    // Первая и последняя точка в рассматриваемом интервале (400 мс)
    final firstPoint = recentPoints.first;
    final lastPoint = recentPoints.last;

    // Смещение за 400 мс
    final dx = lastPoint.dx - firstPoint.dx;
    final dy = lastPoint.dy - firstPoint.dy;

    // Скорость = смещение / время (преобразуем в пиксели в секунду)
    return Offset(dx / 0.4, dy / 0.4);
  }

  // Альтернативный метод - используем несколько последних точек для большей точности
  Offset _calculateSmoothCursorVelocity() {
    if (_cursorHistory.length < 5) {
      return Offset.zero;
    }

    // Берем последние 5 точек (примерно последние 80 мс)
    final recentPoints = _cursorHistory.length >= 5 
        ? _cursorHistory.sublist(_cursorHistory.length - 5)
        : _cursorHistory;

    double totalDx = 0;
    double totalDy = 0;
    int count = 0;

    // Рассчитываем скорость между соседними точками
    for (int i = 1; i < recentPoints.length; i++) {
      final dx = recentPoints[i].dx - recentPoints[i-1].dx;
      final dy = recentPoints[i].dy - recentPoints[i-1].dy;
      totalDx += dx;
      totalDy += dy;
      count++;
    }

    if (count == 0) return Offset.zero;

    // Средняя скорость за кадр (16 мс), преобразуем в секунду
    final avgDxPerFrame = totalDx / count;
    final avgDyPerFrame = totalDy / count;

    return Offset(avgDxPerFrame * 60, avgDyPerFrame * 60); // Преобразуем в пиксели/секунду
  }


  void _cleanOldCursorHistory() {
    final now = DateTime.now();
    final cutoffTime = now.subtract(Duration(milliseconds: 400));
    
    // Удаляем записи старше 400 мс
    _cursorHistory.removeWhere((position) {
      // Поскольку мы не храним временные метки для каждой позиции,
      // удаляем старые записи, оставляя только последние (предполагая 60 FPS)
      return _cursorHistory.indexOf(position) < _cursorHistory.length - 25; // ~400ms при 60 FPS
    });
  }

  
  void _onPanStart(DragStartDetails details) async {
    if (!_isAlive) return;
    
    _physicsTimer?.cancel();
    _isThrown = false;
    _velocity = Offset.zero;
    
    setState(() {
      _isDragging = true;
      _isFollowingCursor = false;
      _dragStartOffset = details.globalPosition;
      _mouseOverWidgetOrChat = true;
    });
    
    _animationTimer1?.cancel();
    _animationTimer1 = null;
    
    // Очищаем историю курсора при начале жеста
    _cursorHistory.clear();
    _dragStartTime = DateTime.now();
    
    // Запускаем таймер для сбора истории позиций курсора
    _cursorHistoryTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (!_isDragging) {
        timer.cancel();
        return;
      }
      _cleanOldCursorHistory();
    });

    Offset? last_cursor_pos = await _getCursorPosition();

    _animationTimer1 = Timer.periodic(Duration(milliseconds: 16), (timer) async {
      Offset? cursorPos = await _getCursorPosition();
      if (cursorPos == null && last_cursor_pos != null) {
        cursorPos = last_cursor_pos;
      }
      if (last_cursor_pos == null) {
        return;
      }
      last_cursor_pos = cursorPos;
      
      // Сохраняем позицию курсора в историю
      _cursorHistory.add(cursorPos!);
      _cleanOldCursorHistory();
      
      final targetPos = Offset(
        cursorPos.dx - 110, // Смещение по X
        cursorPos.dy - 160, // Смещение по Y
      );
      
      // Получаем текущую позицию окна
      final currentPos = await windowManager.getPosition();

      // Вычисляем новую позицию с интерполяцией
      final newX = currentPos.dx + (targetPos.dx - currentPos.dx) * 0.1;
      final newY = currentPos.dy + (targetPos.dy - currentPos.dy) * 0.1;
      
      final newPos = Offset(newX, newY);
      
      setState(() {
        _position = newPos;
      });
      
      windowManager.setPosition(newPos);
    });
  }
  Timer? _animationTimer1;

void _onPanUpdate(DragUpdateDetails details) async {
  // Останавливаем предыдущий таймер, если он активен
 return;
}
void _onPanEnd(DragEndDetails details) async {
    if (!_isDragging) return;

    _animationTimer1?.cancel();
    _animationTimer1 = null;
    _cursorHistoryTimer?.cancel();
    _cursorHistoryTimer = null;

    Offset? cursorPos = await _getCursorPosition();
    if (cursorPos == null) {
      cursorPos = await windowManager.getPosition();
    }
    final startPosition = _dragStartOffset;
    double distance = (cursorPos! - startPosition).distance;
    
    // РАСЧЕТ СКОРОСТИ НА ОСНОВЕ ПОСЛЕДНИХ 400 МС КУРСОРА
    final velocity = _calculateRecentCursorVelocity();
    
    setState(() {
      _isDragging = false;
      
      // Используем рассчитанную скорость на основе истории курсора
      final scaledVelocity = Offset(
        velocity.dx / 30, 
        velocity.dy / 30
      );
      _velocity = Offset(
        scaledVelocity.dx.clamp(-21.0, 21.0),
        scaledVelocity.dy.clamp(-17.0, 17.0)
      );
      
      _isThrown = _velocity.distance > 2.0;
      
      // Исправляем формулы счастья и голода
      _happiness = (_happiness + (_velocity.distance / 7)).clamp(0, 100).toDouble();
      _hunger = (_hunger + (_velocity.distance / 14)).clamp(0, 100).toDouble();
      
      _idleOffset = 0;
    });

    if (_isThrown) {
      _startAnimation('walk');
      _startPhysicsEngine();
    } else {
      windowManager.getPosition().then((position) {
        setState(() {
          _userSetPosition = position;
          _userHasSetPosition = true;
        });
        _saveData();
        
        // Фиксируем виджет на высоте 150px от нижнего края экрана
        final targetY = _screenHeight - _windowHeight;
        _returnToUserPosition();
      });
    }
    
    // Очищаем историю после использования
    _cursorHistory.clear();
  }

  // Обработка драг-н-дропа файлов
  void _handleFileDrag() {
    if (!_isAlive || _isChatOpen)  return;
    
    _startAnimation('catch');
    
    // Плавное движение к курсору
    _moveToCursor();
  }

  void _moveToCursor() async {
  final initialPos = await windowManager.getPosition();
  Timer? timer;
  DateTime? startTime;
  
  timer = Timer.periodic(Duration(milliseconds: 16), (timer) async {
    final cursorPos = await _getCursorPosition();
    if (cursorPos == null) {
      timer.cancel();
      return;
    }
    
    startTime ??= DateTime.now();
    
    // Рассчитываем направление к курсору от начальной позиции
    final directionX = cursorPos.dx - _windowWidth / 2 - initialPos.dx;
    final directionY = max(cursorPos.dy - 150, 0.0) - initialPos.dy;
    
    // Вычисляем расстояние до курсора
    final distance = sqrt(directionX * directionX + directionY * directionY);
    
    // Ограничиваем максимальное расстояние 100 пикселями
    final limitedDistance = min(distance, 45.0);
    
    // Нормализуем направление (если расстояние не нулевое)
    final normalizedX = distance > 0 ? directionX / distance : 0.0;
    final normalizedY = distance > 0 ? directionY / distance : 0.0;
    
    // Вычисляем целевую позицию (не дальше 100 пикселей от начальной)
    final targetX = initialPos.dx + normalizedX * limitedDistance;
    final targetY = initialPos.dy + normalizedY * limitedDistance;
    
    // Анимация с фиксированной скоростью ~100px за 750ms
    final elapsed = DateTime.now().difference(startTime!).inMilliseconds;
    final progress = min(elapsed / 750.0, 1.0);
    final eased = Curves.easeInOut.transform(progress);
    
    // Текущая позиция окна
    final currentPos = await windowManager.getPosition();
    
    // Плавное движение к целевой позиции
    final newX = currentPos.dx + (targetX - currentPos.dx) * 0.015; // Коэффициент сглаживания
    final newY = currentPos.dy + (targetY - currentPos.dy) * 0.015;
    
    windowManager.setPosition(Offset(newX, newY));
    
    // Автоматическое завершение через 3 секунды бездействия (опционально)
    if ((elapsed > 7000 && progress >= 1.0)||_isDragging==false) {
      timer.cancel();
    }
  });
  
  // Функция для остановки анимации (можно вызвать извне)
  // _stopAnimation() => timer?.cancel();
}

void _returnToUserPosition() async {
  final currentPos = await windowManager.getPosition();
  Timer? timer;
  DateTime? startTime;
  
  timer = Timer.periodic(Duration(milliseconds: 16), (timer) async {
    startTime ??= DateTime.now();
    

    // Вычисляем целевую позицию для этого кадра (не дальше 100 пикселей)
    final targetX = _userSetPosition.dx;
    final targetY = _userSetPosition.dy;
    
    // Анимация с фиксированной скоростью ~100px за 750ms
    final elapsed = DateTime.now().difference(startTime!).inMilliseconds;
    final progress = min(elapsed / 750.0, 1.0);
    final eased = Curves.easeInOut.transform(progress);
    
    // Плавное движение к целевой позиции
    final newX = currentPos.dx + (targetX - currentPos.dx) * 0.2 +3; // Коэффициент сглаживания
    final newY = currentPos.dy + (targetY - currentPos.dy) * 0.2 +3;
    
    windowManager.setPosition(Offset(newX, newY));
   
    
 // Then in your code:
    if (((targetX-newX).abs() < 30 && (targetY-newY).abs() < 30)||elapsed>1200||_isDragging) {
      windowManager.setPosition(_userSetPosition); // Точная установка позиции
      timer.cancel();
      return;
    }
    
  });
}

Future<Offset?> _getCursorPosition() async {
  try {
    // Используем screen_retriever для получения позиции курсора
    final cursorInfo = await screenRetriever.getCursorScreenPoint();
    return Offset(cursorInfo.dx, cursorInfo.dy);
  } catch (e) {
    print('Error getting cursor position: $e');
    return null;
  }
}

  Widget _buildStatusBars() {

    bool should_show = (!_currentPhrase.isEmpty && _currentPhrase!="");
    return AnimatedOpacity(
      opacity: (_showStatus||should_show) ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            if (_currentPhrase.isNotEmpty && _currentPhrase!="")
              Text(
                _currentPhrase,
                style: TextStyle(color: Colors.white, fontSize: 12),
              )
            else
              Column(
                children: [
                  Text('Lv.$_level $_petName', style: TextStyle(color: Colors.white)),
                  _buildStatusBar('${_locale.get("mood")}', _happiness, Colors.green),
                  _buildStatusBar('${_locale.get("satiety")}', 100 - _hunger, Colors.orange),
                ],
              ),
          ],
        ),
      ),
    );
  }
  Future<void> getFocus() async {
      await windowManager.focus();
      const channel = MethodChannel('screenshot_channel');
      //final result = await channel.invokeMethod('getFocus');
      
  }

  void _test_to_build(){
    return;
  }


  
  Widget _buildInteractiveWidget() {
    return Positioned.fill(
      child: Listener(
        onPointerDown: (PointerDownEvent evt) {
          if (evt.kind == PointerDeviceKind.mouse && evt.buttons == kSecondaryMouseButton) {
              WindowManager.activateFullClick();
            _showContextMenuAtPosition();
          }
        },
        child: MouseRegion(
          onEnter: (event) {
            if (!_isMovingWindow && !_isAnimatingDrop) {
              setState(() {
                _showStatus = true;
                _opacity = 1.0;
              });
            }
            _startHoverTimer();
            _mouseOverWidgetOrChat = true;
            _lastCursorMove = DateTime.now();
            
            // Прерываем idle анимацию при наведении
            if (_currentAnimation == 'idle') {
              _startAnimation('idle'); // Сбрасываем анимацию
            }
          },
          onExit: (event) {
            if (!_isMovingWindow && !_isAnimatingDrop) {
              setState(() {
                _showStatus = false;
                _opacity = 0.0;
              });
            }
            if (_showRecentFiles){
                 WindowManager.returnTo80x80Clickable();
              setState((){
                _showRecentFiles=false;
              });
            }

            
          
            _cancelHoverTimer();
            _mouseOverWidgetOrChat = false;
          },
          onHover: (event) {
            _lastCursorMove = DateTime.now();
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTap,
            onDoubleTap: _onDoubleTap,
            onLongPressStart: (details) {
              _startLongPressTimer(details.globalPosition);
            },
            onLongPressEnd: (details) {
              _cancelLongPressTimer();
            },
            onLongPressCancel: _cancelLongPressTimer,
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  width: _windowWidth,
                  height: _windowHeight,
                  child: Container(
                    width: _windowWidth,
                    height: _windowHeight,
                     key: _petKey, 
                    child: Stack(
                      children: [
                        Positioned(bottom:0, left: (_windowWidth-80)/2, child: _buildPet()),
                        Positioned(
                          bottom: 120,
                          left: 0,
                          right: 0,
                          child: Center(child: _buildStatusBars()),
                        ),
                      ],
                    ),
                  ),
                ),

              

                if (_showRecentFiles)
                  Positioned(
                    left: 0,
                    top: 15,
                    child: _buildRecentFilesOverlay(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*
Widget _buildPet() {
  return FbxPetWidget(
    isAlive: _isAlive,
    currentAnimation: _currentAnimation,
    isMusicPlaying: _isMusicPlaying,
    isDragging: _isDragging, // Добавьте этот флаг при перетаскивании
    modelPath: 'assets/models/pet4.glb',
  );
}
  */

  Widget _buildPet() {
    if (!_isAlive) {
      return Icon(Icons.cancel, size: 60, color: Colors.red);
    }

    // Используем систему анимаций
    if (_animations[_currentAnimation] != null && _animations[_currentAnimation]!.isNotEmpty) {
      final currentFrame = _animations[_currentAnimation]![_currentFrameIndex];
      return Image.file(
        File(currentFrame.imagePath),
        width: 110,
        height: 100,
        fit: BoxFit.contain,
      );
    }

    // Fallback на статическое изображение
    return Image.asset(
      _isMusicPlaying ? 'assets/images/2.png' : 'assets/images/main_template.png',
      width: 80,
      height: 80,
      fit: BoxFit.contain,
    );
  }


Widget _buildPetContent() {
  if (!_isAlive) {
    return Icon(Icons.cancel, size: 60, color: Colors.red);
  }

  // Используем систему анимаций
  if (_animations[_currentAnimation] != null && _animations[_currentAnimation]!.isNotEmpty) {
    final currentFrame = _animations[_currentAnimation]![_currentFrameIndex];
    return Image.file(
      File(currentFrame.imagePath),
      width: 110,
      height: 100,
      fit: BoxFit.contain,
    );
  }

  // Fallback на статическое изображение
  return Image.asset(
    _isMusicPlaying ? 'assets/images/2.png' : 'assets/images/main_template.png',
    width: 80,
    height: 80,
    fit: BoxFit.contain,
  );
}


  void _animateWindowToPosition(Offset targetPosition) {
    _setMovingState(true);
    _isAnimatingDrop = true;
    
    windowManager.getPosition().then((startPos) {
      final startX = startPos.dx;
      final startY = startPos.dy;
      final duration = Duration(milliseconds: 500);
      final startTime = DateTime.now();

      Timer.periodic(Duration(milliseconds: 16), (timer) async {
        final t = DateTime.now().difference(startTime).inMilliseconds / duration.inMilliseconds;
        final eased = Curves.easeOut.transform(min(1.0, t));
        
        double curX = startX + (targetPosition.dx - startX) * eased;
        double curY = startY + (targetPosition.dy - startY) * eased;
        
        curX = curX.clamp(0.0, _screenWidth - _windowWidth);
        curY = curY.clamp(0.0, _screenHeight - _windowHeight);
        
        await windowManager.setPosition(Offset(curX, curY));
        
        if (t >= 1.0) {
          timer.cancel();
          _isAnimatingDrop = false;
          _setMovingState(false);
          setState(() {
            _userSetPosition = Offset(curX, curY);
            _userHasSetPosition = true;
          });
          _saveData();
        }
      });
    });
  }
  void _revealInExplorer(EatenFile filePath) async {
    try {
      if (Platform.isWindows) {
        await Process.run('explorer', ['/select,', filePath.path]);
      } else if (Platform.isMacOS) {
        await Process.run('open', ['-R', filePath.path]);
      } else if (Platform.isLinux) {
        final dir = path.dirname(filePath.path);
        await Process.run('xdg-open', [dir]);
      }
    } catch (e) {
      debugPrint('Error revealing file: $e');
    }
  }

  void _setMovingState(bool val) {
    if (_isMovingWindow == val) return;
    setState(() => _isMovingWindow = val);
  }

  void _startHoverTimer() {
    _hoverTimer?.cancel();
    _hoverTimer = Timer(Duration(milliseconds: 2000), () {
      if (mounted && !_isHoveringRecentFiles && !_contextMenuOpen && !_chatOverlayVisible) {
        setState(() => _showRecentFiles = true);
        WindowManager.activateFullClick();
        _isFollowingCursor = false;
      }
    });
  }

  void _cancelHoverTimer() {
    _hoverTimer?.cancel();
    if (mounted && !_isHoveringRecentFiles) {
      setState(() => _showRecentFiles = false);
      if (!_contextMenuOpen && !_chatOverlayVisible) {
        _isFollowingCursor = false;
      }
    }
  }

  
Future<void> _startServer() async {
  final server = await ServerSocket.bind('localhost', 8081);
  print('Server listening on port 8080');

  server.listen((Socket socket) {
    final List<int> dataBuffer = [];
    
    socket.listen(
      (List<int> data) {
        dataBuffer.addAll(data);
      },
      onDone: () {
        // Декодируем все полученные данные как UTF-8
        final String receivedString = utf8.decode(dataBuffer);
         // Если окно чата уже открыто - отправляем текст

         
      if (ProcessManager().hasProcess("chat_window")) {
         _sendToServer(receivedString);
        return;
      }
      
      // Открываем новое окно чата
       
        _openChatWindowWithText(receivedString,"chat_window");
      },
      onError: (error) {
        print('Socket error: $error');
      }
    );
  });
}


Future<void> _startServer2() async {
  final server = await ServerSocket.bind('localhost', 8082);
  print('Server listening on port 8080');

  server.listen((Socket socket) {
    final List<int> dataBuffer = [];
    
    socket.listen(
      (List<int> data) {
        dataBuffer.addAll(data);
      },
      onDone: () {
        // Декодируем все полученные данные как UTF-8
        final String receivedString = utf8.decode(dataBuffer);
         // Если окно чата уже открыто - отправляем текст
        if (receivedString=="chat is ready"){
        setState(() {
          _chatIsReadyToReceiveMessages = true;
        });

        }
         
      },
      onError: (error) {
        print('Socket error: $error');
      }
    );
  });
}
  final ScrollController _gridScrollController = ScrollController();
  final GlobalKey _gridViewKey = GlobalKey();

Widget _buildRecentFilesOverlay() {
  if (!_showRecentFiles) return SizedBox.shrink();

  // Сортируем файлы: сначала помеченные звездочкой, затем по частоте открытий, затем по давности последнего открытия
  final sortedFiles = _files.toList()
    ..sort((a, b) {
      // 1. Сначала помеченные звездочкой
      if (a.isStarred && !b.isStarred) return -1;
      if (!a.isStarred && b.isStarred) return 1;
      
      // 2. Затем по частоте открытий (по убыванию)
      final openCountComparison = b.openCount.compareTo(a.openCount);
      if (openCountComparison != 0) return openCountComparison;
      
      // 3. Затем по давности последнего открытия (сначала недавно открытые)
      if (a.lastOpened != null && b.lastOpened != null) {
        return b.lastOpened!.compareTo(a.lastOpened!);
      }
      if (a.lastOpened != null) return -1;
      if (b.lastOpened != null) return 1;
      
      return 0;
    });

  return Listener(
    onPointerDown: (_) {
      // Блокируем события мыши от прохождения к нижним слоям
    },
    onPointerMove: (_) {
      // Блокируем события мыши от прохождения к нижним слоям
    },
    child: MouseRegion(
      onEnter: (_) {
        setState(() => _isHoveringRecentFiles = true);
      },
      onExit: (_) {
        // Добавляем задержку перед скрытием, чтобы избежать мгновенного закрытия
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() => _isHoveringRecentFiles = false);
          }
        });
        
        if (!_contextMenuOpen && !_chatOverlayVisible) {
          Future.delayed(Duration(milliseconds: 100), () {
            if (mounted) {
              setState(() => _isFollowingCursor = false);
            }
          });
        }
        
        if (Platform.isWindows && !_isHoveringRecentFiles && !_contextMenuOpen) {
          Future.delayed(Duration(milliseconds: 100), () {
            windowManager.setIgnoreMouseEvents(false);
          });
        }
      },
      child: Center( // Центрируем весь оверлей
        child: Container(
          width: _windowWidth - 15,
          height: _windowHeight - 15,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: true,
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: GridView.builder(
              key: _gridViewKey,
              controller: _gridScrollController,
              padding: EdgeInsets.all(6),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: sortedFiles.isEmpty ? 1 : sortedFiles.length,
              itemBuilder: (context, index) {
                if (sortedFiles.isEmpty) {
                  return Center( // Центрируем содержимое пустой ячейки
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Icon(Icons.folder_open, color: Colors.white54, size: 24),
                      ),
                    ),
                  );
                }

                final file = sortedFiles[index];
                final displayName = file.isWeb ? file.pageTitle : _getDisplayFileName(file);
                
                // Безопасная проверка на папку
                bool isDirectory = false;
                if (!file.isWeb) {
                  try {
                    final dir = Directory(file.path);
                    isDirectory = dir.existsSync();
                  } catch (e) {
                    isDirectory = false;
                  }
                }
                
                return MouseRegion(
                  onEnter: (_) => _showFileTooltip(displayName),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _showRecentFiles = false;
                        _isHoveringRecentFiles = false;
                      });
                      if (file.isWeb) {
                        _openWebUrl(file);
                      } else if (isDirectory) {
                        _openFile(file);
                      } else {
                        _openFile(file);
                      }
                      _incrementOpenCount(file);
                      _isFollowingCursor = false;
                    },
                    onLongPress: () {
                      setState(() {
                        _showRecentFiles = false;
                        _isHoveringRecentFiles = false;
                      });
                      if (file.isWeb) {
                        _searchWebTitle(file);
                      } else if (isDirectory) {
                        _revealInExplorer(file);
                      } else {
                        _revealInExplorer(file);
                      }
                      _isFollowingCursor = false;
                    },
                    
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: file.isStarred ? Colors.yellow.withOpacity(0.5) : Colors.white.withOpacity(0.2), 
                          width: file.isStarred ? 2 : 1
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center( // Центрируем всё содержимое ячейки
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Для папок
                                if (isDirectory)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder,
                                        size: 40,
                                        color: Colors.green.shade300,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        displayName.length > 15 ? '${displayName.substring(0, 15)}...' : displayName,
                                        style: TextStyle(
                                          color: Colors.green.shade300,
                                          fontSize: 9,
                                          fontWeight: file.isStarred ? FontWeight.bold : FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  )
                                // Для web-файлов
                                else if (file.isWeb)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (file.iconBytes != null)
                                        Center(
                                          child: Image.memory(
                                            file.iconBytes!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      else
                                        Icon(
                                          Icons.language,
                                          size: 40,
                                          color: Colors.blue,
                                        ),
                                      SizedBox(height: 4),
                                      Text(
                                        displayName.length > 15 ? '${displayName.substring(0, 15)}...' : displayName,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 9,
                                          fontWeight: file.isStarred ? FontWeight.bold : FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  )
                                // Для обычных файлов
                                else
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Проверяем, является ли файл изображением
                                      if (_isImageFile(displayName))
                                        Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: Image.file(
                                              File(file.path),
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.insert_drive_file,
                                                  size: 40,
                                                  color: Colors.white,
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      else if (file.iconBytes != null)
                                        Center(
                                          child: Image.memory(
                                            file.iconBytes!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      else
                                        Center(
                                          child: _buildFileIcon(file), // Используем новую функцию для иконок
                                        ),
                                      SizedBox(height: 4),
                                      Text(
                                        displayName.length > 15 ? '${displayName.substring(0, 15)}...' : displayName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: file.isStarred ? FontWeight.bold : FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          if (file.isStarred)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

// Функция для получения отображаемого имени файла (убираем .lnk)
String _getDisplayFileName(EatenFile file) {
  final fileName = p.basename(file.path);
  // Убираем расширение .lnk у ярлыков
  if (fileName.toLowerCase().endsWith('.lnk')) {
    return fileName.substring(0, fileName.length - 4);
  }
  return fileName;
}

// Функция для получения иконки файла
Widget _buildFileIcon(EatenFile file) {
  // Проверяем, является ли файл ярлыком
  if (file.path.toLowerCase().endsWith('.lnk')) {
    // Пытаемся получить иконку целевого файла
    if (file.iconBytes != null && file.iconBytes!.isNotEmpty) {
      return Image.memory(
        file.iconBytes!,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      );
    } else {
      // Если иконка еще не загружена, показываем индикатор загрузки
      return FutureBuilder<Uint8List?>(
        future: _getShortcutTargetIcon(file.path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            // Сохраняем иконку в модели файла
            WidgetsBinding.instance.addPostFrameCallback((_) {
              file.iconBytes = snapshot.data;
            });
            
            return Image.memory(
              snapshot.data!,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            );
          } else {
            return Icon(
              Icons.insert_drive_file,
              size: 40,
              color: Colors.white,
            );
          }
        },
      );
    }
  } else {
    return Icon(
      Icons.insert_drive_file,
      size: 40,
      color: Colors.white,
    );
  }
}

// Функция для получения иконки целевого файла ярлыка
Future<Uint8List?> _getShortcutTargetIcon(String shortcutPath) async {
  if (Platform.isWindows) {
    try {
      // Используем shell32 для получения иконки целевого файла
      final targetPath = await _getShortcutTarget(shortcutPath);
      if (targetPath != null && await File(targetPath).exists()) {
        return await _extractIconFromFile(targetPath);
      }
    } catch (e) {
      print('Error getting shortcut target icon: $e');
    }
  }
  return null;
}
Future<String?> _getShortcutTarget(String shortcutPath) async {
  if (Platform.isWindows) {
    try {
      // Создаем временный файл с JScript кодом
      final tempDir = await Directory.systemTemp.createTemp();
      final scriptFile = File('${tempDir.path}\\get_target.js');
      
      // Записываем JScript код в файл
      await scriptFile.writeAsString('''
        var shell = new ActiveXObject("WScript.Shell");
        var shortcut = shell.CreateShortcut("${shortcutPath.replaceAll('\\', '\\\\')}");
        WScript.Echo(shortcut.TargetPath);
      ''');
      
      // Запускаем cscript с временным файлом
      final result = await Process.run('cscript', [
        '//Nologo',
        '//E:jscript',
        scriptFile.path,
      ]);
      
      // Удаляем временный файл
      await scriptFile.delete();
      await tempDir.delete();
      
      if (result.exitCode == 0) {
        final target = result.stdout.toString().trim();
        return target.isNotEmpty ? target : null;
      }
    } catch (e) {
      print('Error getting shortcut target: $e');
    }
  }
  return null;
}
// Функция для извлечения иконки из файла (для Windows)
Future<Uint8List?> _extractIconFromFile(String filePath) async {
  if (Platform.isWindows) {
    try {
      // Используем PowerShell для извлечения иконки
      final result = await Process.run('powershell', [
        '-Command',
        '''
        Add-Type -AssemblyName System.Drawing
        \$icon = [System.Drawing.Icon]::ExtractAssociatedIcon('$filePath')
        \$bitmap = \$icon.ToBitmap()
        \$ms = New-Object System.IO.MemoryStream
        \$bitmap.Save(\$ms, [System.Drawing.Imaging.ImageFormat]::Png)
        [Convert]::ToBase64String(\$ms.ToArray())
        '''
      ]);

      if (result.exitCode == 0) {
        final base64 = result.stdout.toString().trim();
        if (base64.isNotEmpty) {
          return base64Decode(base64);
        }
      }
    } catch (e) {
      print('Error extracting icon: $e');
    }
  }
  return null;
}
// Функция для проверки, является ли файл изображением
bool _isImageFile(String fileName) {

  return fileName.endsWith('.jpg') || 
         fileName.endsWith('.jpeg') ||
         fileName.endsWith('.png') ||
         fileName.endsWith('.gif') ||
         fileName.endsWith('.bmp') ||
         fileName.endsWith('.webp') ||
         fileName.endsWith('.svg');
}

// Виджет для отображения превью изображения
Widget _buildImagePreview(String filePath) {
  try {
    return Container(
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(filePath),
          fit: BoxFit.cover,
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            // Если не удалось загрузить изображение, показываем стандартную иконку
            return Icon(
              Icons.insert_drive_file, 
              size: 40, 
              color: Colors.white
            );
          },
        ),
      ),
    );
  } catch (e) {
    // При ошибке показываем стандартную иконку файла
    return Icon(
      Icons.insert_drive_file, 
      size: 40, 
      color: Colors.white
    );
  }
}


// Функция для получения File объекта
Future<File> _getImageFile(String filePath) async {
  return File(filePath);
}


// Добавьте эти вспомогательные методы в класс:




Future<void> _openWebUrl(EatenFile url) async {
  String formattedUrl = url.path.trim();
  if (!formattedUrl.startsWith('http')) {
    formattedUrl = 'https://$formattedUrl';
  }
  
  if (await canLaunch(formattedUrl)) {
    await launch(formattedUrl);
  } else {
    debugPrint('Cannot launch URL: $formattedUrl');
  }
}

Future<void> _searchWebTitle(EatenFile url) async {
  final searchUrl = 'https://www.google.com/search?q=${Uri.encodeComponent(url.path)}';
  if (await canLaunch(searchUrl)) {
    await launch(searchUrl);
  }
}

// Убедитесь, что у вас есть импорт для url_launcher:
// import 'package:url_launcher/url_launcher.dart';

  Future<Uint8List?> _getFileIcon (EatenFile fileName) async {
    const MethodChannel _fileIconChannel = MethodChannel('screenshot_channel');
    try {
    final result = await _fileIconChannel.invokeMethod('getFileIcon', fileName.path);
    return result as Uint8List?;
  } catch (e) {
    print('Error getting file icon: $e');
    return null;
  }
  }

  void _showFileTooltip(String fileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(fileName),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
      ),
    );
  }



@override
Widget build(BuildContext context) {
  return RepaintBoundary(
    key: _screenshotKey,
    child: RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        // Передаем события кейлоггеру
        _keyboardLogger.handleKeyEvent(event);
      },
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: DropTarget(
                onDragEntered: (detail) {
                  setState(() {
                    _isFollowingCursor = true;
                  });
                },
                onDragExited: (detail) {
                  setState(() {
                    _isFollowingCursor = false;
                    if (_userHasSetPosition) {
                     // _animateWindowToPosition(_userSetPosition);
                    }
                  });
                },
                onDragDone: (detail) {
                  final paths = <String>[];
                  try {
                    for (final f in detail.files) {
                      if (f.path != null && f.path.isNotEmpty) paths.add(f.path);
                    }
                  } catch (e) {}
                  if (paths.isNotEmpty) _onFileDropped(paths);
                  
                  setState(() {
                    _isFollowingCursor = false;
                    if (_userHasSetPosition) {
                     // _animateWindowToPosition(_userSetPosition);
                    }
                  });
                },
                child: Stack(
                  children: [
                    // Основное пространство - игнорирует события, кроме случаев когда открыто меню
                    Positioned.fill(
                      child: IgnorePointer(
                        ignoring: true, // Пропускаем события только когда меню открыто или режим выбора
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    // InteractiveWidget - всегда кликабелен
                    _buildInteractiveWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



// Добавьте эти методы в ваш основной класс
void _handleFileTap(dynamic file, bool isDirectory) {
  setState(() {
    _showRecentFiles = false;
    _isHoveringRecentFiles = false;
  });
  if (file.isWeb) {
    _openWebUrl(file);
  } else if (isDirectory) {
    _openFile(file);
  } else {
    _openFile(file);
  }
  _incrementOpenCount(file);
  _isFollowingCursor = false;
}

void _handleFileLongPress(dynamic file, bool isDirectory) {
  setState(() {
    _showRecentFiles = false;
    _isHoveringRecentFiles = false;
  });
  if (file.isWeb) {
    _searchWebTitle(file);
  } else if (isDirectory) {
    _revealInExplorer(file);
  } else {
    _revealInExplorer(file);
  }
  _isFollowingCursor = false;
}
@override
void dispose() {
  // Отмена всех таймеров3
   _phraseTimer?.cancel();
    _smtc.dispose();
  _clipboardTimer?.cancel();
  _longPressTimer?.cancel();
  _dayTimer?.cancel();
  _musicCheckTimer?.cancel();
  _stateTimer?.cancel();
  _movementTimer?.cancel();
  _hoverTimer?.cancel();
  _idleTimer?.cancel();
  _physicsTimer?.cancel();
  _animationTimer?.cancel();
  //FileDragDropService.dispose(); // Важно: отключаем листенер
  // Остановка мониторинга
  stopMonitoring();
  
  // Закрытие процессов
  ProcessManager().killAllProcesses();
  _chatProcess?.kill();
  
  // Закрытие сетевых соединений
  _httpClient.close();
  
  // Удаление оверлеев
  _removeContextMenu();
  _removeChatOverlay();
  _submenuOverlay?.remove();
  _fileViewerOverlay?.remove();
  
  // Отписка от слушателей
  windowManager.removeListener(this);
  _keyboardLogger.dispose();
  
  // Очистка контроллеров
  _promptController.dispose();
  _hotkeyService.dispose();
  
  super.dispose();
}
 // Удалите метод _windowListener и добавьте вместо этого:
  @override
  void onWindowMove() async {
    if (_isChatOpen) {
      final pos = await windowManager.getPosition();
      final size = await windowManager.getSize();
      
      // TODO: Отправить новую позицию процессу чата через IPC
      // Например, через named pipe, socket или platform channel
      _sendPositionToChat(pos, size);
    }
  }

  void _sendPositionToChat(Offset position, ui.Size size) async {
    try {
      // Здесь реализация отправки позиции в процесс чата
      // Это может быть через platform channels, sockets или другие методы IPC
      print('New position: $position, size: $size');
    } catch (e) {
      print('Error sending position to chat: $e');
    }
  }

  @override
  void onWindowClose() async => await windowManager.hide();
  @override
  void onWindowFocus() {}
  @override
  void onWindowBlur() {}
}



class _FileGridItem extends StatefulWidget {
  final dynamic file;
  final String displayName;
  final bool isDirectory;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _FileGridItem({
    required this.file,
    required this.displayName,
    required this.isDirectory,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<_FileGridItem> createState() => _FileGridItemState();
}

class _FileGridItemState extends State<_FileGridItem> {
  Timer? _autoOpenTimer;

  @override
  void dispose() {
    _autoOpenTimer?.cancel();
    super.dispose();
  }

  void _startAutoOpenTimer() {
    _autoOpenTimer?.cancel();
    _autoOpenTimer = Timer(Duration(seconds: 4), () {
      widget.onTap();
    });
  }

  void _cancelAutoOpenTimer() {
    _autoOpenTimer?.cancel();
  }

 //сюда_копипаста

 // Функция для проверки, является ли файл изображением
bool _isImageFile(String fileName) {

  return fileName.endsWith('.jpg') || 
         fileName.endsWith('.jpeg') ||
         fileName.endsWith('.png') ||
         fileName.endsWith('.gif') ||
         fileName.endsWith('.bmp') ||
         fileName.endsWith('.webp') ||
         fileName.endsWith('.svg');
}


  void _showFileTooltip(String fileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(fileName),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _showFileTooltip(widget.displayName);
        _startAutoOpenTimer();
      },
      onExit: (_) => _cancelAutoOpenTimer(),
      child: GestureDetector(
        onTap: () {
          _cancelAutoOpenTimer();
          widget.onTap();
        },
        onLongPress: () {
          _cancelAutoOpenTimer();
          widget.onLongPress();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: widget.file.isStarred ? Colors.yellow.withOpacity(0.5) : Colors.white.withOpacity(0.2), 
              width: widget.file.isStarred ? 2 : 1
            ),
          ),
          child: Stack(
            children: [
              // Для папок
              if (widget.isDirectory)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder,
                        size: 40,
                        color: Colors.green.shade300,
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.displayName.length > 15 ? '${widget.displayName.substring(0, 15)}...' : widget.displayName,
                        style: TextStyle(
                          color: Colors.green.shade300,
                          fontSize: 9,
                          fontWeight: widget.file.isStarred ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              // Для web-файлов
              else if (widget.file.isWeb)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.file.iconBytes != null)
                        Image.memory(
                          widget.file.iconBytes!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        )
                      else
                        Icon(
                          Icons.language,
                          size: 40,
                          color: Colors.blue,
                        ),
                      SizedBox(height: 4),
                      Text(
                        widget.displayName.length > 15 ? '${widget.displayName.substring(0, 15)}...' : widget.displayName,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 9,
                          fontWeight: widget.file.isStarred ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              // Для обычных файлов
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Проверяем, является ли файл изображением
                    if (_isImageFile(widget.displayName))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          File(widget.file.path),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.insert_drive_file,
                              size: 40,
                              color: Colors.white,
                            );
                          },
                        ),
                      )
                    else if (widget.file.iconBytes != null)
                      Image.memory(
                        widget.file.iconBytes!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      )
                    else
                      Icon(
                        Icons.insert_drive_file,
                        size: 40,
                        color: Colors.white,
                      ),
                    SizedBox(height: 4),
                    Text(
                      widget.displayName.length > 15 ? '${widget.displayName.substring(0, 15)}...' : widget.displayName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: widget.file.isStarred ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              if (widget.file.isStarred)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}



class WindowsFocusInfo {
  final bool isFileSelection;
  final bool isTextSelection;
  final String? selectedText;
  final String? selectedPath;
  final String? error;
  
  WindowsFocusInfo({
    required this.isFileSelection,
    required this.isTextSelection,
    this.selectedText,
    this.selectedPath,
    this.error,
  });
  
  factory WindowsFocusInfo.fromJson(String jsonString) {
    try {
      final Map<String, dynamic> map = json.decode(jsonString);
      return WindowsFocusInfo(
        isFileSelection: map['isFileSelection'] ?? false,
        isTextSelection: map['isTextSelection'] ?? false,
        selectedText: map['selectedText'],
        selectedPath: map['selectedPath'],
        error: map['error'],
      );
    } catch (e) {
      return WindowsFocusInfo(
        isFileSelection: false,
        isTextSelection: false,
        error: 'JSON parsing error: $e',
      );
    }
  }
  
  factory WindowsFocusInfo.fromMap(Map<String, dynamic> map) {
    return WindowsFocusInfo(
      isFileSelection: map['isFileSelection'] ?? false,
      isTextSelection: map['isTextSelection'] ?? false,
      selectedText: map['selectedText'],
      selectedPath: map['selectedPath'],
      error: map['error'],
    );
  }
  
  bool get hasError => error != null;
  bool get hasSelection => isFileSelection || isTextSelection;
}


// Вспомогательные классы и методы
class ImageInfo {
  final img.Image image;
  final int width;
  final int height;
  final bool isLandscape;
  final bool isPortrait;
  final double aspectRatio;

  ImageInfo({
    required this.image,
    required this.width,
    required this.height,
    required this.isLandscape,
    required this.isPortrait,
    required this.aspectRatio,
  });
}

class ImagePlacement {
  final img.Image image;
  final int x;
  final int y;
  final int width;
  final int height;

  ImagePlacement({
    required this.image,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

class CollageStrategy {
  final int canvasWidth;
  final int canvasHeight;
  final List<ImagePlacement> placements;

  CollageStrategy({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.placements,
  });
}

CollageStrategy _createHorizontalRowStrategy(List<img.Image> images, int maxWidth, int maxHeight) {
  final placements = <ImagePlacement>[];
  int currentX = 0;
  int rowHeight = 0;
  
  // Находим максимальную высоту для ряда
  for (final image in images) {
    rowHeight = rowHeight > image.height ? rowHeight : image.height;
  }
  
  // Масштабируем высоту под максимальную, если нужно
  if (rowHeight > maxHeight) {
    rowHeight = maxHeight;
  }
  
  // Размещаем изображения
  for (final image in images) {
    final scaleFactor = rowHeight / image.height;
    final scaledWidth = (image.width * scaleFactor).round();
    
    // Проверяем, не превысили ли максимальную ширину
    if (currentX + scaledWidth > maxWidth) {
      // Если превысили, создаем новый ряд
      break;
    }
    
    placements.add(ImagePlacement(
      image: image,
      x: currentX,
      y: 0,
      width: scaledWidth,
      height: rowHeight,
    ));
    
    currentX += scaledWidth;
  }
  
  return CollageStrategy(
    canvasWidth: currentX,
    canvasHeight: rowHeight,
    placements: placements,
  );
}

CollageStrategy _createVerticalColumnStrategy(List<img.Image> images, int maxWidth, int maxHeight) {
  final placements = <ImagePlacement>[];
  int currentY = 0;
  int columnWidth = 0;
  
  // Находим максимальную ширину для колонки
  for (final image in images) {
    columnWidth = columnWidth > image.width ? columnWidth : image.width;
  }
  
  // Масштабируем ширину под максимальную, если нужно
  if (columnWidth > maxWidth) {
    columnWidth = maxWidth;
  }
  
  // Размещаем изображения
  for (final image in images) {
    final scaleFactor = columnWidth / image.width;
    final scaledHeight = (image.height * scaleFactor).round();
    
    // Проверяем, не превысили ли максимальную высоту
    if (currentY + scaledHeight > maxHeight) {
      break;
    }
    
    placements.add(ImagePlacement(
      image: image,
      x: 0,
      y: currentY,
      width: columnWidth,
      height: scaledHeight,
    ));
    
    currentY += scaledHeight;
  }
  
  return CollageStrategy(
    canvasWidth: columnWidth,
    canvasHeight: currentY,
    placements: placements,
  );
}

CollageStrategy _createAdaptiveGridStrategy(List<img.Image> images, int maxWidth, int maxHeight, bool isLandscape) {
  final placements = <ImagePlacement>[];
  
  if (images.length <= 3) {
    // Для малого количества изображений - простой ряд или колонка
    if (isLandscape) {
      return _createHorizontalRowStrategy(images, maxWidth, maxHeight);
    } else {
      return _createVerticalColumnStrategy(images, maxHeight, maxWidth);
    }
  }
  
  // Для большего количества - сетка 2xN
  int cols = 2;
  int rows = (images.length / cols).ceil();
  
  int cellWidth = (maxWidth / cols).round();
  int cellHeight = (maxHeight / rows).round();
  
  for (int i = 0; i < images.length; i++) {
    final image = images[i];
    final row = i ~/ cols;
    final col = i % cols;
    
    // Вычисляем размеры с сохранением пропорций
    final double widthRatio = cellWidth / image.width;
    final double heightRatio = cellHeight / image.height;
    final double scale = widthRatio < heightRatio ? widthRatio : heightRatio;
    
    final scaledWidth = (image.width * scale).round();
    final scaledHeight = (image.height * scale).round();
    
    // Центрируем изображение в ячейке
    final x = col * cellWidth + (cellWidth - scaledWidth) ~/ 2;
    final y = row * cellHeight + (cellHeight - scaledHeight) ~/ 2;
    
    placements.add(ImagePlacement(
      image: image,
      x: x,
      y: y,
      width: scaledWidth,
      height: scaledHeight,
    ));
  }
  
  return CollageStrategy(
    canvasWidth: maxWidth,
    canvasHeight: rows * cellHeight,
    placements: placements,
  );
}

CollageStrategy _createMixedOrientationStrategy(List<img.Image> images, int maxWidth, int maxHeight) {
  final placements = <ImagePlacement>[];
  
  // Разделяем изображения по ориентации
  final landscapeImages = images.where((img) => img.width >= img.height).toList();
  final portraitImages = images.where((img) => img.height > img.width).toList();
  
  // Пробуем создать горизонтальный ряд из альбомных изображений
  if (landscapeImages.isNotEmpty) {
    final landscapeStrategy = _createHorizontalRowStrategy(landscapeImages, maxWidth, maxHeight ~/ 2);
    for (final placement in landscapeStrategy.placements) {
      placements.add(placement);
    }
  }
  
  // Добавляем портретные изображения ниже
  if (portraitImages.isNotEmpty) {
    final portraitStrategy = _createHorizontalRowStrategy(portraitImages, maxWidth, maxHeight ~/ 2);
    for (final placement in portraitStrategy.placements) {
      placements.add(ImagePlacement(
        image: placement.image,
        x: placement.x,
        y: maxHeight ~/ 2,
        width: placement.width,
        height: placement.height,
      ));
    }
  }
  
  return CollageStrategy(
    canvasWidth: maxWidth,
    canvasHeight: maxHeight,
    placements: placements,
  );
}

























class WindowManager {
  static const MethodChannel _channel = MethodChannel('screenshot_channel');
  
  // Включить полную кликабельность всей области 200x260
  static Future<void> activateFullClick() async {
    try {
      await _channel.invokeMethod('activateFullClick');
      print('Full click area activated (200x260)');
    } on PlatformException catch (e) {
      print("Failed to activate full click: '${e.message}'");
    }
  }
  
  // Вернуть кликабельность только центральной нижней части 80x80
  static Future<void> returnTo80x80Clickable() async {
    try {
      await _channel.invokeMethod('returnTo80x80Clickable');
      print('Returned to 80x80 clickable area');
    } on PlatformException catch (e) {
      print("Failed to return to 80x80: '${e.message}'");
    }
  }
}
































class FbxPetWidget extends StatefulWidget {
  final bool isAlive;
  final String currentAnimation;
  final bool isMusicPlaying;
  final bool isDragging;
  final String modelPath;

  const FbxPetWidget({
    Key? key,
    required this.isAlive,
    required this.currentAnimation,
    required this.isMusicPlaying,
    required this.isDragging,
    required this.modelPath,
  }) : super(key: key);

  @override
  State<FbxPetWidget> createState() => _FbxPetWidgetState();
}

class _FbxPetWidgetState extends State<FbxPetWidget> {
  final _controller = WebviewController();
  bool _isWebViewInitialized = false;
  String? _tempModelPath;
  String? _modelBase64;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  // Функция для проигрывания анимации
  void playAnimation(String animationName) {
    if (_isWebViewInitialized) {
      final script = '''
        try {
          const viewer = document.querySelector('model-viewer');
          // Здесь можно добавить логику смены анимации
          // Например, если модель поддерживает несколько анимаций
          console.log('Playing animation: $animationName');
        } catch(e) {
          console.log('Animation error:', e);
        }
      ''';
      _controller.executeScript(script);
    }
  }

  // Функция для остановки анимации
  void stopAnimation() {
    if (_isWebViewInitialized) {
      final script = '''
        try {
          const viewer = document.querySelector('model-viewer');
          // Логика остановки анимации
          console.log('Animation stopped');
        } catch(e) {
          console.log('Stop animation error:', e);
        }
      ''';
      _controller.executeScript(script);
    }
  }

  // Функция для смены модели
  void changeModel(String newModelPath) async {
    try {
      final byteData = await rootBundle.load(newModelPath);
      final bytes = byteData.buffer.asUint8List();
      final base64 = base64Encode(bytes);
      final newModelBase64 = 'data:model/gltf-binary;base64,$base64';
      
      final script = '''
        const viewer = document.querySelector('model-viewer');
        viewer.src = '$newModelBase64';
      ''';
      
      _controller.executeScript(script);
    } catch (e) {
      print('Error changing model: $e');
    }
  }

  Future<String> _getModelAsBase64() async {
    try {
      final byteData = await rootBundle.load(widget.modelPath);
      final bytes = byteData.buffer.asUint8List();
      final base64 = base64Encode(bytes);
      return 'data:model/gltf-binary;base64,$base64';
    } catch (e) {
      print('Error encoding model: $e');
      rethrow;
    }
  }

  Future<void> _initializeWebView() async {
    try {
      await _controller.initialize();
      
      _modelBase64 = await _getModelAsBase64();
     final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
  <style>
    html, body { 
      margin: 0; 
      padding: 0; 
      height: 100%; 
      width: 100%; 
      background: transparent !important; 
      overflow: hidden;
      user-select: none;
      -webkit-user-select: none;
    }
    model-viewer { 
      width: 100%; 
      height: 100%; 
      background: transparent !important; 
      transform: scale(0.55) translateX(-8%) translateY(8%);
      pointer-events: none !important; /* Полностью отключаем все события мыши */
      cursor: default !important;
      --interaction-prompt: none !important;
    }
    
    /* Скрываем абсолютно все элементы управления */
    * {
      pointer-events: none !important;
    }
  </style>
</head>
<body>
  <model-viewer 
    src="$_modelBase64" 
    camera-controls="false"
    autoplay
    interaction-prompt="none"
    interaction-policy="none"
    background-color="transparent"
    camera-orbit="0deg 75deg 2.5m"
    field-of-view="30deg"
    min-camera-orbit="auto auto 2m"
    max-camera-orbit="auto auto 3m"
    scale="1.3 1.3 1.3"
    alt="3D Pet Model"
    disable-zoom
    disable-pan
    disable-tap
    ar="false"
    style="--interaction-prompt: none; --poster-color: transparent; pointer-events: none;">
  </model-viewer>
  
  <script>
    document.body.style.backgroundColor = 'transparent';
    const viewer = document.querySelector('model-viewer');
    viewer.style.backgroundColor = 'transparent';
    
    // Полностью отключаем все взаимодействия
    viewer.interactionPrompt = 'none';
    viewer.interactionPolicy = 'none';
    
    // Принудительно отключаем все обработчики событий
    viewer.addEventListener('load', () => {
      // Отключаем все возможные события
      const events = ['mousedown', 'mouseup', 'click', 'touchstart', 'touchend', 'touchmove', 'wheel', 'pointerdown', 'pointerup', 'pointermove'];
      
      events.forEach(eventType => {
        viewer.addEventListener(eventType, (e) => {
          e.preventDefault();
          e.stopPropagation();
          e.stopImmediatePropagation();
          return false;
        }, true);
        
        // Также на document для полной блокировки
        document.addEventListener(eventType, (e) => {
          e.preventDefault();
          e.stopPropagation();
          e.stopImmediatePropagation();
          return false;
        }, true);
      });
      
      // Дополнительно делаем viewer неинтерактивным
      viewer.style.pointerEvents = 'none';
      viewer.setAttribute('data-js-focus-visible', '');
      viewer.removeAttribute('tabindex');
      
      // Скрываем любые возможные элементы управления
      const style = document.createElement('style');
      style.textContent = `
        * {
          pointer-events: none !important;
          cursor: default !important;
        }
        .interaction-prompt, 
        [part*="prompt"],
        [part*="control"],
        .control,
        .prompt,
        .cursor-grab,
        .cursor-grabbing {
          display: none !important;
          visibility: hidden !important;
          opacity: 0 !important;
        }
      `;
      document.head.appendChild(style);
    });
    
    // Глобальная блокировка всех событий
    document.addEventListener('DOMContentLoaded', () => {
      document.body.style.pointerEvents = 'none';
    });
    
    // Блокируем все события на всем документе
    ['mousedown', 'mouseup', 'click', 'touchstart', 'touchend', 'touchmove', 'wheel', 
     'pointerdown', 'pointerup', 'pointermove', 'contextmenu', 'selectstart', 'dragstart']
    .forEach(eventType => {
      document.addEventListener(eventType, (e) => {
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        return false;
      }, true);
    });
    
    // Блокируем выделение текста и контекстное меню
    document.addEventListener('contextmenu', (e) => e.preventDefault());
    document.addEventListener('selectstart', (e) => e.preventDefault());
    document.addEventListener('dragstart', (e) => e.preventDefault());
  </script>
</body>
</html>
''';

      await _controller.loadUrl('data:text/html;charset=utf-8,' + Uri.encodeComponent(htmlContent));
      await _controller.setBackgroundColor(Colors.transparent);
      
      setState(() {
        _isWebViewInitialized = true;
      });
    } catch (e) {
      print('Error initializing WebView: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: _isWebViewInitialized
          ? Webview(
              _controller,
              permissionRequested: (url, permissionKind, isUserInitiated) =>
                  _onPermissionRequested(
                url,
                permissionKind,
                isUserInitiated,
              ),
            )
          : Container(), // Пустой контейнер вместо индикатора загрузки
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
    String url,
    WebviewPermissionKind kind,
    bool isUserInitiated,
  ) async {
    return WebviewPermissionDecision.allow;
  }

  @override
  void dispose() {
    if (_tempModelPath != null) {
      try {
        File(_tempModelPath!).delete();
      } catch (e) {
        print('Error deleting temp file: $e');
      }
    }
    _controller.dispose();
    super.dispose();
  }
}




















class ClipboardMonitor {
  static final ClipboardMonitor _instance = ClipboardMonitor._internal();
  factory ClipboardMonitor() => _instance;
  ClipboardMonitor._internal();
String _lastImageHash = '';
  final Set<String> _processedImageHashes = {};

  Timer? _clipboardTimer;
  String _lastClipboardContent = '';
  final String _registryKey = 'FeedAI';
  String _appExecutable = 'imeyou_pet.exe';
  bool _isProcessingFile = false;
  final Set<String> _processedFiles = {};
  final _disposed = Completer<void>();
  bool _isDisposed = false;
  final int _maxProcessedItems = 12;


   EncryptionService1? service ;


  Future<void> initialize() async {
     service = await EncryptionService1.create();
    await _setupWindowsContextMenu();
    _startClipboardMonitoring();
    await cleanupOldEntries();
  }

  Future<String> _getExecutablePath() async {
    try {
      if (_appExecutable == 'imeyou_pet.exe') {
        final exe = Platform.resolvedExecutable;
        return exe;
      }
      return 'imeyou_pet.exe';
    } catch (e) {
      return 'imeyou_pet.exe';
    }
  }

  Future<void> _setupWindowsContextMenu() async {
    if (!Platform.isWindows) return;

    try {
      final exePath = await _getExecutablePath();

      final ps = '''
        \$menu = "Registry::HKEY_CURRENT_USER\\\\Software\\\\Classes\\\\*\\\\shell\\\\FeedAI"
        \$cmd = "\$menu\\\\command"

        # создаём пункт
        New-Item -Path \$menu -Force | Out-Null
        Set-ItemProperty -Path \$menu -Name "MUIVerb" -Value "Feed to AI"
        Set-ItemProperty -Path \$menu -Name "Icon" -Value "$exePath"
        Set-ItemProperty -Path \$menu -Name "Position" -Value "Top"
        Set-ItemProperty -Path \$menu -Name "Extended" -Value ""  # виден в Shift+F10

        # команда
        New-Item -Path \$cmd -Force | Out-Null
        Set-ItemProperty -Path \$cmd -Name "(Default)" -Value "`"$exePath`" --feed-file `"%1`""

        Write-Output "Classic context menu added."
      ''';

      final result = await Process.run(
        'powershell',
        ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', ps],
      );

      print(result.stdout);
      print(result.stderr);
    } catch (e) {
      print('Error adding context menu: $e');
    }
  }

  Future<void> _refreshExplorerContextMenus() async {
    if (!Platform.isWindows) return;
    try {
      await Process.run('ie4uinit.exe', ['-ClearIconCache']);
      await Process.run('ie4uinit.exe', ['-show']);
      await Process.run('RUNDLL32.EXE', ['shell32.dll,Control_RunDLL']);
      print('Explorer context menu cache refreshed.');
    } catch (e) {
      print('Error refreshing Explorer: $e');
    }
  }

  // Добавляем метод для вычисления хэша изображения
  String _calculateImageHash(List<int> imageBytes) {
    final bytes = Uint8List.fromList(imageBytes);
    final digest = md5.convert(bytes);
    return digest.toString();
  }
Future<void> _saveImageEntry(List<int> imageBytes, bool hasAlpha, String imageHash, String extension) async {
  try {
    print('Starting image save process...');
    
    final directory = await getApplicationDocumentsDirectory();
    final copypasteDir = Directory('${directory.path}/copypasted');
    final imagesDir = Directory('${copypasteDir.path}/images');
    
    if (!copypasteDir.existsSync()) {
      copypasteDir.createSync(recursive: true);
      print('Created copypaste directory: ${copypasteDir.path}');
    }
    
    if (!imagesDir.existsSync()) {
      imagesDir.createSync(recursive: true);
      print('Created images directory: ${imagesDir.path}');
    }

    // Проверяем существующие записи изображений на дубликаты
    final hasDuplicate = await _hasDuplicateImageEntry(imageHash, copypasteDir);
    if (hasDuplicate) {
      print('Duplicate image found, skipping save (hash: $imageHash)');
      return;
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final imageFileName = '$timestamp.$extension';
    final imageFile = File('${imagesDir.path}/$imageFileName');
    
    print('Saving image file: ${imageFile.path}');
    
    // Сохраняем изображение
    await imageFile.writeAsBytes(imageBytes, flush: true);
    
    // Проверяем, что файл создался
    if (imageFile.existsSync()) {
      final fileSize = await imageFile.length();
      print('Image file saved successfully. Size: $fileSize bytes');
    } else {
      print('ERROR: Image file was not created!');
      return;
    }
    
    // Создаем запись в базе
    final entryFile = File('${copypasteDir.path}/$timestamp.cnp');
    
    final entry = {
      'content': imageFileName,
      'timestamp': timestamp,
      'length': imageBytes.length,
      'type': 'image',
      'source': 'clipboard',
      'starred': false,
      'image_info': {
        'hash': imageHash,
        'file_name': imageFileName,
        'file_path': imageFile.path,
        'has_alpha': hasAlpha,
        'format': extension,
        'size': imageBytes.length,
      }
    };

    final jsonString = jsonEncode(entry);
    final bytes = utf8.encode(jsonString);
    await entryFile.writeAsBytes(bytes, flush: true);
    
    if (entryFile.existsSync()) {
      print('Image entry saved successfully: ${entryFile.path}');
    } else {
      print('ERROR: Entry file was not created!');
    }
    
    print('Image entry completed: ${imageFile.path} (${imageBytes.length} bytes, $extension, hash: $imageHash)');
    
    // Очищаем старые хэши
    _cleanupProcessedImageHashes();
    
  } catch (e) {
    print('Error saving image entry: $e');
    print('Stack trace: ${e.toString()}');
  }
}


// Альтернативный метод для проверки изображений (более простой)
Future<bool> _checkClipboardForImageAlternative() async {
  try {
    // Простая проверка через PowerShell
    final result = await Process.run('powershell', [
      '-Command',
      '''
      Add-Type -AssemblyName System.Windows.Forms
      \$hasImage = [System.Windows.Forms.Clipboard]::ContainsImage()
      if (\$hasImage) {
        Write-Output "TRUE"
      } else {
        Write-Output "FALSE"
      }
      '''
    ]);

    final hasImage = result.stdout.toString().trim() == 'TRUE';
    print('Alternative check - Clipboard has image: $hasImage');
    
    return hasImage;
  } catch (e) {
    print('Error in alternative image check: $e');
    return false;
  }
}
Future<void> testImageCapture() async {
  print('=== TESTING IMAGE CAPTURE ===');
  
  // Тест альтернативным методом
  final hasImage = await _checkClipboardForImageAlternative();
  print('Alternative method result: $hasImage');
  
  // Тест основным методом
  await _checkClipboardForImage();
  
  print('=== TEST COMPLETED ===');
}

  // Добавляем метод для проверки дубликатов изображений
  Future<bool> _hasDuplicateImageEntry(String imageHash, Directory copypasteDir) async {
    try {
      final files = copypasteDir.listSync()
        .where((file) => file is File && file.path.endsWith('.cnp'))
        .toList();

      for (final file in files) {
        try {
          final bytes = await File(file.path).readAsBytes();
          String contentString;
          
          try {
            contentString = utf8.decode(bytes);
          } catch (e) {
            contentString = latin1.decode(bytes);
          }
          
          final entry = jsonDecode(contentString);
          
          if (entry is Map<String, dynamic> && 
              entry['type'] == 'image' && 
              entry.containsKey('image_info')) {
            final imageInfo = entry['image_info'] as Map<String, dynamic>;
            final existingHash = imageInfo['hash']?.toString();
            
            if (existingHash == imageHash) {
              return true;
            }
          }
        } catch (e) {
          print('Error checking duplicate image in ${file.path}: $e');
        }
      }
      return false;
    } catch (e) {
      print('Error checking for duplicate images: $e');
      return false;
    }
  }


  void _startClipboardMonitoring() {
    _clipboardTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      
      try {
        await _monitorClipboardWithTimeout();
      } catch (e) {
        if (!_isDisposed) {
          print('Clipboard monitoring error: $e');
        }
      }
    });
  }
  
  Future<void> _monitorClipboardWithTimeout() async {
    final timeoutDuration = Duration(seconds: 1);
    
    try {
      await Future.any([
        _checkClipboardContents(),
        Future.delayed(timeoutDuration, () => throw TimeoutException('Clipboard check timed out'))
      ]);
    } on TimeoutException {
      if (!_isDisposed) {
        print('Clipboard check timeout');
      }
    } catch (e) {
      if (!_isDisposed) {
        print('Error in clipboard check: $e');
      }
    }
  }
  
  Future<void> _checkClipboardContents() async {
    if (_isDisposed) return;
    
    // 1. Проверяем изображения
    final imageProcessed = await _checkClipboardForImage();
    if (imageProcessed || _isDisposed) return;
    
    // 2. Проверяем файлы
    final fileProcessed = await _checkClipboardForFiles();
    if (fileProcessed || _isDisposed) return;
    
    // 3. Проверяем текст
    await _checkClipboardForText();
  }

  // Добавляем недостающий метод для проверки текста
 Future<void> _checkClipboardForText() async {
  if (_isDisposed) return;
  
  try {
    final result = await _runPowerShellWithTimeout(_textCheckScript);
    if (result.exitCode != 0) return;

    String base64Content = result.stdout.trim();
    String currentContent = '';
    
    if (base64Content.isNotEmpty) {
      try {
        final bytes = base64.decode(base64Content);
        currentContent = utf8.decode(bytes);
      } catch (e) {
        if (!_isDisposed) print('Error decoding base64: $e');
        currentContent = '';
      }
    }
    
    if (currentContent.isNotEmpty && 
        currentContent != _lastClipboardContent &&
        _isValidContent(currentContent) &&
        !_isDuplicateContent(currentContent)) {
      
      if (!_isDisposed) {
        print('New clipboard content detected: ${currentContent.length} chars');
        await _saveClipboardEntry(currentContent);
        _lastClipboardContent = currentContent;
      }
    }
  } catch (e) {
    if (!_isDisposed) print('Error reading clipboard text: $e');
  }
}

Future<bool> _checkClipboardForFiles() async {
  if (_isDisposed) return false;
  
  try {
    final result = await _runPowerShellWithTimeout(_fileCheckScript);
    if (result.exitCode != 0) return false;

    final filePath = result.stdout.trim();
    
    if (filePath.isNotEmpty && File(filePath).existsSync()) {
      if (!_isProcessingFile && !_processedFiles.contains(filePath)) {
        _isProcessingFile = true;
        try {
          await _saveFileEntry(filePath);
          _addToProcessedFiles(filePath);
          return true;
        } finally {
          _isProcessingFile = false;
        }
      }
    }
    return false;
  } catch (e) {
    if (!_isDisposed) print('Error checking files: $e');
    return false;
  }
}

Future<bool> _checkClipboardForImage() async {
  if (_isDisposed) return false;
  
  try {
    final result = await _runPowerShellWithTimeout(_imageCheckScript, timeoutSeconds: 5);
    if (result.exitCode != 0) return false;

    final output = result.stdout.trim();
    
    if (output.startsWith('SUCCESS:')) {
      final parts = output.split(':');
      if (parts.length >= 4) {
        final hasAlpha = parts[1].toLowerCase() == 'true';
        final imageBase64 = parts[2];
        final extension = parts[3];
        
        if (!_isDisposed) {
          print('Image found in clipboard. Has alpha: $hasAlpha, Format: $extension, Base64 length: ${imageBase64.length}');
        }
        
        if (imageBase64.length > 100) {
          final imageBytes = base64.decode(imageBase64);
          final imageHash = _calculateImageHash(imageBytes);
          
          if (!_isDisposed && !_processedImageHashes.contains(imageHash) && imageHash != _lastImageHash) {
            await _saveImageEntry(imageBytes, hasAlpha, imageHash, extension);
            _lastImageHash = imageHash;
            _processedImageHashes.add(imageHash);
            _cleanupProcessedImageHashes();
            return true;
          }
        }
      }
    }
    
    return false;
  } catch (e) {
    if (!_isDisposed) print('Error checking clipboard for image: $e');
    return false;
  }
}

// Новая функция для безопасного запуска PowerShell с таймаутом
Future<ProcessResult> _runPowerShellWithTimeout(String script, {int timeoutSeconds = 3}) async {
  Process? process;
  
  try {
    // Запускаем процесс
    process = await Process.start(
      'powershell', 
      ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', script],
      runInShell: false
    );

    // Собираем stdout и stderr
    final stdoutFuture = process.stdout.transform(utf8.decoder).join();
    final stderrFuture = process.stderr.transform(utf8.decoder).join();

    // Ждем завершения процесса с таймаутом
    final exitCode = await process.exitCode.timeout(
      Duration(seconds: timeoutSeconds),
      onTimeout: () {
        // Принудительно завершаем процесс при таймауте
        process?.kill();
        return -1;
      }
    );

    final stdout = await stdoutFuture;
    final stderr = await stderrFuture;

    return ProcessResult(process.pid, exitCode, stdout, stderr);
    
  } catch (e) {
    // Если возникла ошибка, убиваем процесс
    process?.kill();
    return ProcessResult(0, -1, '', e.toString());
  }
}

// Добавляем метод для принудительной очистки всех процессов PowerShell
void _killAllPowerShellProcesses() async {
  if (Platform.isWindows) {
    try {
      // Безопасно завершаем процессы PowerShell
      await Process.run('taskkill', ['/f', '/im', 'powershell.exe']);
      await Process.run('taskkill', ['/f', '/im', 'conhost.exe']);
      print('PowerShell processes cleaned up');
    } catch (e) {
      print('Error killing PowerShell processes: $e');
    }
  }
}


  // Метод для добавления файлов в обработанные с ограничением размера
  void _addToProcessedFiles(String filePath) {
    _processedFiles.add(filePath);
    if (_processedFiles.length > _maxProcessedItems) {
      final list = _processedFiles.toList();
      _processedFiles.clear();
      _processedFiles.addAll(list.sublist(list.length - _maxProcessedItems ~/ 2));
    }
  }
  
  void _cleanupProcessedImageHashes() {
    if (_processedImageHashes.length > _maxProcessedItems) {
      final list = _processedImageHashes.toList();
      _processedImageHashes.clear();
      _processedImageHashes.addAll(list.sublist(list.length - _maxProcessedItems ~/ 2));
    }
  }
  
  // Улучшенный PowerShell скрипт с гарантированным освобождением ресурсов
    final String _fileCheckScript = '''
    Add-Type -AssemblyName System.Windows.Forms
    if ([System.Windows.Forms.Clipboard]::ContainsFileDropList()) {
      \$files = [System.Windows.Forms.Clipboard]::GetFileDropList()
      if (\$files.Count -gt 0) {
        return \$files[0]
      }
    }
    return ""
  ''';

  final String _textCheckScript = '''
    Add-Type -AssemblyName System.Windows.Forms
    try {
      if ([System.Windows.Forms.Clipboard]::ContainsText()) {
        \$text = [System.Windows.Forms.Clipboard]::GetText()
        if (![string]::IsNullOrEmpty(\$text)) {
          \$bytes = [System.Text.Encoding]::UTF8.GetBytes(\$text)
          \$base64 = [Convert]::ToBase64String(\$bytes)
          Write-Output \$base64
        }
      }
    } catch {
      ""
    }
  ''';

  final String _imageCheckScript = '''
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    \$bitmap = \$null
    \$stream = \$null
    try {
      Write-Host "Checking if clipboard contains image..."
      \$hasImage = [System.Windows.Forms.Clipboard]::ContainsImage()
      Write-Host "Clipboard contains image: \$hasImage"
      
      if (\$hasImage) {
        Write-Host "Getting image from clipboard..."
        \$bitmap = [System.Windows.Forms.Clipboard]::GetImage()
        
        if (\$bitmap -ne \$null) {
          Write-Host "Image obtained successfully. Width: \$(\$bitmap.Width), Height: \$(\$bitmap.Height)"
          
          # Определяем формат на основе наличия альфа-канала
          \$hasAlpha = \$bitmap.PixelFormat -eq [System.Drawing.Imaging.PixelFormat]::Format32bppArgb -or
                     \$bitmap.PixelFormat -eq [System.Drawing.Imaging.PixelFormat]::Format32bppPArgb -or
                     \$bitmap.PixelFormat -eq [System.Drawing.Imaging.PixelFormat]::Format64bppArgb
          
          Write-Host "Has alpha channel: \$hasAlpha"
          
          # Выбираем формат
          if (\$hasAlpha) {
            \$format = [System.Drawing.Imaging.ImageFormat]::Png
            \$extension = "png"
          } else {
            \$format = [System.Drawing.Imaging.ImageFormat]::Jpeg
            \$extension = "jpg"
          }
          
          # Конвертируем в байты
          \$stream = New-Object System.IO.MemoryStream
          \$bitmap.Save(\$stream, \$format)
          \$bytes = \$stream.ToArray()
          \$base64 = [Convert]::ToBase64String(\$bytes)
          
          Write-Host "Image converted to base64, length: \$(\$base64.Length)"
          Write-Output "SUCCESS:\$hasAlpha:\$base64:\$extension"
        } else {
          Write-Host "Bitmap is null"
          Write-Output "NO_IMAGE"
        }
      } else {
        Write-Output "NO_IMAGE"
      }
    } catch {
      Write-Host "Error: \$_\"
      Write-Output "ERROR:\$_"
    } finally {
      if (\$stream -ne \$null) { \$stream.Dispose() }
      if (\$bitmap -ne \$null) { \$bitmap.Dispose() }
    }
  ''';


String _fixRussianEncoding(String corruptedText) {
  try {
    // Это исправление для текста вида "Рђ РєС‚Рѕ" -> "А кто"
    final Map<int, String> encodingMap = {
      0xD090: 'А', 0xD091: 'Б', 0xD092: 'В', 0xD093: 'Г', 0xD094: 'Д',
      0xD095: 'Е', 0xD096: 'Ж', 0xD097: 'З', 0xD098: 'И', 0xD099: 'Й',
      0xD09A: 'К', 0xD09B: 'Л', 0xD09C: 'М', 0xD09D: 'Н', 0xD09E: 'О',
      0xD09F: 'П', 0xD0A0: 'Р', 0xD0A1: 'С', 0xD0A2: 'Т', 0xD0A3: 'У',
      0xD0A4: 'Ф', 0xD0A5: 'Х', 0xD0A6: 'Ц', 0xD0A7: 'Ч', 0xD0A8: 'Ш',
      0xD0A9: 'Щ', 0xD0AA: 'Ъ', 0xD0AB: 'Ы', 0xD0AC: 'Ь', 0xD0AD: 'Э',
      0xD0AE: 'Ю', 0xD0AF: 'Я',
      0xD0B0: 'а', 0xD0B1: 'б', 0xD0B2: 'в', 0xD0B3: 'г', 0xD0B4: 'д',
      0xD0B5: 'е', 0xD0B6: 'ж', 0xD0B7: 'з', 0xD0B8: 'и', 0xD0B9: 'й',
      0xD0BA: 'к', 0xD0BB: 'л', 0xD0BC: 'м', 0xD0BD: 'н', 0xD0BE: 'о',
      0xD0BF: 'п', 0xD180: 'р', 0xD181: 'с', 0xD182: 'т', 0xD183: 'у',
      0xD184: 'ф', 0xD185: 'х', 0xD186: 'ц', 0xD187: 'ч', 0xD188: 'ш',
      0xD189: 'щ', 0xD18A: 'ъ', 0xD18B: 'ы', 0xD18C: 'ь', 0xD18D: 'э',
      0xD18E: 'ю', 0xD18F: 'я'
    };

    String result = '';
    for (int i = 0; i < corruptedText.length; i++) {
      if (i + 1 < corruptedText.length) {
        int code = (corruptedText.codeUnitAt(i) << 8) | corruptedText.codeUnitAt(i + 1);
        if (encodingMap.containsKey(code)) {
          result += encodingMap[code]!;
          i++; // Пропускаем следующий символ
          continue;
        }
      }
      result += corruptedText[i];
    }
    return result;
  } catch (e) {
    print('Error fixing Russian encoding: $e');
    return corruptedText;
  }
}

  // Проверяем, является ли текст "mojibake" (испорченной кодировкой)
  bool _isMojibake(String text) {
    if (text.isEmpty) return false;
    
    // Типичные признаки mojibake для русского текста
    final mojibakePatterns = [
      'ў', 'Ђ', 'Ѓ', 'Є', 'Ѕ', 'І', 'Ї', 'Ј', 'љ', 'Њ',
      'Ћ', 'Ќ', 'Ў', 'Џ', 'ђ', '‘', '’', '“', '”', '•',
      '–', '—', '', '™', 'љ', '›', 'ќ', 'ћ', 'џ', ' '
    ];
    
    return mojibakePatterns.any((char) => text.contains(char));
  }

  // Исправляем mojibake (Windows-1252 -> UTF-8)
  String _fixMojibake(String text) {
    try {
      // Предполагаем, что текст был неправильно прочитан как Windows-1252
      final bytes = latin1.encode(text);
      return utf8.decode(bytes);
    } catch (e) {
      print('Error fixing mojibake: $e');
      return text;
    }
  }

  bool _isValidContent(String content) {
    if (content.isEmpty) return false;
    if (content.length < 2) return false;
    if (content.length > 10000) return false;
    if (content.trim().isEmpty) return false;
    
    return true;
  }

  bool _isDuplicateContent(String newContent) {
    // Нормализуем пробелы для сравнения
    final normalizedNew = newContent.replaceAll(RegExp(r'\s+'), ' ').trim();
    final normalizedLast = _lastClipboardContent.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return normalizedNew == normalizedLast;
  }

  Future<void> _saveClipboardEntry(String content) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final copypasteDir = Directory('${directory.path}/copypasted');
      
      if (!copypasteDir.existsSync()) {
        copypasteDir.createSync(recursive: true);
      }

      // Проверяем существующие записи на дубликаты
      if (await _hasDuplicateEntry(content, copypasteDir)) {
        print('Duplicate content found, skipping save');
        return;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${copypasteDir.path}/$timestamp.cnp');
      
      final contentType = _detectContentType(content);
      final entry = {
        'content': content,
        'timestamp': timestamp,
        'length': content.length,
        'type': contentType,
        'source': 'clipboard',
        'starred': false,
      };

      // Сохраняем с правильной UTF-8 кодировкой
      final jsonString = jsonEncode(entry);
       final encrypted = await service!.encryptData(jsonString);
  
      await file.writeAsString(encrypted);
      
      print('Clipboard entry saved: ${file.path} (${content.length} chars, type: $contentType)');
      print('Sample content: ${content.length > 50 ? content.substring(0, 50) + '...' : content}');
    } catch (e) {
      print('Error saving clipboard entry: $e');
    }
  }

  Future<bool> _hasDuplicateEntry(String content, Directory copypasteDir) async {
    try {
      final files = copypasteDir.listSync()
        .where((file) => file is File && file.path.endsWith('.cnp'))
        .toList();

      // Нормализуем новое содержимое для сравнения
      final normalizedNew = content.replaceAll(RegExp(r'\s+'), ' ').trim();

      for (final file in files) {
        try {
          final bytes = await File(file.path).readAsBytes();
          String contentString;
          
          // Пытаемся декодировать как UTF-8
          try {
            contentString = utf8.decode(bytes);
          } catch (e) {
            // Если UTF-8 не работает, пробуем latin1 (для старых записей)
            contentString = latin1.decode(bytes);
          }
          
          final entry = jsonDecode(contentString);
          
          if (entry is Map<String, dynamic> && entry.containsKey('content')) {
            final existingContent = entry['content'].toString();
            final normalizedExisting = existingContent.replaceAll(RegExp(r'\s+'), ' ').trim();
            
            if (normalizedNew == normalizedExisting) {
              return true;
            }
          }
        } catch (e) {
          print('Error checking duplicate in file ${file.path}: $e');
        }
      }
      return false;
    } catch (e) {
      print('Error checking for duplicates: $e');
      return false;
    }
  }

  Future<void> _saveFileEntry(String filePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final copypasteDir = Directory('${directory.path}/copypasted');
      
      if (!copypasteDir.existsSync()) {
        copypasteDir.createSync(recursive: true);
      }

      // Проверяем существующие записи файлов на дубликаты
      if (await _hasDuplicateFileEntry(filePath, copypasteDir)) {
        print('Duplicate file entry found, skipping save: $filePath');
        return;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${copypasteDir.path}/$timestamp.cnp');
      
      final fileInfo = File(filePath);
      final fileName = path.basename(filePath);
      final fileSize = await fileInfo.length();
      final fileExtension = path.extension(filePath).toLowerCase();
      
      final entry = {
        'content': filePath,
        'timestamp': timestamp,
        'length': fileSize,
        'type': 'file',
        'source': 'clipboard',
        'starred': false,
        'file_info': {
          'name': fileName,
          'path': filePath,
          'size': fileSize,
          'extension': fileExtension,
          'is_directory': Directory(filePath).existsSync(),
        }
      };

      final jsonString = jsonEncode(entry);
        final encrypted = await service!.encryptData(jsonString);
      final bytes = utf8.encode(encrypted);
      await file.writeAsBytes(bytes, flush: true);
      
      print('File entry saved: ${file.path} ($fileName, $fileSize bytes)');
    } catch (e) {
      print('Error saving file entry: $e');
    }
  }

  Future<bool> _hasDuplicateFileEntry(String filePath, Directory copypasteDir) async {
    try {
      final files = copypasteDir.listSync()
        .where((file) => file is File && file.path.endsWith('.cnp'))
        .toList();

      for (final file in files) {
        try {
          final bytes = await File(file.path).readAsBytes();
          String contentString;
          
          try {
            contentString = utf8.decode(bytes);
          } catch (e) {
            contentString = latin1.decode(bytes);
          }
          
          final entry = jsonDecode(contentString);
          
          if (entry is Map<String, dynamic> && 
              entry['type'] == 'file' && 
              entry.containsKey('content')) {
            final existingFilePath = entry['content'].toString();
            
            if (existingFilePath == filePath) {
              return true;
            }
          }
        } catch (e) {
          print('Error checking duplicate file in ${file.path}: $e');
        }
      }
      return false;
    } catch (e) {
      print('Error checking for duplicate files: $e');
      return false;
    }
  }

  String _detectContentType(String content) {
    if (_isUrl(content)) return 'url';
    if (_isEmail(content)) return 'email';
    if (_isCode(content)) return 'code';
    if (_isHtml(content)) return 'html';
    if (_isImageUrl(content)) return 'image_url';
    if (_isDocumentUrl(content)) return 'document_url';
    return 'text';
  }

  bool _isUrl(String text) {
    final trimmed = text.trim();
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\w\d-]+\.)+[\w-]+(\/[\w\d-.\/?%&=]*)?$',
      caseSensitive: false
    );
    return urlRegex.hasMatch(trimmed) && 
           (trimmed.startsWith('http://') || 
            trimmed.startsWith('https://') ||
            trimmed.startsWith('www.'));
  }

  bool _isImageUrl(String text) {
    final trimmed = text.trim().toLowerCase();
    return _isUrl(text) && 
           (trimmed.endsWith('.jpg') ||
            trimmed.endsWith('.jpeg') ||
            trimmed.endsWith('.png') ||
            trimmed.endsWith('.gif') ||
            trimmed.endsWith('.bmp') ||
            trimmed.endsWith('.webp') ||
            trimmed.endsWith('.svg'));
  }

  bool _isDocumentUrl(String text) {
    final trimmed = text.trim().toLowerCase();
    return _isUrl(text) && 
           (trimmed.endsWith('.pdf') ||
            trimmed.endsWith('.doc') ||
            trimmed.endsWith('.docx') ||
            trimmed.endsWith('.xls') ||
            trimmed.endsWith('.xlsx') ||
            trimmed.endsWith('.ppt') ||
            trimmed.endsWith('.pptx') ||
            trimmed.contains('/documents/') ||
            trimmed.contains('/document/'));
  }

  bool _isEmail(String text) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(text.trim());
  }

  bool _isCode(String text) {
    final codeIndicators = [
      'function', 'var ', 'const ', 'let ', 'class ', 'def ', 'import ', 
      '#include', 'public ', 'private ', 'protected ', 'static ', 'void ',
      '<?php', '<script', 'import ', 'from ', 'export ', 'def ', 'class ',
      'interface ', 'extends ', 'implements '
    ];
    return codeIndicators.any((indicator) => text.contains(indicator));
  }

  bool _isHtml(String text) {
    final htmlRegex = RegExp(r'<[a-z][\s\S]*>', caseSensitive: false);
    return htmlRegex.hasMatch(text) && text.contains('</');
  }
Future<List<Map<String, dynamic>>> loadClipboardHistory() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final copypasteDir = Directory('${directory.path}/copypasted');
    
    print('Loading from: ${copypasteDir.path}');
    
    if (!copypasteDir.existsSync()) {
      print('Directory does not exist');
      return [];
    }

    final files = copypasteDir.listSync()
      .where((file) => file is File && file.path.endsWith('.cnp'))
      .toList();

    print('Found ${files.length} .cnp files');

    files.sort((a, b) {
      final aName = path.basenameWithoutExtension(a.path);
      final bName = path.basenameWithoutExtension(b.path);
      return int.parse(bName).compareTo(int.parse(aName));
    });

    final history = <Map<String, dynamic>>[];
    
    for (final file in files.take(100)) {
      try {
        print('Reading file: ${file.path}');
        
        final bytes = await File(file.path).readAsBytes();
        String content;
        
        try {
          content = utf8.decode(bytes);
        } catch (e) {
          content = latin1.decode(bytes);
        }
        
        Map<String, dynamic> entry = jsonDecode(content);
        
        // ИСПРАВЛЕНИЕ: проверяем и исправляем русскую кодировку в существующих записях
        if (entry.containsKey('content')) {
          String textContent = entry['content'].toString();
          if (_isRussianMojibake(textContent)) {
            print('Fixing Russian mojibake in file: ${file.path}');
            entry['content'] = _fixRussianEncoding(textContent);
            
            // FIXED: Cast to File explicitly
            final fixedJson = jsonEncode(entry);
            await File(file.path).writeAsBytes(utf8.encode(fixedJson));
          }
        }
        
        if (entry is Map<String, dynamic> && 
            entry.containsKey('content') && 
            entry.containsKey('timestamp')) {
          
          if (!entry.containsKey('source')) {
            entry['source'] = 'clipboard';
          }
          if (!entry.containsKey('starred')) {
            entry['starred'] = false;
          }
          
          history.add(entry);
          print('Successfully loaded entry: ${entry['content'].toString().substring(0, min(30, entry['content'].toString().length))}...');
        } else {
          print('Invalid entry structure in file: ${file.path}');
        }
      } catch (e) {
        print('Error reading clipboard file ${file.path}: $e');
      }
    }

    print('Total loaded entries: ${history.length}');
    return history;
  } catch (e) {
    print('Error loading clipboard history: $e');
    return [];
  }
}

bool _isRussianMojibake(String text) {
  // Проверяем типичные паттерны русской "крокозябры"
  return text.contains('Р') && 
         text.contains('С') && 
         text.contains('Р') && 
         text.contains('С') &&
         text.contains('Р') &&
         text.contains('С');
}

int min(int a, int b) => a < b ? a : b;


 Future<void> cleanupOldEntries() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final copypasteDir = Directory('${directory.path}/copypasted');
      final imagesDir = Directory('${copypasteDir.path}/images');
      
      if (!copypasteDir.existsSync()) return;

      final cutoff = DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch;
      final files = copypasteDir.listSync()
        .where((file) => file.path.endsWith('.cnp'))
        .toList();

      int deletedCount = 0;
      for (final file in files) {
        try {
          final fileName = path.basenameWithoutExtension(file.path);
          final timestamp = int.parse(fileName);
          
          if (timestamp < cutoff) {
            // Удаляем связанные файлы изображений
            final entryBytes = await File(file.path).readAsBytes();
            String contentString;
            try {
              contentString = utf8.decode(entryBytes);
            } catch (e) {
              contentString = latin1.decode(entryBytes);
            }
            
            final entry = jsonDecode(contentString);
            if (entry is Map<String, dynamic> && entry['type'] == 'image') {
              final imageInfo = entry['image_info'] as Map<String, dynamic>;
              final imageFileName = imageInfo['file_name']?.toString();
              if (imageFileName != null && imagesDir.existsSync()) {
                final imageFile = File('${imagesDir.path}/$imageFileName');
                if (imageFile.existsSync()) {
                  imageFile.deleteSync();
                }
              }
            }
            
            file.deleteSync();
            deletedCount++;
            // Удаляем из кэшей
            _processedFiles.removeWhere((path) => path.contains(fileName));
            _processedImageHashes.removeWhere((hash) => hash.contains(fileName));
          }
        } catch (e) {
          print('Error cleaning up file ${file.path}: $e');
        }
      }
      
      // Очищаем кэши
      _cleanupProcessedFilesCache();
      _cleanupProcessedImageHashes();
      
      if (deletedCount > 0) {
        print('Cleaned up $deletedCount old clipboard entries');
      }
    } catch (e) {
      print('Error cleaning up old entries: $e');
    }
  }

  void _cleanupProcessedFilesCache() {
    // Очищаем кэш обработанных файлов, оставляя только последние 50 записей
    if (_processedFiles.length > 50) {
      final list = _processedFiles.toList();
      _processedFiles.clear();
      _processedFiles.addAll(list.sublist(list.length - 50));
    }
  }

  Future<void> _removeWindowsContextMenu() async {
    if (!Platform.isWindows) return;
    try {
      final powershellScript = '''
        Remove-Item -Path "Registry::HKEY_CURRENT_USER\\\\Software\\\\Classes\\\\*\\\\shell\\\\FeedAI" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Output "FeedAI context menu removed."
      ''';

      final result = await Process.run(
        'powershell',
        ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', powershellScript],
      );

      print('Context menu removal output: ${result.stdout}');
      await _refreshExplorerContextMenus();
    } catch (e) {
      print('Error removing context menu: $e');
    }
  }

  Future<void> _restartExplorer() async {
    if (!Platform.isWindows) return;
    await Process.run('taskkill', ['/f', '/im', 'explorer.exe']);
    await Future.delayed(const Duration(seconds: 1));
    await Process.run('explorer.exe', []);
  }

// Обновляем метод dispose для очистки процессов
void dispose() {
  if (_isDisposed) return;
  _isDisposed = true;
  
  _disposed.complete();
  _clipboardTimer?.cancel();
  _clipboardTimer = null;
  
  _processedFiles.clear();
  _processedImageHashes.clear();
  
  // Очищаем процессы PowerShell при dispose
  _killAllPowerShellProcesses();
  _removeWindowsContextMenu();
}
}





class UpdateManager {
  static final UpdateManager _instance = UpdateManager._internal();
  factory UpdateManager() => _instance;
  UpdateManager._internal();

  // Конфигурация
  static const String _versionUrl = 
      'https://raw.githubusercontent.com/yourusername/yourrepo/main/updates/version.json';
  static const String _repoBaseUrl = 
      'https://github.com/yourusername/yourrepo/raw/main/updates/';
   String _currentVersion = '1.0.0'; // Замените на вашу текущую версию
  
  Future<UpdateInfo?> checkForUpdates() async {
    try {
      // Временный фикс - используем хардкод версии
      // Позже замените на получение из package_info
      // final packageInfo = await PackageInfo.fromPlatform();
      // final currentVersion = packageInfo.version;
      
      final currentVersion = _currentVersion;
      print('Текущая версия: $currentVersion');
      
      // Получаем информацию о последней версии
      final response = await http.get(Uri.parse(_versionUrl));
      if (response.statusCode != 200) return null;
      
      final versionData = jsonDecode(response.body);
      final latestVersion = versionData['latest_version'] as String;
      
      // Сравниваем версии
      if (_compareVersions(latestVersion, currentVersion) > 0) {
        return UpdateInfo.fromJson(versionData);
      }
    } catch (e) {
      print('Ошибка при проверке обновлений: $e');
    }
    return null;
  }
  
  // Сравнение версий
  int _compareVersions(String v1, String v2) {
    final parts1 = v1.split('.').map(int.parse).toList();
    final parts2 = v2.split('.').map(int.parse).toList();
    
    for (int i = 0; i < 3; i++) {
      final part1 = i < parts1.length ? parts1[i] : 0;
      final part2 = i < parts2.length ? parts2[i] : 0;
      
      if (part1 > part2) return 1;
      if (part1 < part2) return -1;
    }
    return 0;
  }
  
  // Загрузка обновления
  Future<bool> downloadUpdate(UpdateInfo updateInfo) async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final updatesDir = Directory(path.join(appDir.path, 'updates'));
      
      if (!await updatesDir.exists()) {
        await updatesDir.create(recursive: true);
      }
      
      final zipPath = path.join(updatesDir.path, 'update.zip');
      
      // Загружаем ZIP-архив
      final response = await http.get(Uri.parse(updateInfo.downloadUrl));
      if (response.statusCode != 200) {
        throw Exception('Не удалось загрузить обновление');
      }
      
      // Сохраняем файл
      final file = File(zipPath);
      await file.writeAsBytes(response.bodyBytes);
      
      // Проверяем контрольную сумму
      if (await _verifyChecksum(file, updateInfo.checksumUrl)) {
        return await _applyUpdate(file, updatesDir.path);
      } else {
        throw Exception('Контрольная сумма не совпадает');
      }
    } catch (e) {
      print('Ошибка загрузки обновления: $e');
      return false;
    }
  }
  
  // Проверка контрольной суммы
  Future<bool> _verifyChecksum(File file, String checksumUrl) async {
    try {
      final response = await http.get(Uri.parse(checksumUrl));
      if (response.statusCode != 200) return true; // Пропускаем если файла нет
      
      final expectedChecksum = response.body.trim();
      final bytes = await file.readAsBytes();
      
      
      final digest = sha256.convert(bytes);
      return digest.toString() == expectedChecksum;
    } catch (e) {
      print('Ошибка проверки контрольной суммы: $e');
      return true; // Пропускаем проверку при ошибке
    }
  }
  
  // Применение обновления
  Future<bool> _applyUpdate(File zipFile, String extractPath) async {
    try {
      // Читаем архив
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      
      // Распаковываем во временную директорию
      final tempDir = Directory(path.join(extractPath, 'temp_${DateTime.now().millisecondsSinceEpoch}'));
      await tempDir.create();
      
      for (final file in archive) {
        final filename = path.join(tempDir.path, file.name);
        if (file.isFile) {
          final data = file.content as Uint8List;
          await File(filename).create(recursive: true);
          await File(filename).writeAsBytes(data);
        } else {
          await Directory(filename).create(recursive: true);
        }
      }
      
      // Сохраняем путь к временной директории для установки после перезапуска
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('update_path', tempDir.path);
      
      return true;
    } catch (e) {
      print('Ошибка применения обновления: $e');
      return false;
    }
  }
  
  // Запуск установщика обновлений
  Future<void> launchUpdater() async {
    final prefs = await SharedPreferences.getInstance();
    final updatePath = prefs.getString('update_path');
    
    if (updatePath != null) {
      // Создаем batch-файл для замены файлов
      final appDir = await getApplicationSupportDirectory();
      final batPath = path.join(appDir.path, 'apply_update.bat');
      
      final batContent = '''
@echo off
chcp 65001 > nul
echo Обновление приложения...
timeout /t 3 /nobreak > nul

REM Закрываем приложение если оно запущено
taskkill /F /IM imeyou_pet.exe > nul 2>&1

REM Копируем новые файлы
xcopy "${updatePath.replaceAll('/', '\\')}\\*" "${Directory.current.path.replaceAll('/', '\\')}" /E /Y /I

REM Удаляем временные файлы
rmdir /S /Q "${updatePath.replaceAll('/', '\\')}"

REM Запускаем обновленное приложение
start "" "${Directory.current.path}\\imeyou_pet.exe"

REM Удаляем сам batch-файл
del "%~f0"
''';
      
      await File(batPath).writeAsString(batContent, flush: true);
      
      // Запускаем batch-файл
      await Process.run('cmd', ['/c', batPath], runInShell: true);
      
      // Закрываем текущее приложение
      exit(0);
    }
  }
}

// Модель информации об обновлении
class UpdateInfo {
  final String version;
  final String downloadUrl;
  final String checksumUrl;
  final String changelogUrl;
  final bool critical;
  final int size;
  
  UpdateInfo({
    required this.version,
    required this.downloadUrl,
    required this.checksumUrl,
    required this.changelogUrl,
    required this.critical,
    required this.size,
  });
  
  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      version: json['latest_version'],
      downloadUrl: json['download_url'],
      checksumUrl: json['checksum_url'],
      changelogUrl: json['changelog_url'],
      critical: json['critical'] ?? false,
      size: json['size_bytes'] ?? 0,
    );
  }
}



class UpdateDialog extends StatefulWidget {
  final UpdateInfo updateInfo;
  
  const UpdateDialog({super.key, required this.updateInfo});
  
  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double _downloadProgress = 0.0;
  bool _isDownloading = false;
  bool _isCompleted = false;
  String _status = '';
  
@override
Widget build(BuildContext context) {
  return AlertDialog(
    title: const Text('Доступно обновление'),
    content: SizedBox(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Версия ${widget.updateInfo.version}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Что нового:'),
          FutureBuilder<String>(
            future: _fetchChangelog(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!);
              }
              return const CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 20),
          if (_isDownloading) ...[
            LinearProgressIndicator(value: _downloadProgress),
            const SizedBox(height: 10),
            Text('$_status (${(_downloadProgress * 100).toStringAsFixed(1)}%)'),
          ] else if (_isCompleted) ...[
            const Text('✅ Обновление готово к установке',
                style: TextStyle(color: Colors.green)),
          ],
        ],
      ),
    ),
    actions: [
      if (!widget.updateInfo.critical)
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Позже'),
        ),
      ElevatedButton(
        onPressed: _isDownloading ? null : _startUpdate,
        child: _isCompleted 
            ? const Text('Установить и перезапустить')
            : const Text('Обновить'),
      ),
    ],
  );
}
  
  Future<String> _fetchChangelog() async {
    try {
      final response = await http.get(Uri.parse(widget.updateInfo.changelogUrl));
      return response.body;
    } catch (e) {
      return 'Не удалось загрузить список изменений';
    }
  }
  
  Future<void> _startUpdate() async {
    if (_isCompleted) {
      await UpdateManager().launchUpdater();
      return;
    }
    
    setState(() {
      _isDownloading = true;
      _status = 'Загрузка...';
    });
    
    final success = await UpdateManager().downloadUpdate(widget.updateInfo);
    
    if (success) {
      setState(() {
        _isDownloading = false;
        _isCompleted = true;
        _status = 'Готово!';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при загрузке обновления')),
      );
    }
  }
}