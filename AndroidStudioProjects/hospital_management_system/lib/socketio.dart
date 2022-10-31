import 'package:socket_io_client/socket_io_client.dart';

class SocketClient{

  SocketClient._();

  static SocketClient? _instance;

  static SocketClient get instance {
    _instance ??= SocketClient._();
    return _instance!;
  }

  Socket? _socket;

  Socket get socket => _openSocket();

  Socket _openSocket() {
    if(_socket == null){
      print('creating socket');
      _socket = io('https://chchms.herokuapp.com', OptionBuilder().setTransports(['websocket']).build());
      //socket.connect();
      print('success');
    }
    return _socket!;
  }
  
  /*void notify(event, data){
    try {
      socket.emit(event, data);
    }
  }*/
  
}