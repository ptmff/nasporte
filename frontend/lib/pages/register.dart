import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nasporte_frontend/pages/login.dart';
import 'package:nasporte_frontend/pages/home.dart';
import 'package:nasporte_frontend/pages/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;


  void _register() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста заполните все поля')),
      );
      return;
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Некорректная почта')),
      );
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароли не совпадают')),
      );
      return;
    }
    const url = 'http://10.0.2.2:5038/Auth/register';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
        'repeatedPassword': confirmPassword,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Регистрация прошла успешно')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage())
        );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Регистрация не удалась')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff171717),
      appBar: appBar(context),
      body: ListView(
        children: [
          const SizedBox(height: 14),
          _registerText(),
          const SizedBox(height: 40),
          _usernameRegisterInput(),
          const SizedBox(height: 25),
          _emailRegisterInput(),
          const SizedBox(height: 25),
          _passwordRegisterInput(),
          const SizedBox(height: 25),
          _passwordRepeatInput(),
          const SizedBox(height: 25),
          _registerButton(context),        
        ],
      ),
    );
  }

  Padding _registerButton(context) {
  return Padding(
    padding: const EdgeInsets.only(left: 50, right: 50),
    child: ElevatedButton(
      onPressed: _register,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff6236FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: const Size.fromHeight(44),
      ),
      child: const Text(
        'Регистрация',
        style: TextStyle( 
          color: Color(0xffFFFFFF),
          fontSize: 14, 
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Column _usernameRegisterInput() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 50),
        child: Text(
          'Имя пользователя',
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
          controller: _usernameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black,
            hintText: 'Введите имя пользователя...',
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

  Column _passwordRepeatInput() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 50),
        child: Text(
          'Повторите пароль',
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
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black,
            hintText: 'Повторите пароль...',
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
    ]
  );
}

  Column _passwordRegisterInput() {
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
            hintText: 'Придумайте пароль...',
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
    ]
  );
}

  Column _emailRegisterInput() {
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
        child: TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black,
            hintText: 'Введите почту...',
            hintStyle: const TextStyle(
              color: Color(0xffC9C9C9),
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(
            color: Color(0xffC9C9C9),
            fontSize: 12,
          ),
        ),
      ),
    ]
  );
}

  Column _registerText() {
  return const Column(
    children: [
      Text(
        'Регистрация',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xffFFFFFF),
        ),
      ),
      Text(
        'Создать аккаунт',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xffC9C9C9),
        ),
      ),
    ],
  );
}

  AppBar appBar(context) {
    return AppBar(
      backgroundColor: const Color(0xff171717),
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/retturn_arrow.svg',
            width: 17.55,
            height: 20,
            ),
        ),
      ),
    );
  }
}