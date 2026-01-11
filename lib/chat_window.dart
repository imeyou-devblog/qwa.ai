import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:screen_retriever/screen_retriever.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (args.length >= 4) {
    final chatHistory = json.decode(args[0]);
    final petX = double.parse(args[1]);
    final petY = double.parse(args[2]);
    final petWidth = double.parse(args[3]);
    final petHeight = double.parse(args[4]);
    
    await _initChatWindow(petX, petY, petWidth, petHeight);
    runApp(ChatWindowApp(
      chatHistory: chatHistory,
      petPosition: Offset(petX, petY),
      petSize: Size(petWidth, petHeight),
    ));
  }
}

Future<void> _initChatWindow(double petX, double petY, double petWidth, double petHeight) async {
  await windowManager.ensureInitialized();
  
  // Размеры окна чата
  final chatWidth = 400;
  final chatHeight = 800;
  
  // Позиционируем окно чата над основным окном
  final chatX = petX;
  final chatY = petY - chatHeight;
  
  await windowManager.setAsFrameless();
  await windowManager.setSize(Size(chatWidth, chatHeight));
  await windowManager.setPosition(Offset(chatX, chatY));
  await windowManager.setAlwaysOnTop(true);
  await windowManager.setVisible(true);
}

class ChatWindowApp extends StatelessWidget {
  final List<Map<String, String>> chatHistory;
  final Offset petPosition;
  final Size petSize;

  const ChatWindowApp({
    Key? key,
    required this.chatHistory,
    required this.petPosition,
    required this.petSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatWindowContent(
        chatHistory: chatHistory,
        petPosition: petPosition,
        petSize: petSize,
      ),
    );
  }
}

class ChatWindowContent extends StatefulWidget {
  final List<Map<String, String>> chatHistory;
  final Offset petPosition;
  final Size petSize;

  const ChatWindowContent({
    Key? key,
    required this.chatHistory,
    required this.petPosition,
    required this.petSize,
  }) : super(key: key);

  @override
  _ChatWindowContentState createState() => _ChatWindowContentState();
}

class _ChatWindowContentState extends State<ChatWindowContent> with WindowListener {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage() {
    // Здесь будет отправка сообщения через IPC
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      _controller.clear();
      // TODO: Отправка сообщения в основной процесс
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Заголовок с кнопкой закрытия
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      '💬 Чат с AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: () => windowManager.close(),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // История сообщений
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(12),
                itemCount: widget.chatHistory.length,
                itemBuilder: (context, index) {
                  final chat = widget.chatHistory[index];
                  final isAI = chat['type'] == 'ai';
                  final bubbleColor = isAI ? Colors.cyan.withOpacity(0.33) : Colors.orange.withOpacity(0.33);

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            chat['message'] ?? '',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Поле ввода
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Введите сообщение...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void onWindowMove() async {
    // Синхронизируем позицию с основным окном
    final currentPos = await windowManager.getPosition();
    // TODO: Отправить позицию в основной процесс
  }

  @override
  void onWindowClose() {
    // TODO: Уведомить основной процесс о закрытии
  }
}