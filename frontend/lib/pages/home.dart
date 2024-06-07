import 'package:flutter/material.dart';
import 'package:nasporte_frontend/shared/appbar_main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Column(
        children: [
          appBar(),
        ],
      ),
    );
  }
}