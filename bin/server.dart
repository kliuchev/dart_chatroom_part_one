import 'package:shelf/shelf_io.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main(List<String> args) async {
  /// Create a set to store all connected clients
  final clients = <WebSocketChannel>{};

  /// Create a WebSocket handler that will listen for incoming connections
  final handler = webSocketHandler((WebSocketChannel webSocket) {
    /// Add the new client to the set
    clients.add(webSocket);

    /// Listen for incoming messages from the client
    webSocket.stream.listen((message) {
      /// When a message is received, send it to all connected clients
      for (final client in clients) {
        client.sink.add(message);
      }
    }, onDone: () {
      /// When the client disconnects, remove it from the set
      clients.remove(webSocket);
    });
  });

  /// Start the server
  final server = await serve(handler, '0.0.0.0', 8080);

  print('Serving at ws://${server.address.host}:${server.port}');
}
