import 'package:bandnames/pages/status.dart';
import 'package:bandnames/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:bandnames/pages/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {'home': (_) => HomePage(), 'status': (_) => StatusPage()},
      ),
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
    );
  }
}
