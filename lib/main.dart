import 'package:band_app/src/pages/home.dart';
import 'package:band_app/src/pages/status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/services/socket_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (context) => HomeScreen(),
          'status': (context) => StatusScreen(),
        },
      ),
    );
  }
}
