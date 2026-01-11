import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';


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
  Future<void> initialize() async {
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
      final bytes = utf8.encode(jsonString);
      await file.writeAsBytes(bytes, flush: true);
      
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
      final bytes = utf8.encode(jsonString);
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