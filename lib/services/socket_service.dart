import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serveStatus = ServerStatus.Connecting;

  IO.Socket _socket;

  ServerStatus get serverStatus => this._serveStatus;

  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    this._socket = IO.io('http://192.168.0.7:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    this._socket.on('connect', (_) {
      this._serveStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('disconnect', (_) {
      this._serveStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo-mensaje $payload');
    // });
  }
}
