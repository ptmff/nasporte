import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  HubConnection? _connection;
  final String _hubUrl = 'http://10.0.2.2:5038/ChatHub';
  final String _chatId = '2ae11c1b-afef-4149-9a19-3efab26c49a9';
  final Uuid _uuid = Uuid();

  List<Message> get messages => _messages;

  Future<void> connect() async {
    _connection = HubConnectionBuilder().withUrl(_hubUrl).build();
    await _connection?.start();

    _connection?.on('ReceiveMessage', (args) {
      final decoded = json.decode(args![1]);
      final message = Message(decoded['id'], decoded['text'], DateTime.parse(decoded['timestamp']), false);
      if (!_messages.any((msg) => msg.id == message.id)) {
        _messages.add(message);
        notifyListeners();
      }
    });

    await _connection?.invoke('JoinChat', args: [_chatId]);
  }

  void disconnect() {
    _connection?.stop();
  }

  void addMessage(String text) async {
    final messageId = _uuid.v4();
    final message = Message(messageId, text, DateTime.now(), true);
    _messages.add(message);
    await _connection?.invoke('SendMessage', args: [_chatId, 'user', json.encode({'id': messageId, 'text': message.text, 'timestamp': message.timestamp.toIso8601String()})]);
    notifyListeners();
  }
}

class Message {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isUser;

  Message(this.id, this.text, this.timestamp, this.isUser);
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  late ChatProvider _chatProvider;

  @override
  void initState() {
    super.initState();
    _chatProvider = context.read<ChatProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatProvider.connect();
    });
  }

  @override
  void dispose() {
    _chatProvider.disconnect();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/arrow_purple_back.svg'), 
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Text(
                'Т',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Лучший тренер',
                  style: TextStyle(
                    color: Color(0xFF252525),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'В сети',
                  style: TextStyle(
                    color: Color(0xFF616161),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        toolbarHeight: 80,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5.0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            color: Color(0xFFDBDBDB),
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return ChatMessage(
                      text: message.text,
                      timestamp: '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                      isUser: message.isUser,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Написать...',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Color(0xFFACADB9),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFF6855FF)),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _chatProvider.addMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final String timestamp;
  final bool isUser;

  ChatMessage({required this.text, required this.timestamp, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) CircleAvatar(child: Text('Т', style: TextStyle(fontWeight: FontWeight.bold))),
          if (!isUser) SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: isUser ? Color.fromARGB(255, 214, 215, 224) : Color(0xFF6855FF),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: isUser ? Color(0xFF323142) : Color(0xFFF5F6FA),
                    ),
                  ),
                ),
                Text(
                  timestamp,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) SizedBox(width: 10.0),
        ],
      ),
    );
  }
}