import 'package:flutter/material.dart';
import 'package:nasporte_frontend/pages/home.dart';
import 'package:nasporte_frontend/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:nasporte_frontend/pages/load.dart';
import 'package:nasporte_frontend/pages/main_page.dart';
import 'package:nasporte_frontend/pages/chat.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const MainPage(),
    );
  }
}