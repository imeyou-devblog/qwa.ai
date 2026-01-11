import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (args.isNotEmpty) {
    final eatenFiles = json.decode(args[0]) as List<dynamic>;
    
    await windowManager.ensureInitialized();
    await windowManager.setSize(Size(800, 600));
    await windowManager.center();
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setTitle('Съеденные файлы');
    
    runApp(EatenFilesWindowApp(eatenFiles: eatenFiles.cast<String>()));
  }
}

class EatenFilesWindowApp extends StatelessWidget {
  final List<String> eatenFiles;

  const EatenFilesWindowApp({Key? key, required this.eatenFiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('📁 Съеденные файлы'),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => windowManager.close(),
            ),
          ],
        ),
        body: EatenFilesContent(eatenFiles: eatenFiles),
      ),
    );
  }
}

class EatenFilesContent extends StatelessWidget {
  final List<String> eatenFiles;

  const EatenFilesContent({Key? key, required this.eatenFiles}) : super(key: key);

  IconData _getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    
    if (['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(extension)) {
      return Icons.image;
    } else if (['.mp3', '.wav', '.flac', '.m4a', '.ogg'].contains(extension)) {
      return Icons.audio_file;
    } else if (['.mp4', '.avi', '.mkv', '.mov', '.wmv'].contains(extension)) {
      return Icons.video_file;
    } else if (['.txt', '.doc', '.docx', '.pdf', '.rtf'].contains(extension)) {
      return Icons.description;
    } else if (['.zip', '.rar', '.7z', '.tar', '.gz'].contains(extension)) {
      return Icons.archive;
    } else if (['.exe', '.msi', '.app', '.deb', '.dmg'].contains(extension)) {
      return Icons.apps;
    } else {
      return Icons.insert_drive_file;
    }
  }

  void _openFile(String filePath) async {
    try {
      if (Platform.isWindows) {
        await Process.run('start', ['""', filePath], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', [filePath]);
      } else {
        await Process.run('xdg-open', [filePath]);
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: eatenFiles.length,
      itemBuilder: (context, index) {
        final filePath = eatenFiles[index];
        final fileName = path.basename(filePath);
        final fileExists = File(filePath).existsSync();
        
        return GestureDetector(
          onTap: () => _openFile(filePath),
          onLongPress: () => _openFileFolder(filePath),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Opacity(
              opacity: fileExists ? 1.0 : 0.33,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getFileIcon(fileName),
                    size: 32,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      fileName.length > 20 ? '${fileName.substring(0, 17)}...' : fileName,
                      style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}