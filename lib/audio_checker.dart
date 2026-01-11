import 'dart:io';
import 'dart:async';

class AudioChecker {
  static Future<bool> isAudioPlaying() async {
    if (!Platform.isWindows) return false;
    
    try {
      final process = await Process.run('powershell', [
        '-Command',
        '''
        \$session = Get-AudioDevice -Playback 2>&1
        if (\$session -like "*Active*") { exit 0 } else { exit 1 }
        '''
      ]);
      
      return process.exitCode == 0;
    } catch (e) {
      print('Audio check error: $e');
      return false;
    }
  }
}