import 'package:band_app/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => socketService.socket!.emit(
          'nuevo-mensaje',
          {'nombre':'Flutter', 'mensaje':'Hola Desde Flutter'},
         
        ),
        child: const Icon(Icons.message),
      ),
      body: Center(
        child: Text('Server Status: ${socketService.serverStatus}'),
      ),
    );
  }
}
