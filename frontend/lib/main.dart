import 'package:flutter/material.dart';
import 'package:nasporte_frontend/pages/load.dart';
import 'package:nasporte_frontend/pages/main_page.dart';

void main() {
  runApp(const MyApp());
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