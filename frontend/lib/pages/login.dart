import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nasporte_frontend/pages/main_page.dart';
import 'package:nasporte_frontend/pages/register.dart';
import 'package:nasporte_frontend/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class  _LoginPageState extends State<LoginPage>{

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  void _login() async{
    final email = _emailController.text;
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста заполните все поля')),
      );
      return;
    }
    const url = 'http://10.0.2.2:5038/Auth/login';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'login': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вы вошли в аккаунт')),
      );
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Неверная почта или пароль')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff171717),
      body: ListView(
        children: [
          const SizedBox(height: 70),
          _enterText(),
          const SizedBox(height: 40),
          _emailInput(),
          const SizedBox(height: 25),
          _passwordInput(),
          const SizedBox(height: 25),
          _loginButton(context),
          const SizedBox(height: 12),
          _noAccount(context),
        ],
      ),
    );
  }

  Row _noAccount(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Нет аккаунта?',
          style: TextStyle(
            color: Color(0xffC9C9C9),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage())
            );
          },
          child: const Text(
            ' Зарегистрироваться',
            style: TextStyle(
              color: Color(0xff6236FF),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Padding _loginButton(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff6236FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: const Size.fromHeight(44),
        ),
        child: const Text(
          'Войти',
          style: TextStyle( 
            color: Color(0xffFFFFFF),
            fontSize: 14, 
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

Column _passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text(
            'Пароль',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, top: 10, right: 50),
          child: TextField(
            obscureText: _obscureText,
            controller: _passwordController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black,
              hintText: 'Введите пароль...',
              hintStyle: const TextStyle(
                color:Color(0xffC9C9C9),
                fontSize: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(_obscureText
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            style: const TextStyle(
              color:Color(0xffC9C9C9),
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, top: 7),
          child: GestureDetector (
            onTap: () {
              //открывает страницу с восстановлением пароля(хз как мы это делать будем)
            },
            child: const Text(
              'Забыли пароль?',
              style: TextStyle(
                color: Color(0xff6236FF),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ]
    );
  }

  Column _emailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text(
            'Почта',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, top: 10, right: 50),
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black,
              hintText: 'Введите почту...',
              hintStyle: const TextStyle(
                color:Color(0xffC9C9C9),
                fontSize: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(
              color:Color(0xffC9C9C9),
              fontSize: 12,
            ),
          ),
        ),
      ]
    );
  }

  Column _enterText() {
    return const Column(
      children: [
        Text(
          'Вход',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xffFFFFFF),
          ),
        ),
        Text(
          'Добро пожаловать',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xffC9C9C9),
          ),
        ),
      ],
    );
  }
}