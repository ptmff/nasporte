import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nasporte_frontend/pages/login.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLoginPage();
  }

  void _navigateToLoginPage() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff171717),
      body: Center(
        child: SvgPicture.asset(
          'assets/icons/nasporte_icon.svg',
        ),
      ),
    );
  }
}