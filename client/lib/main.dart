import 'package:flutter/material.dart';
import 'package:web_socket_client/web_socket_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatroom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  /// The WebSocket client.
  late WebSocket socket;

  /// The list of received messages.
  final messages = <String>[];

  /// The scroll controller for the list view.
  final _scrollController = ScrollController();

  /// The text controller for the text field.
  final _textController = TextEditingController();

  @override
  void initState() {
    /// Create a new WebSocket client and connect to the server.
    socket = WebSocket(Uri.parse('ws://0.0.0.0:8080'));

    /// Listen for incoming messages and update the list of messages.
    socket.messages.listen((message) {
      setState(() {
        messages.add(message);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    /// Close the WebSocket connection when the widget is disposed.
    socket.close();
    super.dispose();
  }

  /// Send a message to the server.
  void _onSubmit() {
    final message = _textController.text;

    /// An empty message should not be sent.
    if (message.isEmpty) return;

    /// Send the message to the server
    socket.send(message);

    /// Clear the text field
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            /// Display the list of messages in a list view.
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),

          /// A text field to type a message and a send button.
          TextField(
            decoration: InputDecoration(
              hintText: 'Type a message',
              suffixIcon: IconButton(
                onPressed: _onSubmit,
                icon: const Icon(Icons.send),
              ),
            ),
            controller: _textController,
            onSubmitted: (_) => _onSubmit(),
          ),
        ],
      ),
    );
  }
}
