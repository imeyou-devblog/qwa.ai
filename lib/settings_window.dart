import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (args.length >= 3) {
    final apiKey = args[0];
    final useDeepSeek = args[1].toLowerCase() == 'true';
    final petName = args[2];
    
    await windowManager.ensureInitialized();
    await windowManager.setSize(Size(500, 400));
    await windowManager.center();
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setTitle('Настройки');
    
    runApp(SettingsWindowApp(
      apiKey: apiKey,
      useDeepSeek: useDeepSeek,
      petName: petName,
    ));
  }
}

class SettingsWindowApp extends StatefulWidget {
  final String apiKey;
  final bool useDeepSeek;
  final String petName;

  const SettingsWindowApp({
    Key? key,
    required this.apiKey,
    required this.useDeepSeek,
    required this.petName,
  }) : super(key: key);

  @override
  _SettingsWindowAppState createState() => _SettingsWindowAppState();
}

class _SettingsWindowAppState extends State<SettingsWindowApp> {
  late TextEditingController _apiKeyController;
  late TextEditingController _petNameController;
  late bool _useDeepSeek;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController(text: widget.apiKey);
    _petNameController = TextEditingController(text: widget.petName);
    _useDeepSeek = widget.useDeepSeek;
  }

  void _saveSettings() {
    // Здесь можно сохранить настройки в файл или отправить обратно в основное приложение
    print('Settings saved:');
    print('API Key: ${_apiKeyController.text}');
    print('Use DeepSeek: $_useDeepSeek');
    print('Pet Name: ${_petNameController.text}');
    
    // Закрыть окно
    windowManager.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('⚙️ Настройки'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _petNameController,
                decoration: InputDecoration(
                  labelText: 'Имя питомца',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _apiKeyController,
                decoration: InputDecoration(
                  labelText: 'API ключ',
                  hintText: 'Введите ваш API ключ',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _useDeepSeek,
                    onChanged: (value) => setState(() => _useDeepSeek = value!),
                  ),
                  Text('Использовать DeepSeek API'),
                ],
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text('Сохранить', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _petNameController.dispose();
    super.dispose();
  }
}