import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:jagadis/common/models/user_session.dart';
import 'package:jagadis/common/services/secure_storage_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketService {
  static const String _url = "wss://9fad-182-253-127-167.ngrok-free.app";
  late WebSocketChannel _channel;

  WebsocketService(String alertId, String userId) {
    Uri websocketUrl = Uri.parse("$_url/sos/$userId/alert/$alertId");

    _channel = WebSocketChannel.connect(websocketUrl);
  }

  WebSocketChannel getChannel() {
    return _channel;
  }

  void closeConnection() {
    _channel.sink.close();
  }

  static Future<WebSocketChannel> init() async {
    UserSession? user = await SecureStorageService.getSession();
    String? alertId = await SecureStorageService.read("alertId");

    Uri websocketUrl = Uri.parse("$_url/sos/${user?.id}/alert/$alertId");

    return WebSocketChannel.connect(websocketUrl);
  }

  static void sendMessage(WebSocketChannel channel, Position position) {
    Map<String, double> bodyRequest = {
      "latitude": position.latitude,
      "longitude": position.longitude
    };

    String message = jsonEncode(bodyRequest);

    channel.sink.add(message);
  }

  static void close(WebSocketChannel channel) {
    channel.sink.close();
  }
}
