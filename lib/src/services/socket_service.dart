import 'package:flutter/cupertino.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  get serverStatus => _serverStatus;

  IO.Socket? _socket;
  IO.Socket? get socket => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io('http://192.168.1.161:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    _socket!.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket!.on('disconnect', (_) {
      print('disconnect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
